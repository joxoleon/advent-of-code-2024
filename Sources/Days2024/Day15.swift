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
                if m[i][j] == "O" || m[i][j] == "[" {
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
        print("Current rp: \(rp) executing command: \(cmd)")
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
        var (m, commands) = parseInput(input: input)
        // Expand the matrix by double vertically, by the following rules
        // . -> ..
        // O -> []
        // # -> ##
        // @ -> @.
        m = m.map { row in
            row.flatMap { 
            $0 == "." ? [".", "."] : 
            $0 == "O" ? ["[", "]"] : 
            $0 == "#" ? ["#", "#"] : 
            ["@", "."]
            }
        }
        var rp: Util.Position = m.enumerated().compactMap { (i, row) in row.firstIndex(of: "@").map { Util.Position(i, $0) } }.first!

        // start executing commands
        for cmd in commands {
            // debugPrintMatrix(rp: rp, cmd: cmd, m: m)
            if Util.Position.canMoveInDirectionRecursive(Util.Direction(cmd), pos: rp, m: m) {
                var visited: Set<Util.Position> = []
                Util.Position.moveRecursively(Util.Direction(cmd), pos: rp, m: &m, visited: &visited)
                rp += Util.Direction(cmd).dPos()
            }

        }

        return "\(computeGpsCoordinateOfBoxes(m: m))"
    }

}

fileprivate extension Util.Position {
    func canMoveInDirection(_ dir: Util.Direction, m: [[Character]]) -> Bool {
        let newPos = Util.Position(i + dir.dPos().i, j + dir.dPos().j)
        return newPos.isInBounds(Util.GridConstraints(rows: m.count, cols: m[0].count))
    }

    static func canMoveInDirectionRecursive(_ dir: Util.Direction, pos: Util.Position, m: [[Character]]) -> Bool {
        let newPos = Util.Position(pos.i + dir.dPos().i, pos.j + dir.dPos().j)
        guard newPos.isInBounds(Util.GridConstraints(rows: m.count, cols: m[0].count)) else { return false }
        if newPos.isEmpty(m) { return true }
        if newPos.isWall(m) { return false }

        var positionsToVisit: [Util.Position] = [newPos]
        if m[newPos.i][newPos.j] == "[" && (dir == .up || dir == .down) {
            positionsToVisit.append(Util.Position(newPos.i, newPos.j + 1))
        } else if m[newPos.i][newPos.j] == "]" && (dir == .up || dir == .down) {
            positionsToVisit.append(Util.Position(newPos.i, newPos.j - 1))
        }

        let result = positionsToVisit.allSatisfy { canMoveInDirectionRecursive(dir, pos: $0, m: m) }
        return result
    }

    static func moveRecursively(_ dir: Util.Direction, pos: Util.Position, m: inout [[Character]], visited: inout Set<Util.Position>) {
        if visited.contains(pos) { return }
        visited.insert(pos)
    
        let nextPos = Util.Position(pos.i + dir.dPos().i, pos.j + dir.dPos().j)
    
        // Check if the current position is a wall - just in case so that I know I'm not doing anything wrong
        if pos.isWall(m) { 
            assertionFailure("Current position is a wall") 
            return
        }
    
        // Handle movement for both player and boxes
        if nextPos.isBox(m) {
            var toMove = [nextPos]
            if m[nextPos.i][nextPos.j] == "[" && (dir == .up || dir == .down) {
                toMove.append(Util.Position(nextPos.i, nextPos.j + 1))
            } else if m[nextPos.i][nextPos.j] == "]" && (dir == .up || dir == .down) {
                toMove.append(Util.Position(nextPos.i, nextPos.j - 1))
            }
            for b in toMove {
                moveRecursively(dir, pos: b, m: &m, visited: &visited)
            }
        } else if nextPos.isWall(m) {
            assertionFailure("Next position is a wall")
            return
        }
    
        // Move the entity (player or box) to the next position
        m[nextPos.i][nextPos.j] = m[pos.i][pos.j]
        m[pos.i][pos.j] = "."
    }

    func isEmpty(_ m: [[Character]]) -> Bool {
        return m[i][j] == "."
    }

    func isWall(_ m: [[Character]]) -> Bool {
        return m[i][j] == "#"
    }

    func isBox(_ m: [[Character]]) -> Bool {
        return m[i][j] == "O" || m[i][j] == "[" || m[i][j] == "]"
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
