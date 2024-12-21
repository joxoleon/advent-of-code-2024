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

    struct Grid {
        var grid: [[Character]]
        var constraints: GridConstraints

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

        func findPosition(_ c: Character) -> Position? {
            for i in grid.indices {
                for j in grid[i].indices {
                    if grid[i][j] == c {
                        return Position(i, j)
                    }
                }
            }
            return nil
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

