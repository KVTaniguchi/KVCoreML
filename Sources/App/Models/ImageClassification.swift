import FluentProvider

final class ImageClassification: Model {
    
    let storage = Storage()
    
    let title: String
    let predictions: [Prediction]
    
    init(title: String, predictions: [Prediction]) {
        self.title = title
        self.predictions = predictions
    }
    
    init(row: Row) throws {
        title = try row.get("title")
        predictions = try row.get("predictions")
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("title", title)
        try row.set("predictions", predictions)
        return row
    }
}

final class Prediction: Model {
    let storage = Storage()
    
    let title: String
    let confidence: Double
    
    init(title: String, confidence: Double) {
        self.title = title
        self.confidence = confidence
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("title", title)
        try row.set("confidence", confidence)
        return row
    }
    
    init(row: Row) throws {
        title = try row.get("title")
        confidence = try row.get("confidence")
    }
}
