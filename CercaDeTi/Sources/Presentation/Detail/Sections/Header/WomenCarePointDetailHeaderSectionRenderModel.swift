//
//  WomenCarePointDetailHeaderSectionRenderModel.swift
//  MujerMadrid
//
//  Created by Javier Martin on 18/7/25.
//

struct WomenCarePointDetailHeaderSectionRenderModel {
    /// Center name
    public let title: String
    /// Center type
    public let centerType: String

    /// Initializer for `WomenCarePointDetailHeaderSectionRenderModel`
    /// - Parameters:
    ///  - title: center name
    ///  - centerType: Center type
    public init(title: String, centerType: String) {
        self.title = title
        self.centerType = centerType
    }

    /// empty initializer
    init() {
        title = ""
        centerType = ""
    }
}
