// https://adventofcode.com/2024/day/9
import Foundation

// MARK: - Types
extension DayNine {
    struct Block {
        let id: Int?

        var isEmpty: Bool {
            return id == nil
        }

        var stringValue: String {
            return id == nil ? "." : "\(id!)"
        }
    }
}

class DayNine: Day {
    let dayNumber = 9

    // MARK: - Part One
    func partOne(input: String) -> String {
        var blocks = prepareBlockArray(input: input)

        // Sort blocks

        var i = 0
        var j = blocks.count - 1
        while i < j {
            // Increment i until we find an empty block
            while !blocks[i].isEmpty && i < j {
                i += 1
            }

            while blocks[j].isEmpty && i < j {
                j -= 1
            }

            // Just in case
            if i >= j {
                break
            }

            // Swap
            while blocks[i].isEmpty && !blocks[j].isEmpty && i < j {
                blocks.swapAt(i, j)
                i += 1
                j -= 1
            }
        }
        // printBlocks(blocks)

        return "Block Checksum is \(calculateChecksum(blocks: blocks))"

    }

    // MARK: - Part Two
    func partTwo(input: String) -> String {
        let fileSystem = FileSystem(input: input)
        fileSystem.moveFilesToLeftmostLocation()
        // let blocks = fileSystem.toBlockRepresentation()
        // printBlocks(blocks)
        let checksum = fileSystem.calculateChecksum()
        return "File System Checksum is \(checksum)"
    }

    // MARK: - Utility Functions

    func prepareBlockArray(input: String) -> [Block] {
        let inputArr = Array(input)
        let arr = inputArr.map { Int(String($0))! }
        return encodedBlocksToBlockRepresentation(blockArr: arr)
    }

    func encodedBlocksToBlockRepresentation(blockArr: [Int]) -> [Block] {
        var blocks: [Block] = []
        for i in 0..<blockArr.count {
            let id = i % 2 == 0 ? i / 2 : nil
            for _ in 0..<blockArr[i] {
                blocks.append(Block(id: id))
            }
        }
        return blocks
    }

    func calculateChecksum(blocks: [Block]) -> Int {
        var checksum = 0
        for i in 0..<blocks.count {
            checksum += i * (blocks[i].id ?? 0)
        }
        return checksum
    }

    func printBlocks(_ blocks: [Block]) {
        let blockStringRepresentation = blocks.map { $0.stringValue }.joined()
        print("Blocks: \(blockStringRepresentation)")
    }


    // MARK: - Testing
    func test() {
    }
}


class FileSystem {

    // MARK: - Types
    class File {
        let id: Int? // if nil, empty space
        var startBlock: Int
        var size: Int // In blocks

        init(id: Int?, startBlock: Int, size: Int) {
            self.id = id
            self.startBlock = startBlock
            self.size = size
        }

        var toString: String {
            return id == nil ? "Empty Space - Start Block: \(startBlock) - Size: \(size)" : "File \(id!) - Start Block: \(startBlock) - Size: \(size)"
        }
    }

    // MARK: - Properties

    var files: [Int: File] = [:]
    var emptySpaces/*What are we living for?*/: [File] = []

    // MARK: - Initializers

    init(input: String) {
        let inputArray = Array(input)
        let arr = inputArray.map { Int(String($0))! }
        
        var currentBlock = 0
        for i in 0..<arr.count {
            let size = arr[i]
            if i % 2 == 0 {
                files[i / 2] = (File(id: i / 2, startBlock: currentBlock, size: size))
            } else {
                emptySpaces.append(File(id: nil, startBlock: currentBlock, size: size))
            }
            currentBlock += size
        }
    }

    func moveFilesToLeftmostLocation() {
        let orderedIds: [Int] = files.keys.sorted(by: >)
        // print("Ordered IDs: \(orderedIds)")

//        printEncodedBlockRepresentation()
        for id in orderedIds {
            let file = files[id]!
            let emptySpace = emptySpaces.first { $0.size >= file.size && $0.startBlock <= file.startBlock }
            if let emptySpace = emptySpace {
                files[id] = File(id: id, startBlock: emptySpace.startBlock, size: file.size)
                emptySpace.startBlock += file.size
                emptySpace.size -= file.size
                if emptySpace.size == 0 {
                    emptySpaces.removeAll { $0 === emptySpace }
                }

                // Add empty space to the right of the file
                let newEmptySpace = File(id: nil, startBlock: file.startBlock, size: file.size)
                // insert new empty space in the correct position based on start block
                if let index = emptySpaces.firstIndex(where: { $0.startBlock > newEmptySpace.startBlock }) {
                    emptySpaces.insert(newEmptySpace, at: index)
                } else {
                    emptySpaces.append(newEmptySpace)
                }

//                printEncodedBlockRepresentation()
            }
        }
    }

    func calculateChecksum() -> Int {
        var checksum = 0
        for (id, file) in files {
            for i in file.startBlock..<(file.startBlock + file.size) {
                checksum += i * id
            }
        }
        return checksum
    }

    func toBlockRepresentation() -> [DayNine.Block] {
        var allFiles = files.values + emptySpaces
        allFiles.sort { $0.startBlock < $1.startBlock }
        var encodedBlocks: [DayNine.Block] = []
        for file in allFiles {
            for _ in 0..<file.size {
                encodedBlocks.append(DayNine.Block(id: file.id))
            }
        }
        return encodedBlocks
    }

    func printEncodedBlockRepresentation() {
        let blocks = toBlockRepresentation()
        let blockStringRepresentation = blocks.map { $0.stringValue }.joined()
        print("Blocks: \(blockStringRepresentation)")
    }

    // MARK: - Utility Functions

    func printFileSystem() {
        print("Files:")
        for file in files {
            print(file.value.toString)
        }

        print("Empty Spaces:")
        for emptySpace in emptySpaces {
            print(emptySpace.toString)
        }
    }
}
