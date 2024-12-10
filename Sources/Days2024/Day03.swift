// https://adventofcode.com/2024/day/3
import Foundation

class DayThree: Day {
    let dayNumber: Int = 3
    let year = 2024
    
    func partOne(input: String) -> String {
        var result: Int128 = 0
        let mulOperations = extractMulOperations(from: input)
        for operation in mulOperations {
            result += evaluateMulOperation(operation)
        }
        return "\(result)"
    }

    func extractMulOperations(from input: String) -> [String] {
        let pattern = "mul\\((\\d+),(\\d+)\\)"
        return input.matches(for: pattern)
    }

    func evaluateMulOperation(_ operation: String) -> Int128 {
        let parathesesContent = operation.dropFirst(4).dropLast(1)
        let numbers = parathesesContent.split(separator: ",").map { Int128($0)! }
        assert(numbers.count == 2)
        return numbers[0] * numbers[1]
    }

    func partTwo(input: String) -> String {
        let strings = extractStringsBetweenDoAndDont(from: input)
        let transformedInput = strings.joined()
        let mulOperations = extractMulOperations(from: transformedInput)
        var result: Int128 = 0
        for operation in mulOperations {
            result += evaluateMulOperation(operation)
        }
        return "\(result)"
    }

    func extractStringsBetweenDoAndDont(from input: String) -> [String] {
        enum State {
            case doFound
            case dontFound
        }

        var state = State.doFound
        var result = [String]()
        var currentString = ""
        var i = input.startIndex

        while i < input.endIndex {
            if input[i...].hasPrefix("do()") {
                state = .doFound
                i = input.index(i, offsetBy: 4) // Move past "do()"
            } else if input[i...].hasPrefix("don't()") {
                if state == .doFound, !currentString.isEmpty {
                    result.append(currentString)
                    currentString = ""
                }
                state = .dontFound
                i = input.index(i, offsetBy: 7) // Move past "don't()"
            } else {
                if state == .doFound {
                    currentString.append(input[i])
                }
                i = input.index(after: i)
            }
        }

        return result
    }

    func test() {
        let input = "do()123don't()456do()don't()do()don't()undo()don't()do()don't()unundo()789don't()012"
        let result = extractStringsBetweenDoAndDont(from: input)
        print(result)
        assert(result == ["123", "789"])
    }
}

fileprivate extension String {
    func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch let error {
            print("Invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
