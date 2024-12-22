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
        for i in 0..<grid.rows {
            for j in 0..<grid.cols {
                let firstTile = grid[Util.Position(i, j)]
                if firstTile == "#" { continue }
                let firstDistance = distances[Util.Position(i, j)]!

                if i == 7 && j == 8 {
                    print("End")
                }

                for k in i..<min(grid.rows, i + maxCheatDistance + 1) {
                    for l in j..<min(grid.cols, j + maxCheatDistance + 1) {
                        let secondTile = grid[Util.Position(k, l)]
                        if secondTile == "#" { continue }
                        let manhattan = abs(i - k) + abs(j - l)
                        if manhattan > maxCheatDistance { continue }
                        
                        let secondDistance = distances[Util.Position(k, l)]!
                        let d1 = max(firstDistance, secondDistance)
                        let d2 = min(firstDistance, secondDistance)
                        let savedTime = d1 - d2 - manhattan
                        debugMap[savedTime, default: 0] += 1
                        if savedTime >= minSavedTime {
                            cheatCount += 1
                        }
                    }
                }
            }
        }

        for (k, v) in debugMap.sorted(by: { $0.key < $1.key }) {
            if k >= 50 {
                print("There are \(v) pairs with saved time \(k)")
            }
        }

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
        let minSavedTime = 50
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
