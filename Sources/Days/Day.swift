import Foundation

public protocol Day {
    var dayNumber: Int { get }

    func partOne(input: String) -> String
    func partTwo(input: String) -> String
    func run()
    func test()
}

extension Day {
    public var inputFileName: String {
        return "input\(String(format: "%02d", dayNumber)).txt"
    }

    public func loadInput() -> String {
        let basePath = "/Users/jovanradivojsa/Desktop/workspace/advent-of-code/advent-of-code-2024"
        let path = "\(basePath)/\(inputFileName)"
        return try! String(contentsOfFile: path, encoding: .utf8)
    }

    public func run() {
        let input = loadInput()
        print("Day \(dayNumber) - Part One: \(partOne(input: input))")
        print("Day \(dayNumber) - Part Two: \(partTwo(input: input))")
    }
}
