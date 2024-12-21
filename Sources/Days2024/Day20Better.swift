// https://advetofcode.com/2024/day/20
import Foundation

class DayTwentyBetter: Day {
    let dayNumber: Int = 20
    let year: Int = 2024

    // MARK: - Part One

    func bfsDistances(from start: Util.Position, in grid: Util.Grid) -> [Util.Position: Int] {
        var distances = [start: 0]
        var queue = [start]
        
        while !queue.isEmpty {
            let current = queue.removeFirst()
            let currentDistance = distances[current]!
            
            for direction in Util.Direction.allCases {
                let newPosition = current + direction.dPos()
                if grid.isInBounds(newPosition) && distances[newPosition] == nil {
                    distances[newPosition] = currentDistance + 1
                    queue.append(newPosition)
                }
            }
        }
        
        return distances
    }
    
    func countCheats(distances: [Util.Position: Int], minSavedTime: Int, maxCheatDistance: Int) -> Int {
        let positions = Array(distances.keys)
        var cheatCount = 0

        for i in 0..<positions.count {
            for j in i+1..<positions.count {
                let p1 = positions[i]
                let p2 = positions[j]
                let d1 = distances[p1]!
                let d2 = distances[p2]!
                let manhattanDistance = abs(p1.i - p2.i) + abs(p1.j - p2.j)
                if  manhattanDistance > maxCheatDistance {
                    continue
                }

                if d2 - d1 - manhattanDistance >= minSavedTime {
                    cheatCount += 1
                }
            }
        }

        return cheatCount
    }

    func partOne(input: String) -> String {
        let grid = Util.Grid(grid: input.components(separatedBy: .newlines).map { line in return Array(line) })
        let start = grid.findPosition("S")!

        let distances = bfsDistances(from: start, in: grid)
        let cheatFor2Steps = countCheats(distances: distances, minSavedTime: 20, maxCheatDistance: 2)

        return "The number of cheats that save at least 2 steps is \(cheatFor2Steps)"
    }

    // MARK: - Part Two
    func partTwo(input: String) -> String {
        return ""
    }
}
