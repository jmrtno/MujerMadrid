//
//  WomenCarePointHomeListSectionObservedModel.swift
//  MujerMadrid
//
//  Created by Javier Martin on 18/7/25.
//

public struct WomenCarePointHomeListSectionObservedModel {
    /// information from centers
    public var data: [WomenCarePointModel.EventModel]?
    /// Boolean that show/hide centers list
    public var showList: Bool
    
    /// Initializer for `WomenCarePointHomeListSectionObservedModel`
    /// - Parameters:
    ///  - data: information from centers
    ///  - showList: Boolean that show/hide centers list
    public init(data: [WomenCarePointModel.EventModel]?, showList: Bool) {
        self.data = data
        self.showList = showList
    }
    
    /// empty initializer
    init() {
        data = []
        showList = false
    }
}
