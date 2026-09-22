import Foundation

struct WomenCarePointDetailHeaderSectionRenderModel {
    /// Center name
    let title: String
    /// Center type
    let centerType: String

    /// Initializer for `WomenCarePointDetailHeaderSectionRenderModel`
    /// - Parameters:
    ///  - title: center name
    ///  - centerType: Center type
    init(title: String, centerType: String) {
        self.title = title
        self.centerType = centerType
    }

    /// empty initializer
    init() {
        title = ""
        centerType = ""
    }
}
