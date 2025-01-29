//
//  MetadataArchive.swift
//  
//
//  Created by Christophe Bronner on 2024-06-21.
//

import BinaryCodable

public struct MetadataArchive {

	public var key: MetadataKey
	public var value: [UInt8]

	@inlinable public init(_ value: [UInt8], forKey key: MetadataKey) {
		self.key = key
		self.value = value
	}

	@inlinable public init(forKey key: MetadataKey, write: (inout [UInt8]) -> Void) {
		var value: [UInt8] = []
		write(&value)
		self.init(value, forKey: key)
	}

	@inlinable public var length: Int {
		value.count
	}

}

//MARK: - Binary Codable

extension MetadataArchive : BinaryDecodable, BinaryEncodable {

	@inlinable public init(from decoder: inout BinaryDecoder) {
		key = MetadataKey(rawValue: decoder.uint8())
		value = decoder.bytes(UInt8.self)
	}

	@inlinable public func encode(to encoder: inout BinaryEncoder) {
		encoder.encode(key.rawValue)
		encoder.bytes(value, length: UInt8.self)
	}

}

//MARK: - Decoding & Encoding Value

extension MetadataArchive {

	@inlinable public func decode<T>(by decoding: (inout BinaryDecoder) -> T) -> T {
		var decoder = BinaryDecoder(of: value)
		return decoding(&decoder)
	}

	@inlinable public func decode<T: BinaryDecodable>(_ type: T.Type) throws(T.Failure) -> T {
		try BinaryDecoder.decode(T.self, from: value)
	}

	@inlinable public mutating func encode(by encoding: (inout BinaryEncoder) -> Void) {
		var encoder = BinaryEncoder()
		encoding(&encoder)
		value = encoder.bytes
	}

	@inlinable public mutating func encode<T: BinaryEncodable>(_ value: T) throws(T.Failure) {
		self.value.removeAll(keepingCapacity: true)
		try BinaryEncoder.encode(value, into: &self.value)
	}

}

//MARK: - Builtin Value Formats

extension MetadataArchive {

	@inlinable public func string() -> String {
		decode { $0.ascii(length: $0.remainingBytes.count) }
	}

	@inlinable public mutating func string(_ value: String) {
		encode { $0.ascii(value) }
	}

	@inlinable public func version() -> VersionArchive {
		decode(VersionArchive.self)
	}

	@inlinable public mutating func version(_ value: VersionArchive) {
		encode(value)
	}

	@inlinable public func strings() -> [String] {
		decode { decoder in
			(0..<decoder.uint8()).map { _ in decoder.ascii(length: decoder.uint8()) }
		}
	}

	@inlinable public mutating func strings(_ values: [String]) {
		encode { encoder in
			encoder.uint8(values.count)
			for value in values {
				encoder.ascii(value, length: UInt8.self)
			}
		}
	}

	@inlinable public func dependencies() -> [DependencyArchive] {
		decode { decoder in
			(0..<decoder.uint8()).map { _ in decoder.decode(DependencyArchive.self) }
		}
	}

	@inlinable public mutating func dependencies(_ values: [DependencyArchive]) {
		encode { encoder in
			encoder.uint8(values.count)
			for value in values {
				encoder.encode(value)
			}
		}
	}

}

//MARK: - Metadata Key

public struct MetadataKey: RawRepresentable, Hashable {
	public var rawValue: UInt8

	@inlinable public init(rawValue: UInt8) {
		self.rawValue = rawValue
	}

	@inlinable public init(custom offset: UInt8) {
		self.init(rawValue: 0x80 + offset)
	}

	@inlinable public var isReserved: Bool {
		rawValue < 0x80
	}

	public static let name = Self(rawValue: 0x00)
	public static let repo = Self(rawValue: 0x01)
	public static let description = Self(rawValue: 0x02)
	public static let dependencies = Self(rawValue: 0x03)
	public static let version = Self(rawValue: 0x04)
	public static let author = Self(rawValue: 0x05)
	public static let maintainer = Self(rawValue: 0x06)
	public static let copyright = Self(rawValue: 0x07)
	public static let infourl = Self(rawValue: 0x08)
	public static let capabilities = Self(rawValue: 0x09)

}
