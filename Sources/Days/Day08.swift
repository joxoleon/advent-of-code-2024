// https://adventofcode.com/2020/day/8
import Foundation

class DayEight: Day {
    let dayNumber = 8

    // MARK: - Part One

    func partOne(input: String) -> String {
        let matrix: [[Character]] = input.components(separatedBy: .newlines).map {  Array($0) }
        let constraints = MapConstraints(maxI: matrix.count, maxJ: matrix[0].count)
        
        var antennaLocationsMap: [Character: [Location]] = [:]
        // Populate antenna locations dictionary
        for i in 0..<matrix.count {
            for j in 0..<matrix[i].count {
                let char = matrix[i][j]
                if char != "." {
                    if antennaLocationsMap[char] == nil {
                        antennaLocationsMap[char] = []
                    }
                    antennaLocationsMap[char]?.append(Location(i: i, j: j))
                }
            }
        }

        var antennaAntinodeLocationDictionary: [Character: Set<Location>] = [:]
        // Populate antinode locations dictionary
        for (antenna, locations) in antennaLocationsMap {
            let antinodeLocations = DayEight.antinodeLocations(locations, constraints: constraints)
            antennaAntinodeLocationDictionary[antenna] = Set(antinodeLocations)
        }

        let allAntinodeLocations = antennaAntinodeLocationDictionary.values.reduce(into: Set<Location>()) { $0.formUnion($1) }
        return "Antinode Unique Location Count: \(allAntinodeLocations.count)"
    }

    // MARK: - Utility Functions

    // MARK: - Part Two

    func partTwo(input: String) -> String {
        let matrix: [[Character]] = input.components(separatedBy: .newlines).map {  Array($0) }
        let constraints = MapConstraints(maxI: matrix.count, maxJ: matrix[0].count)
        
        var antennaLocationsMap: [Character: [Location]] = [:]
        // Populate antenna locations dictionary
        for i in 0..<matrix.count {
            for j in 0..<matrix[i].count {
                let char = matrix[i][j]
                if char != "." {
                    if antennaLocationsMap[char] == nil {
                        antennaLocationsMap[char] = []
                    }
                    antennaLocationsMap[char]?.append(Location(i: i, j: j))
                }
            }
        }

        var antennaAntinodeLocationDictionary: [Character: Set<Location>] = [:]
        // Populate antinode locations dictionary
        for (antenna, locations) in antennaLocationsMap {
            let antinodeLocations = DayEight.antinodeLocationsWithResonance(locations, constraints)
            antennaAntinodeLocationDictionary[antenna] = Set(antinodeLocations)
        }

        let allAntinodeLocations = antennaAntinodeLocationDictionary.values.reduce(into: Set<Location>()) { $0.formUnion($1) }
        return "Antinode Unique Location Count: \(allAntinodeLocations.count)"
    }

    // MARK: - Utility Functions

    // MARK: - Testing

    func drawMatrix(_ matrix: [[Character]]) {
        let rowStrings = matrix.map { String($0) }
        let mapString = rowStrings.joined(separator: "\n")
        print(mapString)
    }

    func populateMatrixWithAntinodes(_ matrix: [[Character]], antinodeLocations: [Location]) -> [[Character]] {
        var newMatrix = matrix
        for location in antinodeLocations {
            if newMatrix[location.i][location.j] == "." {
                newMatrix[location.i][location.j] = "#"
            }
        }
        return newMatrix
    }

    func test() {

    }
}

// MARK: - Types

extension DayEight {

    struct Location: Hashable {
        let i: Int
        let j: Int

        func isWithin(_ constraints: MapConstraints) -> Bool {
            return i >= 0 && i < constraints.maxI && j >= 0 && j < constraints.maxJ
        }
    }

    struct MapConstraints {
        let maxI: Int
        let maxJ: Int
    }

    // PART ONE
    static func antinodeLocations(_ l1: Location, _ l2: Location, _ constraints: MapConstraints) -> [Location] {
        let l1Antinode = Location(
            i: l1.i + (l1.i - l2.i),
            j: l1.j + (l1.j - l2.j)
        )

        let l2Antinode = Location(
            i: l2.i + (l2.i - l1.i),
            j: l2.j + (l2.j - l1.j)
        )

        var antinodeLocations: [Location] = []
        if l1Antinode.isWithin(constraints) {
            antinodeLocations.append(l1Antinode)
        }
        if l2Antinode.isWithin(constraints) {
            antinodeLocations.append(l2Antinode)
        }
        return antinodeLocations
    }

    static func antinodeLocations(_ locations: [Location], constraints: MapConstraints) -> [Location] {
        var antinodeLocations: [Location] = []
        for i in 0..<locations.count {
            for j in i+1..<locations.count {
                antinodeLocations.append(contentsOf: DayEight.antinodeLocations(locations[i], locations[j], constraints))
            }
        }
        return antinodeLocations
    }

    // PART TWO
    static func antinodeLocationsWithResonance(_ l1: Location, _ l2: Location, _ constraints: MapConstraints) -> [Location] {
        let l1di = l1.i - l2.i
        let l1dj = l1.j - l2.j
        var l1AntinodeLocations: [Location] = []
        var l1Antinode = Location(i: l1.i + l1di, j: l1.j + l1dj)
        while l1Antinode.isWithin(constraints) {
            l1AntinodeLocations.append(l1Antinode)
            l1Antinode = Location(i: l1Antinode.i + l1di, j: l1Antinode.j + l1dj)
        }

        let l2di = l2.i - l1.i
        let l2dj = l2.j - l1.j
        var l2AntinodeLocations: [Location] = []
        var l2Antinode = Location(i: l2.i + l2di, j: l2.j + l2dj)
        while l2Antinode.isWithin(constraints) {
            l2AntinodeLocations.append(l2Antinode)
            l2Antinode = Location(i: l2Antinode.i + l2di, j: l2Antinode.j + l2dj)
        }

        return l1AntinodeLocations + l2AntinodeLocations + [l1, l2]
    }

    static func antinodeLocationsWithResonance(_ locations: [Location], _ constraints: MapConstraints) -> [Location] {
        var antinodeLocations: [Location] = []
        for i in 0..<locations.count {
            for j in i+1..<locations.count {
                antinodeLocations.append(contentsOf: DayEight.antinodeLocationsWithResonance(locations[i], locations[j], constraints))
            }
        }
        return antinodeLocations
    }
}
