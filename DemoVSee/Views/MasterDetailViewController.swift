//
//  MasterDetailViewController.swift
//  DemoVSee
//
//  Created by Coc Coc on 9/8/20.
//

import UIKit

// MARK: MasterDetailViewController

class MasterDetailViewController : UISplitViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if UIDevice.current.userInterfaceIdiom == .pad {
      preferredDisplayMode = .oneBesideSecondary
    }
    
    self.delegate = self
    guard let leftNavController = viewControllers.first as? UINavigationController,
          let masterViewController = leftNavController.viewControllers.first as? MasterViewController,
          let detailViewController = viewControllers.last as? DetailViewController else {
      fatalError()
    }
    masterViewController.delegate = detailViewController
    detailViewController.navigationItem.leftItemsSupplementBackButton = true
    detailViewController.navigationItem.leftBarButtonItem = displayModeButtonItem
    /// Trick load content on detailVC to load url first
    _ = detailViewController.view
  }
}

extension MasterDetailViewController: UISplitViewControllerDelegate {
  func splitViewController(_ splitViewController: UISplitViewController,
                           collapseSecondary secondaryViewController:UIViewController,
                           onto primaryViewController:UIViewController) -> Bool {
    if UIDevice.current.orientation.isLandscape || UIDevice.current.userInterfaceIdiom == .pad {
      return false
    }
    return true
  }
}
