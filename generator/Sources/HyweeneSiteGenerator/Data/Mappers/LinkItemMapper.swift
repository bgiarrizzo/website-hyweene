/// Maps `LinkItemDTO` → `LinkItemEntity`, validating required fields.
public enum LinkItemMapper {
    /// Errors thrown when required fields are missing.
    public enum MappingError: Error {
        case missingTitle(String)
        case missingURL(String)
    }

    /// Convert a raw DTO into an immutable `LinkItemEntity`.
    public static func toEntity(from dto: LinkItemDTO) throws -> LinkItemEntity {
        guard let title = dto.title, !title.isEmpty else {
            throw MappingError.missingTitle(dto.filePath)
        }

        guard let url = dto.url, !url.isEmpty else {
            throw MappingError.missingURL(dto.filePath)
        }

        let publishDate = dto.publishDate ?? DateFormat()
        let slug = dto.slug.flatMap { $0.isEmpty ? nil : $0 } ?? slugify(title)
        let path = "\(publishDate.short)-\(slug)"

        return LinkItemEntity(
            title: title,
            url: url,
            path: path,
            description: dto.description ?? "",
            publishDate: publishDate,
            updateDate: dto.updateDate,
            body: dto.body,
            slug: slug
        )
    }
}
