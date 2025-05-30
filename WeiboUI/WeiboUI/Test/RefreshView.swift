//
//  RefreshView.swift
//  WeiboUI
//
//  Created by app on 2022/12/22.
//

import SwiftUI
import SwiftUI_Pull_To_Refresh
struct RefreshView: View {
    @State private var now = Date()
    
    var body: some View {

        
        RefreshableScrollView(onRefresh: {done in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                      self.now = Date()
                      done()
                    }
        }) {
            VStack{
                ForEach(1..<20){
                    Text("\(Calendar.current.date(byAdding: .hour, value: $0, to: now)!)").padding(.bottom,10)
                }
            }
        }
    }
}

struct RefreshView_Previews: PreviewProvider {
    static var previews: some View {
        RefreshView()
    }
}
