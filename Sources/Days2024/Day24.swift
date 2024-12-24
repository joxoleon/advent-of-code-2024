import Collections
// https://advetofcode.com/2024/day/24
import Foundation

class DayTwentyFour: Day {
    let dayNumber: Int = 24
    let year: Int = 2024
    struct Expression: Hashable {
        var left: String
        var right: String
        var operation: String
        var output: String

        init(_ str: String) {
            let parts = str.split(separator: " -> ")
            output = String(parts[1])
            let expr = parts[0].split(separator: " ")
            left = String(expr[0])
            operation = String(expr[1])
            right = String(expr[2])
        }

        func hasDependencies(values: [String: Int]) -> Bool {
            return values[left] != nil && values[right] != nil
        }

        /*
        AND gates output 1 if both inputs are 1; if either input is 0, these gates output 0.
        OR gates output 1 if one or both inputs is 1; if both inputs are 0, these gates output 0.
        XOR gates output 1 if the inputs are different; if the inputs are the same, these gates output 0.
        */
        func evaluate(values: inout [String: Int]) {
            if hasDependencies(values: values) == false { fatalError() }

            // Evaluate
            switch operation {
            case "AND":
                values[output] = values[left]! & values[right]!
            case "OR":
                values[output] = values[left]! | values[right]!
            case "XOR":
                values[output] = values[left]! ^ values[right]!
            default:
                fatalError("Unknown operation: \(operation)")
            }
        }
    }

    // MARK: - Part One
    func partOne(input: String) -> String {
        var values = [String: Int]()
        let parts = input.split(separator: "\n\n")

        // Parse the input values
        for part in parts[0].split(separator: "\n") {
            let split = part.split(separator: ": ")
            values[String(split[0])] = Int(split[1])!
        }

        // Parse the expressions
        let expressionStrings = parts[1].split(separator: "\n")
        let expressions = expressionStrings.map { Expression(String($0)) }

        var q = Deque<Expression>()
        q.append(contentsOf: expressions)
        while !q.isEmpty {
            let expr = q.removeFirst()
            if expr.hasDependencies(values: values) {
                expr.evaluate(values: &values)
            } else {
                q.append(expr)
            }
        }

        let res = getFullValue(values: values, startsWith: "z")

        return "\(res)"
    }

    func getFullValue(values: [String: Int], startsWith: String) -> Int {
        let zValues = values.filter { $0.key.starts(with: startsWith) }
        let sorted = zValues.sorted { $0.key < $1.key }
        var result = 0
        for (index, value) in sorted.enumerated() {
            print("\(index): \(value.key) = \(value.value)")
            result |= value.value << index
        }
        return result
    }

    // MARK: - Part Two
    func partTwo(input: String) -> String {
        let res =  formatSwappedWires(swaps: [
            ("btb", "mwp"),
            ("cmv", "z17"),
            ("rdg", "z30"),
            ("rmj", "z23"),
            ]
        )

        return "Swapped wivers are: \(res)"
    }
}

// Graphviz

extension DayTwentyFour {
    func generateGraphviz(input: String) -> String {
        var graphviz = "digraph LogicGraph {\n"

        var values = [String: Int]()
        let parts = input.split(separator: "\n\n")

        // Parse the input values
        for part in parts[0].split(separator: "\n") {
            let split = part.split(separator: ": ")
            let wire = String(split[0])
            let value = Int(split[1])!
            values[wire] = value
            graphviz += "    \"\(wire)\" [shape=circle, style=filled, fillcolor=lightblue];\n"
        }

        // Parse the expressions
        let expressionStrings = parts[1].split(separator: "\n")
        let expressions = expressionStrings.map { Expression(String($0)) }

        for expr in expressions {
            // Add the operation node
            let operationNode = "\(expr.left) \(expr.operation) \(expr.right)"
            graphviz +=
                "    \"\(operationNode)\" [label=\"\(expr.operation)\", shape=box, style=filled, fillcolor=yellow];\n"

            // Add connections to the operation node
            graphviz += "    \"\(expr.left)\" -> \"\(operationNode)\";\n"
            graphviz += "    \"\(expr.right)\" -> \"\(operationNode)\";\n"

            // Add connection from the operation node to the output
            graphviz += "    \"\(operationNode)\" -> \"\(expr.output)\";\n"
        }

        graphviz += "}\n"
        return graphviz
    }

    func formatSwappedWires(swaps: [(String, String)]) -> String {
        // Extract all wires from the swaps
        var wires = swaps.flatMap { [$0.0, $0.1] }

        // Sort the wires alphabetically
        wires.sort()

        // Join them into a single comma-separated string
        return wires.joined(separator: ",")
    }
}

/*
Sus outputs:
z17 - cmv
z23 - rmj
z30 - rdg
btb - mwp
It's at z38, but it's not z38, it's actually above it
Most likely btb and mwp
*/

/*
// Initial graph


*/
