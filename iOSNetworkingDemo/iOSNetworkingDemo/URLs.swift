//
//  URLs.swift
//  iOSNetworkingDemo
//
//  Created by Alekh on 30/08/17.
//
//

import Foundation
import iOSNetwork


public enum AppEndpoint: Endpoint {
    
    case GetPOSTURL
    
    public var path: String {
        switch self {
        case .GetPOSTURL: return ""
        }
    }
    
    public var method: HTTPMethodType {
        switch self {
        case .GetPOSTURL : return .POST
        }
    }
    
    public var endPointName: String {
        switch self {
        case .GetPOSTURL : return "MYUsersURL"
        }
    }
}

//Defines the URL
enum ServicesBaseURLs {
    
    
    private static var appBaseURL : String  {

        return "https://reqres.in/"
    }
    
    static var myUsersURL : String  {
        get {
            return ServicesBaseURLs.appBaseURL + "api/users"
        }
    }
}
