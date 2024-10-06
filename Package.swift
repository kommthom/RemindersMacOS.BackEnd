// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RemindersMacOS.BackEnd",
    platforms: [
        .macOS(.v15)
    ],
	products: [
		.executable(
			name: "RemindersMacOS.BackEnd",
			targets: ["Run"]
		)
	],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor", from: "4.54.0"),
        .package(url: "https://github.com/vapor/jwt.git", from: "4.0.0-rc.2"),
        .package(url: "https://github.com/vapor/queues.git", from: "1.0.0"),
        .package(url: "https://github.com/vapor/queues-redis-driver.git", from: "1.0.0-rc.1"),
        .package(url: "https://github.com/apple/swift-nio.git", .upToNextMajor(from: "2.16.0")),
        .package(url: "https://github.com/apple/swift-nio-ssl.git", .upToNextMajor(from: "2.7.1")),
        .package(url: "https://github.com/vapor/leaf.git", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/binarybirds/swift-html", .upToNextMajor(from: "1.7.0")),
		.package(name: "Lingo", path: "../UserLocalizations"),
		.package(name: "UserDTOs", path: "../UserDTOs"),
		.package(name: "swift-parsing", path: "../swift-parsing"),
		.package(name: "RemindersMacOS.DTOs", path: "../RemindersMacOS.DTOs")
    ],
    targets: [
        .target(
			name: "Domain",
			dependencies: [
				.product(
					name: "Vapor",
					package: "vapor"
				),
				.product(
					name: "JWT",
					package: "jwt"
				),
				.product(
					name: "QueuesRedisDriver",
					package: "queues-redis-driver"
				),
				.product(
					name: "NIO",
					package: "swift-nio"
				),
				.product(
					name: "NIOSSL",
					package: "swift-nio-ssl"
				),
				.product(
					name: "Leaf",
					package: "leaf"
				),
				.product(
					name: "SwiftHtml",
					package: "swift-html"
				),
				.product(
					name: "SwiftSvg",
					package: "swift-html"
				),
				.product(
					name: "Lingo",
					package: "Lingo"
				),
				.product(
					name: "UserDTOs",
					package: "UserDTOs"
				),
				.product(
					name: "swift-parsing",
					package: "swift-parsing"
				),
				.product(
					name: "RemindersMacOS.DTOs",
					package: "RemindersMacOS.DTOs"
				)
			]
		),
        .executableTarget(
			name: "Run",
			dependencies: ["Domain"]
		),
        .testTarget(
			name: "AppTests",
			dependencies: [
				.target(
					name: "Domain"
				),
				.product(
					name: "XCTVapor",
					package: "vapor"
				),
				.product(
					name: "XCTQueues",
					package: "queues"
				),
            ]
        )
    ]
)
