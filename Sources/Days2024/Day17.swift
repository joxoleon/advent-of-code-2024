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
    
    // MARK: Part Two Attempt (Back-Solving)

    // Suppose we know the desired output sequence and we want to find A.
    // We'll try to reconstruct A by going backwards.
    
    // We'll define a helper function that tries to find A given the desired output.
    func partTwo(input: String) -> String {
        let data = parseInput(input: input)
        // The desired output should be the program instructions themselves.
        let desiredOutput = data.instructions // The puzzle states: output a copy of itself.
        
        // We'll try to back solve for the smallest positive A that leads to this output.
        // Strategy:
        // - Each iteration in forward direction consumes A and produces one output.
        // - Backward: Start from A_final = 0 and reconstruct backwards.
        // The number of iterations is equal to desiredOutput.count.
        
        if let foundA = backSolveForA(desiredOutput: desiredOutput) {
            return "The value of A that causes the program to output a copy of itself is: \(foundA)"
        } else {
            return "No solution found."
        }
    }
    
    // Backward solver:
    // Given an output sequence, we reconstruct A starting from the end.
    func backSolveForA(desiredOutput: [Int]) -> Int? {
        // We know at the end A_final = 0
        // We'll build A step by step going backwards.
        // Let’s denote:
        // forward:
        // A_i -> iteration -> A_(i+1)
        //
        // backward:
        // We start from A_end = 0 and go backwards to A_start.
        
        var A_next = 0
        // We'll go backwards from the last output to the first.
        for out in desiredOutput.reversed() {
            // We know after the iteration:
            // A_(i+1) = A_i / 8
            // => A_i = A_(i+1)*8 + (A_i % 8)
            // Also we know from forward steps how output was produced:
            // Steps forward reminder:
            //  B0 = A_i % 8
            //  B2 = B0 ^ 2
            //  C = A_i / (2^B2)
            //  B4 = B2 ^ 3
            //  B5 = B4 ^ C
            //  out = B5 % 8
            //
            // backward:
            // Given out, A_(i+1), we try all B0 in [0..7].
            // For each B0, compute B2, B4:
            //   B2 = B0 ^ 2
            //   B4 = B2 ^ 3
            // We know out = B5 % 8 and B5 = B4 ^ C.
            // So B5 and B4 differ by C. But C = A_i / (2^B2).
            //
            // A_i must be consistent:
            //   A_i = A_(i+1)*8 + B0
            //   C = A_i / (2^B2)
            //
            // Once we pick B0, we know A_i candidate.
            // From B0, B2 = B0^2, we know divisor = 2^(B2).
            // A_i must be such that we can find a C that makes out = (B4 ^ C) % 8.
            
            // Let's try all B0 in [0..7].
            var A_candidate: Int? = nil
            outer: for B0 in 0...7 {
                let A_i = A_next * 8 + B0
                let B2 = B0 ^ 2
                let B4 = B2 ^ 3
                
                // C = A_i / (2^B2)
                let divisor = 1 << B2
                let C = A_i / divisor
                
                // We have out = (B4 ^ C) % 8
                // That means (B4 ^ C) % 8 = out
                // Let’s consider (B4 ^ C).
                // C might be large, but mod 8 we only need last 3 bits of C and B4.
                
                // Check if there's a C that matches this condition:
                // We have B4 (0..7 since B4 is from XOR of small numbers?), B4 is small:
                // Actually, B4 is also in range 0..7 since it's XOR of values in [0..7].
                let B4_mod_8 = B4 & 7
                // We want: (B4 ^ C) % 8 = out
                // Focus on mod 8: Let’s only consider C mod 8:
                let C_mod_8 = C & 7
                
                // (B4_mod_8 ^ C_mod_8) == out
                // Check if this holds:
                if (B4_mod_8 ^ C_mod_8) == out {
                    // This B0 and A_i works for this iteration
                    A_candidate = A_i
                    break outer
                }
            }
            
            guard let A_found = A_candidate else {
                // No B0 led to a consistent A_i
                return nil
            }
            
            // Move to previous iteration:
            A_next = A_found
        }
        
        // After reconstructing all iterations, A_next is our initial A.
        // Check if A_next > 0 as requested.
        if A_next > 0 {
            return A_next
        } else {
            return nil
        }
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
