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
    var timer: Timer!

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
            if (!self.items.isEmpty) {
                self.showMusic(self.items.last!)
            }
        })

        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(exactly: 5)!, repeats: true) { (timer) in
            self.container.downloadSong { (tocando) in
                DispatchQueue.main.async { // Correct

                    if (self.items.last?.cantor != tocando.cantor && self.items.last?.nome != tocando.musica) {
                        self.container.saveSong(cantor: tocando.cantor, musica: tocando.musica, capa: tocando.cover, saved: { (musica) in
                            self.items.append(musica)
                            self.showMusic(musica)
                        })
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
        cell.musica.stringValue = self.items[indexPath.item].nome!
        cell.capa.image =
            NSImage(contentsOf: self.items[indexPath.item].capa!)

        return cell
    }

    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        let musica = self.items[(indexPaths.first?.item)!]
        showMusic(musica)
    }

    func showMusic(_ musica: Musica) {
        DispatchQueue.main.async { // Correct
            self.cantor.stringValue = musica.cantor!
            self.musica.stringValue = musica.nome!

            if let url = musica.capa { // Only try to load the URL if its set
                self.image.image = NSImage(contentsOf: url)
            }
        }

    }
}

