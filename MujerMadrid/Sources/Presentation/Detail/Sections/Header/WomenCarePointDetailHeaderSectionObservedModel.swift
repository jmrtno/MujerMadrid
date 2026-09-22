struct WomenCarePointDetailHeaderSectionObservedModel {
    /// Center name
    var title: String
    /// Center description
    var description: String
    /// Center services
    var services: String
    
    /// Initializer for `WomenCarePointDetailHeaderSectionObservedModel`
    /// - Parameters:
    ///  - title: center name
    ///  - description: Center description
    ///  - services: center services
    init(title: String, description: String, services: String) {
        self.title = title
        self.description = description
        self.services = services
    }
    
    /// empty initializer
    init() {
        title = ""
        description = ""
        services = ""
    }
}
