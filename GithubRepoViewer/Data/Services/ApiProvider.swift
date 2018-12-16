//
//  ApiProvider.swift
//  GithubRepoViewer
//
//  Created by Julia Mineeva on 16/12/2018.
//  Copyright © 2018 Julia Mineeva. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire
import EVReflection


extension HTTPURLResponse {
    public func successStatusCode() -> Bool {
        return 200 ..< 300 ~= statusCode
    }
}


protocol ApiErrorProtocol: Error {
    var localizedMessage: String { get }
    var code: Int { get }
}


struct ApiError: ApiErrorProtocol {
    
    var localizedMessage: String
    var code: Int
    
    init(failureReason: String?, errorCode: Int) {
        self.localizedMessage = failureReason ?? "Error"
        self.code = errorCode
    }
}


class ApiProvider {
    
    private let apiURL: URL!
    private let authTokenHeaderKey = "X-Auth-Token"
    private let appContentHeaderKey = "Content-Type"
    private let userAgent = "User-Agent"
    private let defaults = UserDefaults.standard
    private let authTokenKey = "authTokenKey"
    private let cookie = "Cookie"
    
    var authToken: String? {
        get {
            return defaults.string(forKey: authTokenKey)
        }
        set(newAuthToken) {
            defaults.set(newAuthToken, forKey: authTokenKey)
        }
    }
    
    var isAnonymousAuth = false
    
    private var authorizationHeaders: [String: String] {
        var headers = [String:String]()
        headers[appContentHeaderKey] = "application/json"
        
        if let cookies: [String:Any] = defaults.value(forKey: AppConstants.Cookies) as! [String:Any]? {
            var cookie_all:String = ""
            for (key, value) in cookies {
                cookie_all = "\(cookie_all)\(key)=\(value);"
            }
            
            if isAnonymousAuth {
                if let supportCookies = defaults.value(forKey: AppConstants.CookiesSupport) as? [String : Any] {
                    for (key, value) in supportCookies {
                        cookie_all = "\(cookie_all)\(key)=\(value);"
                    }
                }
            }
            
            headers[cookie] = cookie_all
        }
        
        //        if let authToken = authToken {
        //            headers[ authTokenHeaderKey] = authToken
        //        }
        return headers
    }
    
    required init(URL: URL) {
        apiURL = URL
    }
    
    func request (
        path: String,
        method: Alamofire.HTTPMethod,
        parameters: [String: AnyObject]? = nil,
        encoding: ParameterEncoding = JSONEncoding.default) -> Observable<(HTTPURLResponse, AnyObject)> {
        
        debugPrint("")
        debugPrint("=========================== REQ \(String(describing: parameters?["action"])) START ========================")
        
        debugPrint(authorizationHeaders)
        debugPrint(parameters)
        
        return RxAlamofire.requestString(
            method,
            apiURL.appendingPathComponent(path),
            parameters: parameters,
            encoding: encoding,
            headers: authorizationHeaders)
            .flatMap({ response, data -> Observable<(HTTPURLResponse, AnyObject)> in
                if response.successStatusCode(){
                    let str = data as String
                    guard !(str.isEmpty) else {return Observable.error(self.error(response: response, data: data))}
                    
                    if let cookie: String = response.allHeaderFields[AppConstants.CookieHeaderKey] as? String {
                        var cookies = self.defaults.dictionary(forKey: AppConstants.Cookies) ?? [String:Any]()
                        
                        var parsed_cookie = cookie
                        var startIdx = cookie.index(of: "=") ?? cookie.startIndex
                        let key = String(cookie[..<startIdx])//.substring(to: startIdx)
                        startIdx = cookie.index(after: startIdx)
                        parsed_cookie = String(cookie[startIdx...])//.substring(from: startIdx)
                        
                        let endIdx = parsed_cookie.index(of: ";") ?? parsed_cookie.endIndex
                        parsed_cookie = String(parsed_cookie[..<endIdx])//.substring(to: endIdx)
                        cookies[key] = parsed_cookie
                        self.defaults.setValue(cookies, forKey:AppConstants.Cookies)
                    }
                    return Observable.just((response, data as AnyObject))
                } else {
                    return Observable.error(self.error(response: response, data: data))
                }
            }).debug()
            .flatMap({ response, data -> Observable<(HTTPURLResponse, AnyObject)> in
                debugPrint("=========================== REQ \(String(describing: parameters?["action"])) END ========================")
                debugPrint("")
                return Observable.just((response, data as AnyObject))
            })
            .observeOn(MainScheduler.instance)
    }
    
    func multipartRequest (
        path: String,
        method: Alamofire.HTTPMethod,
        parameters: [String: AnyObject]? = nil,
        data: @escaping (MultipartFormData) -> (),
        encoding: ParameterEncoding = JSONEncoding.default) -> Observable<(HTTPURLResponse, AnyObject)> {
        
        debugPrint("")
        debugPrint("=========================== REQ \(((parameters ?? [:])["action"] as? String) ?? "") START ========================")
        
        debugPrint(authorizationHeaders)
        debugPrint(parameters ?? "")
        
        return SessionManager.default.rx.encodeMultipartUpload(
            to: apiURL.appendingPathComponent("/"),
            method: method,
            headers: authorizationHeaders, data: data)
            .flatMap({ response, data -> Observable<(HTTPURLResponse, AnyObject)> in
                if response.successStatusCode(){
                    return Observable.just((response, data as AnyObject))
                } else {
                    return Observable.error(self.error(response: response, data: (data as? String) ?? "Data is nil!!!"))
                }
            }).debug()
            .flatMap({ response, data -> Observable<(HTTPURLResponse, AnyObject)> in
                debugPrint("=========================== REQ \(((parameters ?? [:])["action"] as? String) ?? "") END ========================")
                debugPrint("")
                return Observable.just((response, data as AnyObject))
            })
            .observeOn(MainScheduler.instance)
    }
    
    private func error(response: HTTPURLResponse, data: String) -> Error {
        let message = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
        return ApiError.init(failureReason:message, errorCode:response.statusCode)
    }
}

extension Reactive where Base: SessionManager {
    func encodeMultipartUpload(to url: URLConvertible,
                               method: HTTPMethod = .post,
                               headers: HTTPHeaders = [:],
                               data: @escaping (MultipartFormData) -> ()) -> Observable<(HTTPURLResponse, AnyObject)>
    {
        return Observable.create { observer in
            self.base.upload(multipartFormData: data,
                             to: url,
                             method: method,
                             headers: headers,
                             encodingCompletion: { (result: SessionManager.MultipartFormDataEncodingResult) in
                                switch result {
                                case .failure(let error):
                                    observer.onError(error)
                                case .success(let upload, _, _):
                                    upload.responseJSON { response in
                                        guard let resp = response.response else {
                                            observer.onError(ApiError(failureReason: "Uploading files response is nil!!", errorCode: -6000))
                                            observer.onCompleted()
                                            return
                                        }
                                        
                                        switch response.result {
                                        case .success(let data):
                                            let dict = data as? NSDictionary
                                            let string = dict?.toJsonString() ?? ""
                                            observer.onNext((resp, string as AnyObject))
                                        case .failure(let error):
                                            observer.onError(error)
                                        }
                                        observer.onCompleted()
                                    }
                                }
            })
            
            return Disposables.create()
        }
    }
}
