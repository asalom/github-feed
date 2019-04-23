//
//  RepositoriesViewController.swift
//  GitHubFeed
//
//  Created by Alex Salom on 23/04/2019.
//  Copyright © 2019 Alex Salom. All rights reserved.
//

import UIKit

protocol RepositoriesView {

}

final class RepositoriesViewController: UIViewController, RepositoriesView {
  private let presenter: RepositoriesPresenter
  
  init(withPresenter presenter: RepositoriesPresenter) {
    self.presenter = presenter
    super.init(nibName: "RepositoriesViewController", bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    presenter.viewDidLoad()
  }
}
