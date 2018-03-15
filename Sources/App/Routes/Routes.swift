import Vapor

extension Droplet {
    func setupRoutes() throws {
        let classificationController = ClassificationContoller()
        classificationController.addRoutes(to: self)
        let predictionsController = PredictionController()
        predictionsController.addRoutes(to: self)
        let textController = KVTextController()
        textController.addRoutes(to: self)
    }
}
