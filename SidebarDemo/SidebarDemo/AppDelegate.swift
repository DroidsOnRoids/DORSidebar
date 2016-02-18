//
//  AppDelegate.swift
//  SidebarDemo
//
//  Created by Piotr Sochalewski on 18.02.2016.
//  Copyright © 2016 Droids On Roids. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var sidebar: SidebarMenu?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        do {
            sidebar = try SidebarMenu(width: 240.0,
                controllers: [AViewController(), BViewController(), nil],
                menuElements: ["First", "Second", "Third"])
            sidebar?.overlayVisible = true
            sidebar?.overlayAlpha = 0.15
            sidebar?.overlayColor = .grayColor()
        }
        catch {
            print(error)
            return true
        }
        
        return true
    }

}