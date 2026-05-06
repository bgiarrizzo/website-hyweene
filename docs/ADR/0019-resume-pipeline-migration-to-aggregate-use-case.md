---
title: "ADR 0019: Resume pipeline migration to aggregate Domain use case"
filename: "0019-resume-pipeline-migration-to-aggregate-use-case.md"
description: "Move resume generation from mutable legacy model code to a Domain aggregate, repository, and use case."
creation_date: 2026-05-06
update_date: 2026-05-06
category: adr
---

# ADR 0019: Resume pipeline migration to aggregate Domain use case

Status: Accepted

## Context

The original resume pipeline mixed file parsing, mutable state, derived tag extraction, sorting, and rendering across `ResumeGenerator` and a family of mutable model classes:

- `ResumeHead`
- `ResumeSkill`
- `ResumeExperience`
- `ResumeEducation`
- `Resume`

That structure worked, but it did not align with the target Clean Architecture for the generator and made aggregate behavior harder to test independently.

## Decision

The resume pipeline is migrated to a Domain aggregate workflow:

- Domain:
  - `ResumeHeadEntity`
  - `ResumeSkillEntity`
  - `ResumeExperienceEntity`
  - `ResumeEducationEntity`
  - `ResumeEntity`
  - `BuildResumeResult`
  - `ResumeContentRepository`
  - `GenerateResumeUseCase`
- Data:
  - section-specific DTOs for head, skills, experiences, and educations
  - `ResumeMapper`
  - `FileSystemResumeContentRepository`
- Runtime:
  - `ResumeGenerator` becomes a thin orchestration adapter that wires concrete repositories and delegates to `GenerateResumeUseCase`

The aggregate keeps the legacy behavior intact:

- experiences, educations, and skills are sorted by ascending `id`
- resume tags are extracted from experience tags only
- site keywords are excluded from the derived tag set
- output is still written to `cv/index.html` using `resume/main.stencil`

## Consequences

Positive:

- Resume generation is now unit-testable as a pure aggregate plus one use case.
- Derived behavior such as sorting and tag filtering now lives in an explicit Domain type.
- The migration pattern is now consistent across blog, links, pages, homepage, and resume.

Trade-offs:

- A temporary compatibility period existed during migration where both legacy and new paths coexisted.
- The aggregate introduces several small types, which increases file count but improves separation of concerns.

## Alternatives Considered

### Keep the existing mutable `Resume` model workflow

Rejected because it keeps business rules embedded in runtime-oriented code.

### Flatten the resume into one large dictionary-oriented entity

Rejected because it would reduce type clarity and make section-level behavior harder to test and maintain.
