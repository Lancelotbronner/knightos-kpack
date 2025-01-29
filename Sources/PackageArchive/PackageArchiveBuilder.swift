//
//  PackageArchive+Builder.swift
//  
//
//  Created by Christophe Bronner on 2024-06-20.
//

extension PackageArchive {

	@_transparent public init(@PackageArchiveBuilder contents: () -> PackageArchive) {
		self = contents()
	}

}

@resultBuilder
public struct PackageArchiveBuilder {

	@inlinable public static func buildExpression(_ expression: PackageArchive) -> PackageArchive {
		expression
	}

	@inlinable public static func buildExpression(_ expression: MetadataArchive...) -> PackageArchive {
		var archive = PackageArchive()
		archive.metadata.append(contentsOf: expression)
		return archive
	}

	@inlinable public static func buildExpression(_ expression: FileArchive...) -> PackageArchive {
		var archive = PackageArchive()
		archive.files.append(contentsOf: expression)
		return archive
	}

	@inlinable public static func buildBlock() -> PackageArchive {
		PackageArchive()
	}

	@inlinable public static func buildPartialBlock(first: PackageArchive) -> PackageArchive {
		first
	}

	@inlinable public static func buildPartialBlock(accumulated: PackageArchive, next: PackageArchive) -> PackageArchive {
		accumulated.merged(with: next)
	}

	@inlinable public static func buildOptional(_ component: PackageArchive?) -> PackageArchive {
		component ?? PackageArchive()
	}

	@inlinable public static func buildEither(first component: PackageArchive) -> PackageArchive {
		component
	}

	@inlinable public static func buildEither(second component: PackageArchive) -> PackageArchive {
		component
	}

	@inlinable public static func buildLimitedAvailability(_ component: PackageArchive) -> PackageArchive {
		component
	}

	@inlinable public static func buildArray(_ components: [PackageArchive]) -> PackageArchive {
		components.reduce(into: PackageArchive()) {
			$0.merge(with: $1)
		}
	}

}
