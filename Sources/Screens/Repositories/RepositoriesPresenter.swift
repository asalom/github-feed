//
//  RepositoriesPresenter.swift
//  GitHubFeed
//
//  Created by Alex Salom on 23/04/2019.
//  Copyright © 2019 Alex Salom. All rights reserved.
//

import Foundation
import RxSwift

protocol RepositoriesPresenter {
  var repositories: [DiffableRepository] { get }
  func viewDidLoad(view: RepositoriesView)
  func search(query: String)
}

final class RepositoriesPresenterImpl: RepositoriesPresenter {
  private let repository: RepositoriesRepository
  private(set) var repositories: [DiffableRepository] = [] {
    didSet {
      self.view?.update()
    }
  }
  private let disposeBag = DisposeBag()
  private weak var view: RepositoriesView?

  init(repository: RepositoriesRepository = RepositoriesRepositoryImpl()) {
    self.repository = repository
  }
  
  func viewDidLoad(view: RepositoriesView) {
    self.view = view
  }

  func search(query: String) {
    repository.search(query: query)
      .map { repository in
        repository.map(DiffableRepository.init)
      }
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] repositories in
        self?.repositories = repositories
      })
      .disposed(by: disposeBag)
  }
}
