#!/usr/bin/swift

import Foundation

func write(string: String, to filePath: String) throws {
    if let fileHandle = FileHandle(forWritingAtPath: filePath), let data = string.data(using: .utf8) {
        fileHandle.seekToEndOfFile()
        fileHandle.write(data)
    } else {
        do {
            try string.write(toFile: filePath, atomically: true, encoding: .utf8)
        } catch {
            print(error)
        }
    }
}

let goodCommands = """
                   👍🏾 ./filenames-printer [DIRECTORY OF THE FILENAMES TO BE PRINTED]
                       ⦿ this will print filenames to the screen

                   👍🏾 ./filenames-printer [DIRECTORY OF THE FILENAMES TO BE PRINTED] [FILE TO WRITE FOUND FILENAMES]
                       ⦿ this will write filenames to the file specified
                   """
let badCommands = "❌ ./filenames-printer"
let moreArgumentsMessage = "⚠️ Script atleast 1 arguments"
let lessArgumentsMessage = "⚠️ Script has 1 or more extra arguments"
let commandLineArguments = CommandLine.arguments
let scriptName = commandLineArguments.first ?? ""
let arguments = commandLineArguments.dropFirst()

// A few checks before we start
guard arguments.count >= 1  else {
    print("\(moreArgumentsMessage)\n\n\(badCommands)\n\n\(goodCommands)")
    exit(1)
}
guard arguments.count <= 2 else {
    print("\(lessArgumentsMessage)\n\n\(badCommands)\n\n\(goodCommands)")
    exit(1)
}

let fileManager = FileManager.default
var searchingDirectory = arguments.first ?? ""
let lastSearchingDirectorySymbol = String(searchingDirectory.last ?? Character(""))

// Make sure searching directory includes a forward slash
if lastSearchingDirectorySymbol != "/" {
    searchingDirectory.append("/")
}

var filenames = try fileManager.contentsOfDirectory(atPath: searchingDirectory)

filenames.sort { $0.lowercased() < $1.lowercased() }

if arguments.count == 1 {
    filenames = filenames.filter { return $0 != scriptName && $0 != ".DS_Store" ? true : false }
    filenames.forEach { print("\($0)") }
} else {
    let storageFilename = arguments.last ?? ""

    filenames = filenames.filter { return $0 != scriptName && $0 != storageFilename && $0 != ".DS_Store" ? true : false }

    // Remove storage file so its empty
    do {
        try fileManager.removeItem(atPath: storageFilename)
    } catch {
        print(error)
        exit(1)
    }

    filenames.forEach {
        do {
            try write(string: "\($0)\n", to: storageFilename)
        } catch {
            print(error)
            exit(1)
        }
    }
}

exit(0)
