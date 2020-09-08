//
//  MasterViewModel.swift
//  DemoVSee
//
//  Created by Coc Coc on 9/8/20.
//

import Foundation

class MasterViewModel {
  private var restService: RestAPIService = RestAPIService()
  private var newsResponseModel: NewsResponseModel?
  private var error: Error?
  private var loadingContent: Bool = false
  
  var updateUIBlock: ((NewsResponseModel?, Error?)->Void)?
  
  /// Request news feed for one month only with test api
  private var requestTime: String {
    let currentDate = Date()
    let requestDate = currentDate.addingTimeInterval(-30*24*60*60)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: requestDate)
  }
  
  func start() {
    getLocalStore()
    getNews(by: "bitcoin")
  }
  
  func getLocalStore() {
    let localData = Storage.retrieve(kStoreFileName, from: Storage.Directory.documents, as: NewsResponseModel.self)
    guard let updateUIBlock = self.updateUIBlock else { return }
    updateUIBlock(localData, nil)
  }
  
  func getNews(by searchTerm: String) {
    restService.getNews(by: searchTerm, requestTime: requestTime) { [weak self] newsResponseModel, error in
      DispatchQueue.main.async {
        guard let strongSelf = self else { return }
        strongSelf.newsResponseModel = newsResponseModel
        strongSelf.error = error
        guard let updateUIBlock = strongSelf.updateUIBlock else { return }
        updateUIBlock(newsResponseModel, error)
      }
    }
  }
}

// MARK: - Calculate properties
extension MasterViewModel {
  var numberItem: Int {
    return self.newsResponseModel?.articles?.count ?? 0
  }
  
  func newsFeedCellViewModel(at index: Int) -> ArticleViewModel? {
    guard let article = self.newsResponseModel?.articles?[index] else { return nil }
    return ArticleViewModel(with: article)
  }
  
  func article(at index: Int) -> Article? {
    return self.newsResponseModel?.articles?[index] ?? nil
  }
}
