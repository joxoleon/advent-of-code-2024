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
                        newMatrix[i][j] = "L"
                        changes += 1
                    } else if seats[i][j] == "L" && adjacentOccupancy == 0 {
                        newMatrix[i][j] = "#"
                        changes += 1
                    } else {
                        newMatrix[i][j] = seats[i][j]
                    }
                }
            }

            if changes == 0 { break }
            swap(&seats, &newMatrix)
        }

        let occupiedCount = seats.flatMap { $0 }.filter { $0 == "#" }.count
        return "Occupied Count: \(occupiedCount)"
    }

    func checkAdjacentOccupancy(seatMatrix: [[Character]], i: Int, j: Int) -> Int {
        var occupiedCount = 0
        let rows = seatMatrix.count
        let cols = seatMatrix[0].count

        let directions = [
            (-1, -1), (-1, 0), (-1, 1),
            (0, -1), (0, 1),
            (1, -1), (1, 0), (1, 1),
        ]

        for (dx, dy) in directions {
            let ni = i + dx
            let nj = j + dy
            if ni >= 0 && ni < rows && nj >= 0 && nj < cols && seatMatrix[ni][nj] == "#" {
                occupiedCount += 1
                if occupiedCount >= 4 {
                    return occupiedCount
                }
            }
        }
        return occupiedCount
    }

    // MARK: - Part Two

func partTwo(input: String) -> String {
        var seats: [[Character]] = input.components(separatedBy: .newlines).map { Array($0) }
        var newMatrix = seats

        while true {
            var changes = 0
            for i in 0..<seats.count {
                for j in 0..<seats[i].count {
                    if seats[i][j] == "." { continue }
                    let visibleOccupancy = checkVisibleOccupancyPt2(seatMatrix: seats, i: i, j: j)
                    if seats[i][j] == "#" && visibleOccupancy >= 5 {
                        newMatrix[i][j] = "L"
                        changes += 1
                    } else if seats[i][j] == "L" && visibleOccupancy == 0 {
                        newMatrix[i][j] = "#"
                        changes += 1
                    } else {
                        newMatrix[i][j] = seats[i][j]
                    }
                }
            }

            if changes == 0 { break }
            swap(&seats, &newMatrix) // Swap pointers instead of copying
        }

        let occupiedCount = seats.flatMap { $0 }.filter { $0 == "#" }.count
        return "Occupied Count: \(occupiedCount)"
    }

    func checkVisibleOccupancyPt2(seatMatrix: [[Character]], i: Int, j: Int) -> Int {
        let directions = [(-1, -1), (-1, 0), (-1, 1), 
                          ( 0, -1),          ( 0, 1), 
                          ( 1, -1), ( 1, 0), ( 1, 1)]
        var occupiedCount = 0
        let rows = seatMatrix.count
        let cols = seatMatrix[0].count

        for (dx, dy) in directions {
            var ni = i + dx
            var nj = j + dy
            while ni >= 0 && ni < rows && nj >= 0 && nj < cols {
                if seatMatrix[ni][nj] == "L" {
                    break
                } else if seatMatrix[ni][nj] == "#" {
                    occupiedCount += 1
                    break
                }
                ni += dx
                nj += dy
            }
        }

        return occupiedCount
    }

    // MARK: - Testing

    func test() {

    }

}
