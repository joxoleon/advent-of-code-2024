// https://adventofcode.com/2024/day/11
import Foundation

class DayEleven: Day {
    let dayNumber = 11
    let year = 2024

    // MARK: - Cache

    struct BlinkStoneInput: Hashable {
        let stone: Int
        let blinkCount: Int
    }
    var blinkStoneCountCache: [BlinkStoneInput: Int] = [:]
    var blinkCache: [Int: [Int]] = [:]

    // MARK: - Part One

    func partOne(input: String) -> String {
        let stoneStrings = input.components(separatedBy: " ")
        let stones = stoneStrings.compactMap { Int($0)! }        
        let stoneCount = blinkCount(stones: stones, count: 25)

        return "Stone Count: \(stoneCount)"
    }

    // MARK: - Utility Functions

    func blinkCount(stones: [Int], count: Int) -> Int {
        var result = 0
        for stone in stones {
            result += blinkStoneCount(input: BlinkStoneInput(stone: stone, blinkCount: count))
        }
        return result
    }

    func blinkStoneCount(input: BlinkStoneInput) -> Int {
        if let cached = blinkStoneCountCache[input] {
            return cached
        }

        var result = 0
        if input.blinkCount == 0 {
            result = 1
        } else {
            let stones = blink(stone: input.stone)
            for stone in stones {
                result += blinkStoneCount(input: BlinkStoneInput(stone: stone, blinkCount: input.blinkCount - 1))
            }
        }

        blinkStoneCountCache[input] = result
        return result
    }

    func blink(stone: Int) -> [Int] {
        if let cached = blinkCache[stone] {
            return cached
        }

        var result: [Int] = []
        if stone == 0 {
            result = [1]
        } else if hasEvenDigits(stone) {
            result = splitDigitsInHalf(stone)
        } else {
            result = [stone * 2024]
        }

        blinkCache[stone] = result
        return result
    }

    func hasEvenDigits(_ number: Int) -> Bool {
        return String(number).count % 2 == 0
    }

    func splitDigitsInHalf(_ number: Int) -> [Int] {
        let numberString = String(number)
        let halfIndex = numberString.count / 2
        let firstHalf = numberString.prefix(halfIndex)
        let secondHalf = numberString.suffix(halfIndex)
        return [Int(firstHalf)!, Int(secondHalf)!]
    }

    // MARK: - Part Two

    func partTwo(input: String) -> String {
        let stoneStrings = input.components(separatedBy: " ")
        let stones = stoneStrings.compactMap { Int($0)! }        
        let stoneCount = blinkCount(stones: stones, count: 75)

        return "Stone Count: \(stoneCount)"
    }

    // MARK: - Utility Functions

    // MARK: - Testing

    func test() {}
}
