//
//  NetworkManager.swift
//  iOSNetworkingDemo
//
//  Created by Alekh on 30/08/17.
//
//

import Foundation
import iOSNetwork

//Manages Network Calls in Watch
class NetworkManager: NSObject {
    
    //Singleton Object. Should change the definition
    static let sharedManager = NetworkManager()
    
    override init(){
        //Creating Data connection here
        singleserviceobject =  YTDataConnection()
    }
    
    //The handler has one service object
    let singleserviceobject : YTDataConnection
    
    
    func samplePOSTRequest(responseData:@escaping (_ test:AnyObject?)->()) {
        
        var request =   YTRequest(route:AppEndpoint.GetPOSTURL, methodType: .POST)
        request.baseURL = URL(string: ServicesBaseURLs.myUsersURL)
        var parameters = [String:AnyObject]()
        parameters["name"] = "Alekh" as AnyObject?
        parameters["job"] = "developer" as AnyObject?
        request.urlArguments = parameters
        callServiceForURLEncodedRequest(request: request) { (response:YTResponse) in
            
            print("response.dataString = :\(response.dataString)")
            if let _ = response.dataString {
                
            }
        }
    }
    
    
    //MARK: Private functions
    private func callServiceForURLEncodedRequest (request: YTRequest,response: @escaping ResponseClosure) {
        
        //Request Copied
        var changedrequest  = request
        let contentTypeURLEncoded = HTTPHeader.ContentType(.UrlEncoded)
        changedrequest.headers = [contentTypeURLEncoded]
        if let _ = request.urlArguments {
            changedrequest.urlArguments = request.urlArguments
        }
        requestNetwork(request: changedrequest, response: response)
    }
    
    private func callServiceForJSONRequest (request: YTRequest,response: @escaping ResponseClosure) {
        
        //Request Copied
        var changedrequest  = request
        let contentTypeJson = HTTPHeader.ContentType(.JSON)
        changedrequest.headers = [contentTypeJson]
        if let _ = request.urlArguments {
            changedrequest.urlArguments = request.urlArguments
        }
        requestNetwork(request: changedrequest, response: response)
    }
    
    private func requestNetwork (request: YTRequest,response: @escaping ResponseClosure)  {
        
        //Internet Availablity status and throw error
        if (!isInternetAvailable()) {
            
        }
        let networkrequest = singleserviceobject.initWithRequest(request, response: response)
        //we will get network response in this block
        let allRequestHandlerResponseDataClosure = { [weak self] (response:YTResponse) in
            //Error handling.
            if self != nil {
                self?.handlerErrorWithResponse(response: response)
            }
        }
        networkrequest?.allRequestHandlerResponseDataClosure = allRequestHandlerResponseDataClosure
        //return networkrequest
    }
    
    
    private func isInternetAvailable() -> Bool {
        
        return true;
    }
    
    ///This function check the response and display error on UI. Implement your own cases here
    private func handlerErrorWithResponse(response: YTResponse) {
        print("Server API Response\(response.yTHTTPResponseStatus.ytServerResponse.description)")
    }
    
}
