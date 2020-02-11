//
//  AppDelegate.swift
//  ToDo
//
//  Created by hackeru on 04/02/2020.
//  Copyright © 2020 hackeru. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
       // print(Realm.Configuration.defaultConfiguration.fileURL)
        
        
        do{
             _ = try Realm()
            
        } catch {
            print("Error instaling new realm \(error)")
        }
        
        
        return true
    }

  
}

