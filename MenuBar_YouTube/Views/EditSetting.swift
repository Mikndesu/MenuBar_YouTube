
//
//  EditSetting.swift
//  MenuBar_YouTube
//
//  Created by MitsukiGoto on 2020/01/27.
//  Copyright © 2020 五島充輝. All rights reserved.
//

import Cocoa

class EditSetting: NSViewController {

    @IBOutlet var window: NSWindow!
    @IBOutlet weak var first: NSPopUpButton!
    @IBOutlet weak var second: NSTextField!
    @IBOutlet weak var third: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func onAccept(_ sender: Any) {
        window.close();
        let max = first.stringValue
        let height = second.stringValue
        let width = third.stringValue
        GetHTML.init().editSetting(max, second: height, third: width)
    }
    
}
