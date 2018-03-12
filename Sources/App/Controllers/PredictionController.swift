
import FluentProvider


struct PredictionController {
    func addRoutes(to drop: Droplet) {
        let predictionGroup = drop.grouped("api", "predictions")
        predictionGroup.get(handler: allPredictions)
        predictionGroup.post("create", handler: createPrediction)
        predictionGroup.get(Prediction.parameter, handler: getPrediction)
    }
    
    func createPrediction(_ req: Request) throws -> ResponseRepresentable {
        guard let json = req.json else {
            throw RequestError.badJSON
        }
        
        let prediction = try Prediction(json: json)
        try prediction.save()
        return prediction
    }
    
    func allPredictions(_ req: Request) throws -> ResponseRepresentable {
        let predictions = try Prediction.all()
        return try predictions.makeJSON()
    }
    
    func getPrediction(_ req: Request) throws -> ResponseRepresentable {
        let prediction = try req.parameters.next(Prediction.self)
        return prediction
    }
}
