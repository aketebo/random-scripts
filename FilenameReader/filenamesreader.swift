#!/usr/bin/swift

import Foundation

func write(string: String, to filePath: String) throws {
    if let fileHandle = FileHandle(forWritingAtPath: filePath),
        let data = string.data(using: .utf8) {
        fileHandle.seekToEndOfFile()
        fileHandle.write(data)
    } else {
        do {
            try string.write(toFile: filePath, atomically: true, encoding: .utf8)
        } catch {
            print("Something went wrong. Could not write to file")
        }
    }
}

if CommandLine.arguments.count == 2 {
    if "help" == CommandLine.arguments[1] {
        print("Here's an example of how this script should be ran:")
        print("./filenamesreader.swift <directory-to-find-filenames> <filename-to-store-filenames>")
        exit(0)
    }
}

guard CommandLine.arguments.count == 3 else {
    print("Arguments not equal to 3")
    print("Hmmm you're command arguments seem to be the problem")
    print("Here's an example:")
    print("./filenamesreader.swift <directory-to-find-filenames> <filename-to-store-filenames>")
    exit(0)
}

let scriptName = "filenamesreader.swift"
var searchPath = CommandLine.arguments[1]
let storeToFileName = CommandLine.arguments[2]
let fileManager = FileManager.default

if searchPath.last! != "/" {
    searchPath.append("/")
}

do {
    let filenames = try fileManager.contentsOfDirectory(atPath: searchPath)

    for filename in filenames {
        if filename == scriptName || filename == storeToFileName { continue }

        let filenamePlusNewLine = filename + "\n"
        try write(string: filenamePlusNewLine, to: storeToFileName)
    }

    print("All done!")
} catch {
    print("😔 I have failed you my friend...")
}
