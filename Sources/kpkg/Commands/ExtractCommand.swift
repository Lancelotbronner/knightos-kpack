//
//  unpack.swift
//  
//
//  Created by Christophe Bronner on 2024-06-22.
//

import ArgumentParser

struct ExtractCommand: ParsableCommand {

	static let configuration = CommandConfiguration(
		commandName: "extracts",
		abstract: "Extracts a package.",
		aliases: ["unpack"])

	func run() throws {
//		inputPackage = fopen(packager.filename, "rb");
//		if (!inputPackage) {
//			printf("Unable to open %s for reading.\n", packager.filename);
//		} else {
//			if (packager.rootName[strlen(packager.rootName) - 1] == '/') {
//				packager.rootName[strlen(packager.rootName) - 1] = '\0';
//			}
//			unpack(inputPackage, packager.rootName, packager.stub);
//			fclose(inputPackage);
//			printf("Extracted %s.\n", packager.filename);
//		}
	}

}
