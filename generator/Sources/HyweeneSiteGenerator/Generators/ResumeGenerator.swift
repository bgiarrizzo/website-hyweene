import Foundation

/// Resume/CV content generator
public class ResumeGenerator: Generator {
    var resume: Resume?
    
    public init() {}
    
    // MARK: - Generator Protocol
    
    public func generate() throws {
        print("#", String(repeating: "-", count: 80))
        print("Processing resume...")
        
        // Load resume components
        try loadResume()
        
        // Write resume page
        try writeResume()
        
        print("✅ Resume generation complete!")
    }
    
    // MARK: - Resume Loading
    
    private func loadResume() throws {
        let fm = FileManager.default
        let resumePath = Config.resumePath
        
        // Load head
        let headPath = "\(resumePath)/head/head.md"
        let head = try ResumeHead(filePath: headPath)
        
        // Load experiences
        var experiences: [ResumeExperience] = []
        let experienceFiles = fm.getAllFiles(from: "\(resumePath)/experiences", withExtension: ".md")
        for expFile in experienceFiles {
            let experience = try ResumeExperience(filePath: expFile.path)
            experiences.append(experience)
        }
        
        // Load educations
        var educations: [ResumeEducation] = []
        let educationFiles = fm.getAllFiles(from: "\(resumePath)/educations", withExtension: ".md")
        for eduFile in educationFiles {
            let education = try ResumeEducation(filePath: eduFile.path)
            educations.append(education)
        }
        
        // Load skills
        var skills: [ResumeSkill] = []
        let skillFiles = fm.getAllFiles(from: "\(resumePath)/skills", withExtension: ".md")
        for skillFile in skillFiles {
            let skill = try ResumeSkill(filePath: skillFile.path)
            skills.append(skill)
        }
        
        // Create resume
        self.resume = Resume(
            head: head,
            experiences: experiences,
            educations: educations,
            skills: skills
        )
        
        print("💼 Loaded resume with \(experiences.count) experiences, \(educations.count) educations, \(skills.count) skills")
    }
    
    // MARK: - File Writing
    
    private func writeResume() throws {
        guard let resume = self.resume else {
            throw NSError(domain: "ResumeGenerator", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Resume not loaded"
            ])
        }
        
        try resume.writeResumeFile()
    }
}
