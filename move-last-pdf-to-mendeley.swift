#!/usr/bin/swift

// Required parameters:
// @raycast.schemaVersion 1
// @raycast.title Move Last PDF to Mendeley
// @raycast.mode silent
// @raycast.packageName System

// Optional parameters:
// @raycast.icon 📚

// Documentation:
// @raycast.description Moves the most recently downloaded PDF to the Mendeley Desktop Downloaded folder.

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
  let mendeleyDirectory = URL(fileURLWithPath: "/Users/valosek/Library/Application Support/Mendeley Desktop/Downloaded")

  let downloads = try FileManager.default.contentsOfDirectory(at: downloadsDirectory, includingPropertiesForKeys: [.addedToDirectoryDateKey], options: .skipsHiddenFiles)

  let pdfs = downloads.filter { $0.pathExtension.lowercased() == "pdf" }

  guard let lastPDF = pdfs.sorted(by: { $0.addedToDirectoryDate > $1.addedToDirectoryDate }).first else {
    failure("No PDF files found in Downloads")
  }

  let destination = mendeleyDirectory.appendingPathComponent(lastPDF.lastPathComponent)

  if FileManager.default.fileExists(atPath: destination.path) {
    failure("Already exists in Mendeley: \(lastPDF.lastPathComponent)")
  }

  try FileManager.default.moveItem(at: lastPDF, to: destination)

  print("Moved to Mendeley: \(lastPDF.lastPathComponent)")
} catch let error as NSError where error.domain == NSCocoaErrorDomain {
  print(error.localizedDescription)
  exit(1)
} catch {
  print(error.localizedDescription)
  exit(1)
}
