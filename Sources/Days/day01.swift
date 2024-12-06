// https://adventofcode.com/2024/day/1
import Foundation

class DayOne: Day {
    var dayNumber: Int = 1

    func partOne(input: String) -> String {
        let inputLines = input.split(separator: "\n").map { String($0) }
        
        var (firstElements, secondElements) =
            inputLines
            .map { $0.split(separator: " ").map { Int($0)! } }
            .reduce(into: ([Int](), [Int]())) { result, pair in
                result.0.append(pair[0])
                result.1.append(pair[1])
            }
        
        firstElements.sort()
        secondElements.sort()
        
        var result = 0
        for i in 0..<firstElements.count {
            result += abs(firstElements[i] - secondElements[i])
        }
        
        return "\(result)"
    }

    func partTwo(input: String) -> String {
        let inputLines = input.split(separator: "\n").map { String($0) }
        
        let (firstElements, secondElements) =
            inputLines
            .map { $0.split(separator: " ").map { Int($0)! } }
            .reduce(into: ([Int](), [Int]())) { result, pair in
                result.0.append(pair[0])
                result.1.append(pair[1])
            }
        
        var countingSortArray = Array(repeating: 0, count: 100000)
        for element in secondElements {
            countingSortArray[element] += 1
        }
        
        var result = 0
        for element in firstElements {
            result += element * countingSortArray[element]
        }
        
        return "\(result)"
    }

    func test() {
        let input = """
            1 2
            2 3
            3 4
            4 5
            5 6
            """
        let result = partOne(input: input)
        assert(result == "5")
    }
}