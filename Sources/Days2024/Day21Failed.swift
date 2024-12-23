// https://adventofcode.com/2024/day/21
import Foundation

class DayTwentyOneFailed: @preconcurrency Day {
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

    // A BFS-based approach to never aim at (i.e. move onto) the '*' gap.
struct DirectionalKeyboard {
    
    // The keypad layout for the robot's directional controls:
    // 
    //    +---+---+
    //    | ^ | A |  <-- row 0
    // +---+---+---+
    // | < | v | > |  <-- row 1
    // +---+---+---+
    //
    // ...but with '*' in the top-left (0,0) to denote the gap the robot must never aim at.
    
    static let grid: [[Character]] = [
        ["*", "^", "A"],
        ["<", "v", ">"]
    ]
    
    // Pre-calculate how many rows/cols
    static let rowCount = grid.count          // 2
    static let colCount = grid[0].count       // 3
    
    // A quick dictionary to lookup the (row, col) for each character.
    // For example: positions['A'] => Position(0, 2)
    static let positions: [Character: Util.Position] = {
        var dict = [Character: Util.Position]()
        for i in 0..<rowCount {
            for j in 0..<colCount {
                let ch = grid[i][j]
                dict[ch] = Util.Position(i, j)
            }
        }
        return dict
    }()
    
    // For BFS, we have four possible moves (up, down, left, right),
    // each associated with a character describing that move.
    static let moves: [(Int, Int, Character)] = [
        (-1, 0, "^"),  // move up
         (1, 0, "v"),  // move down
         (0, -1, "<"), // move left
         (0,  1, ">")  // move right
    ]
    
    /// Returns the shortest path (as a list of '^', 'v', '<', '>') needed
    /// to move the robotic arm from `from` to `to`, never pointing at '*'.
    /// If `from == to`, returns empty array.
    static func shortestPath(from: Util.Position, to: Util.Position) -> [Character] {
        // If the arm is already at `to`, no movement needed:
        if from == to { return [] }
        
        // Standard BFS for the shortest path in a grid.
        // We'll keep track of where we came from (and the move used).
        var queue: [Util.Position] = []
        queue.append(from)
        
        var visited: Set<Util.Position> = []
        visited.insert(from)
        
        // Store (previousPosition, moveUsed) so we can reconstruct the path.
        var cameFrom: [Util.Position: (Util.Position, Character)] = [:]
        
        while !queue.isEmpty {
            let current = queue.removeFirst()
            let (r, c) = (current.i, current.j)
            
            for (dr, dc, moveChar) in moves {
                let nr = r + dr
                let nc = c + dc
                let neighbor = Util.Position(nr, nc)
                
                // Check bounds
                if nr < 0 || nr >= rowCount || nc < 0 || nc >= colCount {
                    continue
                }
                // Check if it's a gap
                if grid[nr][nc] == "*" {
                    continue
                }
                // Already visited?
                if visited.contains(neighbor) {
                    continue
                }
                
                // Mark visited
                visited.insert(neighbor)
                
                // Record how we got here
                cameFrom[neighbor] = (current, moveChar)
                
                // If we've reached our target, reconstruct the path
                if neighbor == to {
                    // Reconstruct moves
                    var path = [Character]()
                    var cur = to
                    while cur != from {
                        guard let (prev, charUsed) = cameFrom[cur] else {
                            fatalError("No path found during BFS reconstruction? Shouldn't happen.")
                        }
                        path.append(charUsed)
                        cur = prev
                    }
                    // The path is reversed, so reverse it back
                    return path.reversed()
                }
                
                queue.append(neighbor)
            }
        }
        
        // If BFS exhausts all possibilities without finding `to`, there's no path.
        // Should not happen in a valid puzzle, but just in case:
        fatalError("No valid path found from \(from) to \(to).")
    }
    
    static func evaluateDestinations(_ destinations: String) -> String {
        // The puzzle states that the starting position is (0, 2) => 'A' (top-right corner).
        var currentPos = Util.Position(0, 2) 
        var result = ""
        
        for ch in destinations {
            // Where do we want to go?
            guard let targetPos = positions[ch] else {
                fatalError("Invalid button \(ch) not found on directional keypad!")
            }
            
            // BFS from currentPos to targetPos
            let path = shortestPath(from: currentPos, to: targetPos)
            // path is an array of moves, e.g. ["<", "v"]
            
            // Append those moves to the result
            result += path.map { String($0) }.joined()
            
            // Then press the button
            result += "A"
            
            // Update the pointer
            currentPos = targetPos
        }
        
        return result
    }
}

    // MARK: - Part One

    @MainActor func evaluateCodeComplexity(_ code: String) -> Int {
        print("")
        let codeNumericPart = Int(code.prefix(3))!
        let numericResult = NumericKeyboard.evaluate(code)
        let d1Result = DirectionalKeyboard.evaluateDestinations(numericResult)
        let d2Result = DirectionalKeyboard.evaluateDestinations(d1Result)
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
