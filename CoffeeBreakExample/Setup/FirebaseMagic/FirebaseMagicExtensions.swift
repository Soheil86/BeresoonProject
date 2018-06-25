//
//  FirebaseMagicExtensions.swift
//  CoffeeBreakExample
//
//  Created by Alex Nagy on 24/06/2018.
//  Copyright © 2018 Alex Nagy. All rights reserved.
//

import Foundation

extension String {
  func firebaseKeyCompatible() -> String {
    return self.lowercased().replacingOccurrences(of: " ", with: "_").replacingOccurrences(of: ".", with: "_").replacingOccurrences(of: "#", with: "_").replacingOccurrences(of: "$", with: "_").replacingOccurrences(of: "[", with: "_").replacingOccurrences(of: "]", with: "_").replacingOccurrences(of: "/", with: "_")
  }
}
