/// Maps `BlogPostDTO` → `BlogPostEntity`, validating required fields.
public enum BlogPostMapper {
    /// Errors thrown when required fields are absent.
    public enum MappingError: Error {
        case missingTitle(String)
        case missingPublishDate(String)
    }

    /// Convert a raw DTO into a fully-validated domain entity.
    ///
    /// - Parameter dto: The DTO produced by parsing a Markdown file.
    /// - Returns: An immutable `BlogPostEntity`.
    /// - Throws: `MappingError` when required fields are missing.
    public static func toEntity(from dto: BlogPostDTO) throws -> BlogPostEntity {
        guard let title = dto.title, !title.isEmpty else {
            throw MappingError.missingTitle(dto.filePath)
        }

        guard let publishDate = dto.publishDate else {
            throw MappingError.missingPublishDate(dto.filePath)
        }

        let slug = dto.slug.flatMap { $0.isEmpty ? nil : $0 } ?? slugify(title)
        let path = "\(publishDate.short)-\(slug)"
        let category = BlogPostCategory(name: dto.categoryName ?? "Uncategorized")
        let readingTime = dto.body.estimatedReadingTime()

        return BlogPostEntity(
            title: title,
            slug: slug,
            body: dto.body,
            summary: dto.summary ?? "",
            publishDate: publishDate,
            updateDate: dto.updateDate ?? publishDate,
            category: category,
            tags: dto.tags,
            readingTime: readingTime,
            path: path,
            prismNeeded: dto.prismNeeded,
            cover: dto.cover,
            draft: dto.draft,
            tocHTML: dto.tocHTML
        )
    }
}
