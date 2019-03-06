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

    func saveSong(cantor: String, musica: String, capa: URL? = nil, saved: (Musica) -> Void) {
        let m = Musica(context: viewContext)
        m.cantor = cantor
        m.nome = musica
        m.capa = capa
        m.dataTocada = Date()

        saveContext()

        saved(m)

    }

    let DONWLOAD_URL = URL(string: "https://players.gc2.com.br/cron/89fm/results.json")

    func downloadSong(finished: @escaping (_ data: RadioRockModel) -> Void) {
        let request = URLRequest(url: DONWLOAD_URL!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 60.0)

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(RadioRockModel.self, from: data)

                finished(data)
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}
