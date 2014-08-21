//
//  AppDelegate.swift
//  Mauxe
//
//  Created by Will on 7/10/14.
//  Copyright (c) 2014 Will. All rights reserved.
//

import UIKit
import QuartzCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UIAlertViewDelegate {
                            
    var window: UIWindow?
    
    var loadingView: LoadingViewController = LoadingViewController()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = loadingView
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        UITabBar.appearance().barTintColor = UIColor.whiteColor()
        println("Stuff done")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            DataManager.manager.fetchDataWithCompletionHandler({(categories: NSArray, error: NSError?) -> Void in
            
                if error != nil {
                    
                    var alert = UIAlertView(title: "Error", message: "Could not connect to server", delegate: self, cancelButtonTitle: "Retry")
                    alert.show()
                    
             }
                
                else {
                    dispatch_sync(dispatch_get_main_queue(), {
                        self.loadingView.transitionWithHandler({
                            print("Handler called")
                            self.window!.rootViewController = MainNavViewController(categories: categories);
                        })
                    })
                }
    
                });
            });
        
        // Override point for customization after application launch.
        return true
    }
    
    func alertViewCancel(alertView: UIAlertView!) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            DataManager.manager.fetchDataWithCompletionHandler({(categories: NSArray, error: NSError?) -> Void in
                
                if error != nil {
                    
                    var alert = UIAlertView(title: "Error", message: "Could not connect to server", delegate: self, cancelButtonTitle: "Retry")
                    alert.show()
                    
                }
                    
                else {
                    dispatch_sync(dispatch_get_main_queue(), {
                        self.loadingView.transitionWithHandler({
                            print("Handler called")
                            self.window!.rootViewController = MainNavViewController(categories: categories);
                        })
                    })
                }
                
            });
        });

    }
    
    func proceed()->() {
        
        DataManager.manager.fetchDataWithCompletionHandler({(categories: NSArray, error: NSError?) -> Void in
            self.loadingView.transitionWithHandler({
                print("Handler called")
                self.window!.rootViewController = CategoriesViewViewController(categories: categories)
                })
            })
        
        println("Helloasdfasdf")
        
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

