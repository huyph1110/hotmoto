//
//  Notification.swift
//  MotoPark
//
//  Created by Huy on 11/1/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import Foundation
import UIKit
import CoreData



func fetchNotifications() -> [Notification] {
    
    let managedContext = App.persistentContainer.viewContext
    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Notification")
    
    let results = try! managedContext.fetch(fetch)
    
    return results as! [Notification]
}

func fetchNotifications(predicate: NSPredicate) -> [Notification] {
    
    let managedContext = App.persistentContainer.viewContext
    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Notification")
    fetch.predicate = predicate
    
    let results = try! managedContext.fetch(fetch)
    
    return results as! [Notification]
}

extension Notification {
    
    func save(){
        let managedContext = App.persistentContainer.viewContext
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func delete()  {
        
        let managedContext = App.persistentContainer.viewContext
        managedContext.delete(self)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func update()  {
        let managedContext = App.persistentContainer.viewContext
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
func initNotification() -> Notification {
    
    let managedContext = App.persistentContainer.viewContext
    let notiEntity = NSEntityDescription.entity(forEntityName: "Notification", in: managedContext)!
    let noti = NSManagedObject(entity: notiEntity, insertInto: managedContext) as! Notification
    noti.isread = false
    
    return noti
}
