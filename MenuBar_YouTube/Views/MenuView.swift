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
    
    let getHTML = GetHTML.init()
    
    var window: NSWindow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let path = Bundle.main.path(forResource: "asset/main", ofType: "html")
        var htmlStr:String = ""
        do {
            htmlStr = try String(contentsOfFile: path! ,encoding:.utf8)
        } catch {
            //エラー処理
        }
        htmlView.loadHTMLString(htmlStr, baseURL: URL(fileURLWithPath:path!))
    }
    
    @IBAction func loadFromHistory(_ sender: Any) {
        window = NSWindow(contentViewController: HistorySelector(nibName: "HistorySelector", bundle: nil))
    }
    
    @IBAction func onSearch(_ sender: Any) {
        let searchWord = searchField.stringValue
        if(searchWord == "") {
        } else {
            let html_path = Bundle.main.path(forResource: "asset/display", ofType: "html")
            GetHTML.init().searchYouTube(searchWord)
            var htmlStr:String = ""
            do {
                htmlStr = try String(contentsOfFile: html_path! ,encoding:.utf8)
                htmlView.loadHTMLString(htmlStr, baseURL: URL(fileURLWithPath:html_path!))
            } catch {
            }
        }
    }
    
    @IBAction func onQuit(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
}
