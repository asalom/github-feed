//
//  RepositoriesViewController.swift
//  GitHubFeed
//
//  Created by Alex Salom on 23/04/2019.
//  Copyright © 2019 Alex Salom. All rights reserved.
//

import UIKit
import IGListKit
import RxSwift
import RxCocoa

protocol RepositoriesView: class {
  func update()
}

final class RepositoriesViewController: UIViewController, RepositoriesView, ListAdapterDataSource {
  @IBOutlet private weak var searchBar: UISearchBar!
  @IBOutlet private weak var collectionView: UICollectionView!
  private let presenter: RepositoriesPresenter
  private var adapter: ListAdapter?
  private let disposeBag = DisposeBag()
  
  init(presenter: RepositoriesPresenter = RepositoriesPresenterImpl()) {
    self.presenter = presenter
    super.init(nibName: "RepositoriesViewController", bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    presenter.viewDidLoad(view: self)

    let updater = ListAdapterUpdater()
    let adapter = ListAdapter(updater: updater, viewController: self, workingRangeSize: 0)
    adapter.collectionView = collectionView
    adapter.dataSource = self
    self.adapter = adapter

    searchBar.rx.text
      .orEmpty
      .debounce(0.5, scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] query in
        self?.presenter.search(query: query)
      })
      .disposed(by: disposeBag)
  }

  func update() {
    adapter?.reloadData(completion: nil)
  }

  func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
    return presenter.repositories
  }

  func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
    return LabelSectionController()
  }

  func emptyView(for listAdapter: ListAdapter) -> UIView? {
    return nil
  }
}

class LabelSectionController: ListSectionController {
  private var repository: Repository?
  override func sizeForItem(at index: Int) -> CGSize {
    return CGSize(width: collectionContext!.containerSize.width, height: 55)
  }

  override func cellForItem(at index: Int) -> UICollectionViewCell {
    let cell = collectionContext!.dequeueReusableCell(withNibName: "RepositoryCell", bundle: nil, for: self, at: index) as! RepositoryCell
    cell.nameLabel.text = repository?.name

    return cell
  }

  override func didUpdate(to object: Any) {
    self.repository = (object as? DiffableRepository)?.repository
  }
}
