//
//  UIViewController+Extension.swift
//  DemoVSee
//
//  Created by Coc Coc on 9/8/20.
//

import UIKit

// MARK: UIViewController Visiable
extension UIViewController {
  func isVisiable() -> Bool {
    return self.isViewLoaded && self.view.window != nil
  }
}
