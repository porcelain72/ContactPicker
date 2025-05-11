// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ContactPicker",
    platforms: [.macOS(.v12)],
    products: [
        .library(name: "ContactPicker", targets: ["ContactPicker"])
    ],
    dependencies: [],
    targets: [
        .target(name: "ContactPicker", dependencies: []),
        .testTarget(name: "ContactPickerTests", dependencies: ["ContactPicker"])
    ]
)
