//
//  MovieListView.swift
//  TestDemo
//
//  Created by app on 2024/8/22.
//

import SwiftUI

struct MovieListView: View {
    @Environment(MovieStore.self) private var movieStore
    
    var body: some View {
        List {
            ForEach(movieStore.movies){movie in
                Text(movie.title)
            }
        }
    }
}

#Preview {
    MovieListView().environment(MovieStore()).preferredColorScheme(.light)
}
