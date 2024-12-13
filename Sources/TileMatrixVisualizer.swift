import Foundation
import SwiftTerm

class TileMatrixVisualizer {

    @MainActor static func visualize(tiles: [[DayTwelve.Tile]]) {
        let rowCount = tiles.count
        let colCount = tiles.first?.count ?? 0

        let top = "─"
        let left = "│"
        let right = "│"
        let bottom = "─"

        for i in 0..<rowCount {
            // Print top perimeters
            for j in 0..<colCount {
                if tiles[i][j].perimeters[1] {
                    print(" " + top + " ", terminator: "")
                } else {
                    print("   ", terminator: "")
                }
            }
            print()

            // Print left perimeters and tile types
            for j in 0..<colCount {
                if tiles[i][j].perimeters[0] {
                    print(left, terminator: "")
                } else {
                    print(" ", terminator: "")
                }
                print(tiles[i][j].type, terminator: "")
                if tiles[i][j].perimeters[2] {
                    print(right, terminator: "")
                } else {
                    print(" ", terminator: "")
                }
            }
            print()

            // Print bottom perimeters
            for j in 0..<colCount {
                if tiles[i][j].perimeters[3] {
                    print(" " + bottom + " ", terminator: "")
                } else {
                    print("   ", terminator: "")
                }
            }
            print()
        }
    }
}
