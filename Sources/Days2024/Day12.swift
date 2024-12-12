// https://adventofcode.com/2024/day/12
import Foundation

class DayTwelve: Day {
    let dayNumber: Int = 12
    let year: Int = 2024

    struct Position: Hashable {
        let i: Int
        let j: Int
    }

    enum Direction: Int, Hashable {
        case left = 0
        case top
        case right
        case bottom
    }

    class Tile: Hashable, Equatable {
        let type: Character
        var perimeters: [Bool] = [false, false, false, false] // left, top, right, bottom
        var isPartOfSegment = false
    
        init(_ char: Character) {
            self.type = char
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(type)
            hasher.combine(perimeters)
        }
    
        static func == (lhs: Tile, rhs: Tile) -> Bool {
            return lhs.type == rhs.type
        }
    
        func populatePerimeters(_ position: Position, _ map: inout [[Tile]], perimeters: inout [Bool]) {
            let directions = [(0, -1), (-1, 0), (0, 1), (1, 0)] // left, top, right, bottom
            let (i, j) = (position.i, position.j)
            
            for (index, direction) in directions.enumerated() {
                let newI = i + direction.0
                let newJ = j + direction.1
                
                if newI < 0 || newI >= map.count || newJ < 0 || newJ >= map[i].count || map[newI][newJ] != map[i][j] {
                    perimeters[index] = true
                }
            }
        }

        var perimiterCount: Int {
            return perimeters.filter { $0 }.count
        }
    }

    static func getNeighborAdjacentTypeOfSameType(tiles: [[Tile]], position: Position, direction: Direction) -> Tile? {
        let (i, j) = (position.i, position.j)
        let currentTile = tiles[i][j]
        
        switch direction {
        case .left:
            if j - 1 >= 0 && tiles[i][j - 1].type == currentTile.type {
                return tiles[i][j - 1]
            }
        case .top:
            if i - 1 >= 0 && tiles[i - 1][j].type == currentTile.type {
                return tiles[i - 1][j]
            }
        case .right:
            if j + 1 < tiles[i].count && tiles[i][j + 1].type == currentTile.type {
                return tiles[i][j + 1]
            }
        case .bottom:
            if i + 1 < tiles.count && tiles[i + 1][j].type == currentTile.type {
                return tiles[i + 1][j]
            }
        }
        return nil
    }

    class GardenSegment {

        // MARK: - Properties
        let positions: [Position]
        let tiles: [[Tile]]

        var area: Int { return positions.count }

        var perimeter: Int {
            var perimiterSum = 0
            for position in positions {
                perimiterSum += tiles[position.i][position.j].perimiterCount
            }
            return perimiterSum
        }

        var price: Int {
            printSegment()
            return area * perimeter
        }

        init(position: Position, tiles: [[Tile]]) {
            var positions: [Position] = []
            var visited: [Position] = []
            var queue: [Position] = [position]
            while !queue.isEmpty {
                let current = queue.removeFirst()
                if visited.contains(current) {
                    continue
                }
                visited.append(current)
                positions.append(current)
                let directions = [(1, 0), (-1, 0), (0, 1), (0, -1)]
                for direction in directions {
                    let i = current.i + direction.0
                    let j = current.j + direction.1
                    if i >= 0 && i < tiles.count && j >= 0 && j < tiles[i].count {
                        if tiles[i][j] == tiles[position.i][position.j] {
                            queue.append(Position(i: i, j: j))
                        }
                    }
                }
            }
            self.positions = positions
            self.tiles = tiles
            
            for position in positions {
                tiles[position.i][position.j].isPartOfSegment = true
            }
        }

        func getContiguousPositionSegments(row: Int) -> [[Position]] {
            var filteredPos = positions.filter { $0.i == row }
            var contiguousPositions: [[Position]] = []
            var currentLine: [Position] = []
            
            while !filteredPos.isEmpty {
                let current = filteredPos.removeFirst()
                if currentLine.isEmpty {
                    currentLine.append(current)
                } else {
                    let last = currentLine.last!
                    if last.j + 1 == current.j {
                        currentLine.append(current)
                    } else {
                        contiguousPositions.append(currentLine)
                        currentLine = [current]
                    }
                }
            }
            
            // Append the last segment if it exists
            if !currentLine.isEmpty {
                contiguousPositions.append(currentLine)
            }
        
            return contiguousPositions
        }

        func getContiguousPositionSegments(column: Int) -> [[Position]] {
            var filteredPos = positions.filter { $0.j == column }
            var contiguousPositions: [[Position]] = []
            var currentLine: [Position] = []
            
            while !filteredPos.isEmpty {
                let current = filteredPos.removeFirst()
                if currentLine.isEmpty {
                    currentLine.append(current)
                } else {
                    let last = currentLine.last!
                    if last.i + 1 == current.i {
                        currentLine.append(current)
                    } else {
                        contiguousPositions.append(currentLine)
                        currentLine = [current]
                    }
                }
            }
            
            // Append the last segment if it exists
            if !currentLine.isEmpty {
                contiguousPositions.append(currentLine)
            }
        
            return contiguousPositions
        }

        func printSegment() {
            let letter = tiles[positions.first!.i][positions.first!.j].type
            print("Segment of \(letter) with area: \(area), perimeter: \(perimeter) and price: \(area * perimeter)")
        }
    }


    // MARK: - Part One

    func partOne(input: String) -> String {
        var tiles: [[Tile]] = input.components(separatedBy: .newlines)
        .map { Array(String($0)) }
        .map { $0.map { Tile($0) } }

        // Create areas
        var segments: [GardenSegment] = []
        for i in tiles.indices {
            for j in tiles.indices {
                let position = Position(i: i, j: j)
                if tiles[i][j].isPartOfSegment == false {
                    let segment = GardenSegment(position: position, tiles: tiles)
                    segments.append(segment)
                }
            }
        }

        print("Segments: \(segments.count)")

        // Populate perimeters
        for i in tiles.indices {
            for j in tiles.indices {
                tiles[i][j].populatePerimeters(Position(i: i, j: j), &tiles, perimeters: &tiles[i][j].perimeters)
            }
        }

        printTileMatrix(tiles: tiles)

        let price = segments.reduce(0) { $0 + $1.price }

        return "Total price: \(price)"
    }

    // MARK: - Part Two

    func partTwo(input: String) -> String {
var tiles: [[Tile]] = input.components(separatedBy: .newlines)
        .map { Array(String($0)) }
        .map { $0.map { Tile($0) } }

        // Create areas
        var segments: [GardenSegment] = []
        for i in tiles.indices {
            for j in tiles.indices {
                let position = Position(i: i, j: j)
                if tiles[i][j].isPartOfSegment == false {
                    let segment = GardenSegment(position: position, tiles: tiles)
                    segments.append(segment)
                }
            }
        }

        // Populate perimeters
        for i in tiles.indices {
            for j in tiles.indices {
                tiles[i][j].populatePerimeters(Position(i: i, j: j), &tiles, perimeters: &tiles[i][j].perimeters)
            }
        }

        printTileMatrix(tiles: tiles)

        // Remove contiguous perimiters (so that each perimiter is counted as a line)
        for segment in segments {
            let minI = segment.positions.map { $0.i }.min()!
            let maxI = segment.positions.map { $0.i }.max()!
            let minJ = segment.positions.map { $0.j }.min()!
            let maxJ = segment.positions.map { $0.j }.max()!


            // Remove top and bottom perimeters
            for i in minI...maxI {
                let contiguousPositionSegments = segment.getContiguousPositionSegments(row: i)
                for contiguousPositions in contiguousPositionSegments {
                    var shouldRemoveTop = false
                    var shouldRemoveBottom = false
                    for position in contiguousPositions {
                        if shouldRemoveTop {
                            tiles[position.i][position.j].perimeters[1] = false
                        }
                        if shouldRemoveBottom {
                            tiles[position.i][position.j].perimeters[3] = false
                        }
                        shouldRemoveTop = shouldRemoveTop || tiles[position.i][position.j].perimeters[1]
                        shouldRemoveBottom = shouldRemoveBottom || tiles[position.i][position.j].perimeters[3]
                    }
                }
            }

            // Remove left and right perimeters
            for j in minJ...maxJ {
                let contiguousPositionSegments = segment.getContiguousPositionSegments(column: j)
                for contiguousPositions in contiguousPositionSegments {
                    var shouldRemoveLeft = false
                    var shouldRemoveRight = false
                    for position in contiguousPositions {
                        if shouldRemoveLeft {
                            tiles[position.i][position.j].perimeters[0] = false
                        }
                        if shouldRemoveRight {
                            tiles[position.i][position.j].perimeters[2] = false
                        }
                        shouldRemoveLeft = shouldRemoveLeft || tiles[position.i][position.j].perimeters[0]
                        shouldRemoveRight = shouldRemoveRight || tiles[position.i][position.j].perimeters[2]
                    }
                }
            }
        }

        print("")
        printTileMatrix(tiles: tiles)
        print("")

        let partTwoPrice = segments.reduce(0) { $0 + $1.price }
        return "Part Two price: \(partTwoPrice)"
    }



    // MARK: - Testing

    func test() {}


    func printTileMatrix(tiles: [[Tile]]) {
        for i in tiles.indices {
            // Print top perimeters
            for j in tiles[i].indices {
                let top = tiles[i][j].perimeters[1] ? "─" : " "
                print(" \(top) ", terminator: "")
            }
            print()
            
            // Print left perimeters and tile types
            for j in tiles[i].indices {
                let left = tiles[i][j].perimeters[0] ? "│" : " "
                print("\(left)\(tiles[i][j].type)", terminator: "")
            }
            // Print right perimeter of the last tile in the row
            print(tiles[i].last!.perimeters[2] ? "│" : " ")
            
            // Print bottom perimeters
            for j in tiles[i].indices {
                let bottom = tiles[i][j].perimeters[3] ? "─" : " "
                print(" \(bottom) ", terminator: "")
            }
            print()
        }
    }
}
