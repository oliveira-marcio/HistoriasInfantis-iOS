//
//  NotificationCenterEventNotifier.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/12/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

public final class NotificationCenterEventNotifier: EventNotifier {

    private let notificationCenter: NotificationCenter

    public required init(notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.notificationCenter = notificationCenter
    }

    public func notify(notification: NotificationRepresentable) {
        DispatchQueue.main.async {
            self.notificationCenter.post(notification.notification)
        }
    }

    public func addObserver(_ observer: Any, selector aSelector: Selector, name aName: Notification.Name?, object anObject: Any?) {
        notificationCenter.addObserver(observer, selector: aSelector, name: aName, object: anObject)
    }

    public func removeObserver(_ observer: Any) {
        notificationCenter.removeObserver(observer)
    }
}
