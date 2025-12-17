import FDependencyInjector
import FData
import Foundation

/// Contract that defines the available API endpoints related to Women Care Points.
public protocol WomenCarePointAPIContract: Instanciable {

    /// Creates an API request to fetch the information displayed on the Women Care Points home screen.
    ///
    /// - Returns: An object conforming to `HTTPAPIContract` that represents the home information request.
    func getWomanCarePointHomeInfo() -> any HTTPAPIContract

    /// Creates an API request to fetch the detailed information of a specific Women Care Point.
    ///
    /// - Parameter centerId: The unique identifier of the care center.
    /// - Returns: An object conforming to `HTTPAPIContract` that represents the detail information request.
    func getWomanCarePointDetailInfo(centerId: String) -> any HTTPAPIContract
}

/// Default implementation of `WomenCarePointAPIContract`.
///
/// This class is responsible for building the API endpoints used to retrieve
/// Women Care Points information from the Madrid public data services.
final class WomenCarePointAPI: WomenCarePointAPIContract {

    /// Required initializer for dependency injection.
    public required init() {
        /* Required by the injector */
    }

    /// Returns the API endpoint used to retrieve the home information
    /// for all Women Care Points.
    ///
    /// - Returns: A `HTTPAPIContract` representing the home information endpoint.
    public func getWomanCarePointHomeInfo() -> any HTTPAPIContract {
        FetchHomeInformationEndpoint()
    }

    /// Returns the API endpoint used to retrieve detailed information
    /// for a specific Women Care Point.
    ///
    /// - Parameter centerId: The unique identifier of the care center.
    /// - Returns: A `HTTPAPIContract` representing the detail information endpoint.
    public func getWomanCarePointDetailInfo(centerId: String) -> any HTTPAPIContract {
        FetchDetailInformationEndpoint(centerId: centerId)
    }

    /// API endpoint used to fetch the general Women Care Points home information.
    ///
    /// This endpoint retrieves a list of available care centers and
    /// their basic public information.
    struct FetchHomeInformationEndpoint: HTTPAPIContract {

        /// URL path for the home information endpoint.
        let path: String

        /// Initializes the endpoint with the predefined public data URL.
        init() {
            path = "https://datos.madrid.es/egob/catalogo/205736-0-atencion-mujeres.json"
        }
    }

    /// API endpoint used to fetch detailed information for a specific care center.
    struct FetchDetailInformationEndpoint: HTTPAPIContract {

        /// URL path for the detail information endpoint.
        let path: String

        /// Initializes the endpoint with the provided care center identifier.
        ///
        /// - Parameter centerId: The unique identifier of the care center.
        init(centerId: String) {
            path = "https://datos.madrid.es/egob/catalogo/tipo/entidadesyorganismos/\(centerId).json"
        }
    }
}
