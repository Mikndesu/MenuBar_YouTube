//
//  MenuVIew.swift
//  MenuBar_YouTube
//
//  Created by MitsukiGoto on 2020/01/08.
//  Copyright © 2020 五島充輝. All rights reserved.
//

import Cocoa
import WebKit

class MenuView: NSViewController {

    @IBOutlet weak var htmlView: WKWebView!
    
    @IBOutlet var searchField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let path = Bundle.main.path(forResource: "display", ofType: "html")
        GetHTML.init().writeHTMLdownDisplay(path)
        var htmlStr:String = ""
        do {
            htmlStr = try String(contentsOfFile: path! ,encoding:.utf8)
        } catch {
            //エラー処理
        }
        htmlView.loadHTMLString(htmlStr, baseURL: URL(fileURLWithPath:path!))
    }
    
    @IBAction func onSearch(_ sender: Any) {
    }
    
    @IBAction func onQuit(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
}
