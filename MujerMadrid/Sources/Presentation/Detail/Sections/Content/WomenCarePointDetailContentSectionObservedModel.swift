import MapKit

struct WomenCarePointDetailContentSectionObservedModel {
    /// information from centers
    public var data: [WomenCarePointModel.EventModel]?
    
    /// Initializer for `WomenCarePointDetailContentSectionObservedModel`
    /// - Parameters:
    ///  - data: information from centers
    public init(data: [WomenCarePointModel.EventModel]? = nil) {
        self.data = data
    }
    /// empty initializer
    init() {
        data = []
    }
}
