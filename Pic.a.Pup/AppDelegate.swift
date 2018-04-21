//
//  AppDelegate.swift
//  Pic-a-Pup
//
//  Created by Philip on 3/13/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging
import MapKit

let primaryColor = UIColor(red: 30/255, green: 129/255, blue: 150/255, alpha: 1)
let secondaryColor = UIColor(red: 85/255, green: 16/255, blue: 83/255, alpha: 1)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        if Auth.auth().currentUser == nil {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let exampleViewController: MenuViewController = mainStoryboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            self.window?.rootViewController = exampleViewController
            self.window?.makeKeyAndVisible()
        }
        
        if #available(iOS 10.0, *) {
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        let latData = userInfo["locationLat"]
        let latString = latData as! String
        let latDouble = Double(latString)
        print(latDouble ?? "NO LAT BITCH ASS")
        
        let longData = userInfo["locationLon"]
        let lonString = longData as! String
        let lonDouble = Double(lonString)
        print(lonDouble ?? "NO LONG DONG BITCH")
        
        if let fuckingWork = latDouble {
            if let pleaseFuckingWork = lonDouble {
                let coordinates = CLLocation(latitude: fuckingWork, longitude: pleaseFuckingWork)
                print(coordinates)
                
                if let mainTabController = self.window?.rootViewController as? PupTabBarController {
                    mainTabController.selectedIndex = 2
                    if let nav = mainTabController.viewControllers![2] as? UINavigationController {
                        if let mapViewController = nav.viewControllers.first as? MapViewController {
                            mapViewController.lostPupLat = coordinates.coordinate.latitude
                            mapViewController.lostPupLon = coordinates.coordinate.longitude
                        }
                    }
                }
            }
        }
    }
    
    // The callback to handle data message received via FCM for devices running iOS 10 or above.
    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
        print("TURDS")
    }
}

