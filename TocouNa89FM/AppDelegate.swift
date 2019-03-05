//
//  AppDelegate.swift
//  TocouNa89FM
//
//  Created by Fernando Crespo on 03/03/19.
//  Copyright © 2019 Fernando Crespo. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    lazy var persistentContainer: MyPersistentContainer = {
        let container = MyPersistentContainer(name: "RadioRockModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if let rootVC = NSApplication.shared.keyWindow?.contentViewController as? ViewController {
            rootVC.container = persistentContainer
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

}

