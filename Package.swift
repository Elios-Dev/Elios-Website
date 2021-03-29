// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "EliosDevGithubIo",
    products: [
        .executable(
            name: "EliosDevGithubIo",
            targets: ["EliosDevGithubIo"]
        )
    ],
    dependencies: [
        .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.7.0")
    ],
    targets: [
        .target(
            name: "EliosDevGithubIo",
            dependencies: ["Publish"]
        )
    ]
)