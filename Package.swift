// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "kpkg2",
	platforms: [
		.macOS(.v12),
	],
	products: [
		.library(name: "PackageArchive", targets: ["PackageArchive"]),
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.4.0"),
		.package(url: "https://github.com/lancelotbronner/klib2.git", branch: "main"),
	],
	targets: [
		.target(name: "PackageArchive", dependencies: ["klib2"]),
		.executableTarget(name: "kpkg", dependencies: [
			.product(name: "ArgumentParser", package: "swift-argument-parser"),
			"PackageArchive",
		]),
	]
)
