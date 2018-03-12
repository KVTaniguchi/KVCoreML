import Vapor
import FluentProvider

// for learning sake, a prediction is a parent to an image classification / text classification / image emotion

final class Prediction: Model {
    let storage = Storage()

    let title: String
    
    init(title: String) {
        self.title = title
    }

    func makeRow() throws -> Row {
        var row = Row()
        try row.set("title", title)
        return row
    }

    init(row: Row) throws {
        title = try row.get("title")
    }
}

extension Prediction: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self, closure: { (builder) in
            builder.id()
            builder.string("title")
        })
    }

    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Prediction: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(title: json.get("title"))
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", id)
        try json.set("title", title)
        
        return json
    }
}

extension Prediction: ResponseRepresentable {}

extension Prediction {
    var imageClassifications: Children<Prediction, ImageClassification> {
        return children()
    }
}

