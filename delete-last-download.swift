#!/usr/bin/swift

// Required parameters:
// @raycast.schemaVersion 1
// @raycast.title Delete Last Download
// @raycast.mode silent
// @raycast.packageName System

// Optional parameters:
// @raycast.icon 🗑️

// Documentation:
// @raycast.description Deletes the most recently added file from the Downloads folder.

import Foundation

// MARK: - Convenience

extension URL {
  var addedToDirectoryDate: Date {
    return (try? resourceValues(forKeys: [.addedToDirectoryDateKey]).addedToDirectoryDate) ?? .distantPast
  }
}

func failure(_ message: String) -> Never {
  print("❌ \(message)")
  exit(1)
}

func success(_ message: String) -> Never {
  print("✅ \(message)")
  exit(0)
}

func cancelled(_ message: String) -> Never {
  print("ℹ️ \(message)")
  exit(0)
}

func confirmDeletion(fileName: String) -> Bool {
  let process = Process()
  process.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
  process.arguments = [
    "-e", "on run argv",
    "-e", "set fileName to item 1 of argv",
    "-e", "display dialog \"Delete the latest download?\" & return & return & fileName buttons {\"Cancel\", \"Delete\"} default button \"Delete\" with icon caution",
    "-e", "return button returned of result",
    "-e", "end run",
    "--", fileName
  ]

  let output = Pipe()
  process.standardOutput = output
  process.standardError = Pipe()

  do {
    try process.run()
    process.waitUntilExit()
  } catch {
    failure("Failed to show confirmation dialog: \(error.localizedDescription)")
  }

  guard process.terminationStatus == 0 else {
    return false
  }

  let responseData = output.fileHandleForReading.readDataToEndOfFile()
  let response = String(data: responseData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
  return response == "Delete"
}

// MARK: - Main

do {
  let downloadsDirectory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!

  let downloads = try FileManager.default.contentsOfDirectory(at: downloadsDirectory, includingPropertiesForKeys: [.addedToDirectoryDateKey], options: .skipsHiddenFiles)

  guard let lastDownload = downloads.sorted(by: { $0.addedToDirectoryDate > $1.addedToDirectoryDate }).first else {
    failure("No downloaded files found.")
  }

  guard confirmDeletion(fileName: lastDownload.lastPathComponent) else {
    cancelled("Deletion cancelled.")
  }

  try FileManager.default.removeItem(at: lastDownload)
  success("Deleted: \(lastDownload.lastPathComponent)")
} catch {
  failure(error.localizedDescription)
}
