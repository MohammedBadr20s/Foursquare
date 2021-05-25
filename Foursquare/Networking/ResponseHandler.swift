//
//  ResponseHandler.swift
//  Foursquare
//
//  Created by GoKu on 24/05/2021.
//

import Foundation
import Alamofire

//MARK:- Response Enum
enum ResponseEnum {
    case failure(_ error: ApiError?, _ data: Any?)
    case success(_ value: Any?)
}

//MARK:- ApiError Status Codes with message and Title
enum ApiError: Int {
    case BadRequest = 400
    case Forbidden = 403
    case ServerError = 500
    case ClientSideError = 0
    case unprocessableEntity = 422
    
    var message: String {
        switch self {
        case .BadRequest:
            return "Bad Request"
        case .Forbidden:
            return "Forbidden"
        case .ServerError:
            return "Internal Server Error"
        case.ClientSideError:
            return "Client Side Error"
        case .unprocessableEntity:
            return "Couldn't Parse Data"
        }
    }
    
    
    var title: String {
        switch self {
        case .BadRequest:
            return "Bad Request"
        case .Forbidden:
            return "Forbidden"
        case .ServerError:
            return "Internal Server Error"
        case.ClientSideError:
            return "Client Side Error"
        case .unprocessableEntity:
            return "Unprocessable Entity"
        }
    }
}

//MARK:- Response Handler
class ResponseHandler {
    
    static let shared = ResponseHandler()
    
    //MARK:- Handle Response Data according to Status Code
    func handleResponse<T: BaseModel>(_ response: AFDataResponse<Any>, model: T.Type) -> ResponseEnum {
        guard let code = response.response?.statusCode else {
            return .failure(ApiError.ClientSideError, nil)
        }
        
        if code < 400, let res = response.value as? Parameters {
            return handleResponseData(response: .success(res), model: model)
        } else {
            return handleError(response.value, code: code)
        }
    }
    
    //MARK:- Handle Error result
    func handleError(_ res: Any?, code: Int) -> ResponseEnum {
        let error = ApiError(rawValue: code)
        
        if let res = res {
            let errorModel = ErrorModel.decodeJSON(res, To: ErrorModel.self, format: .useDefaultKeys)
            return .failure(error, errorModel)
        }
        
        return .failure(error, nil)
    }
    //MARK:- Handle Response Data
    func handleResponseData<T: BaseModel>(response: ResponseEnum, model: T.Type) -> ResponseEnum {
        switch response {
        case .failure(let error, let data):
            return .failure(error, data)
        case .success(let value):
            guard let value = value else {
                return .failure(ApiError.ClientSideError, nil)
            }
            let responseData = model.decodeJSON(value, To: model, format: .useDefaultKeys)
            return .success(responseData)
        }
    }
    
}
