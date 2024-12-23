import Foundation

enum Util {
    struct GridConstraints {
        let rows: Int
        let cols: Int

        init(rows: Int, cols: Int) {
            self.rows = rows
            self.cols = cols
        }
    }

    struct Position: Hashable, Equatable {
        var i: Int
        var j: Int

        init(_ i: Int, _ j: Int) {
            self.i = i
            self.j = j
        }

        func isInBounds(_ constraints: GridConstraints) -> Bool {
            return i >= 0 && i < constraints.rows && j >= 0 && j < constraints.cols
        }
        
        func manhattanDistance(to other: Position) -> Int {
            return abs(i - other.i) + abs(j - other.j)
        }

        // Addition
        static func + (lhs: Position, rhs: Position) -> Position {
            return Position(lhs.i + rhs.i, lhs.j + rhs.j)
        }

        static func += (lhs: inout Position, rhs: Position) {
            lhs = lhs + rhs
        }

        // Subtraction
        static func - (lhs: Position, rhs: Position) -> Position {
            return Position(lhs.i - rhs.i, lhs.j - rhs.j)
        }

        static func -= (lhs: inout Position, rhs: Position) {
            lhs = lhs - rhs
        }

        // Multiplication
        static func * (lhs: Position, rhs: Int) -> Position {
            return Position(lhs.i * rhs, lhs.j * rhs)
        }

        static func *= (lhs: inout Position, rhs: Int) {
            lhs = lhs * rhs
        }

        // Division
        static func / (lhs: Position, rhs: Int) -> Position {
            return Position(lhs.i / rhs, lhs.j / rhs)
        }

        static func /= (lhs: inout Position, rhs: Int) {
            lhs = lhs / rhs
        }

        // Move
        func move(_ direction: Character) -> Util.Position {
            switch direction {
                case "^":
                    return Util.Position(i - 1, j)
                case "v":
                    return Util.Position(i + 1, j)
                case "<":
                    return Util.Position(i, j - 1)
                case ">":
                    return Util.Position(i, j + 1)
                default:
                    fatalError("Invalid direction")
            }
        }
    }

    enum Direction: Hashable, CaseIterable {
        case left
        case up
        case right
        case down

        func dPos() -> Position {
            switch self {
            case .left:
                return Position(0, -1)
            case .up:
                return Position(-1, 0)
            case .right:
                return Position(0, 1)
            case .down:
                return Position(1, 0)
            }
        }

        func turnRight() -> Direction {
            Self.allCases[(Self.allCases.firstIndex(of: self)! + 1) % Self.allCases.count]
        }

        func turnLeft() -> Direction {
            Self.allCases[(Self.allCases.firstIndex(of: self)! + 3) % Self.allCases.count]
        }
    }

    struct PathInput: Hashable {
        let start: Position
        let end: Position
        let obstacleCharacters: Set<Character>
    }

    struct Grid {
        var grid: [[Character]]
        var constraints: GridConstraints
        var memoizedPaths: [PathInput: [[Position]]] = [:]
        var memoizedPositions: [Character: Position] = [:]

        var rows: Int {
            return constraints.rows
        }

        var cols: Int {
            return constraints.cols
        }

        init(grid: [[Character]]) {
            self.grid = grid
            self.constraints = GridConstraints(rows: grid.count, cols: grid[0].count)
        }

        func isInBounds(_ p: Position) -> Bool {
            return p.i >= 0 && p.i < constraints.rows && p.j >= 0 && p.j < constraints.cols
        }

        func isWall(_ p: Position) -> Bool {
            return grid[p.i][p.j] == "#"
        }

        func isPath(_ p: Position) -> Bool {
            return grid[p.i][p.j] == "."
        }

        mutating func findPosition(_ c: Character) -> Position? {
            if let memoized = memoizedPositions[c] {
                return memoized
            }
            
            for i in grid.indices {
                for j in grid[i].indices {
                    if grid[i][j] == c {
                        memoizedPositions[c] = Position(i, j)
                        return Position(i, j)
                    }
                }
            }
            return nil
        }

        // This function needs to go through all possible shortest paths from input.start to input.end
        // And return them as an array of arrays of positions (each array is a path)
        // The paths should not contain any obstacles
        mutating func allShortestPaths(for input: PathInput) -> [[Position]] {
            if let memoized = memoizedPaths[input] {
                return memoized
            }

            var allPaths: [[Position]] = []
            var currentPath: [Position] = []

            func dfs(current: Position) {
                if current == input.end {
                    allPaths.append(currentPath)
                    return
                }

                for dir in [(0,1), (1,0), (0,-1), (-1,0)] {
                    let next = Position(current.i + dir.0, current.j + dir.1)
                    if isInBounds(next) && 
                       !currentPath.contains(next) &&
                       !input.obstacleCharacters.contains(grid[next.i][next.j]) {
                        currentPath.append(next)
                        dfs(current: next)
                        currentPath.removeLast()
                    }
                }
            }

            currentPath.append(input.start)
            dfs(current: input.start)

            let minLength = allPaths.map { $0.count }.min() ?? 0
            let shortestPaths = allPaths.filter { $0.count == minLength }

            memoizedPaths[input] = shortestPaths
            return shortestPaths
        }

        // Index with position
        subscript(p: Position) -> Character {
            get {
                return grid[p.i][p.j]
            }
            set {
                grid[p.i][p.j] = newValue
            }
        }
    }

    
    struct MovementState: Hashable {
        let position: Position
        let direction: Direction
        
    }

    static func renderMatrix(m: [[Character]]) {
        for row in m {
            for cell in row {
                print(cell, terminator: "")
            }
            print("")
        }
    }
}

extension Array where Element == Util.Position {
    func toDirString() -> String {
        var result = ""
        for i in 0..<count - 1 {
            let current = self[i]
            let next = self[i + 1]
            if next.i > current.i {
                result += "v"
            } else if next.i < current.i {
                result += "^"
            } else if next.j > current.j {
                result += ">"
            } else {
                result += "<"
            }
        }
        return result
    }
}
