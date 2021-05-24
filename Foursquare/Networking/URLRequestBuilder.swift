//
//  URLRequestBuilder.swift
//  Foursquare
//
//  Created by GoKu on 24/05/2021.
//

import Foundation
import Alamofire
import RxSwift

//MARK:- URL Request Building Protocol
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

//MARK:- URLRequestBuilder Common Properties and Functions
extension URLRequestBuilder {
    
    var baseURL: String {
        return Environment.current()?.rawValue ?? ServerPath.baseURL.rawValue
    }
    
    var mainURL: URL {
        /*Forced Typecast is safe here because your baseURL must be valid or the app will crash with the First API Request
         and navigate to this line of code before even launch
         */
        return URL(string: baseURL)!
    }
    
    var requestURL: URL {
        /*Forced Typecast is safe here because if mainURL is valid requestURL is going to be valid even if path is empty
         */
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
    //MARK:- API Request Function
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
    //MARK:- Handle Error comes from Request Function
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
