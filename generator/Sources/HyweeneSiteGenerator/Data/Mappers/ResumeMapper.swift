/// Maps resume DTOs into immutable Domain entities.
public enum ResumeMapper {
    /// Errors thrown when required fields are missing.
    public enum MappingError: Error {
        case missingExperienceTitle(String)
        case missingExperienceCompany(String)
        case missingEducationTitle(String)
        case missingEducationSchool(String)
    }

    /// Convert a head DTO into its Domain entity.
    public static func toEntity(from dto: ResumeHeadDTO) -> ResumeHeadEntity {
        ResumeHeadEntity(body: dto.body)
    }

    /// Convert a skill DTO into its Domain entity.
    public static func toEntity(from dto: ResumeSkillDTO) -> ResumeSkillEntity {
        ResumeSkillEntity(id: dto.id, body: dto.body)
    }

    /// Convert an experience DTO into its Domain entity.
    public static func toEntity(from dto: ResumeExperienceDTO) throws -> ResumeExperienceEntity {
        guard let title = dto.title, !title.isEmpty else {
            throw MappingError.missingExperienceTitle(dto.filePath)
        }
        guard let company = dto.company, !company.isEmpty else {
            throw MappingError.missingExperienceCompany(dto.filePath)
        }

        return ResumeExperienceEntity(
            id: dto.id,
            title: title,
            company: company,
            companyURL: dto.companyURL,
            location: dto.location ?? "",
            workMode: dto.workMode ?? "",
            startDate: dto.startDate,
            endDate: dto.endDate,
            contractType: dto.contractType,
            tags: dto.tags,
            body: dto.body
        )
    }

    /// Convert an education DTO into its Domain entity.
    public static func toEntity(from dto: ResumeEducationDTO) throws -> ResumeEducationEntity {
        guard let title = dto.title, !title.isEmpty else {
            throw MappingError.missingEducationTitle(dto.filePath)
        }
        guard let school = dto.school, !school.isEmpty else {
            throw MappingError.missingEducationSchool(dto.filePath)
        }

        return ResumeEducationEntity(
            id: dto.id,
            title: title,
            school: school,
            location: dto.location ?? "",
            startDate: dto.startDate,
            endDate: dto.endDate,
            formationType: dto.formationType,
            status: dto.status,
            body: dto.body
        )
    }
}
