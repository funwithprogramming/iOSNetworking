
import Foundation
//
//  YTErrors.swift
//  _Swift
//
//  Created by Alekh on 05/05/16.
//  Copyright © 2016 . All rights reserved.
//

/*
 Structure which defines Errors/response types associalted from search suggestions
 */
struct SuggestionError {
    
    var firstErrorLabel:String?
    var multilineErrorLabel:String?
    var imageName: String?
    var link:String?
    
    enum SuggestionErrorType:String {
        case NoSuggestion
        case NoActivitiesInCity
        case SearchNoSuggestion
    }
    
    var suggestionErrorType:SuggestionErrorType
    
    init(statusCode:String, message:String) {
        multilineErrorLabel = message
        suggestionErrorType = SuggestionErrorType.NoActivitiesInCity
    }
    
    init(message:String)
    {
        multilineErrorLabel = message
        suggestionErrorType = SuggestionErrorType.NoSuggestion
    }
    
}

/*
 Structure which defines Errors/response types associalted from HTTP response
 The ServerResponseStatus contains the sub response contained in network
 */
public struct YTHTTPResponseStatus : Error {
    
    public enum ServerResponseStatus : Error,CustomStringConvertible {
        
        //The server Responded and this hit is now ok
        case success
        // Can't connect to the server
        case connectionError(error: NSError, message:String)
        // The server responded with a non 200 status code
        case serverError(statusCode: Int, errorMessage : String)
        //NSdata to string conversion Error in response
        case  responseStringNotValid
        // No Data in response From Server
        case  noDataError
        //Failure With Other  Reason . Could be custom API issues
        case  failure(errorMessage:String)
        //Failure Without other Reason
        case  failureOther
        
        public var description: String {
            get {
                switch self {
                case .success:
                    return "Success"
                case .connectionError(let error, let message):
                    return "Error:\(error) Message:\(message)"
                case .serverError(let statusCode, let errorMessage):
                    return "StatusCode:\(statusCode) errorMessage:\(errorMessage)"
                case .responseStringNotValid:
                    return "ResponseStringNotValid. Not a valid UTF8 String"
                case .failure(let errorMessage):
                    return "Error Message : \(errorMessage)"
                case .noDataError:
                    return "No incoming data"
                default:
                    return "Uknown error"
                }
            }
        }
    }
    public var ytServerResponse :    ServerResponseStatus
}

/*
 Enum which defines Specifc Error Associated With
 */
protocol YTActivityHTTPResponse  {
    
    /*
     Case in which there is some problem with JSON Validation
     */
}

/*
 Protocol which needs to be implemented to defines Success and Failure of API HIt
 */
protocol CheckError {
    var  isSuccessFull : Bool { get }
}

/*
 Extension of YTHTTPResponseStatus  which in addition of Normal errors associated with API hit also adds its own error. Like JSON Validation, Wrong Parameters etc. Please add your custom error cases in this enum
 TODO: CHeck whether description is working here or not. This is wrapped in YTHTTPResponseStatus as we can also throw this error
 */
extension YTHTTPResponseStatus   {
    
    
    // Defines custom erros associated with activity API
    enum ActivityAPIResponse : CustomStringConvertible, Error {
        
        case jsonNotValid
        case requestNotValid
        case successWithMessage(String?)
        case failureWithMessage(String?)
        case failureWithNoCityFound(String?)
        var description: String {
            get {
                switch self {
                case .jsonNotValid:
                    return "JsonNotValid "
                case .requestNotValid:
                    return "RequestNotValid "
                case .successWithMessage(let message):
                    return message ?? "" + "The API Hit was successfull" ?? ""
                case .failureWithMessage(let message):
                    return message ?? ""
                case .failureWithNoCityFound(let message):
                    return message ?? ""
                }
            }
        }
    }
}

/*
 Protocol which define whether there is error in response. We would checck
 type of errors here
 */
protocol YTActivityResponseError {
    
    //Function which check the type of error in API response of activity
    func isActivityResponseSuccess() -> Bool
    
    func isActivityResponseNoCityFound() -> Bool
}

/*
 Enum which define types of Response Keys(Dictionary Keys) defined in dictionary
 */
enum YTResponseKeys:String{
    
    case data      = "data"
    case code      = "resCode"
    case message   = "resMessage"
    case apicallId = "apicallId"
    case interactionType   = "interactionType"
}

/*
 Extension which modifies the response expected specfic in YTActvity to JSON value. This Function should be implemented
 */
extension YTResponse : YTActivityResponseError {
    
    //The code returned by Custom Activities API
    var resCode : Int? {
        get {
            return self.swiftjsonObject?[YTResponseKeys.code.rawValue].intValue
        }
    }
    var apiMessage : String? {
        get {
            let apiMessage  = self.swiftjsonObject?[YTResponseKeys.message.rawValue].stringValue
            return apiMessage
        }
    }
    
    var interactionType : String? {
        get {
            let apiMessage  = self.swiftjsonObject?[YTResponseKeys.interactionType.rawValue].stringValue
            return apiMessage
        }
    }
    
    /*
     This handles the activity APIU general response
     */
    var ytActivityResponse : YTHTTPResponseStatus.ActivityAPIResponse? {
        get {
            
            if (self.isServerResponseSuccessfull()) {
                let servicesResCode = self.resCode
                if let _ = servicesResCode  {
                    if servicesResCode != 200 {
                        // in case of fetching city
                        if servicesResCode == 102 {
                            return YTHTTPResponseStatus.ActivityAPIResponse.failureWithNoCityFound(String(describing: self.resCode))
                        }
                        return YTHTTPResponseStatus.ActivityAPIResponse.failureWithMessage(self.apiMessage)
                    }
                }
                return YTHTTPResponseStatus.ActivityAPIResponse.successWithMessage(self.apiMessage)
            }
            //Server is not successfull
            return YTHTTPResponseStatus.ActivityAPIResponse.failureWithMessage(self.apiMessage)
            //TODO: Other ActivityAPIResponse Needs to be handled like json not valid etcreturn YTHTTPResponseStatus.ActivityAPIResponse.FailureWithMessage(self.apiMessage)
        }
    }
    func isActivityResponseSuccess() -> Bool {
        //TODO:Modify this static string comparison
        if self.resCode == 200 {
            return true
        }
        return false
    }
    //Message to be printed in API Success/Failure Logs
    var printAPILogMessage : String? {
        get {
            return ytActivityResponse?.description
        }
    }
    
    func isActivityResponseNoCityFound() -> Bool {
        
        if self.resCode == 102 {
            return true
        }
        return false
    }
}







