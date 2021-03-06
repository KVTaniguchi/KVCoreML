
// create a classification from taking in an image or string from service?
// view all classifications from a

import Vapor
import FluentProvider

// the controller for coreMLing would not save, would have a /classify path

// todo - redo the relationships
// a prediction is a sibling or child of the image classification
// add a prediction model child or sibling to the image classification
// classify will

struct ImageProcessController {
    func addRoutes(to drop: Droplet) {
        let processGroup = drop.grouped("api", "imageProcess")
        processGroup.post("process", handler: classify)
    }
    
    func classify(_ req: Request) throws -> ResponseRepresentable {
        guard let json = req.json else {
            throw RequestError.badJSON
        }
        
        let classification = try ImageProcess(json: json)
        
        
        let imageData = classification.imageData
        
        
        // do core ml work
        // create sibling model prediction??
        // return data in the response
        
        return classification
    }
}


struct ClassificationContoller {
    func addRoutes(to drop: Droplet) {
        let classificationGroup = drop.grouped("api", "classifications")
        classificationGroup.get(handler: allClassifications)
        classificationGroup.post("create", handler: createClassification)
        
        classificationGroup.post("classify", handler: classify)
        
        classificationGroup.get(ImageClassification.parameter, handler: getClassification)
        classificationGroup.get(ImageClassification.parameter, "prediction", handler: getClassificationPrediction)
        classificationGroup.get(ImageClassification.parameter, "texts", handler: getClassificationKVTexts)
    }
    
    func classify(_ req: Request) throws -> ResponseRepresentable {
        guard let json = req.json else {
            throw RequestError.badJSON
        }
        
        let classification = try ImageClassification(json: json)
        
        // do core ml work
        // create sibling model prediction??
        // return data in the response
        
        return classification
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
