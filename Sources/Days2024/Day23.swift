// https://adventofcode.com/2024/day/22
import Foundation
import Algorithms

class DayTwentyThree: Day {
    let dayNumber: Int = 23
    let year: Int = 2024

    var cliques: Set<Set<String>> = []
    var targetConnection = 3

    // MARK: - Part One
    func partOne(input: String) -> String {
        let connections = input.components(separatedBy: .newlines)
        var graph = [String: Set<String>]()
        for connection in connections {
            let parts = connection.components(separatedBy: "-")
            graph[parts[0], default: []].insert(parts[1])
            graph[parts[1], default: []].insert(parts[0])
        }

        let namesStartWithT = graph.keys.filter { $0.hasPrefix("t") }
        for name in namesStartWithT {
            populateCliques(graph: graph, name: name, targetElements: targetConnection)
        }

        return "Number of connected sets: \(cliques.count)"
    }

    func populateCliques(graph: [String: Set<String>], name: String, targetElements: Int) {
        let combinations = graph[name]!.combinations(ofCount: targetElements - 1)
        
        for combination in combinations {
            guard let first = combination.first, let last = combination.last, first != last else { continue }
            guard graph[first]!.contains(last) else { continue }
            let connectedSet = Set([name, first, last])
            cliques.insert(connectedSet)
        }
    }

    // MARK: - Part Two

    func partTwo(input: String) -> String {
        let connections = input.components(separatedBy: .newlines)
        var graph = [String: Set<String>]()
        for connection in connections {
            let parts = connection.components(separatedBy: "-")
            graph[parts[0], default: []].insert(parts[1])
            graph[parts[1], default: []].insert(parts[0])
        }

        let largestClique = findLargestClique(graph: graph)
        let password = largestClique.sorted().joined(separator: ",")
        return "Password to get into the LAN party: \(password)"
    }

    func findLargestClique(graph: [String: Set<String>]) -> [String] {
        var largestClique: [String] = []

        // Recursive Bron-Kerbosch function with pivoting
        func bronKerbosch(r: Set<String>, p: Set<String>, x: Set<String>) {
            print("R: \(r), P: \(p), X: \(x)") // Debugging log

            // Base case: If P and X are empty, R is a maximal clique
            if p.isEmpty && x.isEmpty {
                if r.count > largestClique.count {
                    largestClique = Array(r)
                    print("New largest clique found: \(largestClique)")
                }
                return
            }

            // Choose a pivot to reduce the size of P
            let pivot = (p.union(x).first!) // Select any vertex from P ∪ X
            let pivotNeighbors = graph[pivot] ?? []

            // Iterate over candidates in P not connected to the pivot
            for vertex in p.subtracting(pivotNeighbors) {
                let neighbors = graph[vertex] ?? []

                // Recursive call
                bronKerbosch(
                    r: r.union([vertex]), // Add vertex to R
                    p: p.intersection(neighbors), // Restrict P to neighbors of vertex
                    x: x.intersection(neighbors) // Restrict X to neighbors of vertex
                )

                // Move vertex from P to X
                var newP = p
                var newX = x
                newP.remove(vertex)
                newX.insert(vertex)
            }
        }

        // Initialize the recursion
        bronKerbosch(r: [], p: Set(graph.keys), x: [])
        return largestClique
    }
}