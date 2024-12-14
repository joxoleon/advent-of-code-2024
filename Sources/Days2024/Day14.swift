// https://adventofcode.com/2024/day/14
import Foundation

class DayFourteen: Day {
    let dayNumber: Int = 14
    let year: Int = 2024

    static let width = 11
    static let height = 7
    static let seconds = 100

    struct Position {
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
            return Position(x: (lhs.x + rhs.x) % DayFourteen.width, y: (lhs.y + rhs.y) % DayFourteen.height)
        }

        static func * (lhs: Position, rhs: Int) -> Position {
            return Position(x: (lhs.x * rhs) % DayFourteen.width, y: (lhs.y * rhs) % DayFourteen.height)
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

    // MARK: - Part Two
    func partTwo(input: String) -> String {
        return ""
    }

    // Utility fuction to render matrix with robots on it:
    func render(robots: [Robot]) {
        var matrix = Array(repeating: Array(repeating: 0, count: DayFourteen.width), count: DayFourteen.height)
        for robot in robots {
            matrix[robot.p.y][robot.p.x] += 1
        }

        // Print in a way tha 0 are replaced with "."
        for row in matrix {
            print(row.map { $0 == 0 ? "." : String($0) })
        }
    }

}
