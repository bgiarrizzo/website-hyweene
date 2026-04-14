import Foundation
import Stencil
import PathKit

public enum TemplateEngineError: Error {
    case templateNotFound(String)
    case renderingFailed(String)
    case writeFailed(String)
}

/// Template engine wrapper for Stencil (Jinja2-like templating)
public class TemplateEngine {
    private let environment: Environment
    private let fsLoader: FileSystemLoader
    
    /// Initialize template engine with template directory path
    /// - Parameter templatePath: Path to templates directory
    init(templatePath: String = Config.templatePath) throws {
        let path = Path(templatePath)
        self.fsLoader = FileSystemLoader(paths: [path])
        
        // Create environment with custom filters and globals
        let ext = Extension()
        
        // Register custom filter: is_outdated (checks if date is older than 6 months)
        ext.registerFilter("is_outdated") { (value: Any?) in
            if let dateFormat = value as? DateFormat {
                return isDateOlderThanSixMonths(dateFormat)
            } else if let date = value as? Date {
                return isDateOlderThanSixMonths(date)
            }
            return false
        }
        
        // Register custom filter: capitalize (similar to Jinja2)
        ext.registerFilter("capitalize") { (value: Any?) in
            if let string = value as? String {
                return string.capitalized
            }
            return value
        }
        
        // Register custom filter: join (joins array elements with separator)
        ext.registerFilter("join") { (value: Any?, arguments: [Any?]) in
            guard let array = value as? [Any] else {
                return value ?? ""
            }
            
            // Get separator from first argument, default to ""
            let separator = arguments.first as? String ?? ""
            
            // Convert array elements to strings and join
            let strings = array.map { String(describing: $0) }
            return strings.joined(separator: separator)
        }
        
        // Register custom filter: reverse (reverses an array)
        ext.registerFilter("reverse") { (value: Any?) in
            if let array = value as? [Any] {
                return Array(array.reversed())
            }
            return value
        }
        
        // Register custom filter: e (HTML/XML escape)
        ext.registerFilter("e") { (value: Any?) in
            guard let string = value as? String else {
                return value ?? ""
            }
            
            // XML/HTML escape
            var escaped = string
            escaped = escaped.replacingOccurrences(of: "&", with: "&amp;")
            escaped = escaped.replacingOccurrences(of: "<", with: "&lt;")
            escaped = escaped.replacingOccurrences(of: ">", with: "&gt;")
            escaped = escaped.replacingOccurrences(of: "\"", with: "&quot;")
            escaped = escaped.replacingOccurrences(of: "'", with: "&#39;")
            return escaped
        }
        
        self.environment = Environment(
            loader: fsLoader,
            extensions: [ext],
            templateClass: Template.self
        )
    }
    
    // MARK: - Template Rendering
    
    /// Render a template with context data
    /// - Parameters:
    ///   - templateName: Name of template file (e.g., "blog/single.stencil")
    ///   - context: Dictionary of template variables
    /// - Returns: Rendered HTML string
    /// - Throws: Template rendering errors
    func render(template templateName: String, context: [String: Any]) throws -> String {
        // Add global variables
        var fullContext = context
        fullContext["yearNow"] = Calendar.current.component(.year, from: Date())
        
        do {
            return try environment.renderTemplate(name: templateName, context: fullContext)
        } catch {
            throw TemplateEngineError.renderingFailed("Failed to render template '\(templateName)': \(error)")
        }
    }
    
    /// Prepare template data by merging site context with custom data
    /// - Parameter dataList: Array of dictionaries to merge
    /// - Returns: Merged context dictionary
    func prepareTemplateData(_ dataList: [[String: Any]]) -> [String: Any] {
        var data: [String: Any] = ["site": Config.siteContext()]
        
        // Merge all dictionaries in dataList
        for item in dataList {
            data.merge(item) { _, new in new }
        }
        
        return data
    }
    
    /// Convenience method: prepare data and render template
    /// - Parameters:
    ///   - templateName: Name of template file
    ///   - dataList: Array of dictionaries to merge with site context
    /// - Returns: Rendered HTML string
    /// - Throws: Template rendering errors
    func renderWithData(template templateName: String, dataList: [[String: Any]]) throws -> String {
        let context = prepareTemplateData(dataList)
        return try render(template: templateName, context: context)
    }
    
    // MARK: - File Writing
    
    /// Write rendered content to file in release directory
    /// - Parameters:
    ///   - content: Rendered HTML content
    ///   - filename: Relative path from release directory (e.g., "blog/index.html")
    /// - Throws: File writing errors
    func writePage(content: String, to filename: String) throws {
        let fullPath = "\(Config.releasePath)/\(filename)"
        
        do {
            try FileManager.default.writeFile(content: content, to: fullPath)
            print("✅ Written: \(filename)")
        } catch {
            throw TemplateEngineError.writeFailed("Failed to write '\(filename)': \(error)")
        }
    }
    
    /// Complete workflow: prepare data, render template, and write to file
    /// - Parameters:
    ///   - dataList: Array of dictionaries to merge
    ///   - templateName: Template file name
    ///   - filename: Output file path (relative to release directory)
    /// - Throws: Rendering or writing errors
    func writeFile(dataList: [[String: Any]], template templateName: String, to filename: String) throws {
        let content = try renderWithData(template: templateName, dataList: dataList)
        try writePage(content: content, to: filename)
    }
}

// MARK: - Global Template Engine Instance

nonisolated(unsafe) private var _sharedTemplateEngine: TemplateEngine?

/// Get or create shared template engine instance
public func getTemplateEngine() throws -> TemplateEngine {
    if let engine = _sharedTemplateEngine {
        return engine
    }
    
    let engine = try TemplateEngine()
    _sharedTemplateEngine = engine
    return engine
}

// MARK: - Convenience Functions

/// Render template with data
public func renderTemplate(_ templateName: String, dataList: [[String: Any]]) throws -> String {
    let engine = try getTemplateEngine()
    return try engine.renderWithData(template: templateName, dataList: dataList)
}

/// Write rendered template to file
public func writeFile(dataList: [[String: Any]], template templateName: String, to filename: String) throws {
    let engine = try getTemplateEngine()
    try engine.writeFile(dataList: dataList, template: templateName, to: filename)
}
