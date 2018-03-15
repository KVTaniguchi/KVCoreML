import FluentProvider

final class ImageClassification: Model {
    
    let storage = Storage()
    
    let title: String
    let confidence: Double
    let predictionID: Identifier?
    
    init(title: String, confidence: Double, prediction: Prediction) {
        self.title = title
        self.confidence = confidence
        self.predictionID = prediction.id
    }
    
    init(row: Row) throws {
        title = try row.get("title")
        confidence = try row.get("confidence")
        predictionID = try row.get(Prediction.foreignIdKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("title", title)
        try row.set("confidence", confidence)
        try row.set(Prediction.foreignIdKey, predictionID)
        return row
    }
}

extension ImageClassification: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self, closure: { (builder) in
            builder.id()
            builder.string("title")
            builder.double("confidence")
            builder.parent(Prediction.self)
        })
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension ImageClassification: JSONConvertible {
    convenience init(json: JSON) throws {
        let predictionId: Identifier = try json.get("predictionId")
        guard let prediction = try Prediction.find(predictionId) else {
            throw RequestError.cantFindPermission
        }
        try self.init(title: json.get("title"), confidence: json.get("confidence"), prediction: prediction)
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", id)
        try json.set("title", title)
        try json.set("confidence", confidence)
        try json.set("predictionId", predictionID)
        return json
    }
}

extension ImageClassification: ResponseRepresentable {}

extension ImageClassification {
    var prediction: Parent<ImageClassification, Prediction> {
        return parent(id: predictionID)
    }
    
    var categories: Siblings<ImageClassification, KVText, Pivot<ImageClassification, KVText>> {
        return siblings()
    }
}




