//
//  Ring.swift
//  iBreath-X
//
//  Created by app on 2024/8/24.
//

import Foundation
import SwiftUI
class Ring: ObservableObject {
    /// A single wedge within a chart ring.
    struct Wedge: Equatable {
        /// 弧度值（所有楔形的弧度值之合最大为2π，即360°）
        var width: Double
        /// 横轴深度比例 [0,1]. （用来计算楔形的长度）
        var depth: Double
        /// 颜色值
        var hue: Double
    }
}
//struct WedgeShape: Shape {
//  func path(in rect: CGRect) -> Path {
//            // WedgeGeometry是用来计算绘制信息的类，详细代码见Demo。
//        let points = WedgeGeometry(wedge, in: rect)
//
//        var path = Path()
//        path.addArc(center: points.center, radius: points.innerRadius,
//            startAngle: .radians(wedge.start), endAngle: .radians(wedge.end),
//            clockwise: false)
//        path.addLine(to: points[.bottomTrailing])
//        path.addArc(center: points.center, radius: points.outerRadius,
//            startAngle: .radians(wedge.end), endAngle: .radians(wedge.start),
//            clockwise: true)
//        path.closeSubpath()
//        return path
//    }
//  // ···
//}
