//
//  PersistentContainer.swift
//  TocouNa89FM
//
//  Created by Fernando Crespo on 04/03/19.
//  Copyright © 2019 Fernando Crespo. All rights reserved.
//

import Cocoa
import CoreData

class MyPersistentContainer: NSPersistentContainer {
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }

    func loadMusic(finished: @escaping ([Musica]) -> Void) {
        let request: NSFetchRequest<Musica> = Musica.fetchRequest()
        viewContext.perform {
            do {
                let hist = try request.execute()
                finished(hist)
            } catch let error as NSError {
                print(error.description)

            }

        }
    }
}
