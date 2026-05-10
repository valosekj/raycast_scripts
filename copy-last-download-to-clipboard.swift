#!/usr/bin/swift

// Required parameters:
// @raycast.schemaVersion 1
// @raycast.title Copy Last Download to Clipboard
// @raycast.mode silent
// @raycast.packageName System

// Optional parameters:
// @raycast.icon 📋

// Documentation:
// @raycast.description Copies the most recently downloaded file to the clipboard (equivalent to Cmd+C in Finder).

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
  let downloadsDirectory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!

  let downloads = try FileManager.default.contentsOfDirectory(at: downloadsDirectory, includingPropertiesForKeys: [.addedToDirectoryDateKey], options: .skipsHiddenFiles)

  guard let lastDownload = downloads.sorted(by: { $0.addedToDirectoryDate > $1.addedToDirectoryDate }).first else {
    failure("No files in Downloads")
  }

  NSPasteboard.general.clearContents()
  NSPasteboard.general.writeObjects([lastDownload as NSURL])

  print("Copied: \(lastDownload.lastPathComponent)")
} catch {
  print(error.localizedDescription)
  exit(1)
}
