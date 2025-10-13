//
//  WomenCarePointDetailHeaderSectionObservedModel.swift
//  MujerMadrid
//
//  Created by Javier Martin on 18/7/25.
//

public struct WomenCarePointDetailHeaderSectionObservedModel {
    public var title: String
    public var description: String
    public var services: String
    
    public init(title: String, description: String, services: String) {
        self.title = title
        self.description = description
        self.services = services
    }
    
    init() {
        title = ""
        description = ""
        services = ""
    }
}
