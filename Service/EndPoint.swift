//
//  EndPoint.swift
//  VaccinationCenterMapApp
//
//  Created by 황신택 on 2021/11/20.
//

import Foundation
import CoreLocation
import Moya

/// Using moya get json data from server
enum VaccinationCenterService {
    struct Param {
        let page: Int
        let perPage: Int
        let serviceKey: String = apiKey
        
        var dic: [String: Any] {
            return [
                "page": page,
                "perPage": perPage,
                "serviceKey": serviceKey
            ]
        }
    }
    case center(Param)
}


extension VaccinationCenterService: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.odcloud.kr/api")!
    }
    
    var path: String {
        switch self {
        case .center:
           return "/15077586/v1/centers"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .center(let param):
            return .requestParameters(parameters: param.dic, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}

