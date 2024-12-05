//https://adventofcode.com/2024/day/2
import Foundation

enum DayTwo {
    static func partOne() {
        // Load input data
        let inputLines = try! Utility.loadFile(named: "input02.txt")

        // Format the input into an Int Matrix
        let matrix = inputLines.map { $0.split(separator: " ").map { Int($0)! } }

        var safeCount = 0
        for arr in matrix {
            if isSafeArray(arr) {
                safeCount += 1
            }
        }

        print("Day two, part one result: \(safeCount)")
    }

    static func isSafeArray(_ arr: [Int]) -> Bool {
        let startAscending = arr[0] < arr[1]
        
        for i in 0..<arr.count - 1 {
            let distance = abs(arr[i] - arr[i + 1])
            
            if distance > 3 || (startAscending && arr[i] >= arr[i + 1]) || (!startAscending && arr[i] <= arr[i + 1]) {
                return false
            }
        }
        
        return true
    }
}

extension DayTwo {
    static func partTwo() {
        // Load input data
        let inputLines = try! Utility.loadFile(named: "input02.txt")

        // Format the input into an Int Matrix
        let matrix = inputLines.map { $0.split(separator: " ").map { Int($0)! } }

        var safeCount = 0
        for arr in matrix {
            if isSafeArrayWithProblemDampener(arr) {
                safeCount += 1
            }
        }

        print("Day two, part two result: \(safeCount)")
    }

    // This is possibly the worst code I've ever written in my life
    static func isSafeArrayWithProblemDampener(_ arr: [Int]) -> Bool {
        let isMostlyAscending = self.isMostlyAscending(arr)
        print("*** IsSafeWithProblemDampener ***")
        print("arr: \(arr)")
        print("isMostlyAscending: \(isMostlyAscending)")

        // Find the first element that is out of place
        var outOfPlaceIndices = (-1, -1)
        for i in 0..<arr.count - 1 {
            if (isMostlyAscending && arr[i] >= arr[i + 1]) || (!isMostlyAscending && arr[i] <= arr[i + 1] || abs(arr[i] - arr[i + 1]) > 3) {
                outOfPlaceIndices = (i, i + 1)
                break
            }
        }
        print("outOfPlaceIndices: \(outOfPlaceIndices)")
        // No out of place indices means that the array is safe
        guard outOfPlaceIndices != (-1, -1) else { 
            print("Array is safe, no out of place indices! arr: \(arr)")
            return true 
        }

        assert(outOfPlaceIndices.0 != -1 && outOfPlaceIndices.1 != -1 && outOfPlaceIndices.0 < arr.count && outOfPlaceIndices.1 < arr.count)

        // Create two arrays with out of place indices removed
        var arr1 = arr
        arr1.remove(at: outOfPlaceIndices.0)
        var arr2 = arr
        arr2.remove(at: outOfPlaceIndices.1)

        return isSafeArray(arr1) || isSafeArray(arr2)
    }

    static func isMostlyAscending(_ arr: [Int]) -> Bool {
        var ascendingCount = 0
        var descendingCount = 0

        for i in 0..<arr.count - 1 {
            if arr[i] < arr[i + 1] {
                ascendingCount += 1
            } else if arr[i] > arr[i + 1] {
                descendingCount += 1
            }
        }

        return ascendingCount > descendingCount
    }
}


// MARK: - Tests

extension DayTwo {
    static func testIsSafeArray() {
        let testCases = [
            ([7, 6, 4, 2, 1], true),
            ([1, 2, 7, 8, 9], false),
            ([9, 7, 6, 2, 1], false),
            ([1, 3, 2, 4, 5], false),
            ([8, 6, 4, 4, 1], false),
            ([1, 3, 6, 7, 9], true)
        ]

        for (arr, expected) in testCases {
            let result = isSafeArray(arr)
            assert(result == expected, "Expected \(expected) but got \(result) for array \(arr)")
        }
        print("All tests passed")
    }

    static func testIsSafeArrayWithProblemDampener() {
        let testCases = [
            ([7, 6, 4, 2, 1], true),
            ([1, 2, 7, 8, 9], false),
            ([9, 7, 6, 2, 1], false),
            ([1, 3, 2, 4, 5], true),
            ([8, 6, 4, 4, 1], true),
            ([1, 3, 6, 7, 9], true)
        ]

        for (arr, expected) in testCases {
            let result = isSafeArrayWithProblemDampener(arr)
            assert(result == expected, "Expected \(expected) but got \(result) for array \(arr)")
        }
        print("All tests passed")
    }
}