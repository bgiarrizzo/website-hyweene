/// Maps learning module DTOs into immutable Domain entities.
public enum LearnModuleMapper {
    /// Errors thrown when required fields are missing.
    public enum MappingError: Error {
        case missingModuleName(String)
        case missingPageTitle(String)
    }

    /// Convert a page DTO into a validated immutable page entity.
    public static func toEntity(from dto: LearnModulePageDTO) throws -> LearnModulePageEntity {
        guard let title = dto.title, !title.isEmpty else {
            throw MappingError.missingPageTitle(dto.filePath)
        }

        let publishDate = dto.publishDate ?? DateFormat()
        let updateDate = dto.updateDate ?? publishDate

        return LearnModulePageEntity(
            id: dto.id,
            title: title,
            slug: slugify(title),
            summary: dto.summary ?? "",
            tags: dto.tags,
            publishDate: publishDate,
            updateDate: updateDate,
            toc: dto.toc,
            body: dto.body,
            prismNeeded: dto.prismNeeded,
            disabled: dto.disabled
        )
    }

    /// Convert a module DTO into a validated immutable module entity.
    public static func toEntity(from dto: LearnModuleDTO) throws -> LearnModuleEntity {
        guard let name = dto.name, !name.isEmpty else {
            throw MappingError.missingModuleName(dto.filePath)
        }

        return LearnModuleEntity(
            id: dto.id,
            name: name,
            slug: slugify(name),
            logo: dto.logo,
            description: dto.description ?? "",
            disabled: dto.disabled,
            pages: try dto.pages.map { try toEntity(from: $0) }
        )
    }
}
