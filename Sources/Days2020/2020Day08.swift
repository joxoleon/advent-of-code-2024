// https://adventofcode.com/2020/day/8
import Foundation

class DayEight2020: Day {
    let dayNumber = 9
    let year = 2020
    
    var accumulator = 0
    var instructionPointer = 0
    var visitedInstructions: Set<Int> = []

    // MARK: - Part One

    func partOne(input: String) -> String {
        let instructions = input.components(separatedBy: .newlines)
        while visitedInstructions.contains(instructionPointer) == false {
            let (operation, value) = parseInstruction(instruction: instructions[instructionPointer])
            executeInstruction(operation: operation, value: value)
        }
        return "Accumulator value: \(accumulator)"
    }


    // MARK: - Part Two

    func partTwo(input: String) -> String {
        clear()
        let instructionLines = input.components(separatedBy: .newlines)
        let instructions = instructionLines.map { parseInstruction(instruction: $0) }

        for i in 0..<instructions.count {
            var modifiedInstructions = instructions
            if instructions[i].operation == "nop" {
                modifiedInstructions[i].operation = "jmp"
            }
            else if instructions[i].operation == "jmp" {
                modifiedInstructions[i].operation = "nop"
            }

            clear()
            while visitedInstructions.contains(instructionPointer) == false && instructionPointer < instructions.count {
                let (operation, value) = modifiedInstructions[instructionPointer]
                executeInstruction(operation: operation, value: value)
            }

            if instructionPointer == modifiedInstructions.count {
                break
            }
        }

        return "Accumulator value: \(accumulator)"
    }

    // MARK: - Utility Functions

    func parseInstruction(instruction: String) -> (operation: String, value: Int) {
        let parts = instruction.components(separatedBy: " ")
        let value = Int(parts[1])!
        let operation = parts[0]
        return (operation, value)
    }

    func executeInstruction(operation: String, value: Int) {
        visitedInstructions.insert(instructionPointer)
        switch operation {
            case "nop":
                instructionPointer += 1
            case "acc":
                accumulator += value
                instructionPointer += 1
            case "jmp":
                instructionPointer += value
            default:
                assertionFailure()
        }
    }


    // MARK: - Testing

    func test() {

    }

    func clear() {
        accumulator = 0
        instructionPointer = 0
        visitedInstructions = []
    }
}
