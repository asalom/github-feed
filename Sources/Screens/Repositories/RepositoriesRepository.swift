//
//  RepositoriesRepository.swift
//  GitHubFeed
//
//  Created by Alex Salom on 23/04/2019.
//  Copyright © 2019 Alex Salom. All rights reserved.
//

import Foundation
import RxSwift

enum RepositoriesRepositoryError: Error {
  case general
  case decode
  case http(status: Int)
}

protocol RepositoriesRepository {
  func search(query: String) -> Observable<[Repository]>
}

final class RepositoriesRepositoryImpl: RepositoriesRepository {
  private let session: URLSession

  init(session: URLSession) {
    self.session = session
  }

  func search(query: String) -> Observable<[Repository]> {
    return Observable.create { observer in
      let task = self.session.dataTask(with: self.url(for: query)) { (data, response, error) in
        guard let response = response as? HTTPURLResponse, let data = data else {
          observer.on(.error(RepositoriesRepositoryError.general))
          return
        }

        guard 200 ... 299 ~= response.statusCode else {
          observer.on(.error(RepositoriesRepositoryError.http(status: response.statusCode)))
          return
        }

        guard let repositories = try? JSONDecoder().decode(Repositories.self, from: data) else {
          observer.on(.error(RepositoriesRepositoryError.decode))
          return
        }

        observer.on(.next(repositories.items))
        observer.on(.completed)
      }

      task.resume()

      return Disposables.create(with: task.cancel)
    }
  }

  private func url(for query: String) -> URL {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "api.github.com"
    components.path = "/search/repositories"
    components.queryItems = [
      URLQueryItem(name: "q", value: query)
    ]

    return components.url!
  }
}
