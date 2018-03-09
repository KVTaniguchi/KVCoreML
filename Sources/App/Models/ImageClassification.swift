import FluentProvider

final class ImageClassification: Model {
    
    let storage = Storage()
    
    let title: String
    let confidence: Double
    
    init(title: String, confidence: Double) {
        self.title = title
        self.confidence = confidence
    }
    
    init(row: Row) throws {
        title = try row.get("title")
        confidence = try row.get("confidence")
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("title", title)
        try row.set("confidence", confidence)
        return row
    }
}

extension ImageClassification: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self, closure: { (builder) in
            builder.id()
            builder.string("title")
            builder.double("confidence")
        })
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension ImageClassification: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(title: json.get("title"), confidence: json.get("confidence"))
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", id)
        try json.set("title", title)
        try json.set("confidence", confidence)
        return json
    }
}

extension ImageClassification: ResponseRepresentable {}
//extension Reminder: ResponseRepresentable {}

//final class Prediction: Model {
//    let storage = Storage()
//
//    let title: String
//    let confidence: Double
//
//    init(title: String, confidence: Double) {
//        self.title = title
//        self.confidence = confidence
//    }
//
//    func makeRow() throws -> Row {
//        var row = Row()
//        try row.set("title", title)
//        try row.set("confidence", confidence)
//        return row
//    }
//
//    init(row: Row) throws {
//        title = try row.get("title")
//        confidence = try row.get("confidence")
//    }
//}

//extension Prediction: Preparation {
//    static func prepare(_ database: Database) throws {
//        try database.create(self, closure: { (builder) in
//            builder.id()
//            builder.string("title")
//            builder.double("confidence")
//        })
//    }
//
//    static func revert(_ database: Database) throws {
//        try database.delete(self)
//    }
//}

