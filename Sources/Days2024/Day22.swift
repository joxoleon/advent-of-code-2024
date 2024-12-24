// https://adventofcode.com/2024/day/22
import Foundation

class DayTwentyTwo: Day {
    let dayNumber: Int = 22
    let year: Int = 2024

    // MARK: - Part One

    func partOne(input: String) -> String {
        // let secrets = [1, 10, 100, 2024]
        let secrets = input.components(separatedBy: .newlines).compactMap { Int($0) }
        var result = 0
        for secret in secrets {
            result += evolve(secret: secret, times: 2000)
        }
        return "Sum of secrets: \(result)"
    }

    // MARK: - Part Two

    func partTwo(input: String) -> String {
        let n = 2000
        let inputs = input.components(separatedBy: .newlines).compactMap { Int($0) }

        let testSequence = FourDiffSequence(diff1: -2, diff2: 1, diff3: -1, diff4: 3)

    
        struct FourDiffSequence: Hashable {
            let diff1: Int
            let diff2: Int
            let diff3: Int
            let diff4: Int
    
            // Initialize with a sequence of 4 diffs
            init(diff1: Int, diff2: Int, diff3: Int, diff4: Int) {
                self.diff1 = diff1
                self.diff2 = diff2
                self.diff3 = diff3
                self.diff4 = diff4
            }
        }
        var diffsToPrice = [FourDiffSequence: Int]()
    
        for (index, input) in inputs.enumerated() {
            print("Processing input: \(index + 1)/\(inputs.count)")
    
            // Secret evolution and diff evolution in a single pass
            var secrets = Array(repeating: 0, count: n + 1)
            var diffs = Array(repeating: 0, count: n + 1)
            secrets[0] = input
            diffs[0] = 0
            for i in 1...n {
                secrets[i] = evolve(secret: secrets[i - 1])
                diffs[i] = (secrets[i] % 10) - (secrets[i - 1] % 10)
            }
    
            // Sequence creation
            var visited = Set<FourDiffSequence>()
            for i in 3...n {
                let sequence = FourDiffSequence(diff1: diffs[i-3], diff2: diffs[i-2], diff3: diffs[i-1], diff4: diffs[i])
                if visited.contains(sequence) {
                    continue
                }
                visited.insert(sequence)
                if sequence == testSequence {
                    print("Found sequence at index: \(i)")
                    print("Price for sequence\(testSequence) is \(secrets[i] % 10)")
                }
                diffsToPrice[sequence, default: 0] += secrets[i] % 10
            }
        }

        let maxSequence = diffsToPrice.max { $0.value < $1.value }!.key
        print("Max sequence: \(maxSequence)")

        print("Price for sequence\(testSequence) is: \(diffsToPrice[testSequence]!)")


        let maxPrice = diffsToPrice.values.max()!
    
        return "Max price: \(maxPrice)"
    }

    /*
    In particular, each buyer's secret number evolves into the next secret number in the sequence via the following process:
    Calculate the result of multiplying the secret number by 64. Then, mix this result into the secret number. Finally, prune the secret number.
    Calculate the result of dividing the secret number by 32. Round the result down to the nearest integer. Then, mix this result into the secret number. Finally, prune the secret number.
    Calculate the result of multiplying the secret number by 2048. Then, mix this result into the secret number. Finally, prune the secret number.
    Each step of the above process involves mixing and pruning:

    To mix a value into the secret number, calculate the bitwise XOR of the given value and the secret number. Then, the secret number becomes the result of that operation. (If the secret number is 42 and you were to mix 15 into the secret number, the secret number would become 37.)
    To prune the secret number, calculate the value of the secret number modulo 16777216. Then, the secret number becomes the result of that operation. (If the secret number is 100000000 and you were to prune the secret number, the secret number would become 16113920.)
    After this process completes, the buyer is left with the next secret number in the sequence. The buyer can repeat this process as many times as necessary to produce more secret numbers.
    */
    func evolve(secret: Int, times: Int = 1) -> Int {
        var s = secret & 0xFFFFFF  // ensure we start with only 24 bits
        for _ in 0..<times {
            // Step 1
            let left6 = (s << 6) & 0xFFFFFF
            s ^= left6
            s &= 0xFFFFFF

            // Step 2
            let right5 = s >> 5
            s ^= right5
            s &= 0xFFFFFF

            // Step 3
            let left11 = (s << 11) & 0xFFFFFF
            s ^= left11
            s &= 0xFFFFFF
        }
        return s
    }
}
