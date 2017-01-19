//
//  DataHelper.swift
//  reddit-client
//
//  Created by Pablo Romero on 1/19/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit
import CoreData

class DataHelper: NSObject {

    static let sharedInstance: DataHelper = DataHelper()
    
    private lazy var persistentContainer: NSPersistentContainer = {
     
        let modelURL = Bundle.main.url(forResource: "Model.momd/Model.mom", withExtension: nil)
        
        let model = NSManagedObjectModel(contentsOf: modelURL!)!
        
        let container = NSPersistentContainer(name: "reddit-client", managedObjectModel: model)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
           
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
        })
        
        return container
    
    }()
  
    func viewContext() -> NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    func newBackgroundContext() -> NSManagedObjectContext {
        return self.persistentContainer.newBackgroundContext()
    }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.persistentContainer.performBackgroundTask(block)
    }

    func save () {
        
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            
            do {
                
                try context.save()
            
            } catch {
             
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            
            }
        }
    }
}
