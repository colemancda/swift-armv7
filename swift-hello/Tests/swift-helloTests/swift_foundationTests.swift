import Foundation

#if canImport(Testing)
    import Testing

    // https://github.com/swift-embedded-linux/armhf-debian/issues/10:
    // Test that large file system sizes can be read without crashing from FileManager.attributesOfFileSystem.
    // This assumes that the host filesystem will be larger than 4GB, which is typical for modern systems.
    @Test func fileManagerAttributesOfFileSystem() throws {
        let fileManager = FileManager.default
        let attributes = try fileManager.attributesOfFileSystem(forPath: "/")
        let systemSize = try #require(attributes[.systemSize] as? UInt64)
        print("Root '/' drive size: \(systemSize) bytes (\(systemSize / 1024 / 1024 / 1024) GB)")
    }

    // https://github.com/swift-embedded-linux/armhf-debian/issues/12:
    // Test that FileHandle can write a file larger than 2GB without crashing.
    // This is to be run under the 32-bit arch where large file support must be enabled.
    @Test func fileHandleLargeFileSupport() throws {
        // Create the life
        let fileURL = URL(fileURLWithPath: "largefiletest.dat")
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: fileURL.path) {
            #expect(fileManager.createFile(atPath: fileURL.path, contents: nil, attributes: nil))
        }
        defer {
            try? fileManager.removeItem(at: fileURL)
        }

        // Seek to a large offset and write some data
        let fileHandle: FileHandle = try FileHandle(forWritingTo: fileURL)
        defer {
            try? fileHandle.close()
        }
        let data = Data(count: Int(Int32.max >> 1) - 1)  // as many bytes as we can fit in Data
        try fileHandle.write(contentsOf: data)  // write once to get to 1GB
        try fileHandle.write(contentsOf: data)  // write twice to get to 2GB
        try fileHandle.write(contentsOf: "This should go beyond 2GB".data(using: .utf8)!)  // write a little more to go beyond 2GB

        // Print info for verification
        let finalSize = try fileHandle.offset()
        print("Final file size after writing: \(finalSize) bytes (\(finalSize / 1024 / 1024 / 1024) GB)")
    }
#endif
