import Foundation

enum Utility {

    static func loadFile(named fileName: String) throws -> [String] {
        let fileURL = URL(fileURLWithPath: fileName)
        return try String(contentsOf: fileURL).split(separator: "\n").map { String($0) }
    }

}