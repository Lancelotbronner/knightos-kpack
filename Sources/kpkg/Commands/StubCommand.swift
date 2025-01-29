//
//  stub.swift
//  
//
//  Created by Christophe Bronner on 2024-06-22.
//

import ArgumentParser

struct StubCommand: ParsableCommand {

	static let configuration = CommandConfiguration(
		commandName: "stub",
		abstract: "Creates a stub from an existing package.")

}
