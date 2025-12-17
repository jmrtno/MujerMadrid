struct WomenCarePointDetailHeaderSectionObservedModel {
    /// Center name
    public var title: String
    /// Center description
    public var description: String
    /// Center services
    public var services: String
    
    /// Initializer for `WomenCarePointDetailHeaderSectionObservedModel`
    /// - Parameters:
    ///  - title: center name
    ///  - description: Center description
    ///  - services: center services
    public init(title: String, description: String, services: String) {
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
