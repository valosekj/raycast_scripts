#!/usr/bin/swift

// Required parameters:
// @raycast.schemaVersion 1
// @raycast.title Copy Path to Last Desktop File
// @raycast.mode silent
// @raycast.packageName System

// Optional parameters:
// @raycast.icon 📋

// Documentation:
// @raycast.description Copies the absolute path of the most recently added file on ~/Desktop to the clipboard.

import AppKit

// MARK: - Convenience

extension URL {
  var addedToDirectoryDate: Date {
    return (try? resourceValues(forKeys: [.addedToDirectoryDateKey]).addedToDirectoryDate) ?? .distantPast
  }
}

func failure(_ message: String) -> Never {
  print(message)
  exit(1)
}

// MARK: - Main

do {
  let desktopDirectory = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!

  let files = try FileManager.default.contentsOfDirectory(at: desktopDirectory, includingPropertiesForKeys: [.addedToDirectoryDateKey], options: .skipsHiddenFiles)

  guard let lastFile = files.sorted(by: { $0.addedToDirectoryDate > $1.addedToDirectoryDate }).first else {
    failure("No files on Desktop")
  }

  NSPasteboard.general.clearContents()
  NSPasteboard.general.setString(lastFile.path, forType: .string)

  print("Copied: \(lastFile.path)")
} catch {
  failure(error.localizedDescription)
}
