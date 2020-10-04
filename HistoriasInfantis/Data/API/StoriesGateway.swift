//
//  StoriesGateway.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/2/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

typealias StoriesGatewayRequestCompletionHandler = (Result<[Story]>) -> Void

protocol StoriesGateway {
    func fetchStories(then handler: @escaping StoriesGatewayRequestCompletionHandler)
}

class StoriesGatewayImplementation: StoriesGateway {
    let urlSession: URLSessionProtocol

    init(urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
    }

    enum Historinhas {
        static let scheme = "https"
        static let host = "public-api.wordpress.com"
        static let userId = "113100833"
        static let path = "/rest/v1.1/sites/\(userId)/posts"

        static let categoryParam = "category"
        static let fieldsParam = "fields"
        static let resultsPerPageParam = "number"
        static let pageParam = "page"

        static let categoryValue = "historias-infantis-abobrinha"
        static let fieldsValue = "ID,date,modified,title,URL,featured_image,content"

        case getStories(Int, Int)

        var url: URL? {
            guard case .getStories(let page, let resultsPerPage) = self else {
                return nil
            }

            var urlComponent = URLComponents()

            urlComponent.scheme = Historinhas.scheme
            urlComponent.host = Historinhas.host
            urlComponent.path = Historinhas.path

            urlComponent.queryItems = [
                URLQueryItem(name: Historinhas.categoryParam, value: Historinhas.categoryValue),
                URLQueryItem(name: Historinhas.fieldsParam, value: Historinhas.fieldsValue),
                URLQueryItem(name: Historinhas.resultsPerPageParam, value: "\(resultsPerPage)"),
                URLQueryItem(name: Historinhas.pageParam, value: "\(page)"),
            ]

            return urlComponent.url
        }
    }

    func fetchStories(then handler: @escaping StoriesGatewayRequestCompletionHandler) {
        fetchStoriesPerPage(then: handler)
    }

    private func fetchStoriesPerPage(
        page: Int = 1,
        resultPerPage: Int = 50,
        stories: [Story] = [],
        then handler: @escaping StoriesGatewayRequestCompletionHandler) {
        let request = URLRequest(url: Historinhas.getStories(page, resultPerPage).url!)
        let task = urlSession.dataTask(with: request) { data, response, error in
            guard let data = data
                else {
                    handler(.failure(StoriesRepositoryError.gatewayRequestFail(error?.localizedDescription ?? "Error")))
                    return
            }

            do {
                let storiesObject = try JSONDecoder().decode(StoriesEntity.self, from: data)
                let parsedStories = self.parse(stories: storiesObject.stories)
                let updatedStories = stories + parsedStories

                if storiesObject.hasMoreStories {
                    self.fetchStoriesPerPage(page: page + 1, stories: updatedStories, then: handler)
                } else {
                    handler(.success(updatedStories))
                }
            } catch {
                handler(.failure(StoriesRepositoryError.gatewayParseFail(error.localizedDescription)))
                return
            }
        }
        task.resume()
    }

    // TODO: Create proper HTML Parser!
    private func parse(stories: [StoryEntity]) -> [Story] {
        var parsedStories = [Story]()
        for story in stories {
            parsedStories.append(
                Story(
                    title: story.title,
                    url: "",
                    imageUrl: "",
                    paragraphs: [],
                    createDate: Date(),
                    updateDate: Date()
                )
            )
        }
        return parsedStories
    }
}
