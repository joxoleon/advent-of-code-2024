// https://adventofcode.com/2024/day/25
import Foundation

class DayTwentyFive: Day {
    let dayNumber: Int = 25
    let year: Int = 2024

    struct Schematic: Hashable {
        let isLock: Bool
        let pins: [Int]

        // Constants:
        static let maxPinHeight = 6

        init(m: String) {
            let matrix: [[Character]] = m.split(separator: "\n").map { Array($0) }
            var p = [Int]()
            
            if matrix[0][0] == "#" {
                isLock = true
                for j in 0..<matrix[0].count {
                    var pCount = 0
                    for i in 0..<matrix.count {
                        if matrix[i][j] == "#" {
                            pCount += 1
                        }
                    }
                    p.append(pCount - 1)
                }
            } else {
                isLock = false
                for j in 0..<matrix[0].count {
                    var pCount = 0
                    for i in (0..<matrix.count).reversed() {
                        if matrix[i][j] == "#" {
                            pCount += 1
                        }
                    }
                    p.append(pCount - 1)
                }
            }
            
            pins = p
        }

        init(isLock: Bool, pins: [Int]) {
            self.isLock = isLock
            self.pins = pins
        }

        func fits(_ other: Schematic) -> Bool {
            for i in 0..<pins.count {
                if pins[i] + other.pins[i] >= Schematic.maxPinHeight {
                    return false
                }
            }
            return true
        }
    }

    // MARK: - Part One

    func partOne(input: String) -> String {

        let lines = input.split(separator: "\n\n")
        let schematics = lines.map { Schematic(m: String($0)) }
        let locks = schematics.filter { $0.isLock }
        let keys = schematics.filter { !$0.isLock }

        // Debug prints:
        print("Locks:")
        for lock in locks {
            print(lock.pins)
        }
        print("\nKeys:")
        for key in keys {
            print(key.pins)
        }
        print("\n")


        var uniqueLockKeyPairsCount = 0
        for lock in locks {
            for key in keys {
                if lock.fits(key) {
                    uniqueLockKeyPairsCount += 1
                }
            }
        }

        return "Unique Lock-Key Pairs: \(uniqueLockKeyPairsCount)"
    }

    // MARK: - Part Two
    func partTwo(input: String) -> String {
    
    
        return ""
    }
}
