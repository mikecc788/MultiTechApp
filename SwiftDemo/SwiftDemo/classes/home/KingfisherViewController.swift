//
//  KingfisherViewController.swift
//  SwiftDemo
//
//  Created by chenliao on 2021/12/24.
//

import UIKit
import Foundation

class KingfisherViewController:UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        // 直接调用，更简单
        // asyncFetch()
        
        asyncFetchWithoutMainActor()
  
        
    }
    
    // 方式2：创建一个异步方法来调用
    func handleData() async {
        await fetchAllData()
    }
    //
    //    // 如果需要在按钮点击等事件中调用
    //    @objc func buttonTapped() {
    //        Task {
    //            await fetchAllData()
    //        }
    //    }
    
    func fetchData(from url: String) async throws -> String {
        print("Fetching data from \(url)...")
        try await Task.sleep(nanoseconds: 2*1_000_000_000)
        return "Data from \(url)"
    }
    
    func fetchAllData() async {
        let urls = ["https://api.example.com/endpoint1", "https://api.example.com/endpoint2"]
        do{
            // 使用 Task 并行执行两个网络请求
            async let result1 = fetchData(from: urls[0])
            async let result2 = fetchData(from: urls[1])
            let (data1,data2) = try await (result1,result2)
            print("Result 1: \(data1)")
            print("Result 2: \(data2)")
        }catch{
            print("Error fetching data: \(error)")
        }
    }
    
    // 不使用 @MainActor 的情况，需要手动切换到主线程
    func asyncFetchWithoutMainActor() {
        Task {
            await fetchAllData()
            // 如果要更新 UI，需要手动切换到主线程
            DispatchQueue.main.async {
                self.view.backgroundColor = .red
            }
            
        }
    }
    
    // 使用 @MainActor 的情况，自动在主线程执行
    func asyncFetch() {
        Task { @MainActor in
            await fetchAllData()
            // 直接更新 UI，因为已经在主线程了
            self.view.backgroundColor = .red
        }
    }
}


