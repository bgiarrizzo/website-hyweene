/// Maps `PageDTO` to `PageEntity`, validating required fields.
public enum PageMapper {
    /// Errors thrown when required fields are missing.
    public enum MappingError: Error {
        case missingTitle(String)
    }

    /// Convert a DTO into a validated immutable page entity.
    public static func toEntity(from dto: PageDTO) throws -> PageEntity {
        guard let title = dto.title, !title.isEmpty else {
            throw MappingError.missingTitle(dto.filePath)
        }

        return PageEntity(
            title: title,
            body: dto.body,
            permalink: dto.permalink ?? "",
            slug: slugify(title),
            summary: dto.summary ?? "",
            cover: dto.cover
        )
    }
}
