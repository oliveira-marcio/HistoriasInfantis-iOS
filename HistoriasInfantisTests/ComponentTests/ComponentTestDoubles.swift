//
//  ComponentTestDoubles.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/20/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation
@testable import HistoriasInfantis

struct ComponentTestDoubles {
    /// Mock I/O
    public lazy var eventNotifier: EventNotifierStub = EventNotifierStub()
    public lazy var imageLoader: FakeImageLoader = FakeImageLoader()

    public lazy var storiesLocalGateway: FakeStoriesLocalGateway = FakeStoriesLocalGateway()

    public lazy var storiesGateway: FakeStoriesGateway = FakeStoriesGateway()

    /// Mock View

    public lazy var storiesListView: StoriesListViewSpy = StoriesListViewSpy()
    public lazy var favoritesListView: FavoritesListViewSpy = FavoritesListViewSpy()
    public lazy  var baseStoriesListViewRouter: StoriesListViewRouterSpy = StoriesListViewRouterSpy()

    public lazy var storyViewSpy: StoryViewSpy = StoryViewSpy()

    /// Data

    public lazy var storiesRepository: StoriesRepository = StoriesRepositoryImplementation(storiesGateway: storiesGateway,
                                                                                           storiesLocalGateway: storiesLocalGateway,
                                                                                           eventNotifier: eventNotifier)

    /// Use cases

    public lazy var displayStoriesUseCase = DisplayStoriesListUseCase(storiesRepository: storiesRepository)

    public lazy var requestNewStoriesUseCase = RequestNewStoriesUseCase(storiesRepository: storiesRepository)

    public lazy var displayFavoritesListUseCase = DisplayFavoritesListUseCase(storiesRepository: storiesRepository)

    public lazy var toggleFavoriteStoryUseCase = ToggleFavoriteStoryUseCase(storiesRepository: storiesRepository)


    /// Presenters

    public lazy var storiesListPresenter = StoriesListPresenter(view: storiesListView,
                                                                imageLoader: imageLoader,
                                                                router: baseStoriesListViewRouter,
                                                                displayStoriesListUseCase: displayStoriesUseCase,
                                                                requestNewStoriesUseCase: requestNewStoriesUseCase,
                                                                eventNotifier: eventNotifier)

    public lazy var  favoritesListPresenter = FavoritesListPresenter(view: favoritesListView,
                                                                     imageLoader: imageLoader,
                                                                     router: baseStoriesListViewRouter,
                                                                     displayFavoritesListUseCase: displayFavoritesListUseCase,
                                                                     eventNotifier: eventNotifier)
}
