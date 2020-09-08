//
//  ArticleViewModel.swift
//  DemoVSee
//
//  Created by Coc Coc on 9/8/20.
//

import Foundation
import UIKit

class ArticleViewModel {
  private var article: Article!
  
  init(with article: Article) {
    self.article = article
  }
  
  var titleString: String {
    return article.title ?? ""
  }
  
  var desctiptionString: String {
    return article.articleDescription ?? ""
  }
  
  var timeStampString: String {
    if let date = article.publishedAt {
      let dateFormatter = DateFormatter()
      dateFormatter.dateStyle = .full
      return dateFormatter.string(from: date)
    } else {
      return ""
    }
  }
  
  var imageURLString: String {
    return article.urlToImage ?? ""
  }
}
