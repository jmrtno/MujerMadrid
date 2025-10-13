//
//  WomenCarePointHomeListSectionObservedModel.swift
//  MujerMadrid
//
//  Created by Javier Martin on 18/7/25.
//

public struct WomenCarePointHomeListSectionObservedModel {
    public var data: [WomenCarePointModel.EventModel]?
    public var showList: Bool
    
    public init(data: [WomenCarePointModel.EventModel]?, showList: Bool) {
        self.data = data
        self.showList = showList
    }
    
    public static var empty: WomenCarePointHomeListSectionObservedModel {
        return WomenCarePointHomeListSectionObservedModel(data: [], showList: false)
    }
}
