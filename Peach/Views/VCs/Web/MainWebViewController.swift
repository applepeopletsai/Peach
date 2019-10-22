//
//  MainWebViewController.swift
//  Peach
//
//  Created by DaWei Liao on 2019/9/12.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit
import WebKit

class MainWebViewController: CoreVC {
    
    private var webView:WKWebView!
    private var urlObservation: NSKeyValueObservation?
    private var stringURL:String? = nil
    
    //MARK: Lifecycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureWebView()
        configureUIFrame()
        showLoadingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadingView.play()
        
        // Add observation.
        self.urlObservation = self.webView.observe(\.url, changeHandler: { (webView, change) in
            Log.debug("webView URL ChangeTo:\(webView.url?.absoluteString ?? "xxxxxxx")")
            
            if let url = webView.url?.absoluteString {
                if url == self.stringURL {
                    Log.debug("Same URL")
                    
                    DispatchQueue.main.async {
                        
                        self.tabBarController?.tabBar.isHidden = false
                        self.tabBarController?.tabBar.alpha = 0.0
                        
                        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
                            self.tabBarController?.tabBar.alpha = 1.0
                        }, completion: nil)
                    }
                    
                }else{
                    Log.debug("Different URL, origanal url = \(self.stringURL!)")
                    
                    DispatchQueue.main.async {
                        self.tabBarController?.tabBar.alpha = 1.0
                        self.tabBarController?.tabBar.isHidden = false
                        
                        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {
                            self.tabBarController?.tabBar.alpha = 0.0
                        }, completion: { (complete) in
                            self.tabBarController?.tabBar.isHidden = true
                        })
                    }
                }
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.urlObservation?.invalidate()
    }
    
    //MARK: Public Function
    func loadWebView(withStringURL stringURL:String?) {
        self.stringURL = stringURL
    }

    //MARK: Private Function
    private func configureWebView() {
        let configuration:WKWebViewConfiguration = WKWebViewConfiguration()
        let userContentController:WKUserContentController = WKUserContentController()
        configuration.userContentController = userContentController
        
        let preferences:WKPreferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true

        configuration.preferences = preferences
        
        var javascript:String = ""
        javascript.append("document.documentElement.style.webkitTouchCallout='none';")
        javascript.append("document.documentElement.style.webkitUserSelect='none';")
        
        let noneSelectScript:WKUserScript = WKUserScript(source: javascript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        configuration.userContentController.addUserScript(noneSelectScript)

        
        self.webView = WKWebView(frame: .zero, configuration: configuration)
        self.webView.backgroundColor = .darkGray
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.webView.scrollView.backgroundColor = .clear
        self.view.addSubview(self.webView)
        
        if let stringURL = self.stringURL{
            Log.debug("stringURL = \(stringURL)")
            let url:URL = URL(string: stringURL)!
            let request:URLRequest = URLRequest(url:url)
            self.webView.load(request)
            Log.debug("webView init complete")
        }
    }
    
    private func configureUIFrame() {
        DispatchQueue.main.async {
            self.webView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height)
        }
    }
}

extension MainWebViewController: WKUIDelegate {}

extension MainWebViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        Log.debug("")
        //隱藏loadingView
        self.hideLoadingView()
    }
}

extension MainWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Log.debug("")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        Log.debug("")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Log.debug("")
        
        //隱藏loadingView
        self.hideLoadingView()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Log.debug(error)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        Log.debug("")
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        Log.debug("")
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void){
        Log.debug("")
        completionHandler(.useCredential, nil)
    }
    
}
