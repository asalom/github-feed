//
//  RepositoriesPresenter.swift
//  GitHubFeed
//
//  Created by Alex Salom on 23/04/2019.
//  Copyright © 2019 Alex Salom. All rights reserved.
//

import Foundation

protocol RepositoriesPresenter {
  func viewDidLoad()
}

final class RepositoriesPresenterImpl: RepositoriesPresenter {
  private let repository: RepositoriesRepository

  init(repository: RepositoriesRepository) {
    self.repository = repository
  }
  
  func viewDidLoad() {
    
  }
}
