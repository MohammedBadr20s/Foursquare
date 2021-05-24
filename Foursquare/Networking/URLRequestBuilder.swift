//
//  URLRequestBuilder.swift
//  Foursquare
//
//  Created by GoKu on 24/05/2021.
//

import Foundation
import Alamofire
import RxSwift

protocol URLRequestBuilder: URLRequestConvertible {
    
    var baseURL: String { get }
    
    var mainURL: URL { get }
    
    var requestURL: URL { get }
    
    var path: String { get }
    
    var headers: HTTPHeaders { get }
    
    var parameters: Parameters? { get }
    
    var method: HTTPMethod { get }
    
    var encoding: ParameterEncoding { get }
    
    var urlRequest: URLRequest { get }
    
    func Request<T: BaseModel>(model: T.Type) -> Observable<T>
    
    func handleError<T: BaseModel>(apiError: ApiError?, data: Any?, observer: AnyObserver<T>)
}


extension URLRequestBuilder {
    
    var mainURL: URL {
        return URL(string: baseURL)!
    }
    
    var requestURL: URL {
        let urlStr = mainURL.absoluteString + path
        return URL(string: urlStr)!
    }
    
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        headers.forEach{request.addValue($0.value, forHTTPHeaderField: $0.name)}
        return request
    }
    
    func asURLRequest() throws -> URLRequest {
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    func Request<T:BaseModel>(model: T.Type) -> Observable<T> {
        
        return Observable.create { (observer: AnyObserver<T>) -> Disposable in
            AF.request(self).responseJSON { (response: AFDataResponse<Any>) in
                response.interceptResuest("\(self.requestURL)", self.parameters)
                let resEnum = ResponseHandler.shared.handleResponse(response, model: model)
                
                switch resEnum {
                case .failure(let error, let data):
                    handleError(apiError: error, data: data, observer: observer)
                case .success(let value):
                    if let model = value as? T {
                        observer.onNext(model)
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
    func handleError<T: BaseModel>(apiError: ApiError?, data: Any?, observer: AnyObserver<T>) {
        if let apiError = apiError {
            observer.onError(ErrorModel(meta: Meta(code: apiError.rawValue, errorType: apiError.title, errorDetail: apiError.message, requestID: "")))
        } else if let error = data as? ErrorModel {
            observer.onError(error)
        } else if let errorArr = data as? [ErrorModel] {
            let defaultError = ErrorModel(meta: Meta(code: apiError?.rawValue ?? 0, errorType: apiError?.title ?? "", errorDetail: apiError?.message ?? "", requestID: ""))
            observer.onError(errorArr.first ?? defaultError)
        }
    }
}
