//
//  FileArchive.swift
//  
//
//  Created by Christophe Bronner on 2024-06-21.
//

import BinaryCodable

public final class FileArchive {
	//TODO: CoW?

	/// The full path the file should be written to on extraction.
	public var path: String

	@usableFromInline var _uncompressedLength = 0
	@usableFromInline var _uncompressedBytes: [UInt8]?
	@usableFromInline var _compressedBytes: [UInt8]?
	@usableFromInline var _compression: CompressionKey

	@usableFromInline var _checksum: ChecksumKey
	@usableFromInline var _checksumBytes: [UInt8]?
	@usableFromInline var _checksumVerificationStatus: ChecksumVerificationStatus

	@usableFromInline enum ChecksumVerificationStatus {
		case unchecked
		case checked(verified: Bool)
		case unnecessary
	}

	@usableFromInline init(uncompressed uncompressedBytes: [UInt8], at path: String) {
		self.path = path
		_uncompressedBytes = uncompressedBytes
		_compression = .default
		_checksum = .default
		_checksumVerificationStatus = .unnecessary
	}

	@usableFromInline init(compressed compressedBytes: [UInt8], uncompressedLength: Int, using compression: CompressionKey, checksum checksumBytes: [UInt8], using checksum: ChecksumKey, at path: String) {
		self.path = path
		_uncompressedLength = uncompressedLength
		_compressedBytes = compressedBytes
		_compression = compression
		_checksum = checksum
		_checksumVerificationStatus = .unchecked
	}

}

//MARK: - Compression Management

extension FileArchive {

	/// The compression algorithm used on this file.
	@inlinable public var compression: CompressionKey {
		_compression
	}

	/// Applies a compression algorithm to the file.
	/// - Parameter algorithm: The algorithm to use.
	@inlinable public func compress(using algorithm: CompressionKey) {
		guard _compression != algorithm else { return }
		if _uncompressedBytes == nil {
			var uncompressedBytes: [UInt8] = []
			uncompressedBytes.reserveCapacity(_uncompressedLength)
			//TODO: Uncompress immediately
			_uncompressedBytes = uncompressedBytes
		}
		_compressedBytes = nil
	}

	@inlinable public var uncompressedBytes: [UInt8] {
		if let _uncompressedBytes {
			return _uncompressedBytes
		}
		guard let _compressedBytes else {
			preconditionFailure("FileArchive has neither compressed nor uncompressed bytes")
		}
		//TODO: Automatically decompress
		let uncompressedBytes: [UInt8] = []
		_uncompressedBytes = uncompressedBytes
		return uncompressedBytes
	}

	@inlinable public var compressedBytes: [UInt8] {
		if let _compressedBytes {
			return _compressedBytes
		}
		guard let _uncompressedBytes else {
			preconditionFailure("FileArchive has neither compressed nor uncompressed bytes")
		}
		// TODO: Automatically compress
		let compressedBytes: [UInt8] = []
		_compressedBytes = compressedBytes
		return compressedBytes
	}

}

//MARK: - Checksum Management

extension FileArchive.ChecksumVerificationStatus {

	@inlinable public var isChecked: Bool {
		switch self {
		case .unchecked: false
		default: true
		}
	}

	@inlinable public var isVerified: Bool {
		switch self {
		case .unchecked: false
		case let .checked(verified): verified
		case .unnecessary: true
		}
	}

	@inlinable public var invalidated: FileArchive.ChecksumVerificationStatus {
		switch self {
		case .unchecked, .unnecessary: self
		case .checked: .unchecked
		}
	}

}

extension FileArchive {

	/// The checksum algorithm used to verify the uncompressed file.
	@inlinable public var checksum: ChecksumKey {
		_checksum
	}

	@inlinable public func check(using algorithm: ChecksumKey) {
		guard _checksum != algorithm else { return }
		_checksum = algorithm
		_checksumBytes = nil
		_checksumVerificationStatus = _checksumVerificationStatus.invalidated
	}

	@inlinable public var checksumBytes: [UInt8] {
		if let _checksumBytes {
			return _checksumBytes
		}
		// TODO: Automatically compute checksum
		let checksumBytes: [UInt8] = []
		_checksumBytes = checksumBytes
		return checksumBytes
	}

	/// Whether this file's checksum is verified to match.
	@inlinable public var isVerified: Bool {
		if case .unchecked = _checksumVerificationStatus {
			_checksumVerificationStatus = .checked(verified: _check())
		}
		return _checksumVerificationStatus.isVerified
	}

	@usableFromInline func _check() -> Bool {
		//TODO: Compute checksum using uncompressed data
		let currentChecksumBytes: [UInt8] = []
		return currentChecksumBytes == checksumBytes
	}

}

//MARK: - Binary Codable

extension FileArchive : BinaryDecodable, BinaryEncodable {

//	+------+======+-------+======+======+======+---------+==========+
//	| PLEN | PATH | CTYPE | ULEN | FLEN | FILE | SUMTYPE | CHECKSUM | (more-->)
//	+------+======+-------+======+======+======+---------+==========+

	@inlinable public convenience init(from decoder: inout BinaryDecoder) {
		let plen = decoder.uint8()
		let path = decoder.ascii(length: plen)
		let ctype = CompressionKey(rawValue: decoder.uint8())
		var ulen = 0
		withUnsafeMutableBytes(of: &ulen) {
			$0[2] = decoder.uint8()
			$0[1] = decoder.uint8()
			$0[0] = decoder.uint8()
		}
		var flen = 0
		withUnsafeMutableBytes(of: &flen) {
			$0[2] = decoder.uint8()
			$0[1] = decoder.uint8()
			$0[0] = decoder.uint8()
		}
		let file = decoder.bytes(flen)

		let sumtype = ChecksumKey(rawValue: decoder.uint8())
		let checksum: [UInt8]
		switch sumtype {
		case .none: checksum = []
		case .crc16: checksum = decoder.bytes(2)
		case .sha1: checksum = decoder.bytes(16)
		case .md5: checksum = decoder.bytes(20)
		default: preconditionFailure()
		}

		self.init(
			compressed: file,
			uncompressedLength: ulen,
			using: ctype,
			checksum: checksum,
			using: sumtype,
			at: path)
	}

	@inlinable public func encode(to encoder: inout BinaryEncoder) {
		encoder.ascii(path, length: UInt8.self)
		encoder.encode(compression.rawValue)
		withUnsafeBytes(of: uncompressedBytes.count) {
			encoder.encode($0[0])
			encoder.encode($0[1])
			encoder.encode($0[2])
		}
		withUnsafeBytes(of: compressedBytes.count) {
			encoder.encode($0[0])
			encoder.encode($0[1])
			encoder.encode($0[2])
		}
		encoder.bytes(compressedBytes)
		encoder.encode(checksum.rawValue)
		encoder.bytes(checksumBytes)
	}

}
