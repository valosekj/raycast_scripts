#!/usr/bin/swift

// Required parameters:
// @raycast.schemaVersion 1
// @raycast.title Open Last Desktop File
// @raycast.mode silent
// @raycast.packageName System

// Optional parameters:
// @raycast.icon 💁‍♂️

// Documentation:
// @raycast.description Opens the most recently added file on the Desktop.

import AppKit

extension URL {
  var addedToDirectoryDate: Date {
    return (try? resourceValues(forKeys: [.addedToDirectoryDateKey]).addedToDirectoryDate) ?? .distantPast
  }
}

func failure(_ message: String) -> Never {
  print(message)
  exit(1)
}

do {
  let desktopDirectory = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!

  let files = try FileManager.default.contentsOfDirectory(at: desktopDirectory, includingPropertiesForKeys: [.addedToDirectoryDateKey], options: .skipsHiddenFiles)

  guard let lastFile = files.sorted(by: { $0.addedToDirectoryDate > $1.addedToDirectoryDate }).first else {
    failure("No files on Desktop")
  }

  NSWorkspace.shared.open(lastFile)
} catch {
  failure(error.localizedDescription)
}
