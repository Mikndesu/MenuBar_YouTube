//
//  AppDelegate.swift
//  MenuBar_YouTube
//
//  Created by MitsukiGoto on 2020/01/04.
//  Copyright © 2020 五島充輝. All rights reserved.
//
//  reference at https://clrmemory.com/programming/swift/cocoa-menubar-popover/
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let popover = NSPopover()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        statusItem.title = "YouTube"
        statusItem.action = #selector(AppDelegate.togglePopover(_:))
        showMenu()
    }
    
    func showMenu() {
        popover.contentViewController = MenuView(nibName: "MenuView", bundle: nil)
    }
    
    @objc func togglePopover(_ sender: Any) {
        if popover.isShown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
    
    func showPopover(_ sender: Any) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func closePopover(_ sender: Any) {
        popover.performClose(sender)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
}

