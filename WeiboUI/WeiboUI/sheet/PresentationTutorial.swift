//
//  PresentationTutorial.swift
//  WeiboUI
//
//  Created by app on 2022/12/29.
//

import SwiftUI

struct PresentationTutorial: View {
    var body: some View {
        VStack {
            List(1..<6) { index in
                Text("item \(index)")
            }
            
            Button("show dialog") {
                
            }
        }
    }
}

struct PresentationTutorial_Previews: PreviewProvider {
    static var previews: some View {
        PresentationTutorial()
    }
}
