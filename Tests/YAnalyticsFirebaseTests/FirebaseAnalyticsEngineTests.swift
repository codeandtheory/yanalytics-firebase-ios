//
//  FirebaseAnalyticsEngineTests.swift
//  YAnalyticsFirebaseTests
//
//  Created by Mark Pospesel on 10/13/21.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import XCTest
import YAnalytics
import FirebaseCore

@testable import YAnalyticsFirebase

enum Constants {
    static let appName = "YAnalyticsFirebase"
}

final class FirebaseAnalyticsEngineTests: XCTestCase {
    override func tearDown() {
        super.tearDown()

        // delete the default Firebase app (test only)
        FirebaseApp.app()?.delete { _ in }
    }

    func testDefaultParameters() {
        // Given
        let config = FirebaseAnalyticsConfiguration()

        // Then
        XCTAssertNil(config.name)
        XCTAssertNil(config.options)
        XCTAssertEqual(config.mappings, FirebaseEventMapping.default)
    }

    func testOptionsParameters() throws {
        // Given
        let options = try XCTUnwrap(makeOptions())
        let config = FirebaseAnalyticsConfiguration(options: options)
        XCTAssertNil(FirebaseApp.app())
        let sut = makeSUT(config: config)
        let data = MockAnalyticsData()

        XCTAssert(sut.mock.allEvents.isEmpty)

        // When
        data.allEvents.forEach { sut.track(event: $0) }

        // Then
        XCTAssertNotNil(FirebaseApp.app())
        XCTAssertNil(config.name)
        XCTAssertNotNil(config.options)
        XCTAssertEqual(config.mappings, FirebaseEventMapping.default)
        XCTAssertLogged(engine: sut, data: data)
    }

    func testNameAndOptionsParameters() throws {
        // Given
        let options = try XCTUnwrap(makeOptions())
        let config = FirebaseAnalyticsConfiguration(name: Constants.appName, options: options)

        XCTAssertNil(FirebaseApp.app(name: Constants.appName))

        // When
        _ = makeSUT(config: config)

        // Then
        XCTAssertNotNil(config.name)
        XCTAssertEqual(config.name, Constants.appName)
        XCTAssertEqual(config.options, options)
        XCTAssertEqual(config.mappings, FirebaseEventMapping.default)
        XCTAssertNotNil(FirebaseApp.app(name: Constants.appName))
    }

    func testMappings() throws {
        // Given
        let options = try XCTUnwrap(makeOptions())
        let config = FirebaseAnalyticsConfiguration(options: options)

        // When
        let engine = makeSUT(config: config)
        let mappings = try XCTUnwrap(engine.engine as? FirebaseAnalyticsEngine).mappings

        // Then
        XCTAssertEqual(mappings[AnalyticsEvent.screenViewKey], FirebaseEventMapping.defaultScreenView)
    }

    func testDefaultMappings() throws {
        // Given
        let options = try XCTUnwrap(makeOptions())
        let noMappingsConfig = FirebaseAnalyticsConfiguration(options: options, mappings: [:])
        let sut = makeSUT(config: noMappingsConfig)
        let data = MockAnalyticsData()

        XCTAssert(sut.mock.allEvents.isEmpty)

        // When
        data.allEvents.forEach { sut.track(event: $0) }

        // Then
        XCTAssertLogged(engine: sut, data: data)
    }
}

private extension FirebaseAnalyticsEngineTests {
    func makeSUT(
        config: FirebaseAnalyticsConfiguration,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> SpyAnalyticsEngine {
        let engine = FirebaseAnalyticsEngine(configuration: config)
        let sut = SpyAnalyticsEngine(engine: engine)
        trackForMemoryLeak(engine, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }

    func makeOptions() -> FirebaseOptions? {
        guard let path = Bundle.module.path(forResource: "GoogleService-Info", ofType: "plist") else {
            XCTFail("Missing GoogleService-Info.plist")
            return nil
        }

        return FirebaseOptions(contentsOfFile: path)
    }
}
