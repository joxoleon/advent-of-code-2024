// https://adventofcode.com/2024/day/9
import Foundation

class DayTen: Day {
    let dayNumber = 10
    let year = 2024

    // MARK: - Part One

    func partOne(input: String) -> String {
        let map = processInput(input: input)

        var trailheadSum = 0
        for i in 0..<map.count {
            for j in 0..<map[i].count {
                if map[i][j] == 0 {
                    var visited: Set<Node>? = Set<Node>()
                    let numberOfTrailheads = reachableTrailheads(map: map, i: i, j: j, visited: &visited)
//                    print("For \(i), \(j) there are \(numberOfTrailheads) trailheads")
                    trailheadSum += numberOfTrailheads
                }
            }
        }
        
        return "Trailhead Sum: \(trailheadSum)"
    }

    // MARK: - Utility Functions
    
    struct Node: Hashable {
        let i: Int
        let j: Int
    }

    func processInput(input: String) -> [[Int]] {
        return input.components(separatedBy: .newlines).map { $0.compactMap { Int(String($0)) } }
    }

    static let directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]

    func reachableTrailheads(map: [[Int]], i: Int, j: Int, visited: inout Set<Node>?) -> Int {
        // Track Visited if it exists
        if var visited = visited {
            guard !visited.contains(Node(i: i, j: j)) else {
                return 0
            }
            visited.insert(Node(i: i, j: j))
        }
        
        // Make sure we're in bounds
        guard i >= 0 && i < map.count && j >= 0 && j < map[i].count else {
            return 0
        }

        // Found trailhead exit
        if map[i][j] == 9 {
            return 1
        }
        
        // Count the number of reachable trailheads
        var numberOfReachableTrailHeads = 0
        for direction in DayTen.directions {
            let newI = i + direction.0
            let newJ = j + direction.1
            if newI < 0 || newI >= map.count || newJ < 0 || newJ >= map[newI].count {
                continue
            }
            if map[newI][newJ] - map[i][j] == 1 {
                numberOfReachableTrailHeads += reachableTrailheads(map: map, i: newI, j: newJ, visited: &visited)
            }
        }

        return numberOfReachableTrailHeads
    }


    // MARK: - Part Two
    func partTwo(input: String) -> String {
        let map = processInput(input: input)

        var trailheadSum = 0
        for i in 0..<map.count {
            for j in 0..<map[i].count {
                if map[i][j] == 0 {
                    var visited: Set<Node>? = Set<Node>()
                    let numberOfTrailheads = reachableTrailheads(map: map, i: i, j: j, visited: &visited)
//                    print("For \(i), \(j) there are \(numberOfTrailheads) trailheads")
                    trailheadSum += numberOfTrailheads
                }
            }
        }
        
        return "Trailhead Ranking sum: \(trailheadSum)"
    }

    // MARK: - Utility Functions


    // MARK: - Testing

    func test() {
    }
}
