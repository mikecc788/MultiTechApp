//
//  TabType.swift
//  iBreath-X
//
//  Created by app on 2024/8/27.
//

import Foundation
enum TabType:Int {
    case home
    case info
    case profile
    // 计算属性 title，根据枚举的不同 case 返回不同的字符串
    var title:String{
        switch self {
            case .home:
                return "Home"
            case .info:
              return "Videos"
            case .profile:
              return "Message"
        }
    }
    
    var image: String {
      switch self {
        case .home:
          return "house.fill"
        case .info:
          return "video.fill"
        case .profile:
          return "message.fill"
      }
    }
}
