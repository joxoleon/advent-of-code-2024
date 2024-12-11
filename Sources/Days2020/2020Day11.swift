// https:/adventofcode.com/2020/day/11
import Foundation

class DayEleven2020: Day {
    let dayNumber = 11
    let year = 2020

    // MARK: - Types

    // MARK: - Part One

    func partOne(input: String) -> String {
        var seats: [[Character]] = input.components(separatedBy: .newlines).map { Array($0) }
        var newMatrix = seats

        while true {
            var changes = 0
            for i in 0..<seats.count {
                for j in 0..<seats[i].count {
                    if seats[i][j] == "." { continue }
                    let adjacentOccupancy = checkAdjacentOccupancy(seatMatrix: seats, i: i, j: j)
                    if seats[i][j] == "#" && adjacentOccupancy >= 4 {
                        changes += 1
                        newMatrix[i][j] = "L"
                    } else if seats[i][j] == "L" && adjacentOccupancy == 0 {
                        changes += 1
                        newMatrix[i][j] = "#"
                    }
                }
            }

            seats = newMatrix
            if changes == 0 { break }
        }

        let occupiedCount = seats.flatMap { $0 }.filter { $0 == "#" }.count

        return "Occupied Count: \(occupiedCount)"
    }

    func checkAdjacentOccupancy(seatMatrix: [[Character]], i: Int, j: Int) -> Int {
        var occupiedCount = 0
        let directions = [(-1, -1), (-1, 0), (-1, 1), 
                        ( 0, -1),          ( 0, 1), 
                        ( 1, -1), ( 1, 0), ( 1, 1)]

        for (dx, dy) in directions {
            let ni = i + dx
            let nj = j + dy
            if ni >= 0 && ni < seatMatrix.count && nj >= 0 && nj < seatMatrix[0].count {
                if seatMatrix[ni][nj] == "#" {
                    occupiedCount += 1
                    if occupiedCount >= 4 { // Early exit
                        return occupiedCount
                    }
                }
            }
        }

        return occupiedCount
    }
    
    func printMatrix(_ matrix: [[Character]]) {
        for row in matrix {
            let rowString = row.map { String($0) }.joined()
            print(rowString)
        }
    }

    // MARK: - Part Two

    func partTwo(input: String) -> String {
        return ""
    }

    // MARK: - Testing

    func test() {

    }

}
