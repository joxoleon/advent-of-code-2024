// https://adventofcode.com/2020/day/5
import Foundation

class DayFive2020: Day {
    let dayNumber: Int = 5
    let year: Int = 2020

    let rowCount = 128
    let rowRange = 0..<128

    let seatCount = 8
    let seatRange = 0..<8


    // MARK: - Part One

    func partOne(input: String) -> String {
        let lines = input.components(separatedBy: .newlines)
        var seatIds = lines.map { calculateSeatId(line: $0) }
        
        // Part 1 - Find the max seat id
        let maxSeatId = seatIds.max()!
        print("Max seat id: \(maxSeatId)")

        // Part 2 - Find the missing seat id
        var missingSeatId = 0
        seatIds.sort()
        for i in 0..<seatIds.count - 1 {
            if seatIds[i + 1] - seatIds[i] == 2 {
                missingSeatId = seatIds[i] + 1
            }
        }
        print("Missing seat id: \(missingSeatId)")

        return "Max seat id: \(maxSeatId), Missing seat id: \(missingSeatId)"
    }

    func calculateSeatId(line: String) -> Int {
        let row = calculateRow(line: line)
        let column = calculateSeat(line: line)
        return row * 8 + column
    }

    func calculateRow(line: String) -> Int {
        var range = rowRange
        for char in line.prefix(7) {
            let mid = range.lowerBound + (range.upperBound - range.lowerBound) / 2
            if char == "F" {
                range = range.lowerBound..<mid
            } else {
                range = mid..<range.upperBound
            }
        }

        return range.lowerBound
    }

    func calculateSeat(line: String) -> Int {
        var range = seatRange
        for char in line.suffix(3) {
            let mid = range.lowerBound + (range.upperBound - range.lowerBound) / 2
            if char == "L" {
                range = range.lowerBound..<mid
            } else {
                range = mid..<range.upperBound
            }
        }
        return range.lowerBound
    }

    // MARK: - Part Two

    func partTwo(input: String) -> String {
        return ""
    }

    // MARK: - Tests

    func test() {}
}