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

    enum Direction: Hashable {
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
    }
}

