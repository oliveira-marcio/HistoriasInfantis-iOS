//
//  StoriesGatewayImplementation.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/6/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

class StoriesGatewayImplementation: StoriesGateway {
    let urlSession: URLSessionProtocol!
    let htmlParser: HtmlParser!
    let resultsPerPage: Int!
    let maxPages: Int!

    init(
        urlSession: URLSessionProtocol,
        htmlParser: HtmlParser,
        resultsPerPage: Int,
        maxPages: Int
    ) {
        self.urlSession = urlSession
        self.htmlParser = htmlParser
        self.resultsPerPage = resultsPerPage
        self.maxPages = maxPages
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
        fetchStoriesPerPage(resultsPerPage: resultsPerPage, maxPages: maxPages, then: handler)
    }

    private func fetchStoriesPerPage(
        page: Int = 1,
        resultsPerPage: Int,
        maxPages: Int,
        stories: [Story] = [],
        then handler: @escaping StoriesGatewayRequestCompletionHandler) {
        let request = URLRequest(url: Historinhas.getStories(page, resultsPerPage).url!)
        let task = urlSession.dataTask(with: request) { data, response, error in
            guard let data = data
                else {
                    handler(.failure(StoriesRepositoryError.gatewayRequestFail(error?.localizedDescription ?? "Error")))
                    return
            }

            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                jsonDecoder.dateDecodingStrategy = .iso8601

                let storiesObject = try jsonDecoder.decode(StoriesEntity.self, from: data)

                if storiesObject.stories.count == 0 || page > maxPages {
                    handler(.success(stories))
                    return
                }

                let parsedStories = self.parse(stories: storiesObject.stories)

                self.fetchStoriesPerPage(
                    page: page + 1,
                    resultsPerPage: resultsPerPage,
                    maxPages: maxPages,
                    stories: stories + parsedStories,
                    then: handler
                )
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
                htmlParser.parse(
                    html: story.content,
                    id: story.ID,
                    title: story.title,
                    url: story.URL,
                    imageUrl: story.featuredImage,
                    createDate: story.date,
                    updateDate: story.modified
                )
            )
        }
        return parsedStories
    }
}
