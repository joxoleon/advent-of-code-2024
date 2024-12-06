// https://adventofcode.com/2024/day/6
import Foundation

class DaySix: Day {
    let dayNumber: Int = 6




    func partOne(input: String) -> String {
        // Transform input into a matrix of characters
        let m = getCharacterMatrix(from: input)
        let player = Player(map: m)
        player.run()

        return ""
    }

    func partTwo(input: String) -> String {
        return ""
    }

    // MARK: - Utility functions

    func test() {}

    func getCharacterMatrix(from input: String) -> [[Character]] {
        return input.split(separator: "\n").map { Array($0) }
    }

}

fileprivate let directionCharacterSet = Set<Character>(["^", ">", "v", "<"])

fileprivate enum Direction {
    case up
    case right
    case down
    case left
    
    mutating func rotateRight() {
        switch self {
        case .up:
            self = .right
        case .right:
            self = .down
        case .down:
            self = .left
        case .left:
            self = .up
        }
    }

    init(from char: Character) {
        switch char {
            case "^":
                self = .up
            case ">":
                self = .right
            case "v":
                self = .down
            case "<":
                self = .left
            default:
                fatalError("Invalid character")
        }
    }

    var char: Character {
        switch self {
        case .up:
            return "^"
        case .right:
            return ">"
        case .down:
            return "v"
        case .left:
            return "<"
        }
    }

    var indexIncrement: (Int, Int) {
        switch self {
        case .up:
            return (-1, 0)
        case .right:
            return (0, 1)
        case .down:
            return (1, 0)
        case .left:
            return (0, -1)
        }
    }
}

fileprivate struct Position: Hashable {
    var i: Int
    var j: Int
    // This probably shouldn't be here, but I'm lazy
    var rowCount: Int
    var colCount: Int

    mutating func move(inDirection direction: Direction) {
        let (di, dj) = direction.indexIncrement
        i += di
        j += dj
    }

    func hasExitedMap() -> Bool {
        return i < 0 || i >= rowCount || j < 0 || j >= colCount
    }
}

fileprivate class Player {
    var position: Position
    var direction: Direction
    var map: [[Character]]
    var visited: Set<Position>

    init(map: [[Character]]) {
        self.map = map
        self.position = Player.findStartPosition(map: map)
        self.direction = Direction(from: map[position.i][position.j])
        self.visited = Set<Position>([self.position])
    }

    static func findStartPosition(map: [[Character]]) -> Position {
        for i in 0..<map.count {
            for j in 0..<map[i].count {
                if directionCharacterSet.contains(map[i][j]) {
                    return Position(i: i, j: j, rowCount: map.count, colCount: map[i].count)
                }
            }
        }
        fatalError("No starting position found")
    }

    func nextPosition() -> Position {
        var nextPosition = position
        nextPosition.move(inDirection: direction)
        return nextPosition
    }

    func canMoveToNextPosition() -> Bool {
        let nextPosition = self.nextPosition()
        return map[nextPosition.i][nextPosition.j] != "#"
    }

    func move() {
        if canMoveToNextPosition() {
            position.move(inDirection: direction)
            visited.insert(position)
            map[position.i][position.j] = "x"
        } else {
            direction.rotateRight()
        }
    }

    func run() {
        while !nextPosition().hasExitedMap() {
            move()
        }
        print("Visited \(visited.count) positions")
    }

    func runWithRendering() {
        while !nextPosition().hasExitedMap() {
            renderMap()
            move()
        }
        renderMap()
        print("Visited \(visited.count) positions")
    }

    func renderMap() {
        // Copy the map to avoid modifying the original
        var currentMap = map
        currentMap[position.i][position.j] = direction.char

        // Prepare the map row by row
        let renderedRows = currentMap.map { row in
            row.map { char in
                if char == "x" {
                    // Blue for visited positions
                    return "\u{1B}[34m\(char)\u{1B}[0m"
                } else if directionCharacterSet.contains(char) {
                    // Green for direction characters
                    return "\u{1B}[32m\(char)\u{1B}[0m"
                } else {
                    // Default color for other characters
                    return "\(char)"
                }
            }.joined() // Combine characters into a single string for the row
        }

        let renderMatrix = renderedRows.joined(separator: "\n")

        // Clear the terminal right before printing
        print("\u{1B}[2J")

        // Print all rows at once
        print(renderMatrix)

        // Delay for a bit
        usleep(25_000)
    }

}
