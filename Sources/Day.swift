import Foundation

public protocol Day {
    var dayNumber: Int { get }
    var year: Int { get }

    func partOne(input: String) -> String
    func partTwo(input: String) -> String
    func run()
}

extension Day {
    public var inputFileName: String {
        return "input\(String(format: "%02d", dayNumber)).txt"
    }

    public func loadInput() -> String {
        let basePath = "/Users/jovanradivojsa/Desktop/workspace/advent-of-code/advent-of-code-2024/Input/\(year)"
        let path = "\(basePath)/\(inputFileName)"
        return try! String(contentsOfFile: path, encoding: .utf8)
    }

    public func run() {
        let input = loadInput()
        let partOneStartTime = Date()
        let partOneResult = partOne(input: input)
        let partOneElapsedTimeInterval = Date().timeIntervalSince(partOneStartTime)
        print("Day \(dayNumber) - Part One: \(partOneResult) - Elapsed Time: \(partOneElapsedTimeInterval)s")

        let partTwoStartTime = Date()
        let partTwoResult = partTwo(input: input)
        let partTwoElapsedTimeInterval = Date().timeIntervalSince(partTwoStartTime)
        print("Day \(dayNumber) - Part Two: \(partTwoResult) - Elapsed Time: \(partTwoElapsedTimeInterval)s")
    }
}
