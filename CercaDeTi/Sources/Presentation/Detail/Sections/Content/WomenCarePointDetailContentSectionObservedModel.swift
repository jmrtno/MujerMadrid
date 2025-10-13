//
//  WomenCarePointDetailContentSectionObservedModel.swift
//  MujerMadrid
//
//  Created by Javier Martin on 18/7/25.
//
import MapKit

public struct WomenCarePointDetailContentSectionObservedModel {
    public var data: [WomenCarePointModel.EventModel]?
    // public var showLoading: Bool
    
    public init(data: [WomenCarePointModel.EventModel]? = nil) {
        self.data = data
    }
    
    public static var empty: WomenCarePointDetailContentSectionObservedModel {
        return WomenCarePointDetailContentSectionObservedModel(data: [] /* showLoading: true */)
    }
}
