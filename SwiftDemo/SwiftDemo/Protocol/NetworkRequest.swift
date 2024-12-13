//
//  NetworkRequest.swift
//  SwiftDemo
//
//  Created by app on 2024/12/10.
//

import Foundation
protocol NetworkRequest {
    associatedtype ResponseDataType
    func fetch(completion: @escaping (Result<ResponseDataType, Error>) -> Void)
}

