//
//  AppDelegate.swift
//  Example
//
//  Copyright © 2021 Openpay. All rights reserved.
//  Created by june chen on 9/2/21.
//

import Openpay
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // SceneDelegate is being used for iOS 13+

        Openpay.setBranding(.openpay)
        return true
    }
}
