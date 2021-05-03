/*
 **********************************************************
 *   Statement of Compliance with the Stated Honor Code   *
 **********************************************************
 I hereby declare on my honor that:
 
 (1) All work is completely my own in this Assignment.
 (2) I did NOT receive any help about how to develop the assignment app.
 (3) I did NOT give any help to anyone about how to develop the assignment app.
 (4) I did NOT ask questions to Dr. Balci, GTA or UTA about how to develop the assignment app.
 
 I am hereby writing my name as my signature to declare that the above statements are true:
 
Team 5
 
 **********************************************************
 */
//
//  AppDelegate.swift
//  final
//
//  Created by Joel on 2018/12/1.
//  Copyright © 2018年 Yifan Zhou. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dict_flightNumber_routeData: NSMutableDictionary = NSMutableDictionary()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        
        // Add the plist filename to the document directory path to obtain an absolute path to the plist filename
        let plistFilePathInDocumentDirectory = documentDirectoryPath + "/RouteILike.plist"
        /*
        let fileManager = FileManager.default
        if(!fileManager.fileExists(atPath: plistFilePathInDocumentDirectory)){
            
            let data : [String: [String]] = [:]
            
            let someData = NSDictionary(dictionary: data)
            let isWritten = someData.write(toFile: plistFilePathInDocumentDirectory, atomically: true)
            print("is the file created: \(isWritten)")
            
            
            
        }*/
        /*
         NSMutableDictionary manages an *unordered* collection of mutable (modifiable) key-value pairs.
         Instantiate an NSMutableDictionary object and initialize it with the contents of the CompaniesILike.plist file.
         */
        let dictionaryFromFile: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: plistFilePathInDocumentDirectory)
        
        /*
         IF the optional variable dictionaryFromFile has a value, THEN
         CompaniesILike.plist exists in the Document directory and the dictionary is successfully created
         ELSE read CompaniesILike.plist from the application's main bundle.
         */
        if let dictionaryFromFileInDocumentDirectory = dictionaryFromFile {
            
            // CompaniesILike.plist exists in the Document directory
            dict_flightNumber_routeData = dictionaryFromFileInDocumentDirectory
            
        } else {
            
            // CompaniesILike.plist does not exist in the Document directory; Read it from the main bundle.
            
            // Obtain the file path to the plist file in the mainBundle (project folder)
            let plistFilePathInMainBundle = Bundle.main.path(forResource: "RouteILike", ofType: "plist")
            
            // Instantiate an NSMutableDictionary object and initialize it with the contents of the CompaniesILike.plist file.
            let dictionaryFromFileInMainBundle: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: plistFilePathInMainBundle!)
            
            // Store the object reference into the instance variable
            dict_flightNumber_routeData = dictionaryFromFileInMainBundle!
        }
        return true
    }

    /*
     ----------------------------
     MARK: - Write the Dictionary
     ----------------------------
     */
    func applicationWillResignActive(_ application: UIApplication) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        
        let plistFilePathInDocumentDirectory = documentDirectoryPath + "/RouteILike.plist"
        dict_flightNumber_routeData.write(toFile: plistFilePathInDocumentDirectory, atomically: true)
        
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
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if shortcutItem.type == "com.yifanzhou.final.watchkitapp.watchkitextension.QRScanner"
        {
            (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
        }
        if shortcutItem.type == "com.yifanzhou.final.watchkitapp.watchkitextension.AirportSearch"
        {
            (window?.rootViewController as? UITabBarController)?.selectedIndex = 2
        }
        if shortcutItem.type == "com.yifanzhou.final.watchkitapp.watchkitextension.Favourite"
        {
            (window?.rootViewController as? UITabBarController)?.selectedIndex = 3
        }
        if shortcutItem.type == "com.yifanzhou.final.watchkitapp.watchkitextension.Translator"
        {
            (window?.rootViewController as? UITabBarController)?.selectedIndex = 4
        }
    }


}

