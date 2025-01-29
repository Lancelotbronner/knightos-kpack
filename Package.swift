// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "kpkg",
	targets: [
		.executableTarget(name: "kpack", path: "src"),
	],
	cLanguageStandard: .c2x
)
