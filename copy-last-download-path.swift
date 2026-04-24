#!/usr/bin/swift

// Required parameters:
// @raycast.schemaVersion 1
// @raycast.title Copy Path to Last Download
// @raycast.mode silent
// @raycast.packageName System

// Optional parameters:
// @raycast.icon 📋

// Documentation:
// @raycast.description Copies the absolute path of the most recently added file in ~/Downloads to the clipboard.

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
  let downloadsDirectory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!

  let downloads = try FileManager.default.contentsOfDirectory(at: downloadsDirectory, includingPropertiesForKeys: [.addedToDirectoryDateKey], options: .skipsHiddenFiles)

  guard let lastDownload = downloads.sorted(by: { $0.addedToDirectoryDate > $1.addedToDirectoryDate }).first else {
    failure("No downloaded files")
  }

  NSPasteboard.general.clearContents()
  NSPasteboard.general.setString(lastDownload.path, forType: .string)

  print("Copied: \(lastDownload.path)")
} catch {
  failure(error.localizedDescription)
}
