//
//  StreamManager.swift
//  FeelLife
//
//  Created by app on 2025/2/25.
//

import Foundation

/// 处理流式响应的网络管理器
class StreamManager {
    // MARK: - Properties
    private let baseUrl = "http://159.75.204.128:5000"
    private let requestSemaphore = DispatchSemaphore(value: 5) // 最大并发请求数
    private let maxRetryCount = 3
    
    // 当前会话和任务引用，用于取消请求
    private var currentSession: URLSession?
    private var currentTask: URLSessionDataTask?
    
    // 标记是否有请求正在进行
    private var _isRequestInProgress = false
    
    // 用于同步访问属性的队列
    private let queue = DispatchQueue(label: "com.feellife.streammanager", attributes: .concurrent)
    
    // 存储当前的 delegate 防止被过早释放
    private var currentDelegate: StreamDelegate?
    
    // MARK: - Public Methods
    
    /// 检查是否有请求正在进行
    var isRequestInProgress: Bool {
        var result = false
        queue.sync {
            result = _isRequestInProgress
        }
        return result
    }
    
    /// 取消当前正在进行的网络请求
    func cancelCurrentRequest() {
        queue.async(flags: .barrier) { [weak self] in
            // 取消当前的数据任务
            self?.currentTask?.cancel()
            self?.currentTask = nil
            
            // 使当前会话无效
            self?.currentSession?.invalidateAndCancel()
            self?.currentSession = nil
            
            // 清空 delegate 引用
            self?.currentDelegate = nil
            
            // 更新请求状态
            self?._isRequestInProgress = false
            
            // 确保信号量不会阻塞
            self?.requestSemaphore.signal()
            
            print("已取消当前的网络请求")
        }
    }
    
    /// 获取聊天AI响应
    /// - Parameters:
    ///   - message: 用户消息
    ///   - completion: 完成回调，返回响应字符串或错误
    func getChatAIResponse(for message: String, completion: @escaping (String?) -> Void) {
        // 先取消现有请求
        cancelCurrentRequest()
        
        // 开始新请求
        queue.async { [weak self] in
            guard let self = self else { return }
            
            // 设置请求状态
            self.queue.async(flags: .barrier) {
                self._isRequestInProgress = true
            }
            
            self.performRequest(message, completion: completion, retryCount: self.maxRetryCount, currentDelay: 1.0)
        }
    }
   
    // MARK: - Private Methods
    /// 执行网络请求
    /// - Parameters:
    ///   - message: 用户消息
    ///   - completion: 完成回调
    ///   - retryCount: 剩余重试次数
    ///   - currentDelay: 当前重试延迟
    private func performRequest(_ message: String, completion: @escaping (String?) -> Void, retryCount: Int, currentDelay: TimeInterval) {
        requestSemaphore.wait()
        
        let urlString = "\(baseUrl)/IbreatheChat/GetAIResponse"
        guard let url = URL(string: urlString) else {
            requestSemaphore.signal()
            completion("错误：无效的URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30 // 30秒超时
        
        let parameters: [String: Any] = ["role": "user", "content": message]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            
            // 创建安全的回调
            let safeCompletion: (String?) -> Void = { [weak self] response in
                guard let self = self, self.isRequestInProgress else { return }
                
                // 确保回调在主线程上执行
                DispatchQueue.main.async {
                    completion(response)
                }
            }
            
            let delegate = StreamDelegate(streamManager: self, completion: safeCompletion, errorHandler: { [weak self] error in
                print("Stream error: \(error)")
                
                guard let self = self, self.isRequestInProgress else { return }
                
                if (error.contains("concurrency exceeded") || error.contains("network connection error")) && retryCount > 0 {
                    print("网络错误，将在 \(currentDelay)秒后重试，剩余重试次数: \(retryCount)")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + currentDelay) { [weak self] in
                        guard let self = self, self.isRequestInProgress else { return }
                        self.performRequest(message, completion: completion, retryCount: retryCount - 1, currentDelay: currentDelay * 2)
                    }
                } else {
                    self.requestSemaphore.signal()
                    
                    // 将错误消息转换为用户友好的消息
                    let userFriendlyError: String
                    if error.contains("concurrency exceeded") {
                        userFriendlyError = "服务器繁忙，请稍后再试"
                    } else if error.contains("timeout") {
                        userFriendlyError = "请求超时，请检查网络连接"
                    } else {
                        userFriendlyError = "抱歉，发生了错误，请稍后再试"
                    }
                    
                    DispatchQueue.main.async {
                        completion(userFriendlyError)
                    }
                }
            })
            
            // 在队列上同步更新会话引用
            queue.async(flags: .barrier) { [weak self] in
                guard let self = self else { return }
                
                let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
                let task = session.dataTask(with: request)
                
                self.currentSession = session
                self.currentTask = task
                self.currentDelegate = delegate // 存储 delegate 引用
                
                task.resume()
                print("请求已发送: \(urlString)")
            }
            
        } catch {
            requestSemaphore.signal()
            print("请求参数序列化失败: \(error)")
            
            DispatchQueue.main.async {
                completion("请求参数错误")
            }
        }
    }
    
    // MARK: - 析构函数
    deinit {
        cancelCurrentRequest() // 确保在销毁时取消所有请求
        print("StreamManager 被销毁")
    }
    
    // MARK: - Stream Delegate
    
    /// 处理流式响应的代理类
    private class StreamDelegate: NSObject, URLSessionDataDelegate {
        weak var streamManager: StreamManager?
        var completion: (String?) -> Void
        var errorHandler: (String) -> Void
        var buffer = Data()
        var hasEnded = false
        var hasError = false
        var isCancelled = false
        
        init(streamManager: StreamManager?, completion: @escaping (String?) -> Void, errorHandler: @escaping (String) -> Void) {
            self.streamManager = streamManager
            self.completion = completion
            self.errorHandler = errorHandler
            super.init()
        }
        
        func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
            if let httpResponse = response as? HTTPURLResponse {
                print("收到HTTP响应, 状态码: \(httpResponse.statusCode)")
                
                // 检查请求是否已被取消
                if streamManager == nil || isCancelled {
                    completionHandler(.cancel)
                    return
                }
                
                if httpResponse.statusCode >= 400 {
                    hasError = true
                    errorHandler("HTTP错误: \(httpResponse.statusCode)")
                    completionHandler(.cancel)
                    return
                }
            }
            
            buffer = Data()
            completionHandler(.allow)
        }
        
        func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
            // 检查请求是否已被取消
            if streamManager == nil || hasError || isCancelled {
                return
            }
            
            buffer.append(data)
            processBuffer()
        }
        
        func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
            // 如果 StreamManager 已经被释放，不执行任何回调
            guard let streamManager = streamManager else {
                return
            }
            
            if let error = error {
                if (error as NSError).code == NSURLErrorCancelled {
                    print("请求已取消")
                    isCancelled = true
                    return
                }
                
                hasError = true
                errorHandler(error.localizedDescription)
            } else {
                if !hasEnded && !isCancelled {
                    processBuffer()
                    completion(nil)
                }
            }
            
            // 确保信号量被释放
            if !isCancelled {
                streamManager.requestSemaphore.signal()
            }
            
            // 更新请求状态
            streamManager.queue.async(flags: .barrier) {
                streamManager._isRequestInProgress = false
            }
        }
        
        private func processBuffer() {
            // 检查请求是否已被取消
            if streamManager == nil || hasError || isCancelled {
                return
            }
            
            guard let bufferString = String(data: buffer, encoding: .utf8) else { return }
            
            let lines = bufferString.components(separatedBy: "\n")
            for line in lines.dropLast() where !line.isEmpty {
                processLine(line.trimmingCharacters(in: .whitespacesAndNewlines))
            }
            
            if let lastLine = lines.last {
                buffer = Data(lastLine.utf8)
            }
        }
        
        private func processLine(_ line: String) {
            // 检查请求是否已被取消
            if streamManager == nil || hasError || isCancelled {
                return
            }
            
            guard let dataContent = line.components(separatedBy: "data:").last?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                return
            }
            
            if dataContent == "[DONE]" {
                print("流结束 [DONE]")
                hasEnded = true
                completion(nil)
                return
            }
            
            do {
                guard let jsonData = dataContent.data(using: .utf8),
                      let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                    return
                }
                
                if let error = json["error"] as? String {
                    hasError = true
                    errorHandler(error)
                    return
                }
                
                // 尝试不同的JSON结构
                if let choices = json["Choices"] as? [[String: Any]],
                   let firstChoice = choices.first,
                   let delta = firstChoice["Delta"] as? [String: Any] {
                    
                    // 首先尝试 ReasoningContent，然后尝试 Content
                    if let content = delta["ReasoningContent"] as? String {
                        completion(content)
                    } else if let content = delta["Content"] as? String {
                        completion(content)
                    }
                } else if let choices = json["choices"] as? [[String: Any]],
                          let firstChoice = choices.first,
                          let delta = firstChoice["delta"] as? [String: Any],
                          let content = delta["content"] as? String {
                    completion(content)
                }
                
            } catch {
                print("JSON解析错误: \(error)")
            }
        }
    }
}

