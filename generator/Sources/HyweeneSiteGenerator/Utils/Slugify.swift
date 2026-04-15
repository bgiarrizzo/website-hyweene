import Foundation

/// Slugify function - converts text to URL-friendly format
/// This mimics the behavior of python-slugify library
///
/// Example:
/// ```
/// slugify("Git : Comment je squash mes commits")
/// // Returns: "git-comment-je-squash-mes-commits"
/// ```
public func slugify(_ text: String) -> String {
    return text.slugified()
}

/// Add slug fields to a dictionary
/// Adds slugified versions of common fields (category, module_name, title)
public func addSlug(to data: inout [String: Any]) {
    if let category = data["category"] as? String {
        data["category-slug"] = slugify(category)
    }
    
    if let moduleName = data["module_name"] as? String {
        data["module-slug"] = slugify(moduleName)
    }
    
    if let title = data["title"] as? String {
        data["slug"] = slugify(title)
    }
}
