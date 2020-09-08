//
//  NewsResponseModel.swift
//  DemoVSee
//
//  Created by Coc Coc on 9/7/20.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let newsResponseModel = try NewsResponseModel(json)
//
// To read values from URLs:
//
//   let task = URLSession.shared.newsResponseModelTask(with: url) { newsResponseModel, response, error in
//     if let newsResponseModel = newsResponseModel {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - NewsResponseModel
struct NewsResponseModel: Codable {
  let status: String?
  let totalResults: Int?
  let articles: [Article]?
}

// MARK: NewsResponseModel convenience initializers and mutators

extension NewsResponseModel {
  init(data: Data) throws {
    self = try newJSONDecoder().decode(NewsResponseModel.self, from: data)
  }
  
  init(_ json: String, using encoding: String.Encoding = .utf8) throws {
    guard let data = json.data(using: encoding) else {
      throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
    }
    try self.init(data: data)
  }
  
  init(fromURL url: URL) throws {
    try self.init(data: try Data(contentsOf: url))
  }
  
  func with(
    status: String?? = nil,
    totalResults: Int?? = nil,
    articles: [Article]?? = nil
  ) -> NewsResponseModel {
    return NewsResponseModel(
      status: status ?? self.status,
      totalResults: totalResults ?? self.totalResults,
      articles: articles ?? self.articles
    )
  }
  
  func jsonData() throws -> Data {
    return try newJSONEncoder().encode(self)
  }
  
  func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
    return String(data: try self.jsonData(), encoding: encoding)
  }
}
