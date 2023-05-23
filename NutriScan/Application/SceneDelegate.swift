//
//  SceneDelegate.swift
//  NutriScan
//
//  Created by Yago Marques on 06/05/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.makeKeyAndVisible()
        let initialController = InputsExplorerFactory.make()
        let rootView = UINavigationController(rootViewController: initialController)
        window.rootViewController = rootView

        self.window = window
    }

}

