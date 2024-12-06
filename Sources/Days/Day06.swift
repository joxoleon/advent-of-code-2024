// Please do not look at this code, it won't make ANY SENSE!
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
        let m = getCharacterMatrix(from: input)
        let player = Player(map: m)
        player.runWithLoopObstacleInsertion()
        return ""
    }

    // MARK: - Utility functions

    func test() {}

    func getCharacterMatrix(from input: String) -> [[Character]] {
        return input.split(separator: "\n").map { Array($0) }
    }

}

fileprivate let directionCharacterSet = Set<Character>(["^", ">", "v", "<"])

fileprivate enum Direction: Hashable {
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

fileprivate struct VisitedStruct: Hashable {
    let position: Position
    let direction: Direction
    let index: Int
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
    // Initial Settings
    let initialPosition: Position
    let initialDirection: Direction
    let initialMap: [[Character]]

    var obstaclePositions: [Position] = []
    var position: Position
    var direction: Direction
    var map: [[Character]]
    var visited: Set<VisitedStruct>
    var steps = 0

    init(map: [[Character]]) {
        self.map = map
        self.position = Player.findStartPosition(map: map)
        self.direction = Direction(from: map[position.i][position.j])
        self.visited = Set([VisitedStruct(position: position, direction: direction, index: -1)])
        self.initialPosition = position
        self.initialDirection = direction
        self.initialMap = map
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
        return map[nextPosition.i][nextPosition.j] != "#" && map[nextPosition.i][nextPosition.j] != "O"
    }

    func move() {
        if canMoveToNextPosition() {
            position.move(inDirection: direction)
            steps += 1
            visited.insert(VisitedStruct(position: position, direction: direction, index: steps ))
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

    func runWithLoopObstacleInsertion() {
        run()
        let unorderedVisitedArray = Array(visited)
        let visitedArrayUnfiltered = unorderedVisitedArray.sorted {
            $0.index < $1.index
        }
        let visitedArray = visitedArrayUnfiltered.filter {
            $0.index != -1
            || ($0.position.i == initialPosition.i && $0.position.j == initialPosition.j)
        }
                
        
        var possibleObstacleCount = 0
        for i in 0..<visitedArray.count {
            print("Iteration \(i) from \(visitedArray.count)")
            let visited = visitedArray[i]
            reset()
            // Insert an obstacle at the visited position
            if obstaclePositions.contains(visited.position) {
                continue
            }
            
            map[visited.position.i][visited.position.j] = "O"
            var currentVisitedSet: Set<VisitedStruct> = Set([])
//            print("Map with Added obstacle at \(visited.position)")
//            renderMap()
            
            // Keep moving until we reach the same position with the same direction
            while !nextPosition().hasExitedMap() {
                move()
                if currentVisitedSet.contains(VisitedStruct(position: position, direction: direction, index: -1)) {
                    possibleObstacleCount += 1
                    obstaclePositions.append(visited.position)
                    
                    // Render map with obstacle
//                    print("*** Map with obstacle at \(position)")
//                    renderMap()
                    break
                }
                currentVisitedSet.insert(VisitedStruct(position: position, direction: direction, index: -1))
            }
        }
        print("\n\n")
        for obstaclePosition in obstaclePositions {
            var newMap = initialMap
            newMap[obstaclePosition.i][obstaclePosition.j] = "O"
            print("Obstacle set at \(obstaclePosition)")
            // Print the entire map
            for row in newMap {
                print(row.map { String($0) }.joined())
            }
            print("\n\n")
        }
        print("Possible obstacle count: \(possibleObstacleCount)")
    }

    func reset() {
        position = initialPosition
        direction = initialDirection
        map = initialMap
        visited = Set([VisitedStruct(position: position, direction: direction, index: -1)])
    }
}



// MARK: - Rendering simulation

extension Player {
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

//        // Prepare the map row by row - COLORED
//        let renderedRows = currentMap.map { row in
//            row.map { char in
//                if char == "x" {
//                    // Blue for visited positions
//                    return "\u{1B}[34m\(char)\u{1B}[0m"
//                } else if directionCharacterSet.contains(char) {
//                    // Green for direction characters
//                    return "\u{1B}[32m\(char)\u{1B}[0m"
//                } else {
//                    // Default color for other characters
//                    return "\(char)"
//                }
//            }.joined() // Combine characters into a single string for the row
//        }
//
//        let renderMatrix = renderedRows.joined(separator: "\n")
        
        let renderMatrix = currentMap.map { row in row.map { String($0) }.joined() }.joined(separator: "\n")

        // Clear the terminal right before printing
        print("\u{1B}[2J")

        // Print all rows at once
        print(renderMatrix)

        // Delay for a bit
        usleep(2_000)
    }
}
