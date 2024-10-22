//
//  ProfileView.swift
//  iBreath-X
//
//  Created by app on 2024/8/22.
//

import SwiftUI

struct ProfileView: View {
 
    init() {
        UICollectionView.appearance().backgroundColor = .clear
    }
    var body: some View {
        NavigationStack() {
            VStack{
                Spacer().frame(height: 50)
                Image("圆形 2") // 替换为用户头像的图片
                   .resizable()
                   .frame(width: 100, height: 100)
                   .clipShape(Circle())
                Text("Lili")
                   .font(.title)
                Spacer().frame(height: 20)
                HStack(spacing: 20) {
                      VStack(alignment: .leading) {
                          Text("sex: male")
                          Text("height: 170 cm")
                      }
                      VStack(alignment: .trailing) {
                          Text("age: 28")
                          Text("weight: 28 kg")
                      }
                }
                Spacer().frame(height: 20)
                Button(action: {
                    Task{
                        await loadData()
                    }
                }) {
                    Text("Edit info")
                        .padding()
                        .background(Capsule().fill(Color.white))
                }
                Spacer().frame(height: 40)
                List{
                    ForEach(ProfileStroe.menuItems){items in
                        NavigationLink(value:items.type) {
                            HStack {
                                Image(items.imageName)
                                Text(items.title)
                                Spacer()
                            }.padding(.vertical,10).background(Color.white).padding(.horizontal,5)
                        }
                    }
                }.listRowSpacing(20).modifier(ListBackgroundModifier())
            }.background(MyColorScheme.bgColor).profileRoutes()
            
        }
    }
    func loadData()  async{
        let urlStr = "bifen4pc.qiumibao.com/198.18.0.101:443"
        guard let url = URL(string: urlStr) else {
            print("Invaild URL")
            return
        }
        
        URLSession.shared.dataTask(with: url){ (data,response,error) in
            if let error = error{
                print("error=\(error)")
                return
            }
            
            if let data = data{
                print("data=\(data)")
                do{
                    let per = try JSONDecoder().decode(DeviceInfo.self, from: data)
                    print(per.id)
                }catch {
                    print("")
                }
               
                return
            }else{
                
            }
        }.resume()
    }
}

struct DeviceInfo:Codable{
    let id : String
    
}

#Preview {
    ProfileView()
}
