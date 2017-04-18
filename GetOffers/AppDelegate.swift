//
//  AppDelegate.swift
//  GetOffers
//
//  Created by Aditya  on 04/04/17.
//  Copyright © 2017 Aditya Yadav. All rights reserved.
//

import UIKit
import UserNotifications
import Alamofire
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            
        }
        

        
        if let isLoggedIn = UserDefaults.standard.value(forKey: "accessStatus") {
            
            if isLoggedIn as! Bool == true {
                
                print("Old user is back")

                let loadingStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                
                let initialViewControlleripad : UIViewController = loadingStoryBoard.instantiateViewController(withIdentifier: "Main") as! UINavigationController
                
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window?.rootViewController = initialViewControlleripad
                self.window?.makeKeyAndVisible()
                
            } else {

                print("New user is here")
            }
        
        }
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
      
         
        
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        if let isLoggedIn = UserDefaults.standard.value(forKey: "accessStatus") {
            
            if isLoggedIn as! Bool == true {
                
                let loadingStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                
                let initialViewControlleripad : UIViewController = loadingStoryBoard.instantiateViewController(withIdentifier: "Main") as! UINavigationController
                
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window?.rootViewController = initialViewControlleripad
                self.window?.makeKeyAndVisible()
                
                
            }
        }
        

        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    



}

