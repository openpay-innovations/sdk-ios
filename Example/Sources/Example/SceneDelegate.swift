//
//  SceneDelegate.swift
//  Example
//
//  Copyright © 2021 Openpay. All rights reserved.
//  Created by june chen on 9/2/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)

        let httpsAPIService = HTTPSAPIService(baseURL: URL(string: "https://merchant-server.test/")!)
        window?.rootViewController = UINavigationController(rootViewController: CheckoutViewController(apiService: httpsAPIService))
        window?.makeKeyAndVisible()
    }
}
