//
//  NavigationStackSample.swift
//  TestDemo
//
//  Created by app on 2024/8/20.
//

import SwiftUI

struct NavigationStackSample: View {
    private var countries: [String] = ["China", "Japan", "France", "Korea", "United state"]
    @State private var path = NavigationPath()
//    @State private var path: [String] = []

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                Button {
                    path.append("UK")
                    path.append("India")
                    path.append("1000")
                } label: {
                    Text("Push1").padding()
                }
                
                VStack(spacing:40, content: {
                    ForEach(countries, id: \.self) {country in
                        NavigationLink(value: country) {
                            Text("country\(country)")
                        }
                        
                    }
                    
                    ForEach(0..<10) { i in
                      NavigationLink(value: i) {
                          Text("Index: \(i)")
                      }
                    }
                    
                })
            }.navigationTitle("NavigationStack").navigationDestination(for: Int.self) { country  in
//                CountryView(country: country)
                
                Text("View \(country)")
            }.navigationDestination(for: String.self) { country in
                CountryView(country: country)
            }
        }
    }
}

struct CountryView:View {
    var country = ""
    
    init(country: String = "") {
        self.country = country
        print("【Log】: \(country)")
    }
    
    var body: some View {
        Text(country)
    }
    
}

#Preview {
    NavigationStackSample()
}
