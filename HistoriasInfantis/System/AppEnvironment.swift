//
//  AppEnvironment.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/9/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

struct AppEnvironment {
    let dependencies: DependencyResolver
}

extension AppEnvironment {
    static func bootstrap() -> AppEnvironment {
        let dependencies = DependencyResolver()
        return AppEnvironment(dependencies: dependencies)
    }
}

final class DependencyResolver {
    lazy var htmlParser: HtmlParser = SwiftSoupHtmlParser(author: "Rodrigo Lopes", end: "FIM")

    lazy var storiesGateway: StoriesGateway = StoriesGatewayImplementation(urlSession: URLSession.shared,
                                                                           htmlParser: htmlParser,
                                                                           resultsPerPage: 100,
                                                                           maxPages: 99999)

    lazy var storiesLocalGateway: StoriesLocalGateway = CoreDataStoriesLocalGateway()

    lazy var eventNotifier: NotificationCenterEventNotifier = NotificationCenterEventNotifier()

    lazy var storiesRepository: StoriesRepository = StoriesRepositoryImplementation(storiesGateway: storiesGateway,
                                                                                    storiesLocalGateway: storiesLocalGateway,
                                                                                    eventNotifier: eventNotifier)

    lazy var displayStoriesUseCase = DisplayStoriesListUseCase(storiesRepository: storiesRepository)
    lazy var requestNewStoriesUseCase = RequestNewStoriesUseCase(storiesRepository: storiesRepository)
    lazy var displayFavoritesListUseCase = DisplayFavoritesListUseCase(storiesRepository: storiesRepository)
    lazy var toggleFavoriteStoryUseCase = ToggleFavoriteStoryUseCase(storiesRepository: storiesRepository)
}
