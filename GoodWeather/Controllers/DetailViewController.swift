//
//  DetailViewController.swift
//  ClimaWeatherApp
//
//  Created by Evgenii Kolgin on 01.11.2020.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var url: String?
    
    override func viewWillAppear(_ animated: Bool) {
        if let safeUrl = url {
            let urlString = Constants.DEATAILS_URL + safeUrl
            webView.load(URLRequest(url: URL(string: urlString)!))
        }
    }
    
    override func viewDidLoad() {
        
    }
}

