// https://adventofcode.com/2024/day/18
import Foundation

class DayEighteen: Day {
    let dayNumber: Int = 18
    let year = 2024

    let n = 71
    let firsK = 1024 // This is so stupid
    lazy var gc: Util.GridConstraints = Util.GridConstraints(rows: n, cols: n)
    
    // MARK: - Part one

    func partOne(input: String) -> String {
        let cp = input.components(separatedBy: .newlines).map { line in // CP as in corrupted positions, not the CP that you meant
            let c = line.components(separatedBy: ",").map{ Int($0)! }
            return Util.Position(c[1], c[0]) // Fuck you for this constant swapping of rows and columns!
        }

        var grid: [[Character]] = Array(repeating: Array(repeating: ".", count: n), count: n)
        for p in cp[0..<firsK] {
            grid[p.i][p.j] = "#"
        }

        let minSteps = dijkstra(m: grid, sp: Util.Position(0, 0), ep: Util.Position(n - 1, n - 1))
        
        return "Minimum steps to end: \(minSteps)"
    }

    func dijkstra(m: [[Character]], sp: Util.Position, ep: Util.Position) -> Int { // Returns cost
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
                if newDistance < distances[np.i][np.j] {
                    distances[np.i][np.j] = newDistance
                    q.append(np)
                }
            }
        }

        return distances[ep.i][ep.j]
    }

    // MARK: - Part two

    func partTwo(input: String) -> String {
        let cp = input.components(separatedBy: .newlines).map { line in // CP as in corrupted positions, not the CP that you meant
            let c = line.components(separatedBy: ",").map{ Int($0)! }
            return Util.Position(c[1], c[0])
        }
        var grid: [[Character]] = Array(repeating: Array(repeating: ".", count: n), count: n)
        for p in cp[0..<firsK] {
            grid[p.i][p.j] = "#"
        }

        for p in cp[firsK...] {
            grid[p.i][p.j] = "#"
            let minSteps = dijkstra(m: grid, sp: Util.Position(0, 0), ep: Util.Position(n - 1, n - 1))
            if minSteps == Int.max {
                return "\(p.j),\(p.i)"
            }
        }

        fatalError()
    }
}
