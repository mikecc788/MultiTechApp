import UIKit

class AppAppearance {
    static func tabBarAppearance() -> UITabBarAppearance {
        let ap = UITabBarAppearance()
        ap.configureWithTransparentBackground()   // 关闭系统默认白底/毛玻璃
        ap.backgroundColor = .clear
        ap.backgroundEffect = nil
        ap.shadowColor = .clear                   // 去分割线

        // 独立配置 item 外观，避免引用同一实例被系统内部改写导致的偶发现象
        let stacked = UITabBarItemAppearance()
        stacked.normal.iconColor = .secondaryLabel
        stacked.normal.titleTextAttributes = [
            .foregroundColor: UIColor.secondaryLabel,
            .font: UIFont.systemFont(ofSize: 14, weight: .regular)
        ]
        stacked.selected.iconColor = .purple
        stacked.selected.titleTextAttributes = [
            .foregroundColor: UIColor.purple,
            .font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ]
        stacked.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 3)
        stacked.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 3)

        ap.stackedLayoutAppearance = stacked
        ap.inlineLayoutAppearance = stacked.copy() 
        ap.compactInlineLayoutAppearance = stacked.copy() 

        // iOS 17/18 某些构型下会出现“选中圆角胶囊”高亮，这里用透明图去掉
        ap.selectionIndicatorImage = UIImage()
        return ap
    }

    static func navigationBarAppearance() -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        return appearance
    }
}
