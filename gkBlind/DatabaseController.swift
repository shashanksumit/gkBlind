//
//  DatabaseController.swift
//  gkBlind
//
//  Created by CG-3 on 27/01/17.
//  Copyright © 2017 CG-3. All rights reserved.
//

import Foundation
import CoreData

class DatabaseController
{
    
    private init()
    {
        
    }
    
    
    class func getContext() -> NSManagedObjectContext
    {
        return DatabaseController.persistentContainer.viewContext
    }

    
    
    static var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Model")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    class func saveContext () {
        let context = DatabaseController.persistentContainer.viewContext
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
