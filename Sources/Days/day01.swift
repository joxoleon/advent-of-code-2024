// https://adventofcode.com/2024/day/1
import Foundation

enum DayOne {

    static func partOne() {
        // Load input data
        let inputLines = try! Utility.loadFile(named: "input01.txt")
        
        // Format the input data into a tuple of arrays
        var (firstElements, secondElements) =
            inputLines
            .map { $0.split(separator: " ").map { Int($0)! } }
            .reduce(into: ([Int](), [Int]())) { result, pair in
                result.0.append(pair[0])
                result.1.append(pair[1])
            }
        
        // Part 1
        firstElements.sort()
        secondElements.sort()
        
        var result = 0
        for i in 0..<firstElements.count {
            result += abs(firstElements[i] - secondElements[i])
        }
        print("Day one, part one result: \(result)")
    }


    static func partTwo() {
        // Load input data
        let inputLines = try! Utility.loadFile(named: "input01.txt")
        
        // Format the input data into a tuple of arrays
        let (firstElements, secondElements) =
            inputLines
            .map { $0.split(separator: " ").map { Int($0)! } }
            .reduce(into: ([Int](), [Int]())) { result, pair in
                result.0.append(pair[0])
                result.1.append(pair[1])
            }
        
        // Part 2
        var countingSortArray = Array(repeating: 0, count: 100000)
        for element in secondElements {
            countingSortArray[element] += 1
        }
        
        var result = 0
        for element in firstElements {
            result += element * countingSortArray[element]
        }
        
        print("Day one, part two result: \(result)")
    }  


}