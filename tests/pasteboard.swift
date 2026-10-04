// Test-only full-fidelity pasteboard snapshot. Data stays in the caller's memory.
import AppKit
import Foundation

struct Representation: Codable, Equatable { let type: String; let data: Data }
typealias Snapshot = [[Representation]]
let board = NSPasteboard.general
func snapshot() throws -> Snapshot {
    try (board.pasteboardItems ?? []).map { item in
        try item.types.map { type in
            guard let data = item.data(forType: type) else {
                throw NSError(domain: "pasteboard-fixture", code: 1,
                              userInfo: [NSLocalizedDescriptionKey: "Cannot preserve pasteboard representation"])
            }
            return Representation(type: type.rawValue, data: data)
        }.sorted { $0.type < $1.type }
    }
}
if CommandLine.arguments[1] == "snapshot" {
    FileHandle.standardOutput.write(try JSONEncoder().encode(snapshot()))
} else if CommandLine.arguments[1] == "restore" {
    let data = FileHandle.standardInput.readDataToEndOfFile()
    let original = try JSONDecoder().decode(Snapshot.self, from: data)
    let items = original.map { representations in
        let item = NSPasteboardItem()
        for representation in representations {
            precondition(item.setData(representation.data, forType: NSPasteboard.PasteboardType(representation.type)))
        }
        return item
    }
    board.clearContents()
    if !items.isEmpty { precondition(board.writeObjects(items)) }
    let restored = try snapshot()
    precondition(restored == original, "Pasteboard restoration mismatch")
} else { fatalError("Use snapshot or restore") }
