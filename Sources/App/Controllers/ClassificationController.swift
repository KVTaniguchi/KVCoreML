
// create a classification from taking in an image or string from service?
// view all classifications from a

import Vapor
import FluentProvider

struct ClassificationContoller {
    func addRoutes(to drop: Droplet) {
        let classificationGroup = drop.grouped("api", "classifications")
        classificationGroup.get(handler: allClassifications)
        classificationGroup.post("create", handler: createClassification)
        classificationGroup.get(ImageClassification.parameter, handler: getClassification)
        classificationGroup.get(ImageClassification.parameter, "prediction", handler: getClassificationPrediction)
        classificationGroup.get(ImageClassification.parameter, "texts", handler: getClassificationKVTexts)
    }
    
    func createClassification(_ req: Request) throws -> ResponseRepresentable {
        guard let json = req.json else {
            throw RequestError.badJSON
        }
        
        let classification = try ImageClassification(json: json)
        try classification.save()
        
        if let texts = json["texts"]?.array {
            for textJSON in texts {
                if let text = try KVText.find(textJSON["id"]) {
                    try classification.kvTexts.add(text)
                }
            }
        }
        
        return classification
    }
    
    func allClassifications(_ req: Request) throws -> ResponseRepresentable {
        let allClassifications = try ImageClassification.all()
        return try allClassifications.makeJSON()
    }
    
    func getClassification(_ req: Request) throws -> ResponseRepresentable {
        let classification = try req.parameters.next(ImageClassification.self)
        return classification
    }
    
    func getClassificationPrediction(_ req: Request) throws -> ResponseRepresentable {
        let classification = try req.parameters.next(ImageClassification.self)
        guard let prediction = try classification.prediction.get() else {
            throw RequestError.cantFindPrediction
        }
        
        return prediction
    }
    
    func getClassificationKVTexts(_ req: Request) throws -> ResponseRepresentable {
        let classification = try req.parameters.next(ImageClassification.self)
        return try classification.kvTexts.all().makeJSON()
    }
}

enum RequestError: Error {
    case badJSON
    case cantFindPermission
    case cantFindPrediction
}
