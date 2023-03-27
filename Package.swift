// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "YAnalyticsFirebase",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "YAnalyticsFirebase",
            targets: ["YAnalyticsFirebase"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/yml-org/yanalytics-ios.git",
            from: "1.2.0"
        ),
        .package(
          url: "https://github.com/firebase/firebase-ios-sdk.git",
          .upToNextMajor(from: "10.4.0")
        )
    ],
    targets: [
        .target(
            name: "YAnalyticsFirebase",
            dependencies: [
                .product(name: "YAnalytics", package: "yanalytics-ios"),
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk")
            ]
        ),
        .testTarget(
            name: "YAnalyticsFirebaseTests",
            dependencies: ["YAnalyticsFirebase"],
            resources: [.process("Resources")]
        )
    ]
)
