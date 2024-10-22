//
//  PopView.swift
//  WeiboUI
//
//  Created by app on 2022/12/26.
//

import SwiftUI
struct SheetView:View{
    @Binding var showSheet:Bool
    var body: some View{
        VStack{
            Button {
                self.showSheet = false
            } label: {
                Text("close")
            }.frame(minWidth: 0,maxWidth: .infinity,alignment: .topTrailing).padding()

            Spacer()
        }
    }
}
struct PopView: View {
@State private var showSheet:Bool = false
    var body: some View {
        VStack {
            Button {
                self.showSheet = true
            } label: {
                Text("显示pop")
            }.font(.title).sheet(isPresented: self.$showSheet) {
                SheetView(showSheet:self.$showSheet)
            }

        }
    }
}

struct PopView_Previews: PreviewProvider {
    static var previews: some View {
        PopView()
    }
}
