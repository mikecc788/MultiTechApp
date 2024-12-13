//
//  GenericNetworkManager.swift
//  SwiftDemo
//
//  Created by app on 2024/12/10.
//

import Foundation

class GenericNetworkManager<T:Decodable>:NetworkRequest{
    typealias ResponseDataType = T
    private let url:URL
    init(url: URL) {
        self.url = url
    }
    
    func fetch(completion: @escaping (Result<T, any Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url){data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0, userInfo: nil)))
                return }
            do{
                let decodedData = try JSONDecoder().decode(ResponseDataType.self, from: data)
                completion(.success(decodedData))
            }catch{
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
