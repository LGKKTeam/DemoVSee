//
//  RestAPIService.swift
//  DemoVSee
//
//  Created by Coc Coc on 9/8/20.
//

import Foundation

/// Register new APIs key from https://newsapi.org/bbc-sport-api
let kApiKeyTest = "c592c045cbf442ba9411ef7dbbbbcae4"

class RestAPIService {
  
  func getNews(by searchTerm: String, requestTime: String, completion: @escaping ((NewsResponseModel?, Error?)->Void)) {
    let urlString = "http://newsapi.org/v2/everything?q=\(searchTerm)&from=\(requestTime)&sortBy=publishedAt&apiKey=\(kApiKeyTest)"
    let url = URL(string:urlString)
    guard let _url = url else {
      let dic = [NSLocalizedDescriptionKey: "Invalid url request"]
      let nsError = NSError(domain: "ahdenglish.com", code: -999, userInfo: dic)
      completion(nil, nsError)
      return
    }
    let task = URLSession.shared.newsResponseModelTask(with: _url) { newsResponseModel, response, error in
      completion(newsResponseModel, error)
    }
    task.resume()
  }
}
