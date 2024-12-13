//
//  RawDataManager.swift
//  SwiftDemo
//
//  Created by app on 2024/12/10.
//

import Foundation
class RawDataManager:NetworkRequest{
    typealias ResponseDataType = Data
       private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    func fetch(completion: @escaping (Result<ResponseDataType, Error>) -> Void) {
           let task = URLSession.shared.dataTask(with: url) { data, response, error in
               if let error = error {
                   completion(.failure(error))
                   return
               }

               guard let data = data else {
                   completion(.failure(NSError(domain: "NoData", code: 0, userInfo: nil)))
                   return
               }

               completion(.success(data))
           }

           task.resume()
       }
}
