// https://adventofcode.com/2024/day/17
import Foundation

/*
So, the program 0,1,2,3 would run the instruction whose opcode is 0 and pass it the operand 1, then run the instruction having opcode 2 and pass it the operand 3, then halt.

There are two types of operands; each instruction specifies the type of its operand. The value of a literal operand is the operand itself. For example, the value of the literal operand 7 is the number 7. The value of a combo operand can be found as follows:

Combo operands 0 through 3 represent literal values 0 through 3.
Combo operand 4 represents the value of register A.
Combo operand 5 represents the value of register B.
Combo operand 6 represents the value of register C.
Combo operand 7 is reserved and will not appear in valid programs.
*/

class DaySeventeen: Day {
    let dayNumber: Int = 17
    let year = 2024
    
    enum Instruction: Int {
        case adv = 0
        case bxl = 1
        case bst = 2
        case jnz = 3
        case bxc = 4
        case out = 5
        case bdv = 6
        case cdv = 7
    }
    
    func parseInput(input: String) -> (ip: Int, a: Int, b: Int, c: Int, instructions: [Int]) {
        let lines = input.components(separatedBy: .newlines)
        let ip = 0
        let a = lines[0].components(separatedBy: ": ")[1]
        let b: String = lines[1].components(separatedBy: ": ")[1]
        let c: String = lines[2].components(separatedBy: ": ")[1]
        
        let instructions = lines.last!.components(separatedBy: ": ")[1].components(separatedBy: ",").map { Int($0)! }
        return (ip: ip, a: Int(a)!, b: Int(b)!, c: Int(c)!, instructions: instructions)
    }
    
    func partOne(input: String) -> String {
        let data = parseInput(input: input)
        // Just run forward:
        let output = runProgram(a: data.a)
        let outputString = output.map { String($0) }.joined(separator: ",")
        return "The output is: \(outputString)"
    }
    
    func runProgram(a: Int) -> [Int] {
        var A = a
        var B = 0
        var C = 0
        var output: [Int] = []
        
        while A != 0 {
            // Forward steps:
            // 1. B = A % 8
            B = A % 8
            // 2. B = B ^ 2
            B = B ^ 2
            // 3. C = A / (2^B)
            let divisor = 1 << B
            C = A / divisor
            // 4. B = B ^ 3
            B = B ^ 3
            // 5. B = B ^ C
            B = B ^ C
            // 6. out = B % 8
            output.append(B % 8)
            // 7. A = A / 8
            A = A / 8
        }
        
        return output
    }
    
    // MARK: Part Two Attempt
    
    func partTwo(input: String) -> String {
        let data = parseInput(input: input)
        var target = data.instructions
        target.reverse()
        let a = findA(prog: data.instructions, target: target)
        return "The value of register A is: \(a)"
    }

    // The backtracking function to find A:
    func findA(prog: [Int], target: [Int], a: Int = 0, depth: Int = 0) -> Int {
        // If we've matched all outputs in target:
        if depth == target.count {
            return a
        }
        
        // Try all possible next 3-bit increments (0 to 7):
        for i in 0..<8 {
            let candidateA = a * 8 + i
            let output = runProgram(a: candidateA)
            
            // We need at least one output and the first output should match target[depth]
            if let first = output.first, first == target[depth] {
                if let result = optionalFindAResult(prog: prog, target: target, a: candidateA, depth: depth+1) {
                    return result
                }
            }
        }
        return 0
    }

    // Helper to allow returning nil when no solution found:
    func optionalFindAResult(prog: [Int], target: [Int], a: Int, depth: Int) -> Int? {
        let res = findA(prog: prog, target: target, a: a, depth: depth)
        return res == 0 ? nil : res
    }
}

/*

Decoding the input program:
Register A: 48744869
Register B: 0
Register C: 0

Program: 2,4,1,2,7,5,1,3,4,4,5,5,0,3,3,0

0: 2,4:  bst 4; B = A % 8;
2: 1,2:  bxl 2; B = B ^ 2 = 4 ^ 2 = 6
4: 7,5:  cdv 5; C = A >> B = 48744869 >> 6 = 760763
6: 1,3:  bxl 3; B = B ^ 3 = 6 ^ 3 = 5
8: 4,4:  bxc 4; B = B ^ C = 5 ^ 760763 = 760758
10: 5,5: out 5; output B % 8 = 760758 % 8 = 6 
12: 0,3:  adv 3; A = A >> 3 = 48744869 >> 3 = 6093108
14: 3,3:  jnz 3; jump to 0 if A != 0
*/
