// https://adventofcode.com/2024/day/15
import Foundation


class DayFifteen: Day {
    let dayNumber: Int = 15
    let year = 2024


    func parseInput(input: String) -> (matrix: [[Character]], commands: [Character]) {
        let ln = input.split(separator: "\n\n")
        let matrix: [[Character]] = ln[0].split(separator: "\n").map { Array($0) }

        let commands: String = ln[1].split(separator: "\n").joined()
        return (matrix, Array(commands))
    }

    func computeGpsCoordinateOfBoxes(m: [[Character]]) -> Int {
        var result = 0
        for i in m.indices {
            for j in m[i].indices {
                if m[i][j] == "O" {
                    result += i * 100 + j
                }
            }
        }
        return result
    }

    func renderMatrix(m: [[Character]]) {
        let str = m.map { String($0.map { String($0) }.joined()) }.joined(separator: "\n")
        print(str)
    }

    func debugPrintMatrix(rp: Util.Position, cmd: Character, m: [[Character]]) {
        print("Current rp: \(rp) executed command: \(cmd)")
        renderMatrix(m: m)
    }

    // MARK: - Part One

    func partOne(input: String) -> String {
        var (m, commands) = parseInput(input: input)

        var rp: Util.Position = m.enumerated().compactMap { (i, row) in row.firstIndex(of: "@").map { Util.Position(i, $0) } }.first!
        
        print("Initial matrix state")
        renderMatrix(m: m)
        
        // start executing commands
        for cmd in commands {
            let dPos = Util.Direction(cmd).dPos()
            var newPos = rp + Util.Direction(cmd).dPos()
            // If is empty just move there
            if newPos.isEmpty(m) {
                m[rp.i][rp.j] = "."
                rp = newPos
                m[rp.i][rp.j] = "@"
            } else if newPos.isBox(m) {
                while newPos.isBox(m) {
                    newPos += dPos
                }

                // If it is empty, move everything by one in dPos direction until we get to rp
                if newPos.isEmpty(m) {
                    var moveFromPos = newPos - dPos
                    var moveToPos = newPos
                    while moveToPos != rp {
                        m[moveToPos.i][moveToPos.j] = m[moveFromPos.i][moveFromPos.j]
                        moveToPos = moveFromPos
                        moveFromPos -= dPos
                    }
                    m[rp.i][rp.j] = "."
                    rp += dPos
                } else if newPos.isWall(m) {
                    // In case it is a wall, just ignore
                } else {
                    fatalError("This shoudln't be reachable")
                }

            } else if newPos.isWall(m) {
                // Just ignore if it is wall
            } else {
                assertionFailure("Should never happpen")
            }
        }

        return "\(computeGpsCoordinateOfBoxes(m: m))"
    }

    // MARK: - Part Two
    func partTwo(input: String) -> String {
        
        return ""
    }

}

fileprivate extension Util.Position {
    func canMoveInDirection(_ dir: Util.Direction, m: [[Character]]) -> Bool {
        let newPos = Util.Position(i + dir.dPos().i, j + dir.dPos().j)
        return newPos.isInBounds(Util.GridConstraints(rows: m.count, cols: m[0].count))
    }

    func isEmpty(_ m: [[Character]]) -> Bool {
        return m[i][j] == "."
    }

    func isWall(_ m: [[Character]]) -> Bool {
        return m[i][j] == "#"
    }

    func isBox(_ m: [[Character]]) -> Bool {
        return m[i][j] == "O"
    }
}

fileprivate extension Util.Direction {
    init(_ char: Character) {
        switch char {
            case "^":
                self = .up
            case "v":
                self = .down
            case "<":
                self = .left
            case ">":
                self = .right
            default:
                fatalError("Invalid direction")
        }
    }
}
