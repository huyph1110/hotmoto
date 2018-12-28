//
//  AppDelegate.swift
//  hotmoto
//
//  Created by Huy on 3/25/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit
import GoogleMaps
import PXGoogleDirections
import CoreData
import UserNotifications
import GoogleMobileAds

var directionsAPI: PXGoogleDirections!

@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        
        GMSServices.provideAPIKey(GoogleMap_API)
        directionsAPI = PXGoogleDirections(apiKey: GoogleMap_API) // A valid server-side API key is required here
        GADMobileAds.configure(withApplicationID: Admob_ApplicationID)

        /*
        let mobies = fetchMobies()
        print(mobies.first?.code)

        let mobi = mobies.first
        mobi?.code = "456"
        mobi?.setValue(UIImage(named: "back")?.imageData(), forKey: "image")
        mobi?.update()
        let mobies2 = fetchMobies()
        */
        registerForPushNotifications()

        return true
    }
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        UserDefaults.standard.set(token, forKey: SYSTEM.TOKEN.rawValue)
        print("my token = " + token)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if application.applicationState == .active {
            let noti = initNotification()
            if let info = userInfo as? Dictionary<String,Any> {
                // Check if value present before using it
                //"alert": "{"aps":{"alert":{"title":"title","body":"content"},
                if let aps = info["aps"] as? Dictionary<String,Any> {
                    if let alert = aps["alert"] as? Dictionary<String,Any> {
                         noti.title = alert["title"] as? String
                         noti.parkid = alert["body"] as? String
                    }
                   
                }
                else {
                   // print("no value for key\n")
                }
            }
            else {
                // print("wrong userInfo type")
            }
            noti.date = Date()
            noti.save()

            if let vc: UINavigationController = self.window?.rootViewController as? UINavigationController  {
                application.applicationIconBadgeNumber = 0
               
                if vc.topViewController is RegisterNotificationViewController {
                    vc.performSelector(onMainThread: #selector(RegisterNotificationViewController.reloadData), with: nil, waitUntilDone: true)
                }
                
                if vc.topViewController is MyParkListViewController {
                    (vc.topViewController as! MyParkListViewController).notifiBar.badgeNumber =  (vc.topViewController as! MyParkListViewController).notifiBar.badgeNumber + 1
                }
               
            }
            showNotification(self.window!, noti.title ?? "")
        }

    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

}

