import Foundation

// MARK: - Resume Head

/// Header/summary section of the resume
public class ResumeHead {
    let filePath: String
    var body: String = ""
    
    init(filePath: String) throws {
        self.filePath = filePath
        try processFile()
    }
    
    private func processFile() throws {
        let data = try parseMarkdownFile(filePath)
        self.body = data["body"] as? String ?? ""
    }
    
    func toDictionary() -> [String: Any] {
        return ["body": body]
    }
}

// MARK: - Resume Skill

/// Skill category section
public class ResumeSkill {
    let filePath: String
    var id: Int?
    var body: String = ""
    
    init(filePath: String) throws {
        self.filePath = filePath
        try processFile()
    }
    
    private func processFile() throws {
        let data = try parseMarkdownFile(filePath)
        self.id = data["id"] as? Int
        self.body = data["body"] as? String ?? ""
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = ["body": body]
        if let id = id {
            dict["id"] = id
        }
        return dict
    }
}

// MARK: - Resume Experience

/// Professional experience entry
public class ResumeExperience {
    let filePath: String
    var id: Int?
    var title: String?
    var company: String?
    var companyURL: String?
    var location: String = ""
    var workMode: String = ""
    var startDate: String?
    var endDate: String?
    var contractType: String?
    var tags: [String] = []
    var body: String = ""
    
    init(filePath: String) throws {
        self.filePath = filePath
        try processFile()
    }
    
    private func processFile() throws {
        let data = try parseMarkdownFile(filePath)
        
        self.id = data["id"] as? Int
        self.title = data["title"] as? String
        self.company = data["company"] as? String
        self.companyURL = data["company_url"] as? String
        self.location = data["location"] as? String ?? ""
        self.workMode = data["work_mode"] as? String ?? ""
        self.startDate = data["start_date"] as? String
        self.endDate = data["end_date"] as? String
        self.contractType = data["contract_type"] as? String
        
        if let tags = data["tags"] as? [String] {
            self.tags = tags
        }
        
        self.body = data["body"] as? String ?? ""
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "title": title ?? "",
            "company": company ?? "",
            "location": location,
            "work_mode": workMode,
            "tags": tags,
            "body": body
        ]
        
        if let id = id {
            dict["id"] = id
        }
        
        if let companyURL = companyURL {
            dict["company_url"] = companyURL
        }
        
        if let startDate = startDate {
            dict["start_date"] = startDate
        }
        
        if let endDate = endDate {
            dict["end_date"] = endDate
        }
        
        if let contractType = contractType {
            dict["contract_type"] = contractType
        }
        
        return dict
    }
}

// MARK: - Resume Education

/// Education/formation entry
public class ResumeEducation {
    let filePath: String
    var id: Int?
    var title: String?
    var school: String?
    var location: String = ""
    var startDate: String?
    var endDate: String?
    var formationType: String?
    var status: String?
    var body: String = ""
    
    init(filePath: String) throws {
        self.filePath = filePath
        try processFile()
    }
    
    private func processFile() throws {
        let data = try parseMarkdownFile(filePath)
        
        self.id = data["id"] as? Int
        self.title = data["title"] as? String
        self.school = data["school"] as? String
        self.location = data["location"] as? String ?? ""
        self.startDate = data["start_date"] as? String
        self.endDate = data["end_date"] as? String
        self.formationType = data["formation_type"] as? String
        self.status = data["status"] as? String
        self.body = data["body"] as? String ?? ""
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "title": title ?? "",
            "school": school ?? "",
            "location": location,
            "body": body
        ]
        
        if let id = id {
            dict["id"] = id
        }
        
        if let startDate = startDate {
            dict["start_date"] = startDate
        }
        
        if let endDate = endDate {
            dict["end_date"] = endDate
        }
        
        if let formationType = formationType {
            dict["formation_type"] = formationType
        }
        
        if let status = status {
            dict["status"] = status
        }
        
        return dict
    }
}

// MARK: - Resume

/// Complete resume/CV with all sections
public class Resume {
    let head: ResumeHead
    var experiences: [ResumeExperience]
    var educations: [ResumeEducation]
    var skills: [ResumeSkill]
    var tags: Set<String> = []
    
    init(head: ResumeHead,
         experiences: [ResumeExperience],
         educations: [ResumeEducation],
         skills: [ResumeSkill]) {
        self.head = head
        self.experiences = experiences.sorted { ($0.id ?? 0) < ($1.id ?? 0) }
        self.educations = educations.sorted { ($0.id ?? 0) < ($1.id ?? 0) }
        self.skills = skills.sorted { ($0.id ?? 0) < ($1.id ?? 0) }
        
        // Extract unique tags from experiences (excluding keywords)
        let keywords = Set(Config.keywords.map { $0.lowercased() })
        var allTags = Set<String>()
        
        for experience in experiences {
            for tag in experience.tags {
                let lowercasedTag = tag.lowercased()
                if !keywords.contains(lowercasedTag) {
                    allTags.insert(lowercasedTag)
                }
            }
        }
        
        self.tags = allTags
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "head": head.toDictionary(),
            "experiences": experiences.map { $0.toDictionary() },
            "educations": educations.map { $0.toDictionary() },
            "skills": skills.map { $0.toDictionary() },
            "tags": Array(tags).sorted()
        ]
    }
    
    // MARK: - File Writing
    
    func writeResumeFile() throws {
        let data: [[String: Any]] = [
            ["page_title": "Bruno Giarrizzo - CV"],
            ["resume": toDictionary()]
        ]
        
        let filename = "cv/index.html"
        print("💼 Writing resume: \(filename)")
        
        try writeFile(dataList: data, template: "resume/main.stencil", to: filename)
    }
}
