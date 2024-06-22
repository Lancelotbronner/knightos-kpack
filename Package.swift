// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "kpack",
	targets: [
		.executableTarget(name: "kpack", path: "src"),
	],
	cLanguageStandard: .c2x
)
