//
//  WebImageExample.swift
//  WeiboUI
//
//  Created by app on 2022/12/21.
//

import SwiftUI
import SDWebImageSwiftUI
struct WebImageExample: View {
    let url = URL(string: "https://github.com/xiaoyouxinqing/PostDemo/raw/master/PostDemo/Resources/006PdkDogy1gap6ngiyn3j30u011idle.jpg")!
    
    var body: some View {
        WebImage(url: url).placeholder{Color.gray}.resizable().onSuccess(perform: { (_ , _, _) in
            print("Success")
            SDWebImageManager.shared.imageCache.clear(with: .all,completion: nil)
        }).onFailure(perform: { _ in
            print("Failure")
        }).scaledToFill().frame(height: 600).clipped()
    }
}

struct WebImageExample_Previews: PreviewProvider {
    static var previews: some View {
        WebImageExample()
    }
}
