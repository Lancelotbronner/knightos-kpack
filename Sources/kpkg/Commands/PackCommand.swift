//
//  pack.swift
//  
//
//  Created by Christophe Bronner on 2024-06-22.
//

import ArgumentParser

struct PackCommand: ParsableCommand {

	static let configuration = CommandConfiguration(
		commandName: "pack",
		abstract: "Packs files into a package.")

	@Option(name: .shortAndLong, help: "Specifies an alternate config file.")
	var config: String?

	func run() throws {

//		if (parse_metadata()) {
//			printf("Aborting operation.\n");
//			freeMetadata();
//			fclose(packager.config);
//			return 1;
//		}
//
//		printf("Packaging %s/%s:%d.%d.%d as %s...\n", packager.repo, packager.pkgname,
//				packager.version.major, packager.version.minor, packager.version.patch, packager.filename);
//
//		packager.output = fopen(packager.filename, "wb");
//		if (!packager.output) {
//			printf("Error: unable to open %s for writing.\n", packager.filename);
//			freeMetadata();
//			return 1;
//		}
//
//		// See doc/package_format for information on package format
//		fputs("KPKG", packager.output);
//		fputc(KPKG_FORMAT_VERSION, packager.output);
//
//		// Write metadata
//		fputc(packager.mdlen, packager.output);
//		// Package name
//		fputc(KEY_PKG_NAME, packager.output);
//		fputc((int)strlen(packager.pkgname), packager.output);
//		fputs(packager.pkgname, packager.output);
//		// Package repo
//		fputc(KEY_PKG_REPO, packager.output);
//		fputc((int)strlen(packager.repo), packager.output);
//		fputs(packager.repo, packager.output);
//		// Package version
//		fputc(KEY_PKG_VERSION, packager.output);
//		fputc(3, packager.output);
//		fputc(packager.version.major, packager.output);
//		fputc(packager.version.minor, packager.output);
//		fputc(packager.version.patch, packager.output);
//		// Then write all the optional metadata fields by iterating through them
//		// Package description
//		if(packager.description) {
//			fputc(KEY_PKG_DESCRIPTION, packager.output);
//			fputc((int)strlen(packager.description), packager.output);
//			fputs(packager.description, packager.output);
//			free(packager.description);
//		}
//		// Package's author
//		if(packager.author) {
//			fputc(KEY_PKG_AUTHOR, packager.output);
//			fputc((int)strlen(packager.author), packager.output);
//			fputs(packager.author, packager.output);
//			free(packager.author);
//		}
//		// Package's maintainer
//		if(packager.maintainer) {
//			fputc(KEY_PKG_MAINTAINER, packager.output);
//			fputc((int)strlen(packager.maintainer), packager.output);
//			fputs(packager.maintainer, packager.output);
//			free(packager.maintainer);
//		}
//		// Package's copyright
//		if(packager.copyright) {
//			fputc(KEY_PKG_COPYRIGHT, packager.output);
//			fputc((int)strlen(packager.copyright), packager.output);
//			fputs(packager.copyright, packager.output);
//			free(packager.copyright);
//		}
//		// Package's info URL
//		if(packager.infourl) {
//			fputc(KEY_INFO_URL, packager.output);
//			fputc((int)strlen(packager.infourl), packager.output);
//			fputs(packager.infourl, packager.output);
//			free(packager.infourl);
//		}
//		// Package dependencies
//		if(packager.dependencies_len != 0) {
//			fputc(KEY_PKG_DEPS, packager.output);
//			int len = 1;
//			int i;
//			for (i = 0; i < packager.dependencies_len; ++i) {
//				len += 4;
//				len += strlen(packager.dependencies[i]->name);
//			}
//			fputc(len, packager.output);
//			fputc(packager.dependencies_len, packager.output);
//			for (i = 0; i < packager.dependencies_len; ++i) {
//				fputc(packager.dependencies[i]->version.major, packager.output);
//				fputc(packager.dependencies[i]->version.minor, packager.output);
//				fputc(packager.dependencies[i]->version.patch, packager.output);
//				fputc((int)strlen(packager.dependencies[i]->name), packager.output);
//				fputs(packager.dependencies[i]->name, packager.output);
//			}
//		}
//
//		// Write files
//		rootDir = opendir(packager.rootName);
//		if(!rootDir) {
//			printf("Couldn't open directory %s.\nAborting operation.\n", packager.rootName);
//		} else {
//			writeModel(rootDir, packager.rootName);
//			closedir(rootDir);
//		}
//
//		fclose(packager.output);
//		fclose(packager.config);
//		printf("Successfully wrote %s/%s:%d.%d.%d to %s.\n", packager.repo, packager.pkgname,
//				packager.version.major, packager.version.minor, packager.version.patch, packager.filename);
//		free(packager.pkgname);
//		free(packager.repo);
	}

}
