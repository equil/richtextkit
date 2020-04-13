// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "RichTextKit",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "RichTextKit",
            targets: ["RichTextKit"]),
    ],
    targets: [
        .target(
            name: "RichTextKit",
            dependencies: []),
    ]
)
