// https://adventofcode.com/2024/day/14
import Foundation

class DayFourteen: Day {
    let dayNumber: Int = 14
    let year: Int = 2024

    static let width = 101
    static let height = 103
    static let seconds = 100

    struct Position: Hashable {
        let x: Int
        let y: Int

        var quadrant: Int? {
            // Ignore positions in the middle
            if x == width / 2 || y == height / 2 { return nil }

            // Assign quadrants
            if x < width / 2 && y < height / 2 {
                return 1
            } else if x > width / 2 && y < height / 2 {
                return 2
            } else if x < width / 2 && y > height / 2 {
                return 3
            } else if x > width / 2 && y > height / 2 {
                return 4
            }

            fatalError()
        }

        static func + (lhs: Position, rhs: Position) -> Position {
            let newX = (lhs.x + rhs.x) % DayFourteen.width
            let newY = (lhs.y + rhs.y) % DayFourteen.height
            return Position(x: newX < 0 ? newX + DayFourteen.width : newX, y: newY < 0 ? newY + DayFourteen.height : newY)
        }

        static func * (lhs: Position, rhs: Int) -> Position {
            return Position(x: (lhs.x * rhs) % DayFourteen.width, y: (lhs.y * rhs) % DayFourteen.height)
        }

        static func manhattanDistance(lhs: Position, rhs: Position) -> Int {
            return abs(lhs.x - rhs.x) + abs(lhs.y - rhs.y)
        }
    }

    class Robot {
        var p: Position
        var v: Position

        init(p: Position, v: Position) {
            self.p = p
            self.v = v
        }

        func move() {
            p = p + v
        }

        func move(for seconds: Int) {
            let totalMovement = v * seconds
            p = p + totalMovement
        }
    }

    // MARK: - Part One

    func partOne(input: String) -> String {
        let lines = input.components(separatedBy: .newlines)
        let robots = lines.map { parseLine(line: $0) }

        // Move for seconds
        for robot in robots {
            robot.move(for: DayFourteen.seconds)
        }

        let quadrantCountMap = robots.reduce(into: [Int: Int]()) { result, robot in
            if let quadrant = robot.p.quadrant {
                result[quadrant, default: 0] += 1
            }
        }

        print(quadrantCountMap)

        let quadrantCountValuesMultiplied = quadrantCountMap.values.reduce(1, *)
        return "Safety factor: \(quadrantCountValuesMultiplied)"
    }

    // p=0,4 v=3,-3, where p is the position and v is the velocity
    func parseLine(line: String) -> Robot {
        let parts = line.components(separatedBy: " ")
        let p = parts[0].components(separatedBy: "=")[1].components(separatedBy: ",")
        let v = parts[1].components(separatedBy: "=")[1].components(separatedBy: ",")
        return Robot(p: Position(x: Int(p[0])!, y: Int(p[1])!), v: Position(x: Int(v[0])!, y: Int(v[1])!))
    }

    // Utility fuction to render matrix with robots on it:
    func render(robots: [Robot]) {

        var matrix = Array(repeating: Array(repeating: 0, count: DayFourteen.width), count: DayFourteen.height)
        for robot in robots {
            matrix[robot.p.y][robot.p.x] += 1
        }

        let stringMatrix = matrix.map { row in
            row.map { cell in
                cell == 0 ? "." : "\(cell)"
            }.joined(separator: "")
        }.joined(separator: "\n")

        print("***** Robot positions *****\n")
        print(stringMatrix)
        print("\n")
    }


    // MARK: - Part Two
    func partTwo(input: String) -> String {
        let lines = input.components(separatedBy: .newlines)
        let robots = lines.map { parseLine(line: $0) }

        for secoundCounter in 0...10000 {
            if secoundCounter % 100 == 0 {
                print("Second: \(secoundCounter)")
            }
            let uniqueRobotPositions = Set(robots.map { $0.p })

            if uniqueRobotPositions.count == robots.count {
                print("Second: \(secoundCounter)")
                render(robots: robots)
            }

            for robot in robots {
                robot.move()
            }
        }

        return "DONE"
    }

    func totalManhattanDistance(robots: [Robot]) -> Int {
        var totalDistance = 0
        for i in 0..<robots.count {
            for j in i+1..<robots.count {
                let distance = Position.manhattanDistance(lhs: robots[i].p, rhs: robots[j].p)
                totalDistance += distance
            }
        }
        return totalDistance
    }

}
