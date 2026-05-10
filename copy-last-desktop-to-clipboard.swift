#!/usr/bin/swift

// Required parameters:
// @raycast.schemaVersion 1
// @raycast.title Copy Last Desktop File to Clipboard
// @raycast.mode silent
// @raycast.packageName System

// Optional parameters:
// @raycast.icon 📋

// Documentation:
// @raycast.description Copies the most recently added Desktop file to the clipboard (equivalent to Cmd+C in Finder).

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

  NSPasteboard.general.clearContents()
  NSPasteboard.general.writeObjects([lastFile as NSURL])

  print("Copied: \(lastFile.lastPathComponent)")
} catch {
  print(error.localizedDescription)
  exit(1)
}
