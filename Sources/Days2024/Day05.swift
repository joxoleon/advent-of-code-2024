// https://adventofcode.com/2024/day/5
import Foundation

class DayFive: Day {
    let dayNumber = 5
    let year = 2024

    func partOne(input: String) -> String {
        let (rules, updates) = processInput(input: input)
        let (comesAfterDict, comesBeforeDict) = createRuleDictionary(rules: rules)
        let updateArrays: [[Int]] = updates.map { $0.split(separator: ",").map { Int($0)! } }

        var validUpdateArrays = [[Int]]()
        for update in updateArrays {
            if isValidUpdate(arr: update, comesAfterDict: comesAfterDict, comesBeforeDict: comesBeforeDict) {
                validUpdateArrays.append(update)
            }
        }

        var middleSum = 0
        for validUpdate in validUpdateArrays {
            middleSum += validUpdate[validUpdate.count / 2]
        }

        return "middleSum: \(middleSum)"
    }

    func partTwo(input: String) -> String {
        let (rules, updates) = processInput(input: input)
        let (comesAfterDict, comesBeforeDict) = createRuleDictionary(rules: rules)
        let updateArrays: [[Int]] = updates.map { $0.split(separator: ",").map { Int($0)! } }
        var invalidUpdateArrays = [[Int]]()
        for update in updateArrays {
            if !isValidUpdate(arr: update, comesAfterDict: comesAfterDict, comesBeforeDict: comesBeforeDict) {
                invalidUpdateArrays.append(update)
            }
        }

        var orderedUpdates = [[Int]]()
        for invalidUpdate in invalidUpdateArrays {
            let orderedUpdate = orderUpdate(updateArray: invalidUpdate, comesAfter: comesAfterDict, comesBefore: comesBeforeDict)
            orderedUpdates.append(orderedUpdate)
        }

        let middleSum = orderedUpdates.map { $0[$0.count / 2] }.reduce(0, +)

        return "middleSum: \(middleSum)"
    }

    // MARK: - Utility functions

    func processInput(input: String) -> ([String], [String]) {
        let lines = input.split(separator: "\n").map { String($0) }
        var rules = [String]()
        var updates = [String]()
        for line in lines {
            if line.contains("|") {
                rules.append(line)
            } else {
                updates.append(line)
            }
        }

        return (rules, updates)
    }

    func createRuleDictionary(rules: [String]) -> ([Int: [Int]], [Int: [Int]]) {
        var comesAfterDict = [Int: [Int]]()
        var comesBeforeDict = [Int: [Int]]()
        var allElements = Set<Int>()

        for rule in rules {
            let parts = rule.split(separator: "|").map { String($0) }
            let first = Int(parts[0])!
            let second = Int(parts[1])!
            comesAfterDict[first, default: []].append(second)
            comesBeforeDict[second, default: []].append(first)
            // I don't want to think anymore!
            allElements.insert(first)
            allElements.insert(second)
        }

        // Make sure all elements are in the dictionaries
        for element in allElements {
            if !comesAfterDict.keys.contains(element) {
                comesAfterDict[element] = []
            }
            if !comesBeforeDict.keys.contains(element) {
                comesBeforeDict[element] = []
            }
        }

        return (comesAfterDict, comesBeforeDict)
    }

    func isValidUpdate(arr: [Int], comesAfterDict: [Int: [Int]], comesBeforeDict: [Int: [Int]]) -> Bool {
        for i in 0..<arr.count {
            let current = arr[i]
            let comesAfter = comesAfterDict[current, default: []]
            let comesBefore = comesBeforeDict[current, default: []]

            // Check all elements before current
            for j in 0..<i {
                let before = arr[j]
                if comesAfter.contains(before) {
                    return false
                }
            }

            // Check all elements after current
            for j in i+1..<arr.count {
                let after = arr[j]
                if comesBefore.contains(after) {
                    return false
                }
            }
        }

        return true
    }

    func orderUpdate(updateArray: [Int], comesAfter: [Int: [Int]], comesBefore: [Int: [Int]]) -> [Int] {
        var before = comesBefore
        var after = comesAfter
        
        // filter before and after maps to remove all of the elements that don't exist within the update array
        let updateSet = Set(updateArray)
        for key in before.keys where !updateSet.contains(key) {
            filterRules(comesBefore: &before, comesAfter: &after, element: key)
        }
        for key in after.keys where !updateSet.contains(key) {
            filterRules(comesBefore: &before, comesAfter: &after, element: key)
        }

        // Create a sorted array from the rules
        let sortedArray = createSortedArrayFromRules(comesBefore: before, comesAfter: after)
        return sortedArray
    }

    func createSortedArrayFromRules(comesBefore: [Int: [Int]], comesAfter: [Int: [Int]]) -> [Int] {
        var sortedArray = [Int]()
        
        var before = comesBefore
        var after = comesAfter

        while !before.isEmpty && !comesAfter.isEmpty {
            // Find the first element that has no elements before it
            let first = before.first { $0.value.isEmpty }!

            // Insert it into the sorted array
            sortedArray.append(first.key)
            
            // Remove it from the dictionaries
            filterRules(comesBefore: &before, comesAfter: &after, element: first.key)
        }
        return sortedArray
    }

    func filterRules(comesBefore: inout [Int: [Int]], comesAfter: inout [Int: [Int]], element: Int) {
        for key in comesBefore.keys {
            comesBefore[key] = comesBefore[key]?.filter { $0 != element }
        }
        comesBefore[element] = nil

        for key in comesAfter.keys {
            comesAfter[key] = comesAfter[key]?.filter { $0 != element }
        }
        comesAfter[element] = nil
    }

    func test() {}
}