//
//  FirebaseEventMapping.swift
//  YAnalyticsFirebase
//
//  Created by Sumit Goswami on 17/12/21.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import Foundation
import YAnalytics

/// Information for mapping from `AnalyticsEvent` to Firebase events
public struct FirebaseEventMapping: Equatable {
    /// Firebase event name (used when mapping from `AnalyticsEvent.screenView`)
    public let name: String
    /// Top-level key for Firebase event data dictionary (used when mapping from `AnalyticsEvent.screenView`)
    public let topLevelKey: String

    /// Initialize mapping info
    /// - Parameters:
    ///   - name: Firebase event name (only used for `AnalyticsEvent.screenView`)
    ///   - topLevelKey: data dictionary top-level key (used only for `AnalyticEvent.screenView`)
    public init(name: String = "", topLevelKey: String = "") {
        self.name = name
        self.topLevelKey = topLevelKey
    }
}

public extension FirebaseEventMapping {
    /// default mapping from `AnalyticsEvent.screenView`
    static let defaultScreenView = FirebaseEventMapping(
        name: AnalyticsEvent.screenViewKey,
        topLevelKey: "screenName"
    )

    /// default mappings from all `AnalyticsEvent` cases to Firebase events
    static let `default`: [String: FirebaseEventMapping] = [
        AnalyticsEvent.screenViewKey: .defaultScreenView
    ]
}
