
import Foundation
//
//  YTDataConnection.swift
//
//  Copyright (c) 2016 . All rights reserved.
//

public class YTDataConnection : YTBaseConnection {
    
    //1.Operation Queue here
    /// The Queue Used by YTDataconnection. This Queue contains all the request made by Networking layer
    let queue = OperationQueue()
    
    public override init() {
        super.init()
    }
    
    /// Initialize NetworkDataRequestOperation operation using this method
    ///
    /// - Parameters:
    ///   - request: YTRequest Object
    ///   - response: Respoonse Block
    ///   -returns: kejhdf
    public func initWithRequest(_ request : YTRequest, response: @escaping ResponseClosure) -> NetworkDataRequestOperation? {
        return initWithRequest(request, response: response, responsedataClosure: nil)
    }
    
    //  func initWithRequest(_ request : YTRequest, response: @escaping ResponseClosure,responsedataClosure: ResponseDataClosure?) -> NetworkDataRequestOperation? {
    //    let urlRequest = self.getURLRequestForYTRequest(request)
    //    //SC
    //    let operation = NetworkDataRequestOperation(urlRequest:urlRequest! as URLRequest , timeout: request.timeOut, responseClosure: response, responseDataClosure: responsedataClosure)
    //    queue.addOperation(operation)
    //    return operation
    //  }
    
    //SC
    
    public func initWithRequest(_ request : YTRequest, response: @escaping ResponseClosure,responsedataClosure: ResponseDataClosure?) -> NetworkDataRequestOperation? {
        let urlRequest = self.getURLRequestForYTRequest(request)
        let operation = NetworkDataRequestOperation(urlRequest:urlRequest! as URLRequest , timeout: request.timeOut, responseClosure: response, responseDataClosure: responsedataClosure)
        queue.addOperation(operation)
        return operation
    }
}



