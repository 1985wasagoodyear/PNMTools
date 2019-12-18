//
//  CoreDataManager.swift
//  PNMTools
//
//  Created by K Y on 12/17/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import Foundation
import CoreData

// should this be injected as a property?
private let containerName = "BookSearchLibrary"

// for usage with Decodable Core Data
extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")!
}

extension JSONDecoder {
    convenience init(_ context: NSManagedObjectContext) {
        self.init()
        userInfo[.context] = context
    }
    var context: NSManagedObjectContext? {
        get {
            return userInfo[.context] as? NSManagedObjectContext
        }
        set {
            userInfo[.context] = newValue
        }
    }
}

open class CoreDataManager {
    
    // MARK: - Core Data Stack
    
    open lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MOC: initializes with a concurrency type
    //      dedicates a single thread for them to do work on
    // main - main thread
    // private - any background thread
    
    /// Used for persisting data from mainContext to disk
    open lazy var savingContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.persistentContainer.persistentStoreCoordinator
        return moc
    }()
    
    /// Used for all UI-related work and tasks
    open lazy var mainContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.parent = self.savingContext
        return moc
    }()
    
    /// Used for any background operations, such as downloading or heavy-processing
    open lazy var backgroundContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        moc.parent = self.mainContext
        return moc
    }()
    
    // MARK - Lifecycle Methods
    
    public init() {}
    
    deinit { }
    
    // MARK: - Core Data Saving Support
    
    /// saves in the chain: backgroundContext->mainContext->savingContext
    open func saveAllChanges() {
        // helper function for individually saving a context on its queue
        // then continuing additional work
        func saveHelper(for context: NSManagedObjectContext,
                        _ completion: (()->Void)? = nil) {
            if context.hasChanges {
                context.perform {
                    do {
                        try context.save()
                        completion?()
                    } catch {
                        let nserror = error as NSError
                        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                    }
                }
            }
        }
        // miniature pyramid of doom
        // is there a better way to represent this with less code?
        saveHelper(for: backgroundContext) {
            saveHelper(for: self.mainContext) {
                saveHelper(for: self.savingContext)
            }
        }
            
    }
    
    
    
}
