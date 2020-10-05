//
//  HtmlParser.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/5/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

protocol HtmlParser {
    func parse(html: String,
               id: Int,
               title: String,
               url: String,
               imageUrl: String,
               createDate: Date,
               updateDate: Date) -> Story
}
