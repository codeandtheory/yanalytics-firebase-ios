//
//  FirebaseAnalyticsConfiguration.swift
//  YAnalyticsFirebase
//
//  Created by Sumit Goswami on 17/12/21.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import Foundation
import FirebaseCore

/// Optional configuration parameters for Firebase Analytics
public struct FirebaseAnalyticsConfiguration {
    // Maps to the available configure overrides
    internal enum ConfigureParameters {
        case none
        case options(FirebaseOptions)
        case nameAndOptions(String, FirebaseOptions)
    }

    // Indicates which configure override to use
    internal let parameters: ConfigureParameters

    /// (Optional) Name to configure Firebase Analytics
    ///
    /// `nil` means to use the default
    /// - Important: if you specify `name` then you must also specify `options`
    public var name: String? {
        switch parameters {
        case .none, .options:
            return nil
        case .nameAndOptions(let name, _):
            return name
        }
    }

    /// (Optional) Options to configure Firebase Analytics
    ///
    /// `nil` means to use the GoogleService-Info.plist
    public var options: FirebaseOptions? {
        switch parameters {
        case .none:
            return nil
        case .options(let options):
            return options
        case .nameAndOptions(_, let options):
            return options
        }
    }

    /// Information for mapping from `AnalyticsEvent` to Firebase events
    public let mappings: [String: FirebaseEventMapping]

    /// Initializes configuration with mappings
    ///
    /// Will use the default Firebase Analytics name and options from GoogleServices-Info.plist
    /// - Parameter mapping: info for mapping `AnalyticsEvent` events to Firebase events.
    ///   Defaults to `FirebaseEventMapping.default`.
    public init(
        mappings: [String: FirebaseEventMapping] = FirebaseEventMapping.default
    ) {
        self.parameters = .none
        self.mappings = mappings
    }

    /// Initializes configuration with options and mappings
    ///
    /// Will use the default Firebase Analytics name
    /// - Parameters:
    ///   - options: options to configure Firebase Analytics
    ///   - mapping: info for mapping `AnalyticsEvent` events to Firebase events.
    ///   Defaults to `FirebaseEventMapping.default`.
    public init(
        options: FirebaseOptions,
        mappings: [String: FirebaseEventMapping] = FirebaseEventMapping.default
    ) {
        self.parameters = .options(options)
        self.mappings = mappings
    }

    /// Initializes configuration with name, options, and mappings
    /// - Parameters:
    ///   - name: name to configure Firebase Analytics
    ///   - options: options to configure Firebase Analytics
    ///   - mapping: info for mapping `AnalyticsEvent` events to Firebase events.
    ///   Defaults to `FirebaseEventMapping.default`.
    public init(
        name: String,
        options: FirebaseOptions,
        mappings: [String: FirebaseEventMapping] = FirebaseEventMapping.default
    ) {
        self.parameters = .nameAndOptions(name, options)
        self.mappings = mappings
    }

    /// Default configuration (default app name, options from GoogleService-Info.plist, default mappings)
    public static let `default`: FirebaseAnalyticsConfiguration = FirebaseAnalyticsConfiguration()
}
