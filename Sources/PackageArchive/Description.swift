//
//  ArchivedPackage+Description.swift
//  
//
//  Created by Christophe Bronner on 2024-06-20.
//

import Foundation

extension PackageArchive : CustomStringConvertible, CustomDebugStringConvertible {

	public var description: String {
		debugDescription
	}

	public var debugDescription: String {
		var result = ""
		result += "format: \(format)\n"
		result += "\(metadata.isEmpty ? "▹" : "▿") metadata: \(metadata.count) elements"
		for metadata in metadata {
			result += "\t\(metadata)"
		}
		result += "\(files.isEmpty ? "▹" : "▿") metadata: \(files.count) elements"
		return result
	}

}

extension MetadataArchive : CustomReflectable, CustomStringConvertible, CustomDebugStringConvertible {

	public var description: String {
		debugDescription
	}

	public var debugDescription: String {
		let valueDescription: String = switch key {
		case .name, .repo, .author, .copyright, .description, .infourl, .maintainer:
			string()
		case .version:
			"\(version())"
		case .capabilities, .dependencies:
			"\(value[0]) elements"
		default:
			value.count.formatted(.byteCount(style: .file))
		}
		return "\(key): \(valueDescription)"
	}

	public var customMirror: Mirror {
		func mirror<T>(compact value: T) -> Mirror {
			Mirror(reflecting: "\(key): \(value)")
		}
		func mirror(children values: [Any]) -> Mirror {
			Mirror(self, unlabeledChildren: values)
		}
		return switch key {
		case .name, .repo, .author, .copyright, .description, .infourl, .maintainer:
			mirror(compact: string())
		case .version:
			mirror(compact: version())
		case .capabilities:
			mirror(children: strings())
		case .dependencies:
			mirror(children: dependencies())
		default:
			mirror(compact: value.count.formatted(.byteCount(style: .file)))
		}
	}

}

extension FileArchive : CustomReflectable, CustomStringConvertible, CustomDebugStringConvertible {

	public var description: String {
		"\(path): \(compressedBytes.count.formatted(.byteCount(style: .file)))"
	}

	public var debugDescription: String {
		let byteCount = uncompressedBytes.count.formatted(.byteCount(style: .file))
		var description = "\(path): \(byteCount)"

		if compression != .none {
			let compressedByteCount = compressedBytes.count.formatted(.byteCount(style: .file))
			description += " => '\(compression)' \(compressedByteCount))"
		}

		if checksum != .none {
			var encoded = ""
			encoded.reserveCapacity(checksumBytes.count * 2)
			for byte in checksumBytes {
				let encodedByte = String(byte, radix: 16, uppercase: true)
				if encodedByte.count == 1 {
					encoded.append("0")
				}
				encoded.append(encodedByte)
			}
			description += " [\(checksum) 0x\(encoded)]"
		}

		return description
	}

	public var customMirror: Mirror {
		Mirror(reflecting: description)
	}

}

extension DependencyArchive : CustomReflectable, CustomStringConvertible, CustomDebugStringConvertible {

	public var description: String {
		debugDescription
	}

	public var debugDescription: String {
		let version = switch version {
		case VersionArchive.latest: "latest"
		default: "\(version)"
		}
		return "\(name) @ \(version)"
	}

	public var customMirror: Mirror {
		Mirror(reflecting: description)
	}

}

@DebugDescription
extension VersionArchive : CustomReflectable, CustomStringConvertible, CustomDebugStringConvertible {

	public var description: String {
		debugDescription
	}

	public var debugDescription: String {
		"\(major).\(minor).\(patch)"
	}

	public var customMirror: Mirror {
		Mirror(reflecting: description)
	}

}

extension CompressionKey : CustomReflectable, CustomStringConvertible, CustomDebugStringConvertible {

	public var description: String {
		switch self {
		case .none: "none"
		case .runLengthEncoding: "run-length encoding"
		case .pucrunch: "pucrunch"
		default: "?"
		}
	}

	public var debugDescription: String {
		"\(String(rawValue, radix: 16, uppercase: true)) \(description)"
	}

	public var customMirror: Mirror {
		Mirror(reflecting: debugDescription)
	}

}

extension ChecksumKey : CustomReflectable, CustomStringConvertible, CustomDebugStringConvertible {

	public var description: String {
		switch self {
		case .none: "none"
		case .crc16: "crc16"
		case .sha1: "sha1"
		case .md5: "md5"
		default: "?"
		}
	}

	public var debugDescription: String {
		"\(String(rawValue, radix: 16, uppercase: true)) \(description)"
	}

	public var customMirror: Mirror {
		Mirror(reflecting: debugDescription)
	}

}

extension MetadataKey : CustomReflectable, CustomStringConvertible, CustomDebugStringConvertible {

	@inlinable public var description: String {
		switch self {
		case .name: "name"
		case .repo: "repo"
		case .description: "description"
		case .dependencies: "dependencies"
		case .version: "version"
		case .author: "author"
		case .maintainer: "maintainer"
		case .copyright: "copyright"
		case .infourl: "infourl"
		case .capabilities: "capabilities"
		default: "?"
		}
	}

	public var debugDescription: String {
		"\(String(rawValue, radix: 16, uppercase: true)) \(description)"
	}

	public var customMirror: Mirror {
		Mirror(reflecting: debugDescription)
	}

}

@DebugDescription
extension PackageArchive.Format : CustomReflectable, CustomStringConvertible, CustomDebugStringConvertible {

	public var description: String { "\(rawValue)" }

	public var debugDescription: String { "\(rawValue)" }

	public var customMirror: Mirror {
		Mirror(reflecting: rawValue)
	}

}
