//
//  FavoritesListViewSpy.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/13/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

@testable import HistoriasInfantis

class FavoritesListViewSpy: BaseStoriesListViewSpy, FavoritesListView {
    var presenter: FavoritesListPresenter!
}
