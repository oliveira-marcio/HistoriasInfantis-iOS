//
//  FakeHtmlParser.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/5/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation
@testable import HistoriasInfantis

class FakeHtmlParser: HtmlParser {
    var stories = [Story]()
    var parseWasCalled = 0

    func parse(html: String,
               id: Int,
               title: String,
               url: String,
               imageUrl: String,
               createDate: Date,
               updateDate: Date) -> Story {
        parseWasCalled += 1
        let parsedStory = stories.first!
        stories.removeFirst()
        return parsedStory
    }
}
