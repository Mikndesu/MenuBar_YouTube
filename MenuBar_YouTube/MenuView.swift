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
        var htmlStr:String = ""
        do {
            htmlStr = try String(contentsOfFile: path! ,encoding:.utf8)
        } catch {
            //エラー処理
        }
        htmlView.loadHTMLString(htmlStr, baseURL: URL(fileURLWithPath:path!))
    }
    
    @IBAction func onSearch(_ sender: Any) {
        let searchWord = searchField.stringValue
        if(searchWord == "") {
        } else {
            let html_path = Bundle.main.path(forResource: "display", ofType: "html")
            let txt_path = Bundle.main.path(forResource: "APIKey", ofType: "txt")
            do {
                let apiStr = try String(contentsOfFile: txt_path! ,encoding:.utf8)
                GetHTML.init().searchYouTube(searchWord)
            } catch {
                //エラー処理
            }
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
