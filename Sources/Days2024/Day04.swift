// https://adventofcode.com/2024/day/4
import Foundation

class DayFour: Day {
    let dayNumber = 4
    let year = 2024
    
    func partOne(input: String) -> String {
        // Transform input into a matrix of characters
        let cm = DayFour.getCharacterMatrix(from: input)

        var xmasCount = 0
        for row in 0..<cm.count {
            for column in 0..<cm[row].count {
                if cm[row][column] == "X" {
                    print("Checking for XMAS at row: \(row), column: \(column)")
                    let countAtPosition = DayFour.checkForXmasWordInAllDirections(matrix: cm, row: row, col: column)
                    print("Found \(countAtPosition) XMAS at row: \(row), column: \(column)")

                    xmasCount += countAtPosition
                    print("Current xmasCount: \(xmasCount)")
                }
            }
        }

        return "Xmas Count: \(xmasCount)"
    }

    func partTwo(input: String) -> String {
        let cm = DayFour.getCharacterMatrix(from: input)
        var crossMasCount = 0
        for row in 0..<cm.count {
            for column in 0..<cm[row].count {
                if cm[row][column] == "A" {
                    if DayFour.checkForCrossMas(matrix: cm, row: row, col: column) {
                        crossMasCount += 1
                    }
                }
            }
        }

        return "CrossMas Count: \(crossMasCount)"
    }

    // MARK: - Utility functions

    static func getCharacterMatrix(from input: String) -> [[Character]] {
        return input.split(separator: "\n").map { Array($0) }
    }

    static func checkForXmasWordInAllDirections(matrix: [[Character]], row: Int, col: Int) -> Int {
        // Check for XMAS in all directions
        let directions = 
        [
            (1, 0), 
            (-1, 0), 
            (0, 1), 
            (0, -1),
            (1, 1),
            (1, -1),
            (-1, 1),
            (-1, -1)
        ]

        var xmasCount = 0

        for direction in directions {
            let (dx, dy) = direction
            var x = row
            var y = col
            var word = ""
            while x >= 0 && x < matrix.count && y >= 0 && y < matrix[0].count && abs(x - row) < 4 && abs(y - col) < 4 {
                word.append(matrix[x][y])
                x += dx
                y += dy
            }

            if word == "XMAS" {
                print("Found XMAS in direction: \(direction)")
                xmasCount += 1
            }
        }

        return xmasCount
    }

    static func checkForCrossMas(matrix: [[Character]], row: Int, col: Int) -> Bool {
        // Make sure you are not at the edge of the matrix
        guard row >= 1 && row < matrix.count - 1 && col >= 1 && col < matrix[0].count - 1 else {
            return false
        }
        // Check if the current position is an A
        guard matrix[row][col] == "A" else {
            return false
        }

        // Top left M or S
        if matrix[row - 1][col - 1] == "M" || matrix[row - 1][col - 1] == "S" {
            // Bottom right M or S
            if matrix[row + 1][col + 1] == "M" || matrix[row + 1][col + 1] == "S" {
                // Return false if the top left and bottom right are the same
                guard matrix[row - 1][col - 1] != matrix[row + 1][col + 1] else {
                    return false
                }

                // Top right M or S
                if matrix[row - 1][col + 1] == "M" || matrix[row - 1][col + 1] == "S" {
                    // Bottom left M or S
                    if matrix[row + 1][col - 1] == "M" || matrix[row + 1][col - 1] == "S" {
                        // Return false if the top right and bottom left are the same
                        guard matrix[row - 1][col + 1] != matrix[row + 1][col - 1] else {
                            return false
                        }
                        return true
                    }
                }

            }
        }
        return false
    }


    func test() {
        DayFour.testPartTwo()
    }

    static func testCheckForXmasWordInAllDirections() {
        let input = """
            SSSSSSS
            AAAAAAA
            MMMMMMM
            SAMXMAS
            MMMMMMM
            AAAAAAA
            SSSSSSS
            """
        let matrix = getCharacterMatrix(from: input)
        let result = checkForXmasWordInAllDirections(matrix: matrix, row: 3, col: 3)
        print("Result: \(result)")
        assert(result == 8)
    }

    static func testPartOne() {
        let input = """
        MMMSXXMASM
        MSAMXMSMSA
        AMXSXMAAMM
        MSAMASMSMX
        XMASAMXAMM
        XXAMMXXAMA
        SMSMSASXSS
        SAXAMASAAA
        MAMMMXMMMM
        MXMXAXMASX
        """
        let day = DayFour()
        let result = day.partOne(input: input)
        print("Result: \(result)")
    }

    static func testPartTwo() {
        let input = """
        .M.S......
        ..A..MSMS.
        .M.S.MAA..
        ..A.ASMSM.
        .M.S.M....
        ..........
        S.S.S.S.S.
        .A.A.A.A..
        M.M.M.M.M.
        ..........
        """
        let day = DayFour()
        let result = day.partTwo(input: input)
        print("Result: \(result)")
    }
}
