// https://adventofcode.com/2024/day/19
import Foundation

class DayNineteen: Day {
    let dayNumber: Int = 19
    let year: Int = 2024

    // Types

    class TrieNode {
        var letter: Character
        var fullWords: [String]
        var children: [Character: TrieNode]

        init(letter: Character) {
            self.letter = letter
            self.fullWords = []
            self.children = [:]
        }

        var isRoot: Bool { return letter == "0" }
    }

    class Trie {
        let root: TrieNode = TrieNode(letter: "0")

        func insert(word: String) {
            var currentNode = root
            for letter in word {
                if let child = currentNode.children[letter] {
                    currentNode = child
                } else {
                    let newChild = TrieNode(letter: letter)
                    currentNode.children[letter] = newChild
                    currentNode = newChild
                }
            }
            currentNode.fullWords.append(word)
        }

        func printLevelOrder() {
            var queue: [TrieNode] = [root]
            var level = 0
            while !queue.isEmpty {
                print("Level \(level)")
                var newQueue: [TrieNode] = []
                for node in queue {
                    print("Node: \(node.letter), Full words: \(node.fullWords)")
                    for child in node.children.values {
                        newQueue.append(child)
                    }
                }
                print("----")
                queue = newQueue
                level += 1
            }
        }

        func findPotentialPrefixes(in word: String) -> [String] {
            var currentNode = root
            var prefixes: [String] = []
            for letter in word {
                if let child = currentNode.children[letter] {
                    currentNode = child
                    prefixes.append(contentsOf: currentNode.fullWords)
                } else {
                    break
                }
            }
            return prefixes.reversed() // In this way we start from the longest prefix
        }
    }


    // MARk: - Part One

    var towelFirstTwoLetters: [String: [String]] = [:]
    var singleLetterTowels: [String: String] = [:]
    var trie: Trie = Trie()
    var memo = [String: Bool]()


    func partOne(input: String) -> String {
        let components = input.split(separator: "\n\n")
        let towels = components[0].split(separator: ", ").map { String($0) }
        let combinations = components[1].split(separator: "\n").map { String($0) }

        // Trie implementation
        for towel in towels {
            trie.insert(word: towel)
        }

        trie.printLevelOrder()

        var pcc = 0
         for cd in combinations.enumerated() {
             print("Checking for combination \(cd.offset + 1)/\(combinations.count)")
             if isPossibleTrieRecursive(combination: cd.element) {
                 pcc += 1
             }
         }

        return "Possible combinations: \(pcc)"
    }

    // func isPossibleBruteForce(combination: String, towels: [String]) -> Bool {
    //     if combination.isEmpty { return true }

    //     for towel in towels {
    //         if combination.hasPrefix(towel) {
    //             let newCombination = combination.dropFirst(towel.count)
    //             if isPossibleBruteForce(combination: String(newCombination), towels: towels) {
    //                 return true
    //             }
    //         }
    //     }

    //     return false
    // }

    // func isPossibleBetterFiltering(combination: String, towels: [String]) -> Bool {
    //     if combination.isEmpty { return true }
        
    //     var possibleTowels = [String]()
    //     if let singleLetterTowel = singleLetterTowels[String(combination.prefix(1))] {
    //         possibleTowels.append(singleLetterTowel)
    //     }
    //     if let multiLetterTowels = towelFirstTwoLetters[String(combination.prefix(2))] {
    //         possibleTowels.append(contentsOf: multiLetterTowels)
    //     }

    //     for towel in possibleTowels {
    //         if combination.hasPrefix(towel) {
    //             let newCombination = combination.dropFirst(towel.count)
    //             if isPossibleBetterFiltering(combination: String(newCombination), towels: towels) {
    //                 return true
    //             }
    //         }
    //     }

    //     return false
    // }

    func isPossibleTrieRecursive(combination: String) -> Bool {
        if let result = memo[combination] {
            print("Memo hit for combination: \(combination), result: \(result)")
            return result
        }

        let prefixes = trie.findPotentialPrefixes(in: combination)
        if prefixes.isEmpty {
            memo[combination] = false
            return false
        }

        for prefix in prefixes {
            let newCombination = combination.dropFirst(prefix.count)
            if newCombination.isEmpty || isPossibleTrieRecursive(combination: String(newCombination)) {
                memo[combination] = true
                return true
            }
        }

        memo[combination] = false
        return false
    }

    // MARK: - Part Two

    func partTwo(input: String) -> String {
        
        return ""
    }
}
