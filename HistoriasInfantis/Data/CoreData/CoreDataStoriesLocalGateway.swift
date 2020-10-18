//
//  MemoryStoriesLocalGateway.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/6/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStoriesLocalGateway: StoriesLocalGateway {

    private let manager: CoreDataManager
    static var defaultSortDescriptors = [NSSortDescriptor(key: "createDate", ascending: false)]

    init() {
        manager = CoreDataManager(modelName: "Stories")
    }


    func fetchAll(then handler: @escaping StoriesLocalGatewayFetchCompletionHandler) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Story")
        request.sortDescriptors = CoreDataStoriesLocalGateway.defaultSortDescriptors

        let stories = try? self.manager.managedObjectContext.fetch(request)
        if let stories = stories as? [CDStory] {
            handler(.success(stories.compactMap { Story(from: $0) }))
        } else {
            handler(.failure(StoriesRepositoryError.unableToRetrieve))
        }
    }

    func fetchFavorites(then handler: @escaping StoriesLocalGatewayFetchCompletionHandler) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Story")
        request.predicate = NSPredicate(format: "favorite == true")
        request.sortDescriptors = CoreDataStoriesLocalGateway.defaultSortDescriptors

        let stories = try? self.manager.managedObjectContext.fetch(request)
        if let stories = stories as? [CDStory] {
            handler(.success(stories.compactMap { Story(from: $0) }))
        } else {
            handler(.failure(StoriesRepositoryError.unableToRetrieve))
        }
    }

    func clearAll(then handler: @escaping StoriesLocalGatewayWriteErrorCompletionHandler) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Story")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try manager.managedObjectContext.execute(deleteRequest)
            try manager.managedObjectContext.save()
            handler(nil)
        } catch {
            print("Failed deleting stories")
            handler(.unableToSave)
        }
    }

    func insert(stories: [Story], then handler: @escaping StoriesLocalGatewayWriteErrorCompletionHandler) {
        for story in stories {
            story.newManagedObject(inContext: self.manager.managedObjectContext)
        }

        save(handler: handler)
    }

    func update(storyId: Int, favorite: Bool, then handler: @escaping StoriesLocalGatewayWriteErrorCompletionHandler) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Story")
        request.predicate = NSPredicate(format: "id == %d", storyId)
        request.sortDescriptors = CoreDataStoriesLocalGateway.defaultSortDescriptors

        let stories = try? self.manager.managedObjectContext.fetch(request)
        if let stories = stories as? [CDStory], let story = stories.first {
            story.favorite = favorite
            save(handler: handler)
        } else {
            handler(.unableToSave)
        }
    }

    private func save(handler: @escaping StoriesLocalGatewayWriteErrorCompletionHandler) {
        do {
            try self.manager.managedObjectContext.save()
            handler(nil)
        } catch {
            handler(.unableToSave)
        }
    }
}
