// https://adventofcode.com/2024/day/21
import Foundation

class DayTwentyOne: @preconcurrency Day {
    let dayNumber: Int = 21
    let year: Int = 2024

    // MARK: - Types

    struct PositionPair: Hashable {
        let first: Util.Position
        let second: Util.Position

        func hash(into hasher: inout Hasher) {
            hasher.combine(first)
            hasher.combine(second)
        }

        static func == (lhs: PositionPair, rhs: PositionPair) -> Bool {
            return lhs.first == rhs.first && lhs.second == rhs.second
        }

        func directions() -> String {
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

            return horizontalString + verticalString
        }
    }

    class NumericKeyboard {
        static let grid: [[Character]] = [
            ["7", "8", "9"],
            ["4", "5", "6"],
            ["1", "2", "3"],
            ["*", "0", "A"] // Star should never be directed at
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

        @MainActor static var directions: [PositionPair: String] = {
            var directions = [PositionPair: String]()
            for i in 0..<grid.count {
                for j in 0..<grid[i].count {
                    let first = Util.Position(i, j)
                    for k in 0..<grid.count {
                        for l in 0..<grid[k].count {
                            let second = Util.Position(k, l)
                            let positionPair = PositionPair(first: first, second: second)
                            directions[positionPair] = positionPair.directions()
                        }
                    }
                }
            }
            
            return directions
        }()

        @MainActor static func evaluate(_ code: String) -> String {
            print("*** Evaluate code: \(code)")
            var position = Util.Position(3, 2)
            var result = ""
            for c in code {
                if let newPosition = positions[c] {
                    let positionPair = PositionPair(first: position, second: newPosition)
                    if let direction = directions[positionPair] {
                        result += direction
                        result += "A" // Press the button
                        // print("key[\(grid[position.i][position.j])] -> key[\(grid[newPosition.i][newPosition.j])]: \(direction + "A")")

                        position = newPosition
                    } else {
                        fatalError("Invalid position pair")
                    }
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

        @MainActor static var directions: [PositionPair: String] = {
            var directions = [PositionPair: String]()
            for i in 0..<grid.count {
                for j in 0..<grid[i].count {
                    let first = Util.Position(i, j)
                    for k in 0..<grid.count {
                        for l in 0..<grid[k].count {
                            let second = Util.Position(k, l)
                            let positionPair = PositionPair(first: first, second: second)
                            directions[positionPair] = positionPair.directions()
                        }
                    }
                }
            }
            
            return directions
        }()

        @MainActor static func evaluate(_ code: String) -> String {
            print("*** Evaluate code: \(code)")
            var position = Util.Position(0, 2)
            var result = ""
            for c in code {
                if let newPosition = positions[c] {
                    let positionPair = PositionPair(first: position, second: newPosition)
                    if let direction = directions[positionPair] {
                        result += direction
                        result += "A" // Press the button
                        // print("key[\(grid[position.i][position.j])] -> key[\(grid[newPosition.i][newPosition.j])]: \(direction + "A")")

                        position = newPosition
                    } else {
                        fatalError("Invalid position pair")
                    }
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
        print("*** Evaluated code: \(d2Result)")
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
