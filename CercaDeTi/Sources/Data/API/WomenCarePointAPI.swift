//
//  WomenCarePointAPI.swift
//  MujerMadrid
//
//  Created by Javier Martin on 16/7/25.
//

import FDependencyInjector
import FData
import Foundation

public protocol WomenCarePointAPIContract: Instanciable {
    func getWomanCarePointHomeInfo() -> any HTTPAPIContract
    func getWomanCarePointDetailInfo(centerId: String) -> any HTTPAPIContract
}

open class WomenCarePointAPI: WomenCarePointAPIContract {
    public required init() {
        /* Required by the injector */
    }
    
    public func getWomanCarePointHomeInfo() -> any HTTPAPIContract {
        FetchHomeInformationEndpoint()
    }
    
    public func getWomanCarePointDetailInfo(centerId: String) -> any HTTPAPIContract {
        FetchDetailInformationEndpoint(centerId: centerId)
    }
    
    struct FetchHomeInformationEndpoint: HTTPAPIContract {
        let path: String

        init() {
            path = "https://datos.madrid.es/egob/catalogo/205736-0-atencion-mujeres.json"
        }
    }
    
    struct FetchDetailInformationEndpoint: HTTPAPIContract {
        let path: String

        init(centerId: String) {
            path = "https://datos.madrid.es/egob/catalogo/tipo/entidadesyorganismos/\(centerId).json"
        }
    }
}
