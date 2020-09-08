//
//  DetailViewController.swift
//  DemoVSee
//
//  Created by Coc Coc on 9/7/20.
//

import UIKit
import WebKit

// MARK: DetailViewController

class DetailViewController: UIViewController {
  
  @IBOutlet fileprivate weak var webView: WKWebView!
  @IBOutlet fileprivate weak var indicatorView: UIActivityIndicatorView!
  
  fileprivate var currentIndex: Int = 0
  fileprivate var completionBlock: ((Bool) -> Void)?
  
  var article: Article? {
    didSet {
      if let urlString = article?.url {
        loadContentPage(urlString: urlString)
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    webView.navigationDelegate = self
    indicatorView.hidesWhenStopped = true
    indicatorView.startAnimating()
  }
  
  func loadContentPage(urlString: String) {
    guard let url = URL(string: urlString) else {
      print("Invalid url")
      return
    }
    let request = URLRequest.init(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
    if self.isViewLoaded {
      indicatorView.startAnimating()
      webView.load(request)
    }
  }
}

extension DetailViewController: MasterSelectionDelegate {
  func articleSelected(_ article: Article, at index: Int, completion: ((Bool) -> Void)?) {
    self.article = article
    self.currentIndex = index
    self.completionBlock = completion
  }
}

extension DetailViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    indicatorView.stopAnimating()
    guard let completionBlock = self.completionBlock else {
      return
    }
    completionBlock(true)
  }
  
  func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    indicatorView.stopAnimating()
    guard let completionBlock = self.completionBlock else {
      return
    }
    completionBlock(false)
  }
}
