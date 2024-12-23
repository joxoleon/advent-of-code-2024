// https://adventofcode.com/2024/day/21
import Foundation

class DayTwentyOne: Day {
    let dayNumber: Int = 21
    let year: Int = 2024

    // MARK: - Part One
    
    let numKeypad = Keypad(g: Util.Grid(grid: [
        ["7", "8", "9"],
        ["4", "5", "6"],
        ["1", "2", "3"],
        ["*", "0", "A"],
    ]))
    
    let dirKeypad1 = Keypad(g: Util.Grid(grid: [
        ["*", "^", "A"],
        ["<", "v", ">"],
    ]))
    
    let dirKeypad2 = Keypad(g: Util.Grid(grid: [
        ["*", "^", "A"],
        ["<", "v", ">"],
    ]))

    func partOne(input: String) -> String {
        let codes = input.components(separatedBy: .newlines)
        var result = 0
        for code in codes {
            result += evaluateCodeComplexity(code: code)
        }
        return "Complexity: \(result)"
    }

    // MARK: - Part Two

    func partTwo(input: String) -> String {
        return ""
    }

    // MARK: - Get shit done functions

    func evaluateCodeComplexity(code: String) -> Int {
        let finalResult = 0

        // Get all num keypad paths
        var allResultingOptions = [String]()
        let numKeypadOptions = numKeypad.evaluateCodeShortestOptions(code: "A" + code)
        for option in numKeypadOptions {
            let d1KeypadOptions = dirKeypad1.evaluateCodeShortestOptions(code: "A" + option)
            for dirOption in d1KeypadOptions {                
                let d2KeypadOptions = dirKeypad1.evaluateCodeShortestOptions(code: "A" + dirOption)
                for o in d2KeypadOptions {
                    allResultingOptions.append(o)
                }               
                // let first = d2KeypadOptions.first!
                // let numericPart = Int(code.prefix(3))!
                // let r = first.count * numericPart

                // for o in d2KeypadOptions {
                //     assert(o.count == first.count)
                // }

                // print("Code: \(code)")
                // print("execute: \(first)")
                // print("\(r) = \(first.count) * \(numericPart)")
                // return r
            }
        }

        let minCount = allResultingOptions.map { $0.count }.min()!
        let numericPart = Int(code.prefix(3))!
        print("result: \(minCount) * \(numericPart) = \(minCount * numericPart)")
        return minCount * numericPart
    }

    // MARK: - Test functions

    class Keypad {

        var g: Util.Grid
        var shortestStartEndPaths: [SEKP: [String]] = [:]
        
        init(g: Util.Grid) {
            self.g = g
        }


        func evaluateCodeShortestOptions(code: String) -> [String] {
            let sekps = strToSekps(code)
            var allPaths = [[String]]()
            for sekp in sekps {
                allPaths.append(shortestDirs(sekp: sekp))
            }
            return combinePaths(allPaths)
        }

        func combinePaths(_ allPaths: [[String]]) -> [String] {
            guard !allPaths.isEmpty else { return [] }
            var result = allPaths[0]
            
            for i in 1..<allPaths.count {
                var newResult = [String]()
                if allPaths[i].isEmpty {
                    // If the current row is empty, append "A" to each path in the result
                    newResult = result.map { $0 + "A" }
                } else {
                    for path in result {
                        for nextPath in allPaths[i] {
                            newResult.append(path + "A" + nextPath)
                        }
                    }
                }
                result = newResult
            }
            
            return result.map { $0 + "A" }
        }

        func shortestDirs(sekp: SEKP) -> [String] {
            if let paths = shortestStartEndPaths[sekp] {
                return paths
            }
            
            if sekp.start == sekp.end {
                return []
            }

            let pathInput = Util.PathInput(start: sekp.start, end: sekp.end, obstacleCharacters: ["*"])
            let shortestPaths = g.allShortestPaths(for: pathInput)
            let sps = shortestPaths.map { $0.toDirString() }
            let result = leastDirectionVariation(paths: sps)
            shortestStartEndPaths[sekp] = result
            return result
        }

        func shortestDirs(s: Character, e: Character) -> [String] {
            let sp = g.findPosition(s)!
            let ep = g.findPosition(e)!
            if let paths = shortestStartEndPaths[SEKP(start: sp, end: ep)] {
                return paths
            }

            let pathInput = Util.PathInput(start: sp, end: ep, obstacleCharacters: ["*"])
            let shortestPaths = g.allShortestPaths(for: pathInput)
            let sps = shortestPaths.map { $0.toDirString() }
            let result = leastDirectionVariation(paths: sps)
            shortestStartEndPaths[SEKP(start: sp, end: ep)] = result
            return result
        }

        func strToSekps(_ str: String) -> [SEKP] {
            var result = [SEKP]()
            let arr: [Character] = Array(str)
            for i in 0..<arr.count-1 {
                let start = g.findPosition(arr[i])!
                let end = g.findPosition(arr[i+1])!
                result.append(SEKP(start: start, end: end))
            }
            return result
        }

    }

    // MARK: - Utility

    static func leastDirectionVariation(paths: [String]) -> [String] {
        var result = [String]()
        var minVariation = Int.max
        for path in paths {
            let pa = Array(path)
            var variation = 0
            for i in 0..<path.count-1 {
                if pa[i] != pa[i+1] {
                    variation += 1
                }
            }
            if variation < minVariation {
                minVariation = variation
                result = [path]
            } else if variation == minVariation {
                result.append(path)
            }
        }
        return result
    }


    // MARK: - Tests

    func testEvaluateCodeShortestOptions() {
        let codes = ["A029A", "A980A", "A179A", "A456A", "A379A"]
        for code in codes {
            let result = numKeypad.evaluateCodeShortestOptions(code: code)
            print("\nCode: \(code)")
            for r in result {
                print(r)
            }
        }

    }

    func testStrToSekps() {
        let str = "029A"
        let result = numKeypad.strToSekps(str)
        print("strToSekps")
        for s in result {
            print(s)
        }
    }

    func testFilterLeastDirectionVariation() {
        var paths = ["^^>>", ">>^^", "^>^>", ">^^>", "^>>^"]
        var result = DayTwentyOne.leastDirectionVariation(paths: paths)
        print(result)

        paths = ["^>", ">^"]
        result = DayTwentyOne.leastDirectionVariation(paths: paths)
        print(result)
    }
}

struct SEKP: Hashable {
    let start: Util.Position
    let end: Util.Position
}
