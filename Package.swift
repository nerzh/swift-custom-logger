// swift-tools-version:5.9
import PackageDescription

let name: String = "SwiftCustomLogger"

var packageDependencies: [Package.Dependency] = [
    .package(url: "https://github.com/apple/swift-log", from: "1.5.4"),
]

var mainTargetDependencies: [Target.Dependency] = [
    .product(name: "Logging", package: "swift-log"),
]

let package = Package(
    name: name,
    products: [
        .library(
            name: name,
            targets: [name]),
    ],
    dependencies: packageDependencies,
    targets: [
        .target(
            name: name,
            dependencies: mainTargetDependencies
        )
    ]
)
