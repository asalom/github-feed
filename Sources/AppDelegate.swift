//
//  AppDelegate.swift
//  GitHubFeed
//
//  Created by Alex Salom on 19/03/2019.
//  Copyright © 2019 Alex Salom. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = RepositoriesViewController()
    window?.makeKeyAndVisible()

    return true
  }
}

