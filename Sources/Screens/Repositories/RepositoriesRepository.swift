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
  func search(query: String) -> Single<[Repository]>
}

final class RepositoriesRepositoryImpl: RepositoriesRepository {
  private let session: URLSession

  init(session: URLSession = URLSession.shared) {
    self.session = session
  }

  func search(query: String) -> Single<[Repository]> {
    print("searching \(query)")
    return Single.create { single in
      let task = self.session.dataTask(with: self.request(for: self.url(for: query))) { (data, response, error) in
        guard let response = response as? HTTPURLResponse, let data = data else {
          single(.error(RepositoriesRepositoryError.general))
          return
        }

        guard 200 ... 299 ~= response.statusCode else {
          single(.error(RepositoriesRepositoryError.http(status: response.statusCode)))
          return
        }

        guard let repositories = try? JSONDecoder().decode(Repositories.self, from: data) else {
          single(.error(RepositoriesRepositoryError.decode))
          return
        }

        single(.success(repositories.items))
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

  private func request(for url: URL) -> URLRequest {
    var request = URLRequest(url: url)
    request.setValue("token \(Secrets.GitHub.token)", forHTTPHeaderField: "Authorization")

    return request
  }
}
