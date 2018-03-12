import Vapor

extension Droplet {
    func setupRoutes() throws {
        let classificationController = ClassificationContoller()
        classificationController.addRoutes(to: self)
    }
}
