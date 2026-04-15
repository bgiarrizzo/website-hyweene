import Foundation

/// Protocol for all content generators
public protocol Generator {
    /// Generate all files for this content type
    func generate() throws
}
