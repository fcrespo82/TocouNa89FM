//
//  MusicNSCollectionViewItem.swift
//  TocouNa89FM
//
//  Created by Fernando Crespo on 04/03/19.
//  Copyright © 2019 Fernando Crespo. All rights reserved.
//

import Cocoa

class MusicNSCollectionViewItem: NSCollectionViewItem {

    @IBOutlet weak var cantor: NSTextField!
    @IBOutlet weak var musica: NSTextField!
    @IBOutlet weak var capa: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
