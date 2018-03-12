
// create a classification from taking in an image or string from service?
// view all classifications from a

import Vapor
import FluentProvider

struct ClassificationContoller {
    func addRoutes(to drop: Droplet) {
        let classificationGroup = drop.grouped("api", "classifications")
        classificationGroup.post("create", handler: createClassification)
    }
    
    func createClassification(_ req: Request) throws -> ResponseRepresentable {
        guard let json = req.json else {
            throw Abort.badRequest
        }
        
        let classification = try ImageClassification(json: json)
        try classification.save()
        return classification
    }
}


