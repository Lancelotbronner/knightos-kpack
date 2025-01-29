//
//  kpack.swift
//  
//
//  Created by Christophe Bronner on 2024-06-22.
//

import ArgumentParser

@main struct kpkg: ParsableCommand {

	static let configuration = CommandConfiguration(
		commandName: "kpkg",
		abstract: "KnightOS package manager - Manipulates KnightOS software packages", 
		version: "1.0.0",
		subcommands: [
			DumpCommand.self,
			ExtractCommand.self,
			PackCommand.self,
			StubCommand.self,
		],
		defaultSubcommand: PackCommand.self,
		aliases: ["kpack"])

}
