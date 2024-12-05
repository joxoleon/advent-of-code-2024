// https://adventofcode.com/2024/day/3
import Foundation

enum DayThree {

    // MARK: - Part One

    static func partOne() {
        // Load input data
        let inputLines = try! Utility.loadFile(named: "input03.txt")
        let input = inputLines.joined()

        var result: Int128 = 0
        let mulOperations = extractMulOperations(from: input)
        for operation in mulOperations {
            result += evaluateMulOperation(operation)
        }
        
        print(result)
    }

    static func extractMulOperations(from input: String) -> [String] {
        let pattern = "mul\\((\\d+),(\\d+)\\)"
        return input.matches(for: pattern)
    }

    static func evaluateMulOperation(_ operation: String) -> Int128 {
        let parathesesContent = operation.dropFirst(4).dropLast(1)
        let numbers = parathesesContent.split(separator: ",").map { Int128($0)! }
        assert(numbers.count == 2)
        return numbers[0] * numbers[1]
    }

    // MARK: - Part Two

    static func partTwo() {
        // Load input data
        let inputLines = try! Utility.loadFile(named: "input03.txt")
        let input = inputLines.joined()

        // Extract all substrings between the do() and don't() operations
        let strings = extractStringsBetweenDoAndDont(from: input)
        let transformedInput = strings.joined()
        let mulOperations = extractMulOperations(from: transformedInput)
        var result: Int128 = 0
        for operation in mulOperations {
            result += evaluateMulOperation(operation)
        }
        print(result)
    }

    static func extractStringsBetweenDoAndDont(from input: String) -> [String] {
        enum State {
            case doFound
            case dontFound
        }

        var state = State.doFound
        var result = [String]()
        var currentString = ""
        var i = input.startIndex

        while i < input.endIndex {
            print("CurrenState: \(state), Current substring: \(input[i...])")
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

// MARK: - Tests

extension DayThree {
    static func testExtractDoAndDontStrings() {
        let input = "do()123don't()456do()don't()do()don't()undo()don't()do()don't()unundo()789don't()012"
        let result = extractStringsBetweenDoAndDont(from: input)
        print(result)
        assert(result == ["123", "789"])
    }
}
