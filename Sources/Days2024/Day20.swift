// https://adventofcode.com/2024/day/20
import Foundation

class DayTwenty: Day {
    let dayNumber: Int = 20
    let year: Int = 2024

    var m: Int!
    var n: Int!
    var gc: Util.GridConstraints!
    var minSteps: Int!

    // MARK: - Part One
    func partOne(input: String) -> String {
        var grid: [[Character]] = input.components(separatedBy: .newlines).map { line in
            return Array(line)
        }
        m = grid.count
        n = grid[0].count
        gc = Util.GridConstraints(rows: m, cols: n)
        // Start position is the first S in the grid
        var sp: Util.Position!
        var ep: Util.Position!
        for i in grid.indices {
            for j in grid[i].indices {
                if grid[i][j] == "S" {
                    sp = Util.Position(i, j)
                }
                if grid[i][j] == "E" {
                    ep = Util.Position(i, j)
                }
            }
        }

        var savedMoreThan100Count = 0
        minSteps = dijkstra(m: grid, sp: sp, ep: ep, maxSteps: nil)!
        for i in grid.indices {
            for j in grid[i].indices {
                if grid[i][j] == "#" {
                    grid[i][j] = "."
                    if let newSteps = dijkstra(m: grid, sp: sp, ep: ep, maxSteps: minSteps - 100) {
                        let stepsSaved = minSteps - newSteps
                        if stepsSaved >= 100 {
                            savedMoreThan100Count += 1
                        }
                        print("Steps saved: \(stepsSaved) for removing wall at \(i), \(j)")
                    }
                    grid[i][j] = "#" // Reset
                }
            }
        }

        return "Steps saved more than 100: \(savedMoreThan100Count)"
    }

    func dijkstra(m: [[Character]], sp: Util.Position, ep: Util.Position, maxSteps: Int?) -> Int?
    {  // Returns cost
        var distances = Array(repeating: Array(repeating: Int.max, count: n), count: n)
        let directions: [Util.Direction] = [.down, .right, .up, .left]
        distances[sp.i][sp.j] = 0
        var q: [Util.Position] = [sp]

        while !q.isEmpty {
            let p = q.removeFirst()

            for direction in directions {
                let np = p + direction.dPos()
                guard np.isInBounds(gc) else { continue }
                guard m[np.i][np.j] != "#" else { continue }
                let newDistance = distances[p.i][p.j] + 1
                if let maxSteps = maxSteps, newDistance > maxSteps {
                    continue
                }
                if newDistance < distances[np.i][np.j] {
                    distances[np.i][np.j] = newDistance
                    q.append(np)
                }
            }
        }

        return distances[ep.i][ep.j] == Int.max ? nil : distances[ep.i][ep.j]
    }

    func partTwo(input: String) -> String {
        // var grid = input.components(separatedBy: .newlines).map { line in
        //     return Array(line)
        // }
        // m = grid.count
        // n = grid[0].count
        // gc = Util.GridConstraints(rows: m, cols: n)
        // minSteps = dijkstra(m: grid, sp: Util.Position(0, 0), ep: Util.Position(m - 1, n - 1), maxSteps: nil)!
        // // Start position is the first S in the grid
        // var sp: Util.Position!
        // var ep: Util.Position!
        // for i in grid.indices {
        //     for j in grid[i].indices {
        //         if grid[i][j] == "S" {
        //             sp = Util.Position(i, j)
        //         }
        //         if grid[i][j] == "E" {
        //             ep = Util.Position(i, j)
        //         }
        //     }
        // }
        // let targetStepsMax = minSteps - 100
        // var targetPathCount = 0
        



        return ""
    }

    func allPossiblePathsFrom(sp: Util.Position, ep: Util.Position, m: [[Character]], maxSteps: Int) -> Int {
        var count = 0
        let directions: [Util.Direction] = [.down, .right, .up, .left]
        var q: [(Util.Position, Int)] = [(sp, 0)]
        while !q.isEmpty {
            let (p, steps) = q.removeFirst()
            if steps > maxSteps {
                continue
            }
            if p == ep {
                count += 1
                continue
            }
            for direction in directions {
                let np = p + direction.dPos()
                guard np.isInBounds(gc) else { continue }
                guard m[np.i][np.j] != "#" else { continue }
                q.append((np, steps + 1))
            }
        }
        return count
    }
}

