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
    var progressView: UIProgressView!
    var websites = ["levi.com", "bestbuy.com","victoriassecret.com"]
    
    override func loadView() {
        
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
//        let play = UIBarButtonItem(image: UIImage(systemName: "triangle"), style: .plain, target: self, action: nil)
        
        let goBack = UIBarButtonItem(image:UIImage(systemName:"chevron.backward"), style:.plain, target: webView, action: #selector(webView.goBack))
        let goForward = UIBarButtonItem(image:UIImage(systemName:"chevron.forward"), style:.plain, target: webView, action: #selector(webView.goForward))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [progressButton,spacer, goBack, spacer, goForward,spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

        let url = URL(string:"https://" + websites[0])!
        
        webView.load(URLRequest(url: url))
    
        webView.allowsBackForwardNavigationGestures = true
    }
    @objc func openTapped() {
        
        let ac = UIAlertController(title: "Open page…", message: nil, preferredStyle: .actionSheet)
        for website in websites{
        ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.popoverPresentationController?.barButtonItem =
        self.navigationItem.rightBarButtonItem
        
        present(ac, animated: true)
    }
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        decisionHandler(.cancel)
        let blockedAlert = UIAlertController(title: "Blocked", message: "Visiting that website is not allowed", preferredStyle: .alert)
        present(blockedAlert, animated:true)
        }
    }
extension ViewController: WKNavigationDelegate{

}
