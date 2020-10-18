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
    lazy var gateways: Gateways = CommandLine.arguments.contains("--mock") ? MockGateways() : RealGateways()

    lazy var eventNotifier: NotificationCenterEventNotifier = NotificationCenterEventNotifier()

    lazy var storiesRepository: StoriesRepository = StoriesRepositoryImplementation(storiesGateway: gateways.storiesGateway,
                                                                                    storiesLocalGateway: gateways.storiesLocalGateway,
                                                                                    eventNotifier: eventNotifier)

    lazy var displayStoriesUseCase = DisplayStoriesListUseCase(storiesRepository: storiesRepository)
    lazy var requestNewStoriesUseCase = RequestNewStoriesUseCase(storiesRepository: storiesRepository)
    lazy var displayFavoritesListUseCase = DisplayFavoritesListUseCase(storiesRepository: storiesRepository)
    lazy var toggleFavoriteStoryUseCase = ToggleFavoriteStoryUseCase(storiesRepository: storiesRepository)
}

protocol Gateways: class {
    var storiesGateway: StoriesGateway { set get }
    var storiesLocalGateway: StoriesLocalGateway { set get }
    var imageLoader: ImageLoader { set get }
}

class RealGateways: Gateways {
    lazy var htmlParser: HtmlParser = SwiftSoupHtmlParser(author: "Rodrigo Lopes", end: "FIM")

    lazy var storiesGateway: StoriesGateway = StoriesGatewayImplementation(urlSession: URLSession.shared,
                                                                           htmlParser: htmlParser,
                                                                           resultsPerPage: 100,
                                                                           maxPages: 99999)

    lazy var storiesLocalGateway: StoriesLocalGateway = CoreDataStoriesLocalGateway()
    lazy var imageLoader: ImageLoader = KingfisherImageLoader()
}

class MockGateways: Gateways {
    lazy var storiesGateway: StoriesGateway = MockStoriesGateway()
    lazy var storiesLocalGateway: StoriesLocalGateway = InMemoryStoriesLocalGateway()
    lazy var imageLoader: ImageLoader = MockImageLoader()
}
