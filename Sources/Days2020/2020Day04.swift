// https://adventofcode.com/2020/day/4
import Foundation

class DayFour2020: Day {
    let dayNumber: Int = 4
    let year: Int = 2020

    // MARK: - Part One

    func partOne(input: String) -> String {
        let passports = input.components(separatedBy: "\n\n")
        var validCount = 0
        var eightCount = 0
        for passport in passports {
            let fields = passport.components(separatedBy: .whitespacesAndNewlines)
            eightCount += fields.count == 8 ? 1 : 0
            validCount += isValid(passport: fields) ? 1 : 0
        }
        print("Eight count: \(eightCount)")
        return "Valid count: \(validCount)"
    }

    private func isValid(passport: [String]) -> Bool {
        if passport.count < 7 { return false }
        if passport.count == 7 {
            let containsCid = passport.first { $0.contains("cid:") } != nil
            if containsCid { return false }
        }

        return true
    }

    private func fullyValidate(passport: [String]) -> Bool {
        // validate byr:
        guard let byrValue = fetch("byr:", passport) else { return false }
        guard let yearInt = Int(byrValue) else { return false }
        guard yearInt >= 1920, yearInt <= 2002 else { return false }

        // validate iyr
        guard let iyr = fetch("iyr:", passport) else { return false }
        guard let iyrInt = Int(iyr) else { return false }
        guard iyrInt >= 2010 && iyrInt <= 2020 else { return false }

        // validate eyr
        guard let eyr = fetch("eyr:", passport) else { return false }
        guard let eyrInt = Int(eyr) else { return false }
        guard eyrInt >= 2020, eyrInt <= 2030 else { return false }

        // validate hgt
        guard let hgt = fetch("hgt:", passport) else { return false }
        let unit = hgt.suffix(2)
        let value = hgt.prefix(hgt.count - 2)
        if unit == "cm" {
            guard let value = Int(value) else { return false }
            guard value >= 150, value <= 193 else { return false }
        } else if unit == "in" {
            guard let value = Int(value) else { return false }
            guard value >= 59, value <= 76 else { return false }
        } else {
            return false
        }

        // validate hcl
        guard let hcl = fetch("hcl:", passport) else { return false }
        guard hcl.count == 7 else { return false }
        guard hcl.first == "#" else { return false }
        let hclValue = hcl.dropFirst()
        let validHcl = hclValue.allSatisfy { $0.isHexDigit }
        guard validHcl else { return false }

        // validate ecl
        guard let ecl = fetch("ecl:", passport) else { return false }
        let validEcl = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].contains(ecl)
        guard validEcl else { return false }

        // validate pid
        guard let pid = fetch("pid:", passport) else { return false }
        guard pid.count == 9 else { return false }
        guard let _ = Int(pid) else { return false }

        return true
    }

    private func fetch(_ key: String, _ passport: [String]) -> String? {
        let section = passport.first { $0.contains(key) }
        guard let s = section else { return nil }
        return String(s.split(separator: ":").last!)
    }

    // MARK: - Part Two

    func partTwo(input: String) -> String {
        return ""
    }

    // MARK: - Tests

    func test() {}
}
