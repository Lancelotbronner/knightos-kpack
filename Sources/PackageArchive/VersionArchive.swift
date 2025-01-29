//
//  VersionArchive.swift
//  PackageArchive
//
//  Created by Christophe Bronner on 2024-06-21.
//

import BinaryCodable

public struct VersionArchive: Hashable {
	public let major: UInt8
	public let minor: UInt8
	public let patch: UInt8

	@inlinable public init(major: UInt8, minor: UInt8, patch: UInt8) {
		self.major = major
		self.minor = minor
		self.patch = patch
	}

	public static let latest = VersionArchive(major: 0, minor: 0, patch: 0)
}

//MARK: - Binary Codable

extension VersionArchive : BinaryDecodable, BinaryEncodable {

	@inlinable public init(from decoder: inout BinaryDecoder) {
		major = decoder.uint8()
		minor = decoder.uint8()
		patch = decoder.uint8()
	}

	@inlinable public func encode(to encoder: inout BinaryEncoder) {
		encoder.encode(major)
		encoder.encode(minor)
		encoder.encode(patch)
	}

}
