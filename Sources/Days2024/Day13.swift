// https://adventofcode.com/2024/day/13
import Foundation

class DayThirteen: Day {
    let dayNumber: Int = 13
    let year: Int = 2024

    static func solveSystem(ax: Int, bx: Int, ay: Int, by: Int, xTarget: Int, yTarget: Int) -> (xA: Int?, xB: Int?)? {
        // 1. Calculate the determinant of the matrix [a, b; c, d]
        let determinant = ax * by - bx * ay
        let epsilon = 1e-4
        if abs(Double(determinant)) < epsilon {
            print("The system is singular (determinant is too close to zero), so no unique solution exists.")
            return nil
        }

        // 2. Calculate the inverse of the matrix
        let inverseA = Double(by) / Double(determinant)
        let inverseB = Double(-bx) / Double(determinant)
        let inverseC = Double(-ay) / Double(determinant)
        let inverseD = Double(ax) / Double(determinant)

        // 3. Multiply the inverse matrix by the target vector
        let a = inverseA * Double(xTarget) + inverseB * Double(yTarget)
        let b = inverseC * Double(xTarget) + inverseD * Double(yTarget)
        
        // 4. Round the results to avoid floating-point precision issues
        let roundedA = a.rounded()
        let roundedB = b.rounded()
        
        // 5. Check if the rounded values are integers
        let isXAInteger = abs(a - roundedA) < epsilon
        let isXBInteger = abs(b - roundedB) < epsilon

        if isXAInteger && isXBInteger {
            if roundedA > Double(Int.max) || roundedB > Double(Int.max) {
                print("Solution exceeds Int range. Skipping solution. xA = \(roundedA), xB = \(roundedB)")
                return nil
            }
            
            let intA = Int(roundedA)
            let intB = Int(roundedB)
            if intA >= 0 && intB >= 0 { 
                print("Solution found: xA = \(intA), xB = \(intB)")
                return (xA: intA, xB: intB)
            } else {
                print("Negative solution found. Ignoring this solution. xA = \(intA), xB = \(intB)")
                return nil
            }
        } else {
            print("No integer solution for this system. a = \(a), b = \(b)")
            return nil
        }
    }

    // MARK: - Part One
    
    func partOne(input: String) -> String {
        var tokenSum = 0
        let aTokens = 3
        let bTokens = 1
        let offset = 10000000000000 // Offset is 0 for part one and 10000000000000 for part two

        let equations = input.split(separator: "\n\n")
        for equation in equations {
            let parsedEquation = parseEquation(equationLines: String(equation))
            let xTarget = offset + parsedEquation.xTarget
            let yTarget = offset + parsedEquation.yTarget
            let result = DayThirteen.solveSystem(ax: parsedEquation.ax, bx: parsedEquation.bx, ay: parsedEquation.ay, by: parsedEquation.by, xTarget: xTarget, yTarget: yTarget)
            if let a = result?.xA, let b = result?.xB {
                tokenSum += a * aTokens + b * bTokens
            }
        }

        return "Total tokens: \(tokenSum)"
    }

    /* 
        Button A: X+94, Y+34
        Button B: X+22, Y+67
        Prize: X=8400, Y=5400
    */
    private func parseEquation(equationLines: String) -> (ax: Int, bx: Int, ay: Int, by: Int, xTarget: Int, yTarget: Int) {
        let lines = equationLines.split(separator: "\n")
        assert(lines.count == 3)

        // Get ax, and ay
        let firstLine = lines[0].split(separator: ": ").last!
        let firstLineParts = firstLine.split(separator: ", ")
        let ax = Int(firstLineParts[0].split(separator: "+").last!)!
        let ay = Int(firstLineParts[1].split(separator: "+").last!)!

        // Get bx, and by
        let secondLine = lines[1].split(separator: ": ").last!
        let secondLineParts = secondLine.split(separator: ", ")
        let bx = Int(secondLineParts[0].split(separator: "+").last!)!
        let by = Int(secondLineParts[1].split(separator: "+").last!)!

        // Get xTarget, and yTarget
        let thirdLine = lines[2].split(separator: ": ").last!
        let thirdLineParts = thirdLine.split(separator: ", ")
        let xTarget = Int(thirdLineParts[0].split(separator: "=").last!)!
        let yTarget = Int(thirdLineParts[1].split(separator: "=").last!)! 

        return (ax: ax, bx: bx, ay: ay, by: by, xTarget: xTarget, yTarget: yTarget)
    }

    // MARK: - Part Two

    func partTwo(input: String) -> String {
        return ""
    }

    func test() {
        let result = DayThirteen.solveSystem(ax: 94, bx: 22, ay: 34, by: 67, xTarget: 8400, yTarget: 5400)
        print(result!)
    }
}