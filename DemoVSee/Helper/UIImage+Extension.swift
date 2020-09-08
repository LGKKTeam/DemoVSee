//
//  UIImage+Extension.swift
//  DemoVSee
//
//  Created by Coc Coc on 9/7/20.
//

import UIKit

extension UIImageView {
  func load(url: URL, placeholder: UIImage? = nil, cache: URLCache? = nil, completion: ((Bool)->Void)? = nil) {
    let cache = cache ?? URLCache.shared
    let request = URLRequest(url: url)
    if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
      DispatchQueue.main.async { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.image = image
        completion?(true)
      }
    } else {
      self.image = placeholder
      URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
        guard let strongSelf = self else { return }
        if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
          let cachedData = CachedURLResponse(response: response, data: data)
          cache.storeCachedResponse(cachedData, for: request)
          DispatchQueue.main.async {
            strongSelf.image = image
            completion?(true)
          }
        } else {
          completion?(false)
        }
      }).resume()
    }
  }
}
