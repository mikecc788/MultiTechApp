//
//  TestA.swift
//  WeiboUI
//
//  Created by app on 2022/11/29.
//

import SwiftUI

class DelayedUpdater: ObservableObject {
    @Published var value = 0
    init() {
        for i in 1...10 {
            DispatchQueue.main.asyncAfter(deadline: .now()+Double(i)){
                self.value += 1
            }
        }
    }
}

class EnvironmentShopEntity:ObservableObject{
    @Published var count: Int = 0
    func increase() -> Void {
        self.count += 1
    }
    
    func decrease() -> Void {
        self.count -= 1
    }
}

struct BtnView:View {
    @Binding var isShowText: Bool
    var body: some View{
        Button {
            debugPrint("aaaaaa")
            isShowText.toggle()
        } label: {
            Text("click")
        }

    }
}


struct EnvironmentView1:View {
    @EnvironmentObject var updater:DelayedUpdater
    var body: some View{
        Text("\(updater.value)")
    }
}
struct EnvironmentView2:View {
    @EnvironmentObject var updater:DelayedUpdater
    var body: some View{
        Text("\(updater.value)")
    }
}

struct EnvironmentShopView:View{
    @EnvironmentObject var entity:EnvironmentShopEntity
    var body: some View {
        VStack {
            Text("商品个数: \(entity.count)").padding()
            Button(action: {
                self.entity.increase()
            }, label: {
                Text("增加")
            }).padding()
            Button(action: {
                self.entity.decrease()
            }, label: {
                Text("减少")
            }).padding()
        }
    }
}


struct TestB: View {
    @ObservedObject var updater = DelayedUpdater()
    let updateModel = DelayedUpdater()
    
    let entity = EnvironmentShopEntity()
    var body: some View {
        VStack {
            Text("\(updater.value)").padding()
            EnvironmentView1().environmentObject(updateModel)
            EnvironmentView2().environmentObject(updateModel)
            EnvironmentShopView().environmentObject(entity)
        }
    }
}
struct TestA: View {
    @State private var isShowText: Bool = true
    var body: some View {
        VStack {
            if(isShowText){
                Text("点击后会被隐藏")
            }else {
                Text("点击后会被显示").hidden()
            }
            
            BtnView(isShowText: $isShowText)
        }
    }
}

struct TestA_Previews: PreviewProvider {
    static var previews: some View {
//        TestA()
        TestB()
    }
}
