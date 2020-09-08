//
//  MasterViewController.swift
//  DemoVSee
//
//  Created by Coc Coc on 9/7/20.
//

import UIKit
import Foundation

/// Register new APIs key from https://newsapi.org/bbc-sport-api
let apiKeyTest = "c592c045cbf442ba9411ef7dbbbbcae4"

protocol MasterSelectionDelegate: class {
  func articleSelected(_ article: Article, at index: Int, completion: ((Bool) -> Void)?)
}

// MARK: MasterViewController

class MasterViewController: UITableViewController {
  fileprivate var newsResponseModel: NewsResponseModel?
  @IBOutlet fileprivate var indicatorView: UIActivityIndicatorView!
  
  weak var delegate: MasterSelectionDelegate?
  
  private var loadingContent: Bool = false
  
  /// Request news feed for one month only with test api
  private var requestTime: String {
    let currentDate = Date()
    let requestDate = currentDate.addingTimeInterval(-30*24*60*60)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: requestDate)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.tableFooterView = UIView()
    tableView.estimatedRowHeight = 80
    tableView.allowsMultipleSelection = false
    tableView.rowHeight = UITableView.automaticDimension
    indicatorView.hidesWhenStopped = true
    indicatorView.startAnimating()
    
    let q = "bitcoin"
    getNews(by: q)
  }
  
  func getNews(by searchTerm: String) {
    let urlString = "http://newsapi.org/v2/everything?q=\(searchTerm)&from=\(requestTime)&sortBy=publishedAt&apiKey=\(apiKeyTest)"
    let url = URL(string:urlString)
    guard let _url = url else {
      return
    }
    let task = URLSession.shared.newsResponseModelTask(with: _url) { [weak self] newsResponseModel, response, error in
      DispatchQueue.main.async {
        guard let strongSelf = self else { return }
        if (error != nil) {
          print(error as Any)
        } else {
          strongSelf.newsResponseModel = newsResponseModel
          strongSelf.tableView.reloadData()
          if let article = newsResponseModel?.articles?.first {
            strongSelf.delegate?.articleSelected(article, at: 0, completion: nil)
          }
        }
        strongSelf.indicatorView.stopAnimating()
        strongSelf.tableView.tableHeaderView = UIView()
      }
    }
    task.resume()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.newsResponseModel?.articles?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let count = self.newsResponseModel?.articles?.count ?? 0
    if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NewsTableViewCell.self)) as? NewsTableViewCell,
       indexPath.row < count, let article = self.newsResponseModel?.articles?[indexPath.row] {
      cell.fillData(article)
      return cell
    }
    return UITableViewCell()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if loadingContent {
      return
    }
    let count = self.newsResponseModel?.articles?.count ?? 0
    if indexPath.row < count, let article = self.newsResponseModel?.articles?[indexPath.row] {
      loadingContent = true
      delegate?.articleSelected(article, at: indexPath.row, completion: { [weak self] (success) in
        guard let strongSelf = self else { return }
        if success {
          strongSelf.contentLoaded(at: indexPath.row)
        } else {
          print("Cannot load article's URL")
        }
      })
      if let cell = tableView.cellForRow(at: indexPath) as? NewsTableViewCell {
        cell.setLoading(true)
      }
    }
  }
  
  private func contentLoaded(at index: Int) {
    loadingContent = false
    let indexPath = IndexPath(row: index, section: 0)
    if let cell = tableView.cellForRow(at: indexPath) as? NewsTableViewCell {
      cell.setLoading(false)
    }
    if let detailViewController = delegate as? DetailViewController, !detailViewController.isVisiable() {
      splitViewController?.showDetailViewController(detailViewController, sender: nil)
    }
  }
}
