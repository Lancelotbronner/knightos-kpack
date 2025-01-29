//
//  DependencyArchive.swift
//  
//
//  Created by Christophe Bronner on 2024-06-21.
//

import BinaryCodable

public struct DependencyArchive {
	public let version: VersionArchive
	public let name: String

	@inlinable public init(_ name: String, at version: VersionArchive) {
		self.version = version
		self.name = name
	}
}

//MARK: - Binary Codable

extension DependencyArchive : BinaryDecodable, BinaryEncodable {

	@inlinable public init(from decoder: inout BinaryDecoder) {
		version = decoder.decode(VersionArchive.self)
		let nlen = decoder.uint8()
		name = decoder.ascii(length: nlen)
	}

	@inlinable public func encode(to encoder: inout BinaryEncoder) {
		encoder.encode(version)
		encoder.ascii(name, length: UInt8.self)
	}

}
