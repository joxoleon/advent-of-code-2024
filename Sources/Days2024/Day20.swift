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
                    grid[i][j] = "#"

                    // let directions = [Util.Direction.down, .right, .up, .left]
                    // for direction in directions {
                    //     let np = Util.Position(i, j) + direction.dPos()
                    //     if np.isInBounds(gc) && newGrid[np.i][np.j] == "#" {
                    //         newGrid[np.i][np.j] = "."
                    //         let newSteps = dijkstra(m: newGrid, sp: sp, ep: ep)
                    //         if newSteps < minSteps {
                    //             let stepsSaved = minSteps - newSteps
                    //             print("Steps saved: \(stepsSaved) for removing walls at \(i), \(j) and at \(np.i), \(np.j)")
                    //         }
                    //     }
                    // }
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
        let (grid, start, end) = parseInput(input.components(separatedBy: .newlines))
        let totalCheats = findCheats(grid, start: start, end: end)
        return "Total cheats: \(totalCheats)"
    }
}

extension DayTwenty {
    struct Position: Hashable {
        let x: Int
        let y: Int

        func neighbors() -> [Position] {
            return [
                Position(x: x + 1, y: y),  // right
                Position(x: x - 1, y: y),  // left
                Position(x: x, y: y + 1),  // down
                Position(x: x, y: y - 1),  // up
            ]
        }
    }

    struct State: Hashable {
        let position: Position
        let distance: Int
        let cheatTimeLeft: Int
        let hasCheated: Bool
    }

    struct PrioritizedItem: Comparable {
        let priority: Int
        let state: State

        static func < (lhs: PrioritizedItem, rhs: PrioritizedItem) -> Bool {
            return lhs.priority < rhs.priority
        }
    }

    struct PriorityQueue<T> where T: Comparable {
        private var elements: [T] = []

        mutating func push(_ value: T) {
            elements.append(value)
            elements.sort(by: >)
        }

        mutating func pop() -> T? {
            return elements.popLast()
        }

        var isEmpty: Bool {
            return elements.isEmpty
        }
    }

    func parseInput(_ input: [String]) -> (grid: [[Character]], start: Position, end: Position) {
        var grid: [[Character]] = []
        var start: Position? = nil
        var end: Position? = nil

        for (y, line) in input.enumerated() {
            let row = Array(line)
            for (x, char) in row.enumerated() {
                if char == "S" { start = Position(x: x, y: y) }
                if char == "E" { end = Position(x: x, y: y) }
            }
            grid.append(row)
        }

        return (grid, start!, end!)
    }

    func isValid(_ position: Position, in grid: [[Character]]) -> Bool {
        return position.y >= 0 && position.y < grid.count && position.x >= 0
            && position.x < grid[0].count
    }

    func isWall(_ position: Position, in grid: [[Character]]) -> Bool {
        return grid[position.y][position.x] == "#"
    }

    func manhattanDistance(from: Position, to: Position) -> Int {
        return abs(from.x - to.x) + abs(from.y - to.y)
    }

    func findCheats(_ grid: [[Character]], start: Position, end: Position) -> Int {
        var queue = PriorityQueue<PrioritizedItem>()
        queue.push(
            PrioritizedItem(
                priority: 0,
                state: State(position: start, distance: 0, cheatTimeLeft: 20, hasCheated: false)))
        var memo: [State: Int] = [:]  // Track best known distance to each state
        var stateVisits: [State: Int] = [:]  // Track how many times we've visited each state
        var cheatSavings: [Int: Int] = [:]  // Track savings from cheats

        while !queue.isEmpty {
            let currentItem = queue.pop()!
            let current = currentItem.state

            if current.position == end {
                let timeSaved = max(0, memo[current]! - current.distance)
                if timeSaved >= 100 {
                    cheatSavings[timeSaved, default: 0] += 1
                }
                continue
            }

            for neighbor in current.position.neighbors() {
                guard isValid(neighbor, in: grid) else { continue }
                let isWallTile = isWall(neighbor, in: grid)
                let nextDistance = current.distance + 1
                let nextCheatTime = isWallTile ? current.cheatTimeLeft - 1 : current.cheatTimeLeft
                let nextHasCheated = current.hasCheated || isWallTile

                guard nextCheatTime >= 0 else { continue }

                let nextState = State(
                    position: neighbor, distance: nextDistance, cheatTimeLeft: nextCheatTime,
                    hasCheated: nextHasCheated)

                if let existingDistance = memo[nextState], existingDistance <= nextDistance {
                    continue  // Skip this state since we've seen a better path
                }

                memo[nextState] = nextDistance
                stateVisits[nextState, default: 0] += 1
                if stateVisits[nextState]! > 50 {
                    print("Potential cycle detected at state: \(nextState)")
                    continue
                }

                let priority = nextDistance + manhattanDistance(from: neighbor, to: end)
                queue.push(PrioritizedItem(priority: priority, state: nextState))
            }
        }

        if queue.isEmpty {
            print("No path to end was found.")
        }

        return cheatSavings.filter { $0.key >= 100 }.values.reduce(0, +)
    }
}
