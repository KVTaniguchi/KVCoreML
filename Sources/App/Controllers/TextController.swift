import Vapor
import FluentProvider

struct KVTextController {
    func addRoutes(to drop: Droplet) {
        let textGroup = drop.grouped("api", "text")
        textGroup.get(handler: allText)
        textGroup.post("create", handler: createText)
        textGroup.get(KVText.parameter, handler: getText)
        textGroup.get(KVText.parameter, "imageClassifications", handler: getTextImageClassificationSiblings)
    }
    
    func createText(_ req: Request) throws -> ResponseRepresentable {
        guard let json = req.json else {
            throw RequestError.badJSON
        }
        
        let text = try KVText(json: json)
        try text.save()
        return text
    }
    
    func allText(_ : Request) throws -> ResponseRepresentable {
        let allText = try KVText.all()
        return try allText.makeJSON()
    }
    
    func getText(_ req: Request) throws -> ResponseRepresentable {
        let text = try req.parameters.next(KVText.self)
        return text
    }
    
    func getTextImageClassificationSiblings(_ req: Request) throws -> ResponseRepresentable {
        let text = try req.parameters.next(KVText.self)
        return try text.imageClassificationSiblings.all().makeJSON()
    }
}
