//
//  UIViewController+Extension.swift
//  DemoVSee
//
//  Created by Coc Coc on 9/8/20.
//

import UIKit

// MARK: - Visiable

extension UIViewController {
  func isVisiable() -> Bool {
    return self.isViewLoaded && self.view.window != nil
  }
}

// MARK: - Toast

extension UIViewController {
  func showToast(message : String, font: UIFont) {
    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
      toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
      toastLabel.removeFromSuperview()
    })
  }
}
