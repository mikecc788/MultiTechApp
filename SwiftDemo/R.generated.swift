//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap { Locale(identifier: $0) } ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)

  /// Find first language and bundle for which the table exists
  fileprivate static func localeBundle(tableName: String, preferredLanguages: [String]) -> (Foundation.Locale, Foundation.Bundle)? {
    // Filter preferredLanguages to localizations, use first locale
    var languages = preferredLanguages
      .map { Locale(identifier: $0) }
      .prefix(1)
      .flatMap { locale -> [String] in
        if hostingBundle.localizations.contains(locale.identifier) {
          if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
            return [locale.identifier, language]
          } else {
            return [locale.identifier]
          }
        } else if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
          return [language]
        } else {
          return []
        }
      }

    // If there's no languages, use development language as backstop
    if languages.isEmpty {
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages = [developmentLocalization]
      }
    } else {
      // Insert Base as second item (between locale identifier and languageCode)
      languages.insert("Base", at: 1)

      // Add development language as backstop
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages.append(developmentLocalization)
      }
    }

    // Find first language for which table exists
    // Note: key might not exist in chosen language (in that case, key will be shown)
    for language in languages {
      if let lproj = hostingBundle.url(forResource: language, withExtension: "lproj"),
         let lbundle = Bundle(url: lproj)
      {
        let strings = lbundle.url(forResource: tableName, withExtension: "strings")
        let stringsdict = lbundle.url(forResource: tableName, withExtension: "stringsdict")

        if strings != nil || stringsdict != nil {
          return (Locale(identifier: language), lbundle)
        }
      }
    }

    // If table is available in main bundle, don't look for localized resources
    let strings = hostingBundle.url(forResource: tableName, withExtension: "strings", subdirectory: nil, localization: nil)
    let stringsdict = hostingBundle.url(forResource: tableName, withExtension: "stringsdict", subdirectory: nil, localization: nil)

    if strings != nil || stringsdict != nil {
      return (applicationLocale, hostingBundle)
    }

    // If table is not found for requested languages, key will be shown
    return nil
  }

  /// Load string from Info.plist file
  fileprivate static func infoPlistString(path: [String], key: String) -> String? {
    var dict = hostingBundle.infoDictionary
    for step in path {
      guard let obj = dict?[step] as? [String: Any] else { return nil }
      dict = obj
    }
    return dict?[key] as? String
  }

  static func validate() throws {
    try intern.validate()
  }

  #if os(iOS) || os(tvOS)
  /// This `R.storyboard` struct is generated, and contains static references to 2 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `Main`.
    static let main = _R.storyboard.main()

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "Main", bundle: ...)`
    static func main(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.main)
    }
    #endif

    fileprivate init() {}
  }
  #endif

  /// This `R.color` struct is generated, and contains static references to 1 colors.
  struct color {
    /// Color `AccentColor`.
    static let accentColor = Rswift.ColorResource(bundle: R.hostingBundle, name: "AccentColor")

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "AccentColor", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func accentColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.accentColor, compatibleWith: traitCollection)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "AccentColor", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func accentColor(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.accentColor.name)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.file` struct is generated, and contains static references to 19 files.
  struct file {
    /// Resource file `book@2x.png`.
    static let book2xPng = Rswift.FileResource(bundle: R.hostingBundle, name: "book@2x", pathExtension: "png")
    /// Resource file `defaultAvatar@2x.jpg`.
    static let defaultAvatar2xJpg = Rswift.FileResource(bundle: R.hostingBundle, name: "defaultAvatar@2x", pathExtension: "jpg")
    /// Resource file `detailBg@2x.png`.
    static let detailBg2xPng = Rswift.FileResource(bundle: R.hostingBundle, name: "detailBg@2x", pathExtension: "png")
    /// Resource file `home@2x.png`.
    static let home2xPng = Rswift.FileResource(bundle: R.hostingBundle, name: "home@2x", pathExtension: "png")
    /// Resource file `home_selected@2x.png`.
    static let home_selected2xPng = Rswift.FileResource(bundle: R.hostingBundle, name: "home_selected@2x", pathExtension: "png")
    /// Resource file `icon_between@2x.png`.
    static let icon_between2xPng = Rswift.FileResource(bundle: R.hostingBundle, name: "icon_between@2x", pathExtension: "png")
    /// Resource file `icon_cal@2x.png`.
    static let icon_cal2xPng = Rswift.FileResource(bundle: R.hostingBundle, name: "icon_cal@2x", pathExtension: "png")
    /// Resource file `icon_column@2x.png`.
    static let icon_column2xPng = Rswift.FileResource(bundle: R.hostingBundle, name: "icon_column@2x", pathExtension: "png")
    /// Resource file `icon_course@2x.png`.
    static let icon_course2xPng = Rswift.FileResource(bundle: R.hostingBundle, name: "icon_course@2x", pathExtension: "png")
    /// Resource file `icon_document@2x.png`.
    static let icon_document2xPng = Rswift.FileResource(bundle: R.hostingBundle, name: "icon_document@2x", pathExtension: "png")
    /// Resource file `icon_life@2x.png`.
    static let icon_life2xPng = Rswift.FileResource(bundle: R.hostingBundle, name: "icon_life@2x", pathExtension: "png")
    /// Resource file `icon_live@2x.png`.
    static let icon_live2xPng = Rswift.FileResource(bundle: R.hostingBundle, name: "icon_live@2x", pathExtension: "png")
    /// Resource file `icon_phone@2x.png`.
    static let icon_phone2xPng = Rswift.FileResource(bundle: R.hostingBundle, name: "icon_phone@2x", pathExtension: "png")
    /// Resource file `icon_pwd@2x.png`.
    static let icon_pwd2xPng = Rswift.FileResource(bundle: R.hostingBundle, name: "icon_pwd@2x", pathExtension: "png")
    /// Resource file `icon_right_arrow@2x.png`.
    static let icon_right_arrow2xPng = Rswift.FileResource(bundle: R.hostingBundle, name: "icon_right_arrow@2x", pathExtension: "png")
    /// Resource file `logo@2x.png`.
    static let logo2xPng = Rswift.FileResource(bundle: R.hostingBundle, name: "logo@2x", pathExtension: "png")
    /// Resource file `mine@2x.png`.
    static let mine2xPng = Rswift.FileResource(bundle: R.hostingBundle, name: "mine@2x", pathExtension: "png")
    /// Resource file `mine_selected@2x.png`.
    static let mine_selected2xPng = Rswift.FileResource(bundle: R.hostingBundle, name: "mine_selected@2x", pathExtension: "png")
    /// Resource file `student@2x.png`.
    static let student2xPng = Rswift.FileResource(bundle: R.hostingBundle, name: "student@2x", pathExtension: "png")

    /// `bundle.url(forResource: "book@2x", withExtension: "png")`
    static func book2xPng(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.book2xPng
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "defaultAvatar@2x", withExtension: "jpg")`
    static func defaultAvatar2xJpg(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.defaultAvatar2xJpg
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "detailBg@2x", withExtension: "png")`
    static func detailBg2xPng(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.detailBg2xPng
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "home@2x", withExtension: "png")`
    static func home2xPng(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.home2xPng
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "home_selected@2x", withExtension: "png")`
    static func home_selected2xPng(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.home_selected2xPng
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "icon_between@2x", withExtension: "png")`
    static func icon_between2xPng(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.icon_between2xPng
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "icon_cal@2x", withExtension: "png")`
    static func icon_cal2xPng(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.icon_cal2xPng
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "icon_column@2x", withExtension: "png")`
    static func icon_column2xPng(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.icon_column2xPng
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "icon_course@2x", withExtension: "png")`
    static func icon_course2xPng(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.icon_course2xPng
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "icon_document@2x", withExtension: "png")`
    static func icon_document2xPng(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.icon_document2xPng
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "icon_life@2x", withExtension: "png")`
    static func icon_life2xPng(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.icon_life2xPng
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "icon_live@2x", withExtension: "png")`
    static func icon_live2xPng(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.icon_live2xPng
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "icon_phone@2x", withExtension: "png")`
    static func icon_phone2xPng(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.icon_phone2xPng
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "icon_pwd@2x", withExtension: "png")`
    static func icon_pwd2xPng(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.icon_pwd2xPng
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "icon_right_arrow@2x", withExtension: "png")`
    static func icon_right_arrow2xPng(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.icon_right_arrow2xPng
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "logo@2x", withExtension: "png")`
    static func logo2xPng(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.logo2xPng
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "mine@2x", withExtension: "png")`
    static func mine2xPng(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.mine2xPng
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "mine_selected@2x", withExtension: "png")`
    static func mine_selected2xPng(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.mine_selected2xPng
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "student@2x", withExtension: "png")`
    static func student2xPng(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.student2xPng
      return fileResource.bundle.url(forResource: fileResource)
    }

    fileprivate init() {}
  }

  /// This `R.image` struct is generated, and contains static references to 35 images.
  struct image {
    /// Image `book`.
    static let book = Rswift.ImageResource(bundle: R.hostingBundle, name: "book")
    /// Image `defaultAvatar.jpg`.
    static let defaultAvatarJpg = Rswift.ImageResource(bundle: R.hostingBundle, name: "defaultAvatar.jpg")
    /// Image `detailBg`.
    static let detailBg = Rswift.ImageResource(bundle: R.hostingBundle, name: "detailBg")
    /// Image `home_selected`.
    static let home_selected = Rswift.ImageResource(bundle: R.hostingBundle, name: "home_selected")
    /// Image `home`.
    static let home = Rswift.ImageResource(bundle: R.hostingBundle, name: "home")
    /// Image `icon_between`.
    static let icon_between = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_between")
    /// Image `icon_cal`.
    static let icon_cal = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_cal")
    /// Image `icon_column`.
    static let icon_column = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_column")
    /// Image `icon_course`.
    static let icon_course = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_course")
    /// Image `icon_document`.
    static let icon_document = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_document")
    /// Image `icon_life`.
    static let icon_life = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_life")
    /// Image `icon_live`.
    static let icon_live = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_live")
    /// Image `icon_phone`.
    static let icon_phone = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_phone")
    /// Image `icon_pwd`.
    static let icon_pwd = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_pwd")
    /// Image `icon_right_arrow`.
    static let icon_right_arrow = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_right_arrow")
    /// Image `logo`.
    static let logo = Rswift.ImageResource(bundle: R.hostingBundle, name: "logo")
    /// Image `meLine_5x52_`.
    static let meLine_5x52_ = Rswift.ImageResource(bundle: R.hostingBundle, name: "meLine_5x52_")
    /// Image `mine_selected`.
    static let mine_selected = Rswift.ImageResource(bundle: R.hostingBundle, name: "mine_selected")
    /// Image `mine`.
    static let mine = Rswift.ImageResource(bundle: R.hostingBundle, name: "mine")
    /// Image `msg`.
    static let msg = Rswift.ImageResource(bundle: R.hostingBundle, name: "msg")
    /// Image `set`.
    static let set = Rswift.ImageResource(bundle: R.hostingBundle, name: "set")
    /// Image `student`.
    static let student = Rswift.ImageResource(bundle: R.hostingBundle, name: "student")
    /// Image `tom`.
    static let tom = Rswift.ImageResource(bundle: R.hostingBundle, name: "tom")
    /// Image `vip`.
    static let vip = Rswift.ImageResource(bundle: R.hostingBundle, name: "vip")
    /// Image `工作台`.
    static let 工作台 = Rswift.ImageResource(bundle: R.hostingBundle, name: "工作台")
    /// Image `意见反馈`.
    static let 意见反馈 = Rswift.ImageResource(bundle: R.hostingBundle, name: "意见反馈")
    /// Image `扫一扫`.
    static let 扫一扫 = Rswift.ImageResource(bundle: R.hostingBundle, name: "扫一扫")
    /// Image `搜索`.
    static let 搜索 = Rswift.ImageResource(bundle: R.hostingBundle, name: "搜索")
    /// Image `月亮`.
    static let 月亮 = Rswift.ImageResource(bundle: R.hostingBundle, name: "月亮")
    /// Image `沙漏`.
    static let 沙漏 = Rswift.ImageResource(bundle: R.hostingBundle, name: "沙漏")
    /// Image `直播`.
    static let 直播 = Rswift.ImageResource(bundle: R.hostingBundle, name: "直播")
    /// Image `视频`.
    static let 视频 = Rswift.ImageResource(bundle: R.hostingBundle, name: "视频")
    /// Image `钱包`.
    static let 钱包 = Rswift.ImageResource(bundle: R.hostingBundle, name: "钱包")
    /// Image `钱数`.
    static let 钱数 = Rswift.ImageResource(bundle: R.hostingBundle, name: "钱数")
    /// Image `麦克风`.
    static let 麦克风 = Rswift.ImageResource(bundle: R.hostingBundle, name: "麦克风")

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "book", bundle: ..., traitCollection: ...)`
    static func book(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.book, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "defaultAvatar.jpg", bundle: ..., traitCollection: ...)`
    static func defaultAvatarJpg(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.defaultAvatarJpg, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "detailBg", bundle: ..., traitCollection: ...)`
    static func detailBg(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.detailBg, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "home", bundle: ..., traitCollection: ...)`
    static func home(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.home, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "home_selected", bundle: ..., traitCollection: ...)`
    static func home_selected(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.home_selected, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "icon_between", bundle: ..., traitCollection: ...)`
    static func icon_between(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_between, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "icon_cal", bundle: ..., traitCollection: ...)`
    static func icon_cal(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_cal, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "icon_column", bundle: ..., traitCollection: ...)`
    static func icon_column(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_column, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "icon_course", bundle: ..., traitCollection: ...)`
    static func icon_course(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_course, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "icon_document", bundle: ..., traitCollection: ...)`
    static func icon_document(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_document, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "icon_life", bundle: ..., traitCollection: ...)`
    static func icon_life(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_life, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "icon_live", bundle: ..., traitCollection: ...)`
    static func icon_live(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_live, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "icon_phone", bundle: ..., traitCollection: ...)`
    static func icon_phone(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_phone, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "icon_pwd", bundle: ..., traitCollection: ...)`
    static func icon_pwd(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_pwd, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "icon_right_arrow", bundle: ..., traitCollection: ...)`
    static func icon_right_arrow(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_right_arrow, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "logo", bundle: ..., traitCollection: ...)`
    static func logo(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.logo, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "meLine_5x52_", bundle: ..., traitCollection: ...)`
    static func meLine_5x52_(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.meLine_5x52_, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mine", bundle: ..., traitCollection: ...)`
    static func mine(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mine, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mine_selected", bundle: ..., traitCollection: ...)`
    static func mine_selected(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mine_selected, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "msg", bundle: ..., traitCollection: ...)`
    static func msg(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.msg, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "set", bundle: ..., traitCollection: ...)`
    static func set(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.set, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "student", bundle: ..., traitCollection: ...)`
    static func student(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.student, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "tom", bundle: ..., traitCollection: ...)`
    static func tom(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.tom, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "vip", bundle: ..., traitCollection: ...)`
    static func vip(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.vip, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "工作台", bundle: ..., traitCollection: ...)`
    static func 工作台(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.工作台, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "意见反馈", bundle: ..., traitCollection: ...)`
    static func 意见反馈(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.意见反馈, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "扫一扫", bundle: ..., traitCollection: ...)`
    static func 扫一扫(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.扫一扫, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "搜索", bundle: ..., traitCollection: ...)`
    static func 搜索(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.搜索, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "月亮", bundle: ..., traitCollection: ...)`
    static func 月亮(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.月亮, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "沙漏", bundle: ..., traitCollection: ...)`
    static func 沙漏(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.沙漏, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "直播", bundle: ..., traitCollection: ...)`
    static func 直播(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.直播, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "视频", bundle: ..., traitCollection: ...)`
    static func 视频(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.视频, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "钱包", bundle: ..., traitCollection: ...)`
    static func 钱包(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.钱包, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "钱数", bundle: ..., traitCollection: ...)`
    static func 钱数(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.钱数, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "麦克风", bundle: ..., traitCollection: ...)`
    static func 麦克风(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.麦克风, compatibleWith: traitCollection)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.info` struct is generated, and contains static references to 1 properties.
  struct info {
    struct uiApplicationSceneManifest {
      static let _key = "UIApplicationSceneManifest"
      static let uiApplicationSupportsMultipleScenes = false

      struct uiSceneConfigurations {
        static let _key = "UISceneConfigurations"

        struct uiWindowSceneSessionRoleApplication {
          struct defaultConfiguration {
            static let _key = "Default Configuration"
            static let uiSceneConfigurationName = infoPlistString(path: ["UIApplicationSceneManifest", "UISceneConfigurations", "UIWindowSceneSessionRoleApplication", "Default Configuration"], key: "UISceneConfigurationName") ?? "Default Configuration"
            static let uiSceneDelegateClassName = infoPlistString(path: ["UIApplicationSceneManifest", "UISceneConfigurations", "UIWindowSceneSessionRoleApplication", "Default Configuration"], key: "UISceneDelegateClassName") ?? "$(PRODUCT_MODULE_NAME).SceneDelegate"
            static let uiSceneStoryboardFile = infoPlistString(path: ["UIApplicationSceneManifest", "UISceneConfigurations", "UIWindowSceneSessionRoleApplication", "Default Configuration"], key: "UISceneStoryboardFile") ?? "Main"

            fileprivate init() {}
          }

          fileprivate init() {}
        }

        fileprivate init() {}
      }

      fileprivate init() {}
    }

    fileprivate init() {}
  }

  /// This `R.nib` struct is generated, and contains static references to 2 nibs.
  struct nib {
    /// Nib `BLEVC`.
    static let blevC = _R.nib._BLEVC()
    /// Nib `INNHomeViewCell`.
    static let innHomeViewCell = _R.nib._INNHomeViewCell()

    #if os(iOS) || os(tvOS)
    /// `UINib(name: "BLEVC", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.blevC) instead")
    static func blevC(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.blevC)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UINib(name: "INNHomeViewCell", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.innHomeViewCell) instead")
    static func innHomeViewCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.innHomeViewCell)
    }
    #endif

    static func blevC(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
      return R.nib.blevC.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
    }

    static func innHomeViewCell(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> INNHomeViewCell? {
      return R.nib.innHomeViewCell.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? INNHomeViewCell
    }

    fileprivate init() {}
  }

  /// This `R.reuseIdentifier` struct is generated, and contains static references to 1 reuse identifiers.
  struct reuseIdentifier {
    /// Reuse identifier `INNHomeViewCell`.
    static let innHomeViewCell: Rswift.ReuseIdentifier<INNHomeViewCell> = Rswift.ReuseIdentifier(identifier: "INNHomeViewCell")

    fileprivate init() {}
  }

  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }

    fileprivate init() {}
  }

  fileprivate class Class {}

  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    #if os(iOS) || os(tvOS)
    try storyboard.validate()
    #endif
  }

  #if os(iOS) || os(tvOS)
  struct nib {
    struct _BLEVC: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "BLEVC"

      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
      }

      fileprivate init() {}
    }

    struct _INNHomeViewCell: Rswift.NibResourceType, Rswift.ReuseIdentifierType {
      typealias ReusableType = INNHomeViewCell

      let bundle = R.hostingBundle
      let identifier = "INNHomeViewCell"
      let name = "INNHomeViewCell"

      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> INNHomeViewCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? INNHomeViewCell
      }

      fileprivate init() {}
    }

    fileprivate init() {}
  }
  #endif

  #if os(iOS) || os(tvOS)
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      #if os(iOS) || os(tvOS)
      try launchScreen.validate()
      #endif
      #if os(iOS) || os(tvOS)
      try main.validate()
      #endif
    }

    #if os(iOS) || os(tvOS)
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController

      let bundle = R.hostingBundle
      let name = "LaunchScreen"

      static func validate() throws {
        if #available(iOS 11.0, tvOS 11.0, *) {
        }
      }

      fileprivate init() {}
    }
    #endif

    #if os(iOS) || os(tvOS)
    struct main: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UITabBarController

      let bundle = R.hostingBundle
      let name = "Main"

      static func validate() throws {
        if UIKit.UIImage(named: "home.png", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'home.png' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIKit.UIImage(named: "home_selected.png", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'home_selected.png' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIKit.UIImage(named: "icon_life.png", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'icon_life.png' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIKit.UIImage(named: "mine.png", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'mine.png' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIKit.UIImage(named: "mine_selected.png", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'mine_selected.png' is used in storyboard 'Main', but couldn't be loaded.") }
        if #available(iOS 11.0, tvOS 11.0, *) {
        }
      }

      fileprivate init() {}
    }
    #endif

    fileprivate init() {}
  }
  #endif

  fileprivate init() {}
}
