//
//  EventNotifier.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/12/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

public protocol EventNotifier: class {
    func notify(notification: NotificationRepresentable)
    func addObserver(_ observer: Any, selector aSelector: Selector, name aName: Notification.Name?, object anObject: Any?)
    func removeObserver(_ observer: Any)
}

public protocol NotificationRepresentable {
    var description: String { get }
    var notificationName: Notification.Name { get }
    var notification: Notification { get }
}

public extension NotificationRepresentable where Self: RawRepresentable, RawValue == String {
    var description: String {
        return self.rawValue
    }
}

public extension NotificationRepresentable {
    var notificationName: Notification.Name {
        return Notification.Name(description)
    }

    var notification: Notification {
        return Notification(name: notificationName)
    }
}
