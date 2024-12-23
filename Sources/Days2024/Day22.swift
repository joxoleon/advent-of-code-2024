// https://adventofcode.com/2024/day/22
import Foundation

import Foundation

class DayTwentyTwo: Day {
    let dayNumber: Int = 22
    let year: Int = 2024
    
    func partOne(input: String) -> String {
        let secrets = input.components(separatedBy: .newlines)
            .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        
        let sum = secrets.map { initial in
            var secret = initial
            for _ in 0..<2000 {
                secret = DayTwentyTwo.evolveSecret(secret)
            }
            return secret
        }.reduce(0, +)
        
        return "\(sum)"
    }
    
    static func evolveSecret(_ secret: Int) -> Int {
        var s = secret
        let step1 = s * 64
        s ^= (step1 & 0xFFFFFF)
        s &= 0xFFFFFF
        
        let step2 = s / 32
        s ^= step2
        s &= 0xFFFFFF
        
        let step3 = s * 2048
        s ^= (step3 & 0xFFFFFF)
        s &= 0xFFFFFF
        
        return s
    }
    
    func partTwo(input: String) -> String {
        let inputs = input.components(separatedBy: .newlines)
            .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        
        let maxSequenceLength = 4
        let maxPrice = 10
        var maxTotal = 0
        
        // Precompute all possible 4-change sequences
        let allSequences = generateAllSequences(length: maxSequenceLength, range: -maxPrice..<maxPrice)
        var sequenceScores = [String: Int](minimumCapacity: allSequences.count)

        DispatchQueue.concurrentPerform(iterations: allSequences.count) { i in
            let sequence = allSequences[i]
            let sequenceKey = sequence.map(String.init).joined(separator: ",")
            var total = 0
            
            for initial in inputs {
                if let prices = DayTwentyTwo.matchSequence(initial: initial, sequence: sequence) {
                    total += prices
                }
            }
            
            sequenceScores[sequenceKey] = total
            DispatchQueue.main.sync {
                maxTotal = max(maxTotal, total)
            }
        }
        
        return "\(maxTotal)"
    }

    static func matchSequence(initial: Int, sequence: [Int]) -> Int? {
        var current = initial
        var prices = [Int]()
        var changes = [Int]()
        var seen = [Int: Int]()
        var index = 0
        
        while index < 2000 {
            let price = current % 10
            prices.append(price)
            if prices.count > 1 {
                changes.append(price - prices[prices.count - 2])
                if changes.count >= sequence.count {
                    if changes.suffix(sequence.count).elementsEqual(sequence) {
                        return prices.last
                    }
                }
            }
            
            current = evolveSecret(current)
            index += 1
        }
        
        return nil
    }

    func generateAllSequences(length: Int, range: Range<Int>) -> [[Int]] {
        if length == 1 {
            return range.map { [$0] }
        }
        let shorter = generateAllSequences(length: length - 1, range: range)
        return shorter.flatMap { seq in range.map { seq + [$0] } }
    }

}
