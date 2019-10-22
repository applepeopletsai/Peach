//
//  WebViewController.swift
//  Peach
//
//  Created by Daniel on 27/08/19.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: CoreVC {
    
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK:- Property
    private var webView = WKWebView()
    private var progressView = UIProgressView()
    private var indicatorView = UIActivityIndicatorView()
    private var urlString: String?

    // MARK:- Life Cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addObser()
        self.loadWebView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.webView.frame = CGRect(x: 0, y: self.backButton.frame.maxY, width: self.view.bounds.size.width, height: self.view.bounds.size.height - self.backButton.frame.maxY)
        self.progressView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 1.0)
        self.indicatorView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        self.indicatorView.center = self.view.center
    }
    
    deinit {
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webView.removeObserver(self, forKeyPath: "title")
    }
    
    // MARK:- Setup Function
    func configureWithUrlString(_ urlString: String) {
        self.urlString = urlString
    }
    
    // MARK:- Override Function
    override func setUpUIs() {
        super.setUpUIs()
        
        self.view.addSubview(self.webView)
        self.webView.navigationDelegate = self
        
        self.webView.addSubview(self.progressView)
        self.progressView.progress = 0.0
        self.progressView.tintColor = .red
        
        self.webView.addSubview(self.indicatorView)
        self.indicatorView.hidesWhenStopped = true
        self.indicatorView.style = .gray
    }
    
    // MARK:- Private Function
    private func addObser() {
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
    }
    
    private func loadWebView() {
        if let urlString = urlString, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }
    
    // MARK:- ObserveValue
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress" {
            self.progressView.alpha = 1.0
            self.progressView.setProgress(Float(self.webView.estimatedProgress), animated: true)
            
            if self.webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                    self?.progressView.alpha = 0.0
                    }, completion: { [weak self] (finish) in
                        self?.progressView.progress = 0.0
                })
            }
        }
        
        if keyPath == "title" {
            self.titleLabel.text = self.webView.title
        }
    }
    
    // MARK:- Private Action
    @IBAction private func backButtonPress(_ sender: UIButton) {
        self.dismissVC()
    }
}


extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.indicatorView.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.indicatorView.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("decidePolicyFor navigationAction url:\(navigationAction.request.url?.absoluteString ?? "")")
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("decidePolicyFor navigationResponse url:\(navigationResponse.response.url?.absoluteString ?? "")")
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.indicatorView.stopAnimating()
    }
}


