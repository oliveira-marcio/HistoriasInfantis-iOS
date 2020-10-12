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
    public var postedNotifications = Set<String>()

    public init() {}

    public func notify(notification: NotificationRepresentable) {
        let name = notification.notificationName.rawValue
        postedNotifications.insert(name)
    }

    public func addObserver(_ observer: Any, selector aSelector: Selector, name aName: Notification.Name?, object anObject: Any?) {
    }

    public func removeObserver(_ observer: Any) {

    }

    public func didPost(eventNamed name: String) -> Bool {
        return postedNotifications.contains(name)
    }
}
