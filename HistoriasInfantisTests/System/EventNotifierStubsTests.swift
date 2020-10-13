//
//  EventNotifierStubsTests.swift
//  HistoriasInfantisTests
//
//  Created by Márcio Oliveira on 10/13/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import XCTest
@testable import HistoriasInfantis


enum TestNotification: String, NotificationRepresentable {
    case notification1, notification2
}


class TestClass1: NSObject {
    var method1Called = false
    @objc func class1Method1() {
        method1Called = true
    }
}

class TestClass2: NSObject {
    var method1Called = false
    var method2Called = false

    @objc func class2Method1() {
        method1Called = true
    }


    @objc func class2Method2() {
        method2Called = true
    }
}

class EventNotifierStubsTests: XCTestCase {

    var observer1: TestClass1!
    var observer2: TestClass2!
    var eventNotifierStub: EventNotifierStub!

    override func setUp() {
        observer1 = TestClass1()
        observer2 = TestClass2()

        eventNotifierStub = EventNotifierStub()

        eventNotifierStub.addObserver(observer1!,
                                      selector: #selector(TestClass1.class1Method1),
                                      name: TestNotification.notification1.notificationName,
                                      object: nil)

        eventNotifierStub.addObserver(observer2!,
                                      selector: #selector(TestClass2.class2Method1),
                                      name: TestNotification.notification1.notificationName,
                                      object: nil)

        eventNotifierStub.addObserver(observer2!,
                                      selector: #selector(TestClass2.class2Method2),
                                      name: TestNotification.notification2.notificationName,
                                      object: nil)
    }

    override func tearDown() {
        eventNotifierStub.tearDown()
    }

    func test_it_should_add_observers_for_corresponding_notifications_when_add_observer_is_called() {
        XCTAssertEqual(eventNotifierStub.notificationObservers.count, 2)

        XCTAssertEqual(eventNotifierStub.notificationObservers[TestNotification.notification1.rawValue]?.count, 2)
        XCTAssertEqual(eventNotifierStub.notificationObservers[TestNotification.notification2.rawValue]?.count, 1)

        XCTAssertEqual(eventNotifierStub.notificationObservers[TestNotification.notification1.rawValue]?[observer1]?.first, #selector(TestClass1.class1Method1))
        XCTAssertEqual(eventNotifierStub.notificationObservers[TestNotification.notification1.rawValue]?[observer2]?.first, #selector(TestClass2.class2Method1))
        XCTAssertEqual(eventNotifierStub.notificationObservers[TestNotification.notification2.rawValue]?[observer2]?.first, #selector(TestClass2.class2Method2))
    }

    func test_it_should_emit_corresponding_notifications_when_notify_is_called() {
        eventNotifierStub.notify(notification: TestNotification.notification1)
        eventNotifierStub.notify(notification: TestNotification.notification2)

        XCTAssertEqual(eventNotifierStub.postedNotifications,
                       [TestNotification.notification1.rawValue, TestNotification.notification2.rawValue])
    }

    func test_it_did_post_should_return_true_when_notification_is_emitted() {
        eventNotifierStub.notify(notification: TestNotification.notification1)

        XCTAssertTrue(eventNotifierStub.didPost(eventNamed: TestNotification.notification1.rawValue))
    }

    func test_it_did_post_should_return_false_when_notification_is_not_emitted() {
        eventNotifierStub.notify(notification: TestNotification.notification1)

        XCTAssertFalse(eventNotifierStub.didPost(eventNamed: TestNotification.notification2.rawValue))
    }

    func test_it_should_notify_both_observers_and_invoke_both_of_their_method1_when_notification1_is_emitted() {
        eventNotifierStub.notify(notification: TestNotification.notification1)

        XCTAssertTrue(observer1.method1Called)
        XCTAssertTrue(observer2.method1Called)
        XCTAssertFalse(observer2.method2Called)
    }

    func test_it_should_notify_only_observer2_and_invoke_only_its_method2_when_notification2_is_emitted() {
        eventNotifierStub.notify(notification: TestNotification.notification2)

        XCTAssertFalse(observer1.method1Called)
        XCTAssertFalse(observer2.method1Called)
        XCTAssertTrue(observer2.method2Called)
    }

    func test_it_should_remove_all_observers_from_given_notification_when_remove_observer_is_called_with_notification_name() {
        eventNotifierStub.removeObserver(TestNotification.notification1.notificationName)

        XCTAssertEqual(eventNotifierStub.notificationObservers.count, 1)

        XCTAssertNil(eventNotifierStub.notificationObservers[TestNotification.notification1.rawValue])
        XCTAssertEqual(eventNotifierStub.notificationObservers[TestNotification.notification2.rawValue]?.count, 1)

        XCTAssertEqual(eventNotifierStub.notificationObservers[TestNotification.notification2.rawValue]?[observer2]?.first, #selector(TestClass2.class2Method2))
    }

    func test_it_should_remove_observer_from_all_notifications_when_remove_observer_is_called_with_observer() {
        eventNotifierStub.removeObserver(observer2!)

        XCTAssertEqual(eventNotifierStub.notificationObservers.count, 1)

        XCTAssertEqual(eventNotifierStub.notificationObservers[TestNotification.notification1.rawValue]?.count, 1)
        XCTAssertNil(eventNotifierStub.notificationObservers[TestNotification.notification2.rawValue])

        XCTAssertEqual(eventNotifierStub.notificationObservers[TestNotification.notification1.rawValue]?[observer1]?.first, #selector(TestClass1.class1Method1))
    }

    func test_it_should_notify_only_observer2_and_invoke_only_its_method2_when_notification1_is_removed_and_both_notifications_are_emitted() {
        eventNotifierStub.removeObserver(TestNotification.notification1.notificationName)

        eventNotifierStub.notify(notification: TestNotification.notification1)
        eventNotifierStub.notify(notification: TestNotification.notification2)

        XCTAssertFalse(observer1.method1Called)
        XCTAssertFalse(observer2.method1Called)
        XCTAssertTrue(observer2.method2Called)
    }

    func test_it_should_notify_only_observer1_and_invoke_only_its_method1_when_observer2_is_removed_and_both_notifications_are_emitted() {
        eventNotifierStub.removeObserver(observer2!)

        eventNotifierStub.notify(notification: TestNotification.notification1)
        eventNotifierStub.notify(notification: TestNotification.notification2)

        XCTAssertTrue(observer1.method1Called)
        XCTAssertFalse(observer2.method1Called)
        XCTAssertFalse(observer2.method2Called)
    }
}
