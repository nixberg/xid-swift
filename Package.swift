// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "xid-swift",
    products: [
        .library(
            name: "XID",
            targets: ["XID"]),
    ],
    dependencies: [
        .package(url: "https://github.com/nixberg/base32-swift", from: "0.4.0"),
        .package(url: "https://github.com/nixberg/chacha-rng-swift", from: "0.7.0"),
        .package(url: "https://github.com/nixberg/xoodyak-swift", from: "0.2.0"),
    ],
    targets: [
        .target(
            name: "XID",
            dependencies: [
                .product(name: "Base32", package: "base32-swift"),
                .product(name: "ChaCha", package: "chacha-rng-swift"),
                .product(name: "Xoodyak", package: "xoodyak-swift"),
            ]),
        .testTarget(
            name: "XIDTests",
            dependencies: [
                .product(name: "ChaCha", package: "chacha-rng-swift"),
                "XID",
            ]),
    ]
)
