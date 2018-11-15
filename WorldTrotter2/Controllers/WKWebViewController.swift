//
//  WKWebViewController.swift
//  WorldTrotter2
//
//  Created by Roderick Presswood on 10/11/18.
//  Copyright © 2018 Roderick Presswood. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class WKWebViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
         super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myURL = URL(string: "https://www.github.com/DreamingSavant")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
}
