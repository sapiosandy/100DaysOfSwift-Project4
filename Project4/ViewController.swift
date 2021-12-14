//
//  ViewController.swift
//  Project4
//
//  Created by Sandra Gomez on 12/13/21.
//
import UIKit
import WebKit

class ViewController: UIViewController{
    var webView: WKWebView!
    
    override func loadView() {
        // create an instance of Apple's WKWebView and assign it to the webView property:
        webView = WKWebView()
       
        // set the web view's navigationDelegate property to self which means "when any web page naviagtion happens please tell me - the current view controller.
        webView.navigationDelegate = self
        
        // make our view (the root view of our view controller) that web view:
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        let url = URL(string:"https://www.levis.com")!
        
        // this creates a new URLRequest object from that URL, and gives it to our web view to load:
        webView.load(URLRequest(url: url))
        
    
        webView.allowsBackForwardNavigationGestures = true
    }
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page…", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "levis.com", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "victoriassecret.com", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "bestbuy.com", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
}

extension ViewController: WKNavigationDelegate {
    
}
