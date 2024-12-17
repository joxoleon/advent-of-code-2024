import Foundation

class DaySixteen: Day {
    let dayNumber: Int = 16
    let year = 2024

    // MARK: - Part One

    func partOne(input: String) -> String {
        var m: [[Character]] = input.split(separator: "\n").map { Array($0) }
        let rp: Util.Position = m.enumerated().compactMap { (i, row) in row.firstIndex(of: "S").map { Util.Position(i, $0) } }.first!
        let ep: Util.Position = m.enumerated().compactMap { (i, row) in row.firstIndex(of: "E").map { Util.Position(i, $0) } }.first!
        let startMs = Util.MovementState(position: rp, direction: .right)
        m[rp.i][rp.j] = "."
        m[ep.i][ep.j] = "."

        // Part One solution
        let cost = dijkstra(m: m, start: rp, end: ep)
        let directions = Util.Direction.allCases
        var minCost = Int.max
        for direction in directions {
            let ms = Util.MovementState(position: ep, direction: direction)
            if let price = cost[ms]?.first?.0 {
                minCost = min(minCost, price)
            }
        }
        print("pt1: Min cost to reach destination: \(ep) is \(minCost)")

        // Part Two solution - This is definitely the worst shit I've ever written!  
        var queue: [Util.MovementState] = []
        let endUpPrice = cost[Util.MovementState(position: ep, direction: .up)]!.first!.0
        let endRightPrice = cost[Util.MovementState(position: ep, direction: .right)]!.first!.0
        if endUpPrice < endRightPrice {
            queue = [Util.MovementState(position: ep, direction: .up)]
        } else if endRightPrice < endUpPrice {
            queue = [Util.MovementState(position: ep, direction: .right)]
        } else {
            queue = [Util.MovementState(position: ep, direction: .right), Util.MovementState(position: ep, direction: .up)]
        }

        var visited: [Util.MovementState] = []
        
        while !queue.isEmpty {
            let ms = queue.removeFirst()
            visited.append(ms)

            let next = cost[ms]
            
            if next != nil {
                for (_, nextMs) in next! {
                    if !visited.contains(nextMs) {
                        queue.append(nextMs)
                    }
                }
            }
        }

        var uniqueTiles = Set(visited)
        uniqueTiles.insert(startMs) // JUST IN CASE, FUCK THIS ALREADY
        let uniqueTilePositions: [Util.Position] = Array(Set(uniqueTiles.map { $0.position })) // Yeah, I know, it's shit
        renderMatrix(m: m, uniqueTiles: uniqueTilePositions, start: rp, end: ep)

        print("pt2: Unique tiles: \(uniqueTilePositions.count)")

        return "Min cost to reach destination: \(ep) is \(minCost)"
    }

    func adj(m: [[Character]], ms: Util.MovementState, prices: inout [Util.MovementState: [(Int, Util.MovementState)]]) -> [Util.MovementState] {
        let currentDirection = ms.direction
        let currentCost = prices[ms]!.first!.0
        var result = [Util.MovementState]()
        let directions: [(Util.Direction, Int)] = [
            (currentDirection, currentCost + 1),
            (currentDirection.turnRight(), currentCost + 1001),
            (currentDirection.turnLeft(), currentCost + 1001),
            (currentDirection.turnRight().turnRight(), currentCost + 2001)
        ]

        for (dir, cost) in directions {
            let newPos = ms.position + dir.dPos()
            let newMs = Util.MovementState(position: newPos, direction: dir)
            if newPos.isEmpty(m) {
                if prices[newMs] == nil {
                    prices[newMs] = [(cost, ms)]
                    result.append(newMs)
                } 
                else if prices[newMs]!.first!.0 > cost {
                    // print("There is a cheaper path to reach \(newPos) with cost \(cost)")
                    prices[newMs] = [(cost, ms)]
                    result.append(newMs)
                } 
                else if prices[newMs]!.first!.0 == cost {
                    if !prices[newMs]!.contains(where: { $0.1 == ms }) {
                        prices[newMs]!.append((cost, ms))
                        // print("There are multiple paths to reach \(newPos) with cost \(cost)")
                        // print("All paths to newPos: \(prices[newMs]!)")
                        result.append(newMs)
                    }
                }
            }
        }

        return result
    }

    func dijkstra(m: [[Character]], start: Util.Position, end: Util.Position) -> [Util.MovementState: [(Int, Util.MovementState)]] {
        let startMovementState = Util.MovementState(position: start, direction: .right)
        var prices = [startMovementState: [(0, startMovementState)]]
        var queue = [(0, startMovementState)] // Price, Movement State
    
        while !queue.isEmpty {
            queue.sort { $0.0 < $1.0 }
            let (_, ms) = queue.removeFirst()
            // if ms.position.i == 1 && ms.position.j == 2 {
                // print("Problematic position: \(ms.position)")
            // }
            let adjacents = adj(m: m, ms: ms, prices: &prices)
            queue.append(contentsOf: adjacents.map { (prices[$0]!.first!.0, $0) })
        }
    
        return prices
    }

    func renderMatrix(m: [[Character]], uniqueTiles: [Util.Position], start: Util.Position, end: Util.Position) {
        let greenColor = "\u{001B}[0;32m"
        let resetColor = "\u{001B}[0m"
        
        for i in 0..<m.count {
            for j in 0..<m[0].count {
                let pos = Util.Position(i, j)
                if pos == start {
                    print("\(greenColor)S\(resetColor)", terminator: "")
                } else if pos == end {
                    print("\(greenColor)E\(resetColor)", terminator: "")
                } else if uniqueTiles.contains(pos) {
                    print("\(greenColor)O\(resetColor)", terminator: "")
                } else {
                    print(m[i][j], terminator: "")
                }
            }
            print()
        }
    }

    // MARK: - Part Two

    // I already implemented part two, as an extension of part ONE, however, I really hate the code above, so I'm going to implement it using brutefoce backtracking just to compare the code and see how slow it is
    func partTwo(input: String) -> String {
        // let m: [[Character]] = input.split(separator: "\n").map { Array($0) }
        // let startPos: Util.Position = m.enumerated().compactMap { (i, row) in row.firstIndex(of: "S").map { Util.Position(i, $0) } }.first!
        // let endPos: Util.Position = m.enumerated().compactMap { (i, row) in row.firstIndex(of: "E").map { Util.Position(i, $0) } }.first!

        // Yeah, I just don't give a fuck at this point

        return ""
    }

}

fileprivate extension Util.Position {
    func isEmpty(_ m: [[Character]]) -> Bool {
        return m[i][j] == "."
    }
} 
