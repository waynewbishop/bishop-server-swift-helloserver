// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "HelloServer",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "HelloServer",
            targets: ["HelloServer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/apple/swift-openapi-runtime.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-openapi-generator.git", from: "1.0.0"),
        .package(url: "https://github.com/swift-server/swift-openapi-vapor.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.6.3"),
        .package(url: "https://github.com/swift-server/swift-service-lifecycle.git", from: "2.0.0")
    ],
    targets: [
        .executableTarget(
            name: "HelloServer",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "ServiceLifecycle", package: "swift-service-lifecycle"),
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .product(name: "OpenAPIVapor", package: "swift-openapi-vapor"),
                .product(name: "Logging", package: "swift-log")
            ],
            plugins: [
                .plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator")
            ])
    ]
)
