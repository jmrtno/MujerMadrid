//
//  WomenCarePointDetailHeaderRenderModel.swift
//  MujerMadrid
//
//  Created by Javier Martin on 18/7/25.
//

public struct WomenCarePointDetailHeaderSectionRenderModel {

    public let title: String
    public let centerType: String
    
    public init(title: String, centerType: String) {
        self.title = title
        self.centerType = centerType
    }

    init() {
        title = ""
        centerType = ""
    }
}
