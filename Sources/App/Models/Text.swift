
import FluentProvider


final class KVText: Model {
    
    static let entity = "text"
    
    let storage = Storage()
    
    let title: String
    
    init(title: String) {
        self.title = title
    }
    
    init(row: Row) throws {
        title = try row.get("title")
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("title", title)
        return row
    }
}

extension KVText: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string("title")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension KVText: JSONConvertible {
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

extension KVText: ResponseRepresentable {}

extension KVText {
    var imageClassificationSiblings: Siblings<KVText, ImageClassification, Pivot<KVText, ImageClassification>> {
        return siblings()
    }
}
