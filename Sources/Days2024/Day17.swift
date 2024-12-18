// https://adventofcode.com/2024/day/17
import Foundation

class DaySeventeen: Day {
    let dayNumber: Int = 17
    let year = 2024

    // MARK: - Instructions
    static let adv: Int = 0b000 // division. The numerator is in the A register, the denominator is found by raising 2 to the power of the instrucvtion's combo operand. So 0 2, would be A = A / 2^2 = A / 4.
    static let bxl: Int = 0b001 // bitwise XOR with literal. The B register is XORed with the literal value in the instruction's combo operand, and the result is stored in the B register.
    static let bst: Int = 0b010 // calculates the value of its combo operand, modulo 8 (keeping only it's lowest 3 bits), then writes that value to the B register.
    static let jnz: Int = 0b011 // jump if not zero. Does nothing if the A register is 0. Otherwise it sets IP to the value of the instruction's combo operand.
    static let bxc: Int = 0b100 // bitwise XOR registers B and C, then stores the result in the B register. It reands the combo operand, but does not use it.
    static let out: Int = 0b101 // outputs the value of the A register to the terminal.
    static let bdv: Int = 0b110 // The same as adv, only using the B register instead of the A register. (The numerator is still in the A register.)
    static let cdv: Int = 0b111 // The same as adv, only using the C register instead of the A register. (The numerator is still in the A register.)

    // MARK:- Part One

    /*
    Example Input:
    Register A: 729
    Register B: 0
    Register C: 0

    Program: 0,1,5,4,3,0
    */
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
        var a = data.a
        var b = data.b
        var c = data.c
        var ip = data.ip
        var instructions = data.instructions

        while ip < instructions.count {}
        
        return ""
    }

    // MARK:- Part Two

    func partTwo(input: String) -> String {
    
        return ""
    }
}