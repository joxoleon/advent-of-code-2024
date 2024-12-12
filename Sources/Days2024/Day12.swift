// https://adventofcode.com/2024/day/12
import Foundation

class DayTwelve: Day {
    let dayNumber: Int = 12
    let year: Int = 2024

    // MARK: - Types
    nonisolated(unsafe) static var visited: Set<Position> = []

    struct Position: Hashable {
        let i: Int
        let j: Int

    }

    static func adjacentNeighborCount(for position: Position, in map: [[Character]]) -> Int {
        let directions = [(1, 0), (-1, 0), (0, 1), (0, -1)]
        var count = 0
        for direction in directions {
            let i = position.i + direction.0
            let j = position.j + direction.1
            if i >= 0 && i < map.count && j >= 0 && j < map[i].count {
                if map[i][j] == map[position.i][position.j] {
                    count += 1
                }
            }
        }
        return count
    }

    struct GardenSegment: Hashable {

        // MARK: - Properties
        let positions: [Position]
        let map: [[Character]]

        var area: Int {
            return positions.count
        }

        var perimeter: Int {
            var result = 0
            for position in positions {
                result += 4 - DayTwelve.adjacentNeighborCount(for: position, in: map)
            }
            return result
        }

        var price: Int {
            return area * perimeter
        }

        var letter: String {
            return String(map[positions.first!.i][positions.first!.j])
        }

        var outerSideCount: Int {
            let sideWalker = SideWalker(area: self)
            return sideWalker.outerSideCount()
        }


        var ifSubmoduleRandomParentPosition: Position? {
            // It cant' be a subsegment if it's on the edge
            let minI = positions.map { $0.i }.min()!
            let maxI = positions.map { $0.i }.max()!
            guard minI >= 1 && maxI < map.count - 1 else {
                return nil
            }
            let minJ = positions.map { $0.j }.min()!
            let maxJ = positions.map { $0.j }.max()!
            guard minJ >= 1 && maxJ < map[minI].count - 1 else {
                return nil
            }
            var randomParentPosition: Position? = nil

            // Check if every surrounding tile is the same
            var allTouchedTileLetters: Set<Character> = []
            let directions = [(1, 0), (-1, 0), (0, 1), (0, -1)]
            for position in positions {
                for direction in directions {
                    let i = position.i + direction.0
                    let j = position.j + direction.1
                    if letter != String(map[i][j]) {
                        allTouchedTileLetters.insert(map[i][j])
                        if randomParentPosition == nil {
                            randomParentPosition = Position(i: i, j: j)
                        }
                    }
                }
            }

            if allTouchedTileLetters.count == 1 {
                return randomParentPosition
            }
            return nil
        }

        init(position: Position, map: [[Character]]) {
            var positions: [Position] = []
            var visited: [Position] = []
            var queue: [Position] = [position]
            while !queue.isEmpty {
                let current = queue.removeFirst()
                if visited.contains(current) {
                    continue
                }
                visited.append(current)
                positions.append(current)
                let directions = [(1, 0), (-1, 0), (0, 1), (0, -1)]
                for direction in directions {
                    let i = current.i + direction.0
                    let j = current.j + direction.1
                    if i >= 0 && i < map.count && j >= 0 && j < map[i].count {
                        if map[i][j] == map[position.i][position.j] {
                            queue.append(Position(i: i, j: j))
                        }
                    }
                }
            }
            self.positions = positions
            self.map = map
            // With this done, the main iteration is going to be a piece of cake
            populateGlobalVisited()
        }

        func populateGlobalVisited() {
            for position in positions {
                DayTwelve.visited.insert(position)
            }
        }

        func isInArea(_ position: Position) -> Bool {
            return positions.contains(position)
        }

        func partTwoPrice() -> Int {
            return area * outerSideCount 
        }

        func printSegmentDetails() {
            let letter = String(map[positions.first!.i][positions.first!.j])
            print(" Segment letter: \(letter), outer side count: \(outerSideCount), area: \(area), perimeter: \(perimeter), price: \(price), partTwoPrice: \(partTwoPrice())")
        }
    }

    enum Direction: Int {
        case right = 0
        case up
        case left
        case down

        func turnLeft() -> Direction {
            Direction(rawValue: (self.rawValue + 1) % 4)!
        }

        func turnRight() -> Direction {
            Direction(rawValue: (self.rawValue + 3) % 4)!
        }

        var dPosition: (Int, Int) {
            switch self {
            case .right:
                return (0, 1)
            case .up:
                return (-1, 0)
            case .left:
                return (0, -1)
            case .down:
                return (1, 0)
            }
        }
    }
    
    struct MovementPosition: Hashable {
        let position: Position
        let direction: Direction
    }

    class SideWalker {
        let map: [[Character]]
        let area: GardenSegment
        var position: Position
        var direction = Direction.right
        var visited: Set<MovementPosition> = []

        init(area: GardenSegment) {
            self.area = area
            self.map = area.map
            self.position = area.positions.first!
        }

        func canMoveToTile(direction: Direction) -> Bool {
            let i = position.i + direction.dPosition.0
            let j = position.j + direction.dPosition.1
            return area.isInArea(Position(i: i, j: j)) && !visited.contains(MovementPosition(position: Position(i: i, j: j), direction: direction))
        }

        func move() {
            position = Position(i: position.i + direction.dPosition.0, j: position.j + direction.dPosition.1)
        }

        func outerSideCount() -> Int {
            // Move on those edges and keep on turnin':
            // 1. If can turn left, do it
            // 2. If can go straight, do it
            // 3. Turn right by default
            // Count sides on each turn
            var count = 0
            visited.insert(MovementPosition(position: position, direction: direction)) // Initial one
            while true {
                if canMoveToTile(direction: direction.turnLeft()) { // Left
                    direction = direction.turnLeft()
                    count += 1
                    visited.insert(MovementPosition(position: position, direction: direction))
                    if canMoveToTile(direction: direction) {
                        move()
                    }
                } else if canMoveToTile(direction: direction) { // Straight
                    move()
                } else {
                    direction = direction.turnRight()
                    count += 1
                }
                
                let movementPosition = MovementPosition(position: position, direction: direction)
                if visited.contains(movementPosition) {
                    break
                }
                visited.insert(movementPosition)
            }

            return count
        }

    }

    // MARK: - Part One

    func partOne(input: String) -> String {
        let matrix: [[Character]] = input.components(separatedBy: .newlines).map {
            Array(String($0))
        }
        // Create areas
        var areas: [GardenSegment] = []
        for i in matrix.indices {
            for j in matrix.indices {
                let position = Position(i: i, j: j)
                if !DayTwelve.visited.contains(position) {
                    let area = GardenSegment(position: position, map: matrix)
                    areas.append(area)
                }
            }
        }

        var price = 0
        for area in areas {
            price += area.price
        }

        return "Total price: \(price)"
    }

    // MARK: - Part Two

    func partTwo(input: String) -> String {
        // Clear global visited
        DayTwelve.visited = []

        let matrix: [[Character]] = input.components(separatedBy: .newlines).map {
            Array(String($0))
        }

        // Create segments
        var segments: [GardenSegment] = []
        for i in matrix.indices {
            for j in matrix.indices {
                let position = Position(i: i, j: j)
                if !DayTwelve.visited.contains(position) {
                    let segment = GardenSegment(position: position, map: matrix)
                    segments.append(segment)
                }
            }
        }


        var partTwoPrice = 0
        for segment in segments {
            partTwoPrice += segment.partTwoPrice()
            // segment.printSegmentDetails()
        }

        // Handle subsegments
        for segment in segments {
            guard let parentPosition = segment.ifSubmoduleRandomParentPosition else {
                continue
            }

            let parentSegment = segments.first { $0.isInArea(parentPosition) }!
            partTwoPrice += segment.outerSideCount * parentSegment.area
        }

        return "Part Two price: \(partTwoPrice)"
    }

    // MARK: - Testing

    func test() {}
}
