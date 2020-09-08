//
//  NewsTableViewCell.swift
//  DemoVSee
//
//  Created by Coc Coc on 9/7/20.
//

import UIKit

// MARK: NewsTableViewCell

class NewsTableViewCell: UITableViewCell {
  @IBOutlet fileprivate weak var articleImageView: UIImageView!
  @IBOutlet fileprivate weak var titleLabel: UILabel!
  @IBOutlet fileprivate weak var descLabel: UILabel!
  @IBOutlet fileprivate weak var timestampLabel: UILabel!
  @IBOutlet fileprivate weak var indicatorView: UIActivityIndicatorView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    [titleLabel, descLabel].forEach { (lbl) in
      lbl?.numberOfLines = 0
    }
    articleImageView.contentMode = .scaleAspectFill
    indicatorView.hidesWhenStopped = true
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    articleImageView.image = nil
    titleLabel.text = ""
    descLabel.text = ""
    timestampLabel.text = ""
  }
  
  func setLoading(_ flag: Bool) {
    if flag {
      indicatorView.startAnimating()
    } else {
      indicatorView.stopAnimating()
    }
  }
  
  func fillData(_ article: Article) {
    titleLabel.text = article.title;
    descLabel.text = article.articleDescription
    if let date = article.publishedAt {
      let dateFormatter = DateFormatter()
      dateFormatter.dateStyle = .full
      timestampLabel.text = dateFormatter.string(from: date)
    } else {
      timestampLabel.text = ""
    }
    
    if let urlString = article.urlToImage, let url = URL(string: urlString) {
      articleImageView.load(url: url)
    }
    
    setNeedsLayout()
    layoutIfNeeded()
  }
}
