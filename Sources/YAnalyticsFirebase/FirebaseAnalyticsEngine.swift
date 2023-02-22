//
//  FirebaseAnalyticsEngine.swift
//  YAnalyticsFirebase
//
//  Created by Sumit Goswami on 13/10/21.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import Foundation
import YAnalytics
import FirebaseAnalytics
import FirebaseCore

/// Firebase Analytics Engine
final public class FirebaseAnalyticsEngine {
    /// Info for mapping `AnalyticsEvent` events to Firebase events
    public let mappings: [String: FirebaseEventMapping]
    
    /// Initialize Firebase Engine.
    ///
    /// Although technically you can declare multiple instances of `FirebaseAnalyticsEngine`,
    /// it will only call `FirebaseApp.configure()` once.
    /// Therefore we recommend that you only declare a single instance of the `FirebaseAnalyticsEngine`
    /// (but not a singleton!), and you probably want to do so at app launch
    /// and have its lifecycle map that of your application.
    /// - Parameter configuration: configuration for Firebase Analytics
    public init(
        configuration: FirebaseAnalyticsConfiguration = .default
    ) {
        self.mappings = configuration.mappings

        // Choose which configure override to use
        switch configuration.parameters {
        case .none:
            if FirebaseApp.app() == nil {
                FirebaseApp.configure()
            }
        case .options(let options):
            if FirebaseApp.app() == nil {
                FirebaseApp.configure(options: options)
            }
        case .nameAndOptions(let name, let options):
            if FirebaseApp.app(name: name) == nil {
                FirebaseApp.configure(name: name, options: options)
            }
        }
    }
}

// MARK: - AnalyticsEngine

/// Conform to `AnalyticsEngine` protocol
extension FirebaseAnalyticsEngine: AnalyticsEngine {
    /// Track an analytics event
    /// - Parameter event: the event to log
    public func track(event: AnalyticsEvent) {
        switch event {
        case .screenView(let screenName):
            let mapping = mappings[AnalyticsEvent.screenViewKey] ?? FirebaseEventMapping.defaultScreenView
            let name = mapping.name
            let data = [mapping.topLevelKey: screenName]
            Analytics.logEvent(name, parameters: data)
        case .userProperty(let name, let value):
            Analytics.setUserProperty(value, forName: name)
        case .event(let name, let parameters):
            Analytics.logEvent(name, parameters: parameters)
        }
    }
}

final class AppCoordinator {
    let engine: AnalyticsEngine = FirebaseAnalyticsEngine()

    func trackSomething(someData: [String: Any]?) {
        engine.track(
            event: .event(name: "Something", parameters: someData)
        )
    }
}
