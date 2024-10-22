//
//  Movie.swift
//  TestDemo
//
//  Created by app on 2024/8/22.
//

import Foundation

struct Movie: Identifiable {
    let id = UUID()
    let title: String
    let year: Int
    let rating: Double
}
