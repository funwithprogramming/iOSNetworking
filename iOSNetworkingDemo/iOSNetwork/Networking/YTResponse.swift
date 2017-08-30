
import Foundation
//import SwiftyJSON
//
//  YTResponse.swift
//  _Swift
//
//  Created by Alekh on 04/05/16.
//  Copyright © 2016 . All rights reserved.
//

//This structure encapsulates response. This is general Response expected from Network
public struct YTResponse {
    
    //Response object
    public var yTHTTPResponseStatus : YTHTTPResponseStatus
    
    //NSURL Response Object
    public var nsurlResponseObject : (data:Data?, urlResponse:URLResponse?, error:Error?)
    
    //Data in String Format
    public var dataString : String?
    
    ///It records the total time taken a particular request
    public var timeTakenByRequest : TimeInterval = 0
    
    //Whether server hit was successfull. This checks all the conditions and returns the success
    public func isServerResponseSuccessfull() -> Bool {
        switch self.yTHTTPResponseStatus.ytServerResponse {
        case .success :
            return true
        default:
            return false
        }
    }
}
/*
 Protocol which define types the response expected in  Activity Network Response
 Generally If it is json then we should implement this protocol
 */
protocol YTActivityResponse {
    
    var jsonResponse:Dictionary<String,AnyObject>? {get}
    //Getting the Swifty JSON Object
    var swiftjsonObject: JSON? { get }
}

/*
 Extension which modifies the response expected specfic in YTActvity to JSON value. This Function should be implemented
 */
extension YTResponse : YTActivityResponse {
    
    //TODO: Implement This method
    var jsonResponse: Dictionary<String,AnyObject>?{
        get {
            return ["eded":"eded" as AnyObject]
        }
    }
    
    var swiftjsonObject : JSON?{
        get {
            if let _ = self.dataString {
                let data = self.dataString!.data(using: String.Encoding.utf8)
                //print(data)
                let swiftJsonObj = try? JSON(data: data!)
                print("JSON RESPONSE:\(swiftJsonObj)JSON RESPONSE end")
                return swiftJsonObj
            }
            else {
                return nil
            }
        }
    }
}


