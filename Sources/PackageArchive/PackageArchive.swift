//
//  PackageManifest+ArchivedRepresentation.swift
//
//
//  Created by Christophe Bronner on 2024-06-19.
//

import BinaryCodable

public struct PackageArchive {

	public var format = Format.v0
	public var metadata: [MetadataArchive] = []
	public var files: [FileArchive] = []

	@inlinable public init() { }

	public struct Format: RawRepresentable {
		public var rawValue: UInt8

		@inlinable public init(rawValue: UInt8) {
			self.rawValue = rawValue
		}

		public static let v0 = Self(rawValue: 0x00)
	}

}

extension PackageArchive {

	@inlinable public func merged(with other: PackageArchive) -> PackageArchive {
		var tmp = self
		tmp.merge(with: other)
		return tmp
	}

	@inlinable public mutating func merge(with other: PackageArchive) {
		metadata.append(contentsOf: other.metadata)
		files.append(contentsOf: other.files)
	}

}

//MARK: - Binary Codable

extension PackageArchive : BinaryDecodable, BinaryEncodable {

	@inlinable public init(from decoder: inout BinaryDecoder) {
		let magic = decoder.ascii(length: 4)
		precondition(magic == "KPKG")
		format = Format(rawValue: decoder.uint8())
		for _ in 0..<decoder.uint8() {
			//TODO: Decode metadata
		}
		for _ in 0..<decoder.uint8() {
			files.append(decoder.decode(FileArchive.self))
		}
	}

	@inlinable public func encode(to encoder: inout BinaryEncoder) {
		encoder.ascii("KPKG")
		encoder.encode(format.rawValue)
		encoder.uint8(metadata.count)
		for metadata in metadata {
			encoder.encode(metadata)
		}
		encoder.uint8(metadata.count)
		for file in files {
			encoder.encode(file)
		}
	}

}
