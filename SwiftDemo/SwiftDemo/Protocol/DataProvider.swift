//
//  DataProvider.swift
//  SwiftDemo
//
//  Created by app on 2024/12/10.
//

import Foundation

protocol DataProvider {
    associatedtype DataType
    func getData() -> DataType
}

class GenericDataManager<T>: DataProvider {
    typealias DataType = T
    private var data: T
    init(data: T) {
        self.data = data
    }
    func getData() -> T {
        return data
    }
}
