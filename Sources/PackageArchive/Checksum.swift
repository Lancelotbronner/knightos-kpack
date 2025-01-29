//
//  Checksum.swift
//  
//
//  Created by Christophe Bronner on 2024-06-21.
//

import BinaryCodable

public struct ChecksumKey: RawRepresentable, Hashable {
	public let rawValue: UInt8

	@inlinable public init(rawValue: UInt8) {
		self.rawValue = rawValue
	}

	@inlinable public func over(_ bytes: [UInt8]) -> ChecksumAlgorithm {
		ChecksumAlgorithm(bytes, forKey: self)
	}

	public static let `default` = Self.crc16

	public static let none = Self(rawValue: 0x00)
	/// `CRC16` 2 bytes.
	public static let crc16 = Self(rawValue: 0x01)
	/// `SHA1` 16 bytes.
	public static let sha1 = Self(rawValue: 0x02)
	/// `MD5` 20 bytes.
	public static let md5 = Self(rawValue: 0x03)
}

public struct ChecksumAlgorithm : BinaryEncodable {
	public let key: ChecksumKey
	public let inputBytes: [UInt8]

	@usableFromInline init(_ inputBytes: [UInt8], forKey key: ChecksumKey) {
		self.key = key
		self.inputBytes = inputBytes
	}

	@inlinable public var outputBytes: [UInt8] {
		BinaryEncoder.encode(self)
	}

	@inlinable public func encode(to encoder: inout BinaryEncoder) {
		switch key {
		case .none: break
		case .crc16: encoder.encode(Self.crc16(over: inputBytes))
		default: preconditionFailure("Unimplemented")
		}
	}

	@inlinable public static func crc16(over bytes: [UInt8]) -> UInt16 {
		var crc: UInt16 = 0xffff
		for byte in bytes {
			var c = Int(byte)
			for _ in 0..<8 {
				let check = (crc >> 15) ^ (UInt16(c) >> 7)
				crc <<= 1
				if (check != 0) {
					crc = crc ^ 0x68da
				}
				c <<= 1
				c &= 0xff
			}
		}
		return crc
	}
}
