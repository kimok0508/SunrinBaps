//
//  AppDelegate.swift
//  SunrinBaps
//
//  Created by MacBookPro on 2016. 12. 26..
//  Copyright © 2016년 EDCAN. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame : UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = MainListViewController()
        return true
    }
}

