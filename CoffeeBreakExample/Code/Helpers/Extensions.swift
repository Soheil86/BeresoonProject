//
//  Extensions.swift
//  CoffeeBreakExample
//
//  Created by Alex Nagy on 21/05/2018.
//  Copyright © 2018 Alex Nagy. All rights reserved.
//

import UIKit

enum UIUserInterfaceIdiom: Int {
  case undefined
  case phone
  case pad
}

struct ScreenSize {
  static let width = UIScreen.main.bounds.size.width
  static let height = UIScreen.main.bounds.size.height
  static let maxLength = max(ScreenSize.width, ScreenSize.height)
  static let minLength = min(ScreenSize.width, ScreenSize.height)
}

struct DeviceType {
  static let isiPhone4OrLess = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength < 568.0
  static let isiPhone5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 568.0
  static let isiPhone6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 667.0
  static let isiPhone6Plus = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 736.0
  static let isiPhoneX = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 812.0
  static let isiPad = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.maxLength == 1024.0
  static let isiPadPro = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.maxLength == 1366.0
  
}

extension Dictionary {
  mutating func update(with other:Dictionary) {
    for (key,value) in other {
      self.updateValue(value, forKey:key)
    }
  }
}

public extension CGFloat {
  
  public static func random() -> CGFloat {
    return CGFloat(CGFloat(arc4random()) / 0xFFFFFFFF)
  }
  
  public static func random(_ min: CGFloat, max: CGFloat) -> CGFloat {
    return CGFloat.random() * (max - min) + min
  }
  
}

extension Date {
  func timeAgoDisplay() -> String {
    let secondsAgo = Int(Date().timeIntervalSince(self))
    
    let minute = 60
    let hour = 60 * minute
    let day = 24 * hour
    let week = 7 * day
    let month = 4 * week
    let year = 12 * month
    
    let value: Int
    let unit: String
    if secondsAgo < minute {
      value = secondsAgo
      unit = "sec"
    } else if secondsAgo < hour {
      value = secondsAgo / minute
      unit = "min"
    } else if secondsAgo < day {
      value = secondsAgo / hour
      unit = "hour"
    } else if secondsAgo < week {
      value = secondsAgo / day
      unit = "day"
    } else if secondsAgo < month {
      value = secondsAgo / week
      unit = "week"
    } else if secondsAgo < year {
      value = secondsAgo / month
      unit = "month"
    } else {
      value = secondsAgo / year
      unit = "year"
    }
    
    return "\(value) \(unit)\(value == 1 ? "" : "s") ago"
    
  }
}

extension UIApplication {
  class func getTopMostViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    if let nav = base as? UINavigationController {
      return getTopMostViewController(base: nav.visibleViewController)
    }
    if let tab = base as? UITabBarController {
      if let selected = tab.selectedViewController {
        return getTopMostViewController(base: selected)
      }
    }
    if let presented = base?.presentedViewController {
      return getTopMostViewController(base: presented)
    }
    return base
  }
}

