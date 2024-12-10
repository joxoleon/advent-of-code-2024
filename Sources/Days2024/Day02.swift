//https://adventofcode.com/2024/day/2
import Foundation

class DayTwo: Day {
    let dayNumber: Int = 2
    let year = 2024
    
    func partOne(input: String) -> String {
        let inputLines = input.split(separator: "\n").map { String($0) }

        // Format the input into an Int Matrix
        let matrix = inputLines.map { $0.split(separator: " ").map { Int($0)! } }

        var safeCount = 0
        for arr in matrix {
            if DayTwo.isSafeArray(arr) {
                safeCount += 1
            }
        }

        return "\(safeCount)"
    }

    func partTwo(input: String) -> String {
        let inputLines = input.split(separator: "\n").map { String($0) }

        // Format the input into an Int Matrix
        let matrix = inputLines.map { $0.split(separator: " ").map { Int($0)! } }

        var safeCount = 0
        for arr in matrix {
            if DayTwo.isSafeArrayWithProblemDampener(arr) {
                safeCount += 1
            }
        }

        return "\(safeCount)"
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

    static func isSafeArrayWithProblemDampener(_ arr: [Int]) -> Bool {
        let isMostlyAscending = self.isMostlyAscending(arr)

        // Find the first element that is out of place
        var outOfPlaceIndices = (-1, -1)
        for i in 0..<arr.count - 1 {
            if (isMostlyAscending && arr[i] >= arr[i + 1]) || (!isMostlyAscending && arr[i] <= arr[i + 1] || abs(arr[i] - arr[i + 1]) > 3) {
                outOfPlaceIndices = (i, i + 1)
                break
            }
        }

        // No out of place indices means that the array is safe
        guard outOfPlaceIndices != (-1, -1) else { return true }

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

    func test() {
        let input = """
            7 6 4 2 1
            1 2 7 8 9
            9 7 6 2 1
            1 3 2 4 5
            8 6 4 4 1
            1 3 6 7 9
            """
        let result = partOne(input: input)
        assert(result == "3")

        let result2 = partTwo(input: input)
        assert(result2 == "4")
    }
}