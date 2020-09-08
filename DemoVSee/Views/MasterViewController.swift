//
//  MasterViewController.swift
//  DemoVSee
//
//  Created by Coc Coc on 9/7/20.
//

import UIKit
import Foundation

let kStoreFileName = "DemoVSeeStore"

protocol MasterSelectionDelegate: class {
  func articleSelected(_ article: Article, at index: Int, completion: ((Bool) -> Void)?)
}

// MARK: MasterViewController

class MasterViewController: UITableViewController {
  @IBOutlet fileprivate var indicatorView: UIActivityIndicatorView!
  
  var viewModel: MasterViewModel = MasterViewModel()
  weak var delegate: MasterSelectionDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.tableFooterView = UIView()
    tableView.estimatedRowHeight = 80
    tableView.allowsMultipleSelection = false
    tableView.rowHeight = UITableView.automaticDimension
    indicatorView.hidesWhenStopped = true
    indicatorView.startAnimating()
    setupPullToRefreshControl()
    
    viewModel.updateUIBlock = { [weak self] newsResponseModel, error in
      guard let strongSelf = self else { return }
      strongSelf.updateUIData(newsResponseModel, error: error)
    }
    viewModel.start()
  }
  
  func setupPullToRefreshControl() {
    let refreshControl = UIRefreshControl()
    refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
    refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
    self.refreshControl = refreshControl
  }
  
  @objc func refresh(_ sender: AnyObject) {
    viewModel.start()
  }
  
  func updateUIData(_ newsResponseModel: NewsResponseModel?, error: Error? = nil) {
    if (error != nil) {
      print(error as Any)
    } else {
      self.tableView.reloadData()
      if let article = newsResponseModel?.articles?.first {
        self.delegate?.articleSelected(article, at: 0, completion: nil)
      }
    }
    self.indicatorView.stopAnimating()
    self.tableView.tableHeaderView = UIView()
    self.refreshControl?.endRefreshing()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberItem
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let count = viewModel.numberItem
    if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NewsTableViewCell.self)) as? NewsTableViewCell,
       indexPath.row < count {
      if let item = viewModel.newsFeedCellViewModel(at: indexPath.row) {
        cell.configWithViewModel(item)
      }
      return cell
    }
    return UITableViewCell()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let count = viewModel.numberItem
    
    if indexPath.row < count, let article = viewModel.article(at: indexPath.row) {
      delegate?.articleSelected(article, at: indexPath.row, completion: nil)
      if let detailViewController = delegate as? DetailViewController, !detailViewController.isVisiable() {
        splitViewController?.showDetailViewController(detailViewController, sender: nil)
      }
    }
  }
}
