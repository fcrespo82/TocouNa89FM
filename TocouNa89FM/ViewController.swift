//
//  ViewController.swift
//  TocouNa89FM
//
//  Created by Fernando Crespo on 03/03/19.
//  Copyright © 2019 Fernando Crespo. All rights reserved.
//

import Cocoa
import CoreData

class ViewController: NSViewController, NSCollectionViewDataSource, NSCollectionViewDelegate {

    var container: MyPersistentContainer!
    var items: [Musica] = [] {
        didSet {
            // Update the view, if already loaded.
            self.lista.reloadData()
        }
    }
    var timer: Timer

    // MARK: Outlets
    @IBOutlet weak var image: NSImageView!
    @IBOutlet weak var cantor: NSTextField!
    @IBOutlet weak var musica: NSTextField!
    @IBOutlet weak var lista: NSCollectionView!

    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let delegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
        container = delegate.persistentContainer

        lista.register(MusicNSCollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier("MusicCell"))
        lista.dataSource = self
        lista.delegate = self

        container.loadMusic(finished: { (historico) in
            self.items = historico
        })

        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(exactly: 5)!, repeats: true) { (timer) in
            RadioRockService.downloadSong { (tocando) in
                DispatchQueue.main.async { // Correct
                    if (self.cantor.stringValue != tocando.cantor && self.musica.stringValue != tocando.musica)
                    {
                        self.cantor.stringValue = tocando.cantor
                        self.musica.stringValue = tocando.musica

                        if let url = tocando.cover { // Only try to load the URL if its set
                            self.image.image = NSImage(contentsOf: url)
                        }

                        let musica = Musica(context: self.container.viewContext)
                        musica.cantor = tocando.cantor
                        musica.nome = tocando.musica
                        musica.capa = tocando.cover

                        self.items.append(musica)

                        self.container.saveContext()
                    }
                }
            }
        }
        timer.fire()
    }

    // MARK: Collection View Delegate
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cell: MusicNSCollectionViewItem = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "MusicCell"), for: indexPath) as! MusicNSCollectionViewItem

        cell.cantor.stringValue = self.items[indexPath.item].cantor!
        cell.musica.stringValue = self.items[indexPath.item].musica!
        cell.capa.image =
            NSImage(contentsOf: self.items[indexPath.item].capa!)

        return cell
    }
}

