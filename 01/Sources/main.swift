// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

// Load input data
let fileURL = URL(fileURLWithPath: "input.txt")
let input = try String(contentsOf: fileURL).split(separator: "\n")

// Format the input data into a tuple of arrays
var (firstElements, secondElements) =
    input
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
print("Part 1 result: \(result)")


// Part 2
var countinSortArray = Array(repeating: 0, count: 100000)
for element in secondElements {
    countinSortArray[element] += 1
}

var part2Result = 0
for element in firstElements {
    part2Result += element * countinSortArray[element]
}

print("Part 2 result: \(part2Result)")


