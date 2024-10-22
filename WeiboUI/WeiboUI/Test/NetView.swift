//
//  NetView.swift
//  WeiboUI
//
//  Created by app on 2022/12/13.
//

import SwiftUI

struct NetView: View {
   @State private var text = ""
    var body: some View {
        VStack {
            Text(text).font(.title)
            Button {
                startLoad()
            } label: {
                Text("Start").font(.largeTitle)
            }
            
            Button {
                self.text = ""
            } label: {
                Text("Clear").font(.largeTitle)
            }

        }
    }
    
    func startLoad()  {
        
        NetworkAPI.recommendPostList { result in
            switch result{
            case let .success(list): self.updateText("Post count \(list.list.count)")
            case let .failure(error):
                self.updateText(error.localizedDescription)
            }
        }
        /**
         网络请求3
         
        let url = URL(string: "https://github.com/xiaoyouxinqing/PostDemo/raw/master/PostDemo/Resources/PostListData_recommend_1.json")!
        
        NetworkManager.shard.requestGet(path: "PostListData_recommend_1.json", parameters: nil) { result in
            switch result{
            case let .success(data):
                guard let list = try? JSONDecoder().decode(PostList.self, from: data) else {
                    self.updateText("Can not parse data")
                    return
                    
                }
                self.updateText("Post count \(list.list.count)")
                
            case let .failure(error):
                self.updateText(error.localizedDescription)
            }
        }
         */
        /**
         网络请求2
         AF.request(url).responseData { response in
             switch response.result{
             case let .success(data):
                 guard let list = try? JSONDecoder().decode(PostList.self, from: data) else {
                     self.updateText("Can not parse data")
                     return
                     
                 }
                 self.updateText("Post count \(list.list.count)")
                 
             case let .failure(error):
                 self.updateText(error.localizedDescription)
             }
         }
         */
        
//        var request = URLRequest(url: url)
//        request.timeoutInterval = 15
//        request.httpMethod = "GET"
//        let task =  URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                DispatchQueue.main.async {
//                    self.text = error.localizedDescription
//                }
//                return
//            }
//            guard let httpResponse = response as? HTTPURLResponse,httpResponse.statusCode == 200 else {
//                DispatchQueue.main.async {
//                    self.text = "Invalid response"
//                }
//                    return
//                }
//            guard let data = data else {
//                self.updateText("NO Data")
//                return
//
//            }
//            guard let list = try? JSONDecoder().decode(PostList.self, from: data) else {
//                self.updateText("Can not parse data")
//                return
//
//            }
//            self.updateText("Post count \(list.list.count)")
//        }
//        task.resume()
    }
    
    func updateText(_ text:String) {
        DispatchQueue.main.async {
            self.text = text
        }
       
    }
}

struct NetView_Previews: PreviewProvider {
    static var previews: some View {
        NetView()
    }
}
