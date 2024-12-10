// https://adventofcode.com/2020/day/9
import Foundation

class DayNine2020: Day {
    let dayNumber = 9
    let year = 2020

    // MARK: - Part One

    func partOne(input: String) -> String {
        // This is just a sliding window problem along with a two sum problem, so it can easily be handled by using a set
        let numbers = input.components(separatedBy: .newlines).compactMap { Int($0) }
        let preamble = 25
        var window = Set(numbers[0..<preamble])

        for i in preamble..<numbers.count {
            let target = numbers[i]
            var found = false
            for num in window {
                let complement = target - num
                if window.contains(complement) {
                    found = true
                    break
                }
            }

            if !found {
                return "First number that does not have the property: \(target)"
            }

            window.remove(numbers[i - preamble])
            window.insert(target)
        }

        fatalError("Should not reach here")
    }

    // MARK: - Part Two

    func partTwo(input: String) -> String {
        // This boils down to a sliding window two pointer problem
        let numbers = input.components(separatedBy: .newlines).compactMap { Int($0) }
        
        let target_number = 1492208709
        var i = 0
        var j = 1
        var sum = numbers[i] + numbers[j]
        while j < numbers.count {
            if sum < target_number {
                j += 1
                sum += numbers[j]
            } else if sum > target_number {
                sum -= numbers[i]
                i += 1
            } else {
                let range = numbers[i...j]
                let min = range.min()!
                let max = range.max()!
                return "Encryption weakness: \(min + max)"
            }
        }
        fatalError("Should not reach here")
    }

    // MARK: - Utility Functions

    // MARK: - Testing

    func test() {

    }
}