import MapKit

struct WomenCarePointDetailContentSectionObservedModel {
    /// information from centers
    var data: [WomenCarePointModel.EventModel]?
    
    /// Initializer for `WomenCarePointDetailContentSectionObservedModel`
    /// - Parameters:
    ///  - data: information from centers
    init(data: [WomenCarePointModel.EventModel]? = nil) {
        self.data = data
    }
    /// empty initializer
    init() {
        data = []
    }
}
