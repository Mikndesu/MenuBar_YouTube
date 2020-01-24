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
    
    @IBOutlet var window: NSWindow!
    
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
    
    @IBAction func OkAction(_ sender: Any) {
        let keyWord = comboBox.stringValue
        if(!keyWord.isEmpty) {
            GetHTML.init().showSelectedHistory(keyWord)
            let saveStatus = SaveStatus.shared
            saveStatus.isChanged = 1
            window.close()
        }
    }
    
}
