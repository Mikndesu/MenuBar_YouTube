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
    
    var addTimer = Timer()
    
    var count = 0
    
    let getHTML = GetHTML.init()
    let saveStatus = SaveStatus.shared
    
    var window: NSWindow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let path = Bundle.main.path(forResource: "asset/main", ofType: "html")
        var htmlStr:String = ""
        do {
            htmlStr = try String(contentsOfFile: path! ,encoding:.utf8)
        } catch {
        }
        htmlView.loadHTMLString(htmlStr, baseURL: URL(fileURLWithPath:path!))
    }
    
    @IBAction func editSetting(_ sender: Any) {
        window = NSWindow(contentViewController: EditSetting(nibName: "EditSetting", bundle: nil))
    }
    
    @IBAction func selectHistory(_ sender: Any) {
        addTimer =  Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerCall), userInfo: nil, repeats: true)
        print("s")
        window = NSWindow(contentViewController: HistorySelector(nibName: "HistorySelector", bundle: nil))
    }
    
    @IBAction func onSearch(_ sender: Any) {
        let searchWord = searchField.stringValue
        if(searchWord != "") {
            let html_path = Bundle.main.path(forResource: "asset/display", ofType: "html")
            getHTML.searchYouTube(searchWord)
            var htmlStr:String = ""
            do {
                htmlStr = try String(contentsOfFile: html_path! ,encoding:.utf8)
                htmlView.loadHTMLString(htmlStr, baseURL: URL(fileURLWithPath:html_path!))
            } catch {
            }
        }
    }
    
    func historyShow() {
        let html_path = Bundle.main.path(forResource: "asset/display", ofType: "html")
        var htmlStr:String = ""
        do {
            htmlStr = try String(contentsOfFile: html_path! ,encoding:.utf8)
            htmlView.loadHTMLString(htmlStr, baseURL: URL(fileURLWithPath:html_path!))
        } catch {
        }
    }
    
    @objc func timerCall() {
        if(saveStatus.isChanged == 1) {
            saveStatus.isChanged = 0
            historyShow()
            addTimer.invalidate()
        }
    }
    
    @IBAction func onQuit(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
}
