struct WomenCarePointHomeListSectionObservedModel {
    /// information from centers
    var data: [WomenCarePointModel.EventModel]?
    /// Boolean that show/hide centers list
    var showList: Bool
    
    /// Initializer for `WomenCarePointHomeListSectionObservedModel`
    /// - Parameters:
    ///  - data: information from centers
    ///  - showList: Boolean that show/hide centers list
    init(data: [WomenCarePointModel.EventModel]?, showList: Bool) {
        self.data = data
        self.showList = showList
    }
    
    /// empty initializer
    init() {
        data = []
        showList = false
    }
}
