//
//  HistorySelector.swift
//  MenuBar_YouTube
//
//  Created by MitsukiGoto on 2020/01/23.
//  Copyright © 2020 五島充輝. All rights reserved.
//

import Cocoa

class HistorySelector: NSViewController {

    @IBOutlet weak var customView: NSView!
    @IBOutlet weak var comboBox: NSComboBox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let mutableArray = GetHTML.init().getHistory()
        if let array = mutableArray! as? [String] {
             // Do something
            comboBox.removeAllItems()
            comboBox.addItems(withObjectValues: array)
        }
    }
    
}
