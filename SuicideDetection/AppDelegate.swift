//
//  AppDelegate.swift
//  SuicideDetection
//
//  Created by Isha Nagireddy on 11/23/22.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        preloadData()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    private func preloadData() {
        
        var mainFile = FrequencyMain(words: [KeyValue()])
        var keys = [String()]
        var values = [Int()]
        var length = 0
        
        let preloadedDataKey = "DataLoaded"
        if UserDefaults.standard.bool(forKey: preloadedDataKey) ==  false {
            
            if let fileLocation = Bundle.main.url(forResource: "json_frequency", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: fileLocation)
                    let jsonDecoder = JSONDecoder()
                    let dataFromJson = try jsonDecoder.decode(FrequencyMain.self, from: data)
                    mainFile = dataFromJson
                    
                }
                
                catch {
                    print(error)
                }
                
                length = mainFile.words.count
                for i in stride(from: 0, to: length - 1, by: 1) {
                    keys.append((mainFile.words[i]?.key)!)
                    values.append((mainFile.words[i]?.value)!)
            }
            
        }
            
            // reference to managed object context
            let context = persistentContainer.newBackgroundContext()
            
            // fill the urgentCares array by taking data collected from the three arrays
            context.perform {
                
                for eachElement in 0...(length - 2) {
                    
                    // urgentCare elements will be stored in core data
                    let frequency = Frequency(context: context)
                    frequency.key = keys[eachElement]
                    frequency.value = Float32(values[eachElement])
                    print(frequency)
                    
                    // try saving the information into core data
                    do { try context.save()}
                    catch {
                        print("error, cannot transfer data into core data")
                        return
                    }
                    
                }
            }
            
            // set preloadedDataKey to true telling computer the data has already been loaded next time the app is opened
            UserDefaults.standard.set(true, forKey: preloadedDataKey)
        }
    }

    // MARK: - Core Data stack

var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "SuicideDetection")
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

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

