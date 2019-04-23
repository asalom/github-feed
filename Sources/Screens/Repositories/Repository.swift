//
//  Repository.swift
//  GitHubFeed
//
//  Created by Alex Salom on 23/04/2019.
//  Copyright © 2019 Alex Salom. All rights reserved.
//

import Foundation
import IGListKit

struct Repositories: Codable {
  let items: [Repository]
}

struct Repository: Codable, Equatable {
  let id: String
  let name: String

  public enum CodingKeys: String, CodingKey {
    case id = "node_id"
    case name
  }
}

final class DiffableRepository: ListDiffable {
  let repository: Repository

  init(repository: Repository) {
    self.repository = repository
  }

  func diffIdentifier() -> NSObjectProtocol {
    return repository.id as NSObjectProtocol
  }

  func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    return repository == (object as? DiffableRepository)?.repository
  }
}
