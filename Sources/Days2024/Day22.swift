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

        struct FourDiffSequence: Hashable {
            let diffs: [Int]

            // Initialize with a sequence of 4 diffs
            init(diffs: [Int]) {
                self.diffs = diffs
            }
        }
        var diffsToPrice = [FourDiffSequence: Int]()

        for i in 0..<inputs.count {
            let input = inputs[i]
            print("Processing input: \(i)/\(inputs.count)")
            
            // Secret evolution
            var secrets = Array(repeating: 0, count: n)
            for i in 0..<n {
                secrets[i] = evolve(secret: input, times: i)
            }

            // Diff evolution
            var diffs = Array(repeating: 0, count: n)
            for i in 1..<n {
                diffs[i] = (secrets[i] % 10) - (secrets[i - 1] % 10)
            }

            // Sequence creation
            for i in 4..<n {
                let sequence = FourDiffSequence(diffs: Array(diffs[i-4...i-1]))
                diffsToPrice[sequence, default: 0] += secrets[i] % 10
            }
        }

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

    func evolveSecretsAndDiffs(secret: Int, times: Int = 10) -> (secrets: [Int], diffs: [Int], maxDiff: Int, sequence: [Int]) {
        var secrets = Array(repeating: 0, count: times)
        secrets[0] = secret
        var diffs = Array(repeating: 0, count: times)
        var maxDiffIndex = 0
        var maxDiff = 0
        for i in 1..<times {
            let newSecret = evolve(secret: secrets[i - 1])
            secrets[i] = newSecret
            let nsv = newSecret % 10
            let psv = secrets[i - 1] % 10
            diffs[i] = nsv - psv
            if diffs[i] > maxDiff && i > 3 {
                maxDiff = diffs[i]
                maxDiffIndex = i
            }
        }
        let sequence = Array(diffs[maxDiffIndex-3...maxDiffIndex])
        return (secrets, diffs, maxDiff, sequence)

    }
}
