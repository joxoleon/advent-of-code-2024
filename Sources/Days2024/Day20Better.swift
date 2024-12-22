// https://advetofcode.com/2024/day/20
import Foundation

class DayTwentyBetter: Day {
    let dayNumber: Int = 20
    let year: Int = 2024

    // Types

    // Parse the input file into a grid and find the starting position
    func parseGrid(from input: String) -> (grid: Util.Grid, start: Util.Position) {
        let g = input.components(separatedBy: .newlines).map { line in
            return Array(line)
        }
        let grid = Util.Grid(grid: g)
        for i in 0..<grid.rows {
            for j in 0..<grid.cols {
                if grid[Util.Position(i, j)] == "S" {
                    return (grid, Util.Position(i, j))
                }
            }
        }
        fatalError("No start position found")
    }

    func bfsDistances(from start: Util.Position, in grid: Util.Grid) -> [Util.Position: Int] {
        var distances = [start: 0]
        var queue = [start]
        
        while !queue.isEmpty {
            let current = queue.removeFirst()
            let currentDistance = distances[current]!

            for direction in Util.Direction.allCases {
                let np = current + direction.dPos()
                if np.isInBounds(grid.constraints) && distances[np] == nil && grid[np] != "#" {
                    distances[np] = currentDistance + 1
                    queue.append(np)
                }
            }
        }
        
        return distances
    }

    // MARK: - Main logic for finding cheats

    func countCheats(grid: Util.Grid, distances: [Util.Position: Int], minSavedTime: Int, maxCheatDistance: Int) -> Int {
        var cheatCount = 0
        var debugMap = [Int: Int]()
        
        // For each possible start position of the cheat
        for i in 0..<grid.rows {
            for j in 0..<grid.cols {
                let startPos = Util.Position(i, j)
                let startTile = grid[startPos]
                if startTile == "#" { continue }
                let startDistance = distances[startPos]!
                
                // For each possible end position of the cheat
                // Only check "forward" positions to avoid counting each pair twice
                for di in 0...maxCheatDistance {
                    for dj in -maxCheatDistance...maxCheatDistance {
                        // Skip positions we've already counted (preventing doubles)
                        if di == 0 && dj <= 0 { continue }
                        
                        let endI = i + di
                        let endJ = j + dj
                        
                        // Check bounds
                        if !Util.Position(endI, endJ).isInBounds(grid.constraints) { continue }
                        
                        let endPos = Util.Position(endI, endJ)
                        let endTile = grid[endPos]
                        if endTile == "#" { continue }
                        
                        // Check if the manhattan distance is within cheat range
                        let manhattan = abs(di) + abs(dj)
                        if manhattan > maxCheatDistance { continue }
                        
                        let endDistance = distances[endPos]!
                        
                        // Calculate time saved
                        let originalPath = max(startDistance, endDistance)
                        let newPath = min(startDistance, endDistance) + manhattan
                        let savedTime = originalPath - newPath
                        
                        if savedTime > 0 {
                            debugMap[savedTime, default: 0] += 1
                            if savedTime >= minSavedTime {
                                cheatCount += 1
                            }
                        }
                    }
                }
            }
        }

        // Debug output
        // for (k, v) in debugMap.sorted(by: { $0.key < $1.key }) {
        //     if k >= 50 {
        //         print("There are \(v) cheats that save \(k) picoseconds")
        //     }
        // }

        return cheatCount
    }



    func renderDistancesMatrix(_ distances: [Util.Position: Int], in grid: Util.Grid) {
        for i in 0..<grid.rows {
            for j in 0..<grid.cols {
                let p = Util.Position(i, j)
                if let d = distances[p] {
                    print(String(format: "%02d", d), terminator: " ")
                } else {
                    print("##", terminator: " ")
                }
            }
            print()
        }
    }


    func partOne(input: String) -> String {
        // Parse the grid and find the start position
        let (grid, start) = parseGrid(from: input)
        
        // Compute shortest distances from the start position
        let distances = bfsDistances(from: start, in: grid)
        
        // Render the distances matrix
        //  renderDistancesMatrix(distances, in: grid)

        // Count cheats under different rules
        let minSavedTime = 100
        let maxCheatDistancePt1 = 2
        let cheatsFor2Steps = countCheats(grid: grid, distances: distances, minSavedTime: minSavedTime, maxCheatDistance: maxCheatDistancePt1)
        print("CheatCount: \(cheatsFor2Steps) for minSavedTime: \(minSavedTime) and maxCheatDistance: \(maxCheatDistancePt1)")
        let maxCheatDistancePt2 = 20
        let cheatsFor20Steps = countCheats(grid: grid, distances: distances, minSavedTime: minSavedTime, maxCheatDistance: maxCheatDistancePt2)
        print("CheatCount: \(cheatsFor20Steps) for minSavedTime: \(minSavedTime) and maxCheatDistance: \(maxCheatDistancePt2)")
        
        return ""
    }

    // MARK: - Part Two
    func partTwo(input: String) -> String {
        // Implemented in part one
        return ""
    }
}
