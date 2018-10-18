//
//  Mobi.swift
//  MotoPark
//
//  Created by Huy on 10/1/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit
import CoreData

enum Mobi_State: Int16 {
    case checkin = 1
    case checkout = 0
    case delete = -1

}

func fetchMobies() -> [Mobile] {

    let managedContext = App.persistentContainer.viewContext
    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Mobile")
    
    let results = try! managedContext.fetch(fetch)
    
    return results as! [Mobile]
}

func fetchMobies(predicate: NSPredicate) -> [Mobile] {
    
    let managedContext = App.persistentContainer.viewContext
    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Mobile")
    fetch.predicate = predicate
    
    let results = try! managedContext.fetch(fetch)
    
    return results as! [Mobile]
}

extension Mobile {
    
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
func initMobile() -> Mobile {
    
    let managedContext = App.persistentContainer.viewContext
    let mobiEntity = NSEntityDescription.entity(forEntityName: "Mobile", in: managedContext)!
    let mobi = NSManagedObject(entity: mobiEntity, insertInto: managedContext) as! Mobile
    return mobi
}
