//
//  StateObjectClass.swift
//  CustomTabBar
//
//  Created by app on 2022/12/27.
//

import SwiftUI

class StateObjectClass: ObservableObject {
    let type:String
    let id:Int
    @Published var count = 0
    
    init(type:String){
        self.type = type
        self.id = Int.random(in: 0...1000)
        print("type:\(type) id:\(id) init")
    }
    
    deinit {
           print("type:\(type) id:\(id) deinit")
    }
}

struct CountViewState:View{
    @StateObject var state = StateObjectClass(type:"StateObject")
    var body: some View{
        VStack{
            Text("@StateObject count :\(state.count)")
            Button("+1"){
                state.count += 1
            }
        }
    }
}
struct CountViewObserved:View{
    @ObservedObject var state = StateObjectClass(type:"Observed")
    var body: some View{
        VStack {
            Text("@Observed count :\(state.count)")
            Button("+1"){
                state.count += 1
            }
        }
    }
    
}
