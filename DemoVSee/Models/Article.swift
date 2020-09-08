//
//  Article.swift
//  DemoVSee
//
//  Created by Coc Coc on 9/7/20.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let article = try Article(json)
//
// To read values from URLs:
//
//   let task = URLSession.shared.articleTask(with: url) { article, response, error in
//     if let article = article {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - Article
struct Article: Codable {
  let source: Source?
  let author, title, articleDescription: String?
  let url: String?
  let urlToImage: String?
  let publishedAt: Date?
  let content: String?
  
  enum CodingKeys: String, CodingKey {
    case source, author, title
    case articleDescription = "description"
    case url, urlToImage, publishedAt, content
  }
}

// MARK: Article convenience initializers and mutators

extension Article {
  init(data: Data) throws {
    self = try newJSONDecoder().decode(Article.self, from: data)
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
    source: Source?? = nil,
    author: String?? = nil,
    title: String?? = nil,
    articleDescription: String?? = nil,
    url: String?? = nil,
    urlToImage: String?? = nil,
    publishedAt: Date?? = nil,
    content: String?? = nil
  ) -> Article {
    return Article(
      source: source ?? self.source,
      author: author ?? self.author,
      title: title ?? self.title,
      articleDescription: articleDescription ?? self.articleDescription,
      url: url ?? self.url,
      urlToImage: urlToImage ?? self.urlToImage,
      publishedAt: publishedAt ?? self.publishedAt,
      content: content ?? self.content
    )
  }
  
  func jsonData() throws -> Data {
    return try newJSONEncoder().encode(self)
  }
  
  func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
    return String(data: try self.jsonData(), encoding: encoding)
  }
}

extension Article: Equatable {
  static func == (lhs: Article, rhs: Article) -> Bool {
    return lhs.url == rhs.url
  }
}
