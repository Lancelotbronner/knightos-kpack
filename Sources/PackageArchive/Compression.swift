//
//  Compression.swift
//  
//
//  Created by Christophe Bronner on 2024-06-21.
//

import BinaryCodable

public struct CompressionKey: RawRepresentable, Hashable {
	public let rawValue: UInt8

	@inlinable public init(rawValue: UInt8) {
		self.rawValue = rawValue
	}

	public static let `default` = Self.none

	public static let none = Self(rawValue: 0x00)
	public static let runLengthEncoding = Self(rawValue: 0x01)
	public static let pucrunch = Self(rawValue: 0x02)

}

public struct CompressionAlgorithm : BinaryEncodable {
	public let key: CompressionKey
	public let inputBytes: [UInt8]

	@usableFromInline init(_ inputBytes: [UInt8], forKey key: CompressionKey) {
		self.key = key
		self.inputBytes = inputBytes
	}

	@inlinable public var outputBytes: [UInt8] {
		BinaryEncoder.encode(self)
	}

	@inlinable public func encode(to encoder: inout BinaryEncoder) {
		switch key {
		case .none: encoder.bytes(inputBytes)
		default:
			preconditionFailure("Unimplemented")
		}
	}
	
}
