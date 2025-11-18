//
//  WomenCarePointDetailContentSectionObservedModel.swift
//  MujerMadrid
//
//  Created by Javier Martin on 18/7/25.
//
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
