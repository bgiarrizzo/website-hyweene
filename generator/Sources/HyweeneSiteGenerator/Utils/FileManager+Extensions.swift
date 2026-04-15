import Foundation

extension FileManager {
    // MARK: - File Discovery
    
    /// Get all files from a path with a specific extension
    /// - Parameters:
    ///   - path: Directory path to search
    ///   - fileExtension: File extension to filter (e.g., ".md")
    /// - Returns: Array of file URLs sorted alphabetically
    func getAllFiles(from path: String, withExtension fileExtension: String = ".md") -> [URL] {
        let directoryURL = URL(fileURLWithPath: path)
        var fileURLs: [URL] = []
        
        guard let enumerator = self.enumerator(
            at: directoryURL,
            includingPropertiesForKeys: [.isRegularFileKey],
            options: [.skipsHiddenFiles, .skipsPackageDescendants]
        ) else {
            return []
        }
        
        for case let fileURL as URL in enumerator {
            guard (try? fileURL.resourceValues(forKeys: [.isRegularFileKey]))?.isRegularFile == true else {
                continue
            }
            
            if fileURL.pathExtension == fileExtension.replacingOccurrences(of: ".", with: "") {
                fileURLs.append(fileURL)
            }
        }
        
        return fileURLs.sorted { $0.path < $1.path }
    }
    
    // MARK: - Directory Operations
    
    /// Create directory if it doesn't exist
    /// - Parameter path: Directory path to create
    /// - Throws: FileManager errors
    func createDirectoryIfNeeded(at path: String) throws {
        let url = URL(fileURLWithPath: path)
        
        if !fileExists(atPath: path) {
            try createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    /// Copy directory contents recursively
    /// - Parameters:
    ///   - source: Source directory path
    ///   - destination: Destination directory path
    /// - Throws: FileManager errors
    public func copyDirectory(from source: String, to destination: String) throws {
        let sourceURL = URL(fileURLWithPath: source)
        let destinationURL = URL(fileURLWithPath: destination)
        
        // Create destination if it doesn't exist
        try createDirectoryIfNeeded(at: destination)
        
        // Get all items in source directory
        let items = try contentsOfDirectory(at: sourceURL, includingPropertiesForKeys: nil)
        
        for item in items {
            let destinationPath = destinationURL.appendingPathComponent(item.lastPathComponent)
            
            // Remove existing item if it exists
            if fileExists(atPath: destinationPath.path) {
                try removeItem(at: destinationPath)
            }
            
            try copyItem(at: item, to: destinationPath)
        }
    }
    
    // MARK: - Symlink Operations
    
    /// Create a symbolic link
    /// - Parameters:
    ///   - source: Source path (target of the symlink)
    ///   - destination: Destination path (symlink location)
    /// - Throws: FileManager errors
    func createSymlink(from source: String, to destination: String) throws {
        let destURL = URL(fileURLWithPath: destination)
        
        // Remove existing symlink or file
        if fileExists(atPath: destination) {
            try removeItem(at: destURL)
        }
        
        try createSymbolicLink(
            at: destURL,
            withDestinationURL: URL(fileURLWithPath: source)
        )
        
        print("✅ Created symlink: \(destination) -> \(source)")
    }
    
    // MARK: - Release Management
    
    /// Cleanup old releases, keeping only the most recent ones
    /// - Parameters:
    ///   - releasesPath: Path to releases directory
    ///   - keep: Number of releases to keep (default: 3)
    func cleanupReleases(at releasesPath: String, keep: Int = 3) throws {
        let releasesURL = URL(fileURLWithPath: releasesPath)
        
        guard fileExists(atPath: releasesPath) else {
            print("⚠️  Releases directory doesn't exist: \(releasesPath)")
            return
        }
        
        // Get all release directories sorted by name (timestamp) descending
        let releases = try contentsOfDirectory(
            at: releasesURL,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        )
        .filter { url in
            (try? url.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
        }
        .sorted { $0.lastPathComponent > $1.lastPathComponent }
        
        // Keep only the most recent 'keep' releases
        let toDelete = releases.dropFirst(keep)
        
        for release in toDelete {
            print("🗑️  Deleting old release: \(release.lastPathComponent)")
            try removeItem(at: release)
        }
        
        if toDelete.isEmpty {
            print("✅ No old releases to delete (keeping \(keep) most recent)")
        }
    }
    
    // MARK: - File Writing
    
    /// Write string content to file
    /// - Parameters:
    ///   - content: Content to write
    ///   - path: File path
    /// - Throws: Encoding or FileManager errors
    func writeFile(content: String, to path: String) throws {
        let url = URL(fileURLWithPath: path)
        
        // Create parent directory if needed
        let parentDir = url.deletingLastPathComponent().path
        try createDirectoryIfNeeded(at: parentDir)
        
        try content.write(to: url, atomically: true, encoding: .utf8)
    }
    
    /// Read string content from file
    /// - Parameter path: File path
    /// - Returns: File content as string
    /// - Throws: FileManager or decoding errors
    func readFile(from path: String) throws -> String {
        let url = URL(fileURLWithPath: path)
        return try String(contentsOf: url, encoding: .utf8)
    }
}

// MARK: - Global Helper Functions

/// Release the site by creating symlink and cleaning old releases
public func releaseSite() throws {
    let fm = FileManager.default
    
    // Create symlink to latest build
    try fm.createSymlink(
        from: Config.releasePath,
        to: Config.currentReleasePath
    )
    
    // Cleanup old releases
    try fm.cleanupReleases(at: Config.releasesPath, keep: 3)
}
