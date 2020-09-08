//
//  Source.swift
//  DemoVSee
//
//  Created by Coc Coc on 9/7/20.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let source = try Source(json)
//
// To read values from URLs:
//
//   let task = URLSession.shared.sourceTask(with: url) { source, response, error in
//     if let source = source {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - Source
struct Source: Codable {
  let id: String?
  let name: String?
}

// MARK: Source convenience initializers and mutators

extension Source {
  init(data: Data) throws {
    self = try newJSONDecoder().decode(Source.self, from: data)
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
    id: String?? = nil,
    name: String?? = nil
  ) -> Source {
    return Source(
      id: id ?? self.id,
      name: name ?? self.name
    )
  }
  
  func jsonData() throws -> Data {
    return try newJSONEncoder().encode(self)
  }
  
  func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
    return String(data: try self.jsonData(), encoding: encoding)
  }
}


