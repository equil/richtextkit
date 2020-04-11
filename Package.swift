import PackageDescription

let package = Package(
    name: "RichTextKit",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "RichTextKit",
            targets: ["RichTextKit"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "RichTextKit",
            dependencies: []),
        .testTarget(
            name: "RichTextKitTests",
            dependencies: ["RichTextKit"]),
    ]
)
