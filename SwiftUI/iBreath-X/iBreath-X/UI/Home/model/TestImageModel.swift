//
//  TestImageModel.swift
//  iBreath-X
//
//  Created by app on 2024/9/23.
//

import Foundation
import Combine

class ImageViewModel: ObservableObject {
    @Published var images: [ImageItem] = []
    private var cancellables = Set<AnyCancellable>()
    
    func fetchImages() {
        guard let url = URL(string: "https://buyhk.oss-cn-guangzhou.aliyuncs.com/content.json") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [ImageItem].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                }
            } receiveValue: { [weak self] imageItems in
                self?.images = imageItems
            }
            .store(in: &cancellables)
    }
}

struct ImageItem: Identifiable, Codable {
    let id: String
    let title: String
    let text: String
    let imageUrl: String
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case id, title, text
        case imageUrl = "image_url"
        case createdAt = "created_at"
    }
}
