
import Foundation

//
//  BaseConnection
//
//  Copyright (c) 2007-2016 Alekh. All rights reserved.
//

/*
 */

/// BaseConnection is a generic Class base class that manages a connection.
///Generally We should overide this class to define some custom functionalities
public class YTBaseConnection: NSObject  {
    
    
    /// General Function. It breaks the YTRequest object into NSMutableURLRequest object.
    ///
    ///
    /// - Parameter request: The request structure which needs to be converted
    /// - Returns: NSMutableURLRequest
    func getURLRequestForYTRequest(_ request : YTRequest) ->
        NSMutableURLRequest? {
            let endPointFullURL = request.route?.path
            let fullURl  = URL(string: request.baseURL!.absoluteString + endPointFullURL!)
            print("full url :\(fullURl)")
            //TODO: URL Enoding
            //TODO NETWORK: Cache Policy
            
            //TODO: Return Errorm URL
            guard let _ = fullURl else {return nil}
            let urlRequest : NSMutableURLRequest = NSMutableURLRequest(url: fullURl!, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval:request.timeOut)
          
            //TODO: Optional Handling
            urlRequest.httpMethod = request.methodType!.rawValue
            //TODO: Append Headers.
            //Nil Handling proper
            if let _ = request.headers {
                for header in request.headers!  {
                    header.setRequestHeader(request: urlRequest)
                }
            }
            /******** Setting body  *****************/
            switch request.methodType! {
            case .GET : print("")//Do nothing
            case .POST,.PUT,.DELETE:
                
                if let _ = request.headers {
                    for header in request.headers!  {
                        if (header == HTTPHeader.ContentType(ContentTypes.JSON)){
                            //Encode Parameters of type JSON
                            let data =  try? utilGetDataFromJsonParameters(request.urlArguments)
                            if let _ = data {
                                 urlRequest.httpBody = data!
                            }
                        }
                        if (header == HTTPHeader.ContentType(ContentTypes.UrlEncoded)){
                            //Encode Parameters Parameters of type URL Encoded
                            let data =  try? utilGetDataForURLEncodedParameters(request.urlArguments)
                            if let _ = data {
                                urlRequest.httpBody = data!
                            }
                        }
                    }
                    print ("Request:\(request.route?.path)|Method:POST|headers:\(request.headers)|Header Parameters:\(request.urlArguments)")
                }
                else {
                    urlRequest.httpBody  = request.body
                    print ("Request:\(request.route?.path)|Method:POST|headers:\(request.headers)|body parameters\(self.getJSONFormattedStringFromNSData(request.body))")
                }
            }
            return urlRequest
    }
}

// MARK: - Utilities
extension YTBaseConnection {
    
    /// Converts Dictionary to JSON (Data)
    ///
    /// - Parameter paramaters: This is swift dictionary which is to be encoded
    /// - Returns: encoded dictionary in NSdata form
    /// - Throws: Exception
    fileprivate func utilGetDataFromJsonParameters(_ paramaters:[String : AnyObject]?) throws -> Data? {
        guard let _ = paramaters else {
            return nil
        }
        do {
            var err: NSError?
            let jsonData = try? JSONSerialization.data(withJSONObject: paramaters!, options: [])
            return jsonData
        } catch let error as NSError {
            print(error)
            throw error
        }
    }
    
    /// Converts Dictionary to JSON (Data)
    ///
    /// - Parameter paramaters: This is swift dictionary which is to be encoded
    /// - Returns: encoded dictionary in NSdata form
    /// - Throws: Exception
    fileprivate func utilGetDataForURLEncodedParameters(_ paramaters:[String : AnyObject]?) throws -> Data? {
        
        guard let _  = paramaters else {return nil}
        //Creating Array for appening key value for parameters
        var array = [String]()
        //Construting array from dictionary
        for (key, value) in paramaters! {
             array.append("\(key)=\(value)")
        }
        let urlEncodedString = array.joined(separator:"&")
        let data = urlEncodedString.data(using: .utf8)
        guard let _  = data else {return nil}
        return data
    }
    
    /// Converts Dictinary to Json
    ///
    /// - Parameter data: data This is data which needs to be converted to JSON string
    /// - Returns: String in NSUTF8StringEncoding
    fileprivate func getJSONFormattedStringFromNSData(_ data:Data?) -> String? {
        
        var requestBodyInJSONString:String?
        if let _ = data {
            requestBodyInJSONString = String(data: data! , encoding: String.Encoding.utf8)
        }
        else {
            requestBodyInJSONString = ""
        }
        return requestBodyInJSONString
    }
}



