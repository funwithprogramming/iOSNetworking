//
//  Enums.swift
//  _Swift
//
//  Created by Alekh on 06/05/16.
//  Copyright © 2016 . All rights reserved.
//

import Foundation

/*
 Enum which define type pf method used
 */
public enum HTTPMethodType: String {
  
  case GET    = "GET"
  case POST   = "POST"
  case PUT    = "PUT"
  case DELETE = "DELETE"
}

/*
 Enum which define Some Common Content Types
 */
public enum ContentTypes: String {
  
  case JSON        = "application/json"
  case UrlEncoded  = "application/x-www-form-urlencoded"
}

/*
 Enum which define Some Common Header Types
 */
public typealias MIMEType = String
public enum HTTPHeader  {
  
  case ContentDisposition(String)
  case Accept([MIMEType])
  case ContentType(ContentTypes)
  case Custom(String, String)
  
  var key: String {
    switch self {
    case .ContentDisposition:
      return "Content-Disposition"
    case .Accept:
      return "Accept"
    case .ContentType:
      return "Content-Type"
    case .Custom(let key, _):
      return key
    }
  }
  
  var requestHeaderValue: String {
    switch self {
    case .ContentDisposition(let disposition):
      return disposition
    case .ContentType(let type):
      return type.rawValue
    case .Custom(_, let value):
      return value
    default:return ""
    }
  }
  
  func setRequestHeader(request: NSMutableURLRequest) {
    request.setValue(self.requestHeaderValue, forHTTPHeaderField:self.key)
  }
}

extension HTTPHeader: Equatable {
  
}

public func ==(lhs: HTTPHeader, rhs: HTTPHeader) -> Bool {
  switch (lhs, rhs) {
  case (let .ContentType(var1),let .ContentType(var2)):
    return(var1.rawValue == var2.rawValue)
  default:
    return false
  }
}

