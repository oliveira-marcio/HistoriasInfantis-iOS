//
//  CDStory.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/16/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation
import CoreData

extension CDStory {
}

extension Story {
    init?(from record: CDStory) {
        guard let title = record.title,
            let url = record.url,
            let imageUrl = record.imageUrl,
            let createDate = record.createDate,
            let updateDate = record.updateDate,
            let paragraphsEntity = record.paragraphs?.allObjects as? [CDParagraph]
            else { return nil }

        let paragraphs: [Story.Paragraph] = paragraphsEntity
            .sorted { $0.index < $1.index }
            .compactMap {
                guard let type = $0.type, let text = $0.text
                    else { return nil }

                return Story.Paragraph.makeParagraph(with: type, text: text)
        }

        self.init(id: Int(record.id),
                  title: title,
                  url: url,
                  imageUrl: imageUrl,
                  paragraphs: paragraphs,
                  createDate: createDate,
                  updateDate: updateDate,
                  favorite: record.favorite)
    }

    @discardableResult
    func newManagedObject(inContext context: NSManagedObjectContext) -> CDStory {
        let story = CDStory(context: context)

        story.id = Int64(id)
        story.title = title
        story.url = url
        story.imageUrl = imageUrl
        story.createDate = createDate
        story.updateDate = updateDate
        story.favorite = favorite

        for (index, paragraph) in paragraphs.enumerated() {
            let entry = CDParagraph(context: context)
            entry.index = Int64(index)
            entry.type = paragraph.type
            entry.text = paragraph.text
            story.addToParagraphs(entry)
        }

        return story
    }
}
