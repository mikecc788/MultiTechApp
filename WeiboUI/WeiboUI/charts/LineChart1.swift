//
//  LineChart1.swift
//  WeiboUI
//
//  Created by app on 2022/12/27.
//

import SwiftUI
import Charts


struct LocaleInfo: Identifiable, Hashable {
    var id: String {
        identifier
    }

    let identifier: String
    let language: String
    let currencyCode: String
    let currencySymbol: String
    let price: Int = .random(in: 3...6)
    let updateDate = Date.now.addingTimeInterval(.random(in: -100000...100000))
    var supported: Bool = .random()

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
// 生成演示数据
func prepareData() -> [LocaleInfo] {
    Locale.availableIdentifiers
        .map {
            let cnLocale = Locale(identifier: "zh-cn")
            let locale = Locale(identifier: $0)
            return LocaleInfo(
                identifier: $0,
                language: cnLocale.localizedString(forIdentifier: $0) ?? "",
                currencyCode: locale.currencyCode ?? "",
                currencySymbol: locale.currencySymbol ?? ""
            )
        }
        .filter {
            !($0.currencySymbol.isEmpty || $0.currencySymbol.isEmpty || $0.currencyCode.isEmpty)
        }
}

struct BlurTest: View{
    var body: some View {
        //cc889966886
        ZStack {
            Color.init("31D3D3").edgesIgnoringSafeArea(.all)
            VStack {
                Text(".ultraThin").padding().frame(width: 200, height: 100).background(.ultraThinMaterial)
                Text(".thin").padding().frame(width: 200, height: 100).background(.thinMaterial)
                Text(".regular").padding().frame(width: 200, height: 100).background(.regularMaterial)
                Text(".thick").padding().frame(width: 200, height: 100).background(.thickMaterial)
                Text(".ultraThick").padding().frame(width: 200, height: 100).background(.ultraThickMaterial)
            }.padding().shadow(color: .black.opacity(0.2), radius: 5,x: 0,y: 8)
        }
    }
}

struct LineChart1: View {
    @State var localeInfos = [LocaleInfo]()
    @State var animated = false
    var body: some View {
        BlurTest()
        
//        Text("Hello ").offset(x:animated ? 200 : 0).animation(.easeOut, value: animated).frame(width: 500,height: 300).onAppear{animated.toggle()}
//        if #available(iOS 16.0, *) {
//            Table (localeInfos) {
//                TableColumn("标识符", value: \.identifier).width(min: 50,max: 50)
//                TableColumn("语言", value: \.language).width(min: 200,max: 300)
//                TableColumn("价格") {
//                    Text("\($0.price)")
//                        .foregroundColor($0.price > 4 ? .red : .green)
//                }
//                TableColumn("货币代码", value: \.currencyCode)
//                TableColumn("货币符号", value: \.currencySymbol)
//            }.task {
//                localeInfos = prepareData()
//            }
//        }
    }
}

struct LineChart1_Previews: PreviewProvider {
    static var previews: some View {
        LineChart1()
    }
}
