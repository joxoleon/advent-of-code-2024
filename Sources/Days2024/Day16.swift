// https://adventofcode.com/2024/day/16
import Foundation

class DaySixteen: Day {
    let dayNumber: Int = 16
    let year = 2024

    // MARK: - Part One

    func partOne(input: String) -> String {
        var m: [[Character]] = input.split(separator: "\n").map { Array($0) }
        let rp: Util.Position = m.enumerated().compactMap { (i, row) in row.firstIndex(of: "S").map { Util.Position(i, $0) } }.first!
        let ep: Util.Position = m.enumerated().compactMap { (i, row) in row.firstIndex(of: "E").map { Util.Position(i, $0) } }.first!
        // Cleanup Matrix
        m[rp.i][rp.j] = "."
        m[ep.i][ep.j] = "."

        let minCost = dijkstra(m: m, start: rp, end: ep)[ep]!.0        

        return "Min cost to reach destination: \(ep) is \(minCost)"
    }

    func adj(m: [[Character]], pos: Util.Position, direction: Util.Direction, prices: inout [Util.Position: (Int, Util.Position)]) -> [(Util.Position, Util.Direction)] {
        var result = [(Util.Position, Util.Direction)]()
        let currentCost = prices[pos]!.0
        let directions = [
            (direction, currentCost + 1), 
            (direction.turnRight(), currentCost + 1001),
            (direction.turnLeft(), currentCost + 1001),
            (direction.turnRight().turnRight(), currentCost + 2001)]
    
        for (dir, cost) in directions {
            let newPos = pos + dir.dPos()
            if newPos.isEmpty(m) && (prices[newPos] == nil || prices[newPos]!.0 > cost) {
                result.append((newPos, dir))
                prices[newPos] = (cost, pos)
            }
        }
    
        return result
    }

    func dijkstra(m: [[Character]], start: Util.Position, end: Util.Position) -> [Util.Position: (Int, Util.Position)] {
        var cost = [start: (0, start)]
        var queue = [(start, Util.Direction.right)]
    
        while !queue.isEmpty {
            let (pos, dir) = queue.removeFirst()
            let adjacents = adj(m: m, pos: pos, direction: dir, prices: &cost)
            queue.append(contentsOf: adjacents)
            // queue.sort { cost[$0.0]!.0 < cost[$1.0]!.0 }
        }
    
        return cost
    }

    // MARK: - Part Two

    func partTwo(input: String) -> String {
    
        return ""
    }
}

fileprivate extension Util.Position {
    func isEmpty(_ m: [[Character]]) -> Bool {
        return m[i][j] == "."
    }
}