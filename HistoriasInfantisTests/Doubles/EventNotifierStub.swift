//
//  EventNotifierStub.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/12/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation
@testable import HistoriasInfantis

public class EventNotifierStub: EventNotifier {
    public var postedNotifications = [String]()
    public var notificationObservers = [String: [NSObject: [Selector]]]()

    public init() {}

    public func notify(notification: NotificationRepresentable) {
        let name = notification.notificationName.rawValue
        postedNotifications.append(name)

        guard let notificationObservers = notificationObservers[name] else { return }

        for (observer, selectors) in notificationObservers {
            for selector in selectors {
                observer.perform(selector)
            }
        }
    }

    public func addObserver(_ observer: Any, selector aSelector: Selector, name aName: Notification.Name?, object anObject: Any?) {
        guard let notificationName = aName?.rawValue,
        let nsObserver = observer as? NSObject else { return }

        if let _ = notificationObservers[notificationName] {
            if let _ = notificationObservers[notificationName]?[nsObserver] {
                notificationObservers[notificationName]?[nsObserver]?.append(aSelector)
            } else {
                notificationObservers[notificationName]?[nsObserver] = [aSelector]
            }
        } else {
            notificationObservers[notificationName] = [nsObserver: [aSelector]]
        }
    }

    public func removeObserver(_ observer: Any) {
        if let notificationName = observer as? Notification.Name {
            notificationObservers[notificationName.rawValue] = nil
        }

        if let observer = observer as? NSObject {
            for notification in notificationObservers.keys {
                notificationObservers[notification]?[observer] = nil
                if notificationObservers[notification]?.count == 0 {
                    notificationObservers[notification] = nil
                }
            }
        }
    }

    public func didPost(eventNamed name: String) -> Bool {
        return postedNotifications.contains(name)
    }

    public func tearDown() {
        for notification in notificationObservers.keys {
            notificationObservers[notification] = nil
        }
    }
}
