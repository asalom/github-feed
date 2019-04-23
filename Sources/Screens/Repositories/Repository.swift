//
//  Repository.swift
//  GitHubFeed
//
//  Created by Alex Salom on 23/04/2019.
//  Copyright © 2019 Alex Salom. All rights reserved.
//

import Foundation

struct Repositories: Codable {
  let items: [Repository]
}

struct Repository: Codable {
  let id: String
  let name: String

  public enum CodingKeys: String, CodingKey {
    case id = "node_id"
    case name
  }
}
