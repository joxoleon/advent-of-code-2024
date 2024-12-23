// https://adventofcode.com/2024/day/21
import Foundation

class DayTwentyOne: @preconcurrency Day {
    let dayNumber: Int = 21
    let year: Int = 2024

    // MARK: - Types

    struct PositionPair: Hashable {
        let first: Util.Position
        let second: Util.Position

        @MainActor static var memoizedDirections: [PositionPair: String] = [:]

        func hash(into hasher: inout Hasher) {
            hasher.combine(first)
            hasher.combine(second)
        }

        static func == (lhs: PositionPair, rhs: PositionPair) -> Bool {
            return lhs.first == rhs.first && lhs.second == rhs.second
        }

        @MainActor func directions(firstHorizontal: Bool = true) -> String {
            if let memoized = Self.memoizedDirections[self] {
                return memoized
            }
            let horizontalDif = second.j - first.j
            var horizontalString = ""
            switch horizontalDif {
                case 1: horizontalString += ">"
                case 2: horizontalString += ">>"
                case -1: horizontalString += "<"
                case -2: horizontalString += "<<"
                case 0: break
                default: fatalError("Invalid horizontal difference")
            }

            let verticalDif = second.i - first.i
            var verticalString = ""
            switch verticalDif {
                case 1: verticalString += "v"
                case 2: verticalString += "vv"
                case 3: verticalString += "vvv"
                case -1: verticalString += "^"
                case -2: verticalString += "^^"
                case -3: verticalString += "^^^"
                case 0: break
                default: fatalError("Invalid vertical difference")
            }

            let dirs = firstHorizontal ? (horizontalString + verticalString) : (verticalString + horizontalString)
            Self.memoizedDirections[self] = dirs
            return dirs
        }
    }

    class NumericKeyboard {
        static let grid: [[Character]] = [
            ["7", "8", "9"],
            ["4", "5", "6"],
            ["1", "2", "3"],
            ["*", "0", "A"] // Star should never be directed at
        ]
        
         static let positions: [Character: Util.Position] = {
            var positions = [Character: Util.Position]()
            for i in 0..<grid.count {
                for j in 0..<grid[i].count {
                    positions[grid[i][j]] = Util.Position(i, j)
                }
            }
            return positions
        }()

        @MainActor static func evaluate(_ code: String) -> String {
            var position = Util.Position(3, 2)
            var result = ""
            for c in code {
                if let newPosition = positions[c] {
                    let positionPair = PositionPair(first: position, second: newPosition)
                    let firstHorizontal = position.i != 3
                    let directions = positionPair.directions(firstHorizontal: firstHorizontal)
                    result += directions
                    result += "A" // Press the button
                    position = newPosition
                } else {
                    fatalError("Invalid character")
                }
            }
            return result
        }
    }

    class DirectionalKeyboard {
        static let grid: [[Character]] = [
            ["*", "^", "A"], // Star should never be directed at
            ["<", "v", ">"]
        ]

        @MainActor static var positions: [Character: Util.Position] = {
            var positions = [Character: Util.Position]()
            for i in 0..<grid.count {
                for j in 0..<grid[i].count {
                    positions[grid[i][j]] = Util.Position(i, j)
                }
            }
            return positions
        }()

        @MainActor static func evaluate(_ code: String) -> String {
            var position = Util.Position(0, 2)
            var result = ""
            for c in code {
                if let newPosition = positions[c] {
                    let positionPair = PositionPair(first: position, second: newPosition)
                    let dirs = positionPair.directions()
                    // Sort the directions by distance from the current position in order to minimize the number of moves
                    // Make sure that the top left corner is UNREACHABLE
                    let directions = dirs.sorted { (a, b) -> Bool in
                        let aPos = positions[a]!
                        let bPos = positions[b]!
                        
                        // Check if moving to a or b would lead to the top left corner
                        if (aPos.i == 0 && aPos.j == 0) {
                            return false
                        }
                        if (bPos.i == 0 && bPos.j == 0) {
                            return true
                        }
                        
                        let aDist = abs(aPos.i - position.i) + abs(aPos.j - position.j)
                        let bDist = abs(bPos.i - position.i) + abs(bPos.j - position.j)
                        return aDist < bDist
                    }
                    result += directions
                    result += "A" // Press the button
                    position = newPosition
                } else {
                    fatalError("Invalid character")
                }
            }
            return result
        }
    }

    // MARK: - Part One

    @MainActor func evaluateCodeComplexity(_ code: String) -> Int {
        print("")
        let codeNumericPart = Int(code.prefix(3))!
        let numericResult = NumericKeyboard.evaluate(code)
        let d1Result = DirectionalKeyboard.evaluate(numericResult)
        let d2Result = DirectionalKeyboard.evaluate(d1Result)
        print("\(d2Result)")
        print("\(d1Result)")
        print("\(numericResult)")
        print("\(code)")
        let complexity = d2Result.count * codeNumericPart
        print("Code: \(code), Complexity: \(complexity) = \(d2Result.count) * \(codeNumericPart)")
        return complexity
    }

    @MainActor func partOne(input: String) -> String {
        let lines = input.components(separatedBy: .newlines)
        var totalComplexity = 0
        for line in lines {
            totalComplexity += evaluateCodeComplexity(line)
        }

        return "Total complexity: \(totalComplexity)"
    }

    // MARK: - Part Two

    func partTwo(input: String) -> String {
        
        return ""
    }
}
