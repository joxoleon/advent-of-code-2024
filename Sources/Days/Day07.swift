// https://adventofcode.com/2020/day/7
import Foundation

class DaySeven: Day {
    let dayNumber = 7
    
    func partOne(input: String) -> String {
        let inputs = input.components(separatedBy: "\n").filter { $0.isEmpty == false }
        var totalSum: Int128 = 0
        for input in inputs {
            let parts = input.components(separatedBy: ":")
            let result = Int128(parts[0])!
            let operands = parts[1].components(separatedBy: " ").compactMap { Int($0) }
            totalSum += processInput(result: result, operands: operands)
        }

        return "total sum: \(totalSum)"
    }

    private func processInput(result: Int128, operands: [Int]) -> Int128 {
        let operatorCount = operands.count - 1
        let maxOperatorCode = 1 << operatorCount
        for operatorCode in 0..<maxOperatorCode {
            let currentResult = evaluate(operands: operands, operatorCode: operatorCode)
            if currentResult == result {
                return result
            }
        }
        
        return 0
    }

    private func evaluate(operands: [Int], operatorCode: Int) -> Int128 {
        var result = Int128(operands[0])
        for i in 1..<operands.count {
            let operatorBit = (operatorCode >> (operands.count - i - 1)) & 1
            switch operatorBit {
            case 0:
                result += Int128(operands[i])
            case 1:
                result *= Int128(operands[i])
            default:
                assertionFailure()
            }
        }
        return result
    }

    // MARK: - Part Two

    func partTwo(input: String) -> String {
        let inputs = input.components(separatedBy: "\n").filter { $0.isEmpty == false }
        var totalSum: Int128 = 0
        for input in inputs {
            let parts = input.components(separatedBy: ":")
            let result = Int128(parts[0])!
            let operands = parts[1].components(separatedBy: " ").compactMap { Int($0) }
            // Try binary first
            var resultValue = processInput(result: result, operands: operands)
            if resultValue == 0 {
                // Try ternary
                resultValue = processInputTernary(result: result, operands: operands)
            }
            totalSum += resultValue
        }
        return "total sum: \(totalSum)"
    }
    
    func processInputTernary(result: Int128, operands: [Int]) -> Int128 {
        print("Processing input: \(result) \(operands)")
        let operatorCount = operands.count - 1
        let maxOperatorCode = Int(pow(3.0, Double(operatorCount)))
        for operatorCode in 0..<maxOperatorCode {
            let currentResult = evaluateTernary(operands: operands, operatorCode: operatorCode)
            if currentResult == result {
                return result
            }
        }
        
        return 0
    }
    
    func evaluateTernary(operands: [Int], operatorCode: Int) -> Int128 {
        var result = Int128(operands[0])
        var code = operatorCode
        for i in 1..<operands.count {
            let operatorValue = code % 3
            code /= 3

            switch operatorValue {
            case 0: // Addition
                result += Int128(operands[i])
            case 1: // Multiplication
                result *= Int128(operands[i])
            case 2: // Concatenation
                result = Int128("\(result)\(operands[i])")!
            default:
                assertionFailure("Unexpected operator value")
            }
        }
        return result
    }
    
    // MARK: - Testing
    
    func test() {
        testEvaluateTernary()
        print("Tests successful")
    }

    func testEvaluate() {
        var result = evaluate(operands: [1, 2, 3, 4], operatorCode: 0b101)
        assert(result == 20)

        result = evaluate(operands: [1, 2, 3, 4], operatorCode: 0)
        assert(result == 10)

        result = evaluate(operands: [1, 2, 3, 4], operatorCode: 0b111)
        assert(result == 24)
    }

    func testProcessInput() {
        var result = processInput(result: 20, operands: [1, 2, 3, 4])
        assert(result == 20)

        result = processInput(result: 10, operands: [1, 2, 3, 4])
        assert(result == 10)

        result = processInput(result: 24, operands: [1, 2, 3, 4])
        assert(result == 24)
        
        result = processInput(result: 36, operands: [1, 2, 3, 4])
        assert(result == 36)
        
        result = processInput(result: 200, operands: [1, 2, 3, 4])
        assert(result == 0)
    }

    func testEvaluateTernary() {
        var result = evaluateTernary(operands: [1, 2, 3, 4], operatorCode: 10)
        assert(result == 20)

        result = evaluateTernary(operands: [1, 2, 3, 4], operatorCode: 26)
        assert(result == 1234)

        result = evaluateTernary(operands: [1, 2, 3, 4], operatorCode: 14)
        assert(result == 144)
    }
    
}
