//
//  PostImageCell.swift
//  WeiboUI
//
//  Created by app on 2022/11/25.
//

import SwiftUI
private let kImageSpace: CGFloat = 6
struct PostImageCell: View {
    let images:[String]
    let width:CGFloat
    var body: some View {
        Group{
            if images.count == 1{
                loadImage(name: images[0]).resizable().scaledToFill().frame(width: width, height: width * 0.75).clipped()
            }else if images.count == 2{
                PostImageCellRow(images: Array(images[0...1]), width: width)
            }else if images.count == 3{
                PostImageCellRow(images: Array(images[0...2]), width: width)
            }else if images.count == 4{
                VStack {
                    PostImageCellRow(images: Array(images[0...1]), width: width)
                    PostImageCellRow(images: Array(images[2...3]), width: width)
                }
            }else if images.count == 5{
                VStack {
                    PostImageCellRow(images: Array(images[0...1]), width: width)
                    PostImageCellRow(images: Array(images[2...4]), width: width)
                }
            }else if images.count == 6{
                VStack {
                    PostImageCellRow(images: Array(images[0...2]), width: width)
                    PostImageCellRow(images: Array(images[3...5]), width: width)
                }
            }
        }
        
        
    }
}
struct PostImageCellRow: View {
    let images: [String]
    let width: CGFloat
    var body: some View {
        HStack(alignment: .center, spacing: kImageSpace){
            ForEach(images, id: \.self) { image in
                loadImage(name: image).resizable().scaledToFill().frame(width: (self.width - kImageSpace * CGFloat(self.images.count - 1)) / CGFloat(self.images.count), height: (self.width - kImageSpace * CGFloat(self.images.count - 1)) / CGFloat(self.images.count)).clipped()
            }
        }
    }
}
struct PostImageCell_Previews: PreviewProvider {
    static var previews: some View {
        let images = postList.list[0].images
        let width = UIScreen.main.bounds.width
        return Group{
            PostImageCell(images: Array(images[0...0]), width: width)
            PostImageCell(images: Array(images[0...1]), width: width)
            PostImageCell(images: Array(images[0...2]), width: width)
            PostImageCell(images: Array(images[0...3]), width: width)
            PostImageCell(images: Array(images[0...4]), width: width)
            PostImageCell(images: Array(images[0...5]), width: width)
        }.previewLayout(.fixed(width: width, height: 300))
        
    }
}
