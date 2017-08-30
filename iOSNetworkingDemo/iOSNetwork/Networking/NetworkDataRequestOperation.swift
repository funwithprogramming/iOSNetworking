


import UIKit
import CoreData

//
//  NetworkRequestOpration.swift
//  
//
//  Created by Alekh on 01/07/16.
//  Copyright © 2016 . All rights reserved.
//

/// The Short Declaration of tuple used of the response block which we will get from request
public typealias ResponseClosure   = (_ response: YTResponse)->()

/// The Short Declaration of tuple used
typealias URLConnectionResponseTuple = (data:Data?, urlResponse:URLResponse?, error:NSError?)

/// This block give us the response data in bytes
public typealias ResponseDataClosure   = (_ dataReceived: Int64, _ totalData: Int64)->()

//Default Timeout for NetworkDataRequestOperation. Default to 3 mins
let networkDataRequestOperationTimeOut  = 180.0

/**
 NetworkDataRequestOperation is inherited from NSOperation.
 @superclass
 
 */

public class NetworkDataRequestOperation: Operation {
    
    //1. Response closure block it has
    //2. Should cancel the operation
    //3. It contains the data request object also
    //4. Response block it contains
    
    ///For caching ?
    
    fileprivate var innerContext: NSManagedObjectContext?
    
    ///For data task it creates
    fileprivate var task: URLSessionTask?
    
    ///The data for task irt has recceived
    fileprivate let incomingData = NSMutableData()
    
    ///The session it will use. It shoudl be passed into this operation
    var session : Foundation.URLSession?
    
    ///
    var urlRequest: URLRequest?
    
    ///The response block associated with Request
    var responseClosure :ResponseClosure?
    
    ///The response data associated with Request
    var responseDataClosure : ResponseDataClosure?
    
    ///The response data associated with object which is centralized object for making all network hits
    public var allRequestHandlerResponseDataClosure : ResponseClosure?
    
    ///It records the start time for a particular request
    fileprivate var requestStartTime  =  Date()
    
    ///It records the start time for a particular request
    fileprivate var timeTakenByRequest :  TimeInterval {
        
        let currentTime = NSDate()
        let totalTime = currentTime.timeIntervalSince(self.requestStartTime)
        return totalTime
    }
    
    ///
    fileprivate var urlResponse: URLResponse?
    
    ///
    fileprivate  var expectedContentLength : Int64 = 0
    
    
    /// tell whether Request operation has finished executing. Default if false
    fileprivate var executionFinished: Bool = false
    
    //Default timeOut //180 seconds
    //let timeOut: NSTimeInterval  = 180.0
    
    /// Initializer
    ///
    /// - Parameters:
    ///   - urlRequest: urlRequest object
    ///   - timeout: Timeout to be expected from Network Data Request Operation
    ///   - responseClosure: Pass block of the code which is executed when we get respsone
    ///   - responseDataClosure: todo
    init(urlRequest: URLRequest, timeout:TimeInterval,responseClosure: @escaping ResponseClosure,responseDataClosure: ResponseDataClosure?) {
        super.init()
        self.urlRequest = urlRequest
        //self.session = session
        //configure the session
        print("timeout = \(timeout)")
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest  = timeout
        sessionConfig.timeoutIntervalForResource = timeout
        self.session =  Foundation.URLSession(configuration:sessionConfig, delegate: self, delegateQueue:nil)
        self.responseClosure = responseClosure
    }
    
    ///Convenience initializer
    convenience init(urlRequest: URLRequest,timeout:TimeInterval, responseClosure: @escaping ResponseClosure) {
        self.init(urlRequest: urlRequest,timeout:timeout, responseClosure: responseClosure, responseDataClosure: nil)
    }
    
    ///If You want to make Request with default timeout.
    convenience init(urlRequest: URLRequest, responseClosure: @escaping ResponseClosure) {
        self.init(urlRequest: urlRequest,timeout: networkDataRequestOperationTimeOut, responseClosure: responseClosure, responseDataClosure: nil)
    }
    
    override public var isAsynchronous: Bool {
        return true
    }
    
    override public var isExecuting: Bool {
        get {
            return executionFinished
        }
        set (newAnswer) {
            willChangeValue(forKey: "isExecuting")
            executionFinished = newAnswer
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    var internalFinished: Bool = false
    
    override public var isFinished: Bool {
        get {
            return internalFinished
        }
        set (newAnswer) {
            willChangeValue(forKey: "isFinished")
            internalFinished = newAnswer
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override public func start() {
        isExecuting = true
        execute()
    }
    
    func execute() {
        // Perform your async task here.
        self.task = self.session?.dataTask(with: self.urlRequest!)
        task!.resume()
    }
    func finish() {
        // Notify the completion of async task and hence the completion of the operation
        isExecuting = false
        isFinished = true
    }
}


// MARK: - NSURLSessionTaskDelegate, NSURLSessionDataDelegate
extension NetworkDataRequestOperation : URLSessionTaskDelegate, URLSessionDataDelegate {
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        //Defining NSURL Response
        let dataReceived = self.incomingData as? Data
        let urlConnectionTuple  = (dataReceived, urlResponse, error)
        print("ERROR:\(error)")
        //Data in String Format
        var stringData : String?
        
        //Handliing Response Errors related to networking
        var yTServerResponseStatus = YTHTTPResponseStatus.ServerResponseStatus.failureOther
        if ((error) == nil) {
            let statusCode = (urlResponse as! HTTPURLResponse).statusCode
            if statusCode == 200 {
                yTServerResponseStatus = YTHTTPResponseStatus.ServerResponseStatus.success
                do {
                    try stringData = self.parseNSDataToString(self.incomingData as Data)
                    print(stringData)
                }
                catch  {
                    yTServerResponseStatus = YTHTTPResponseStatus.ServerResponseStatus.responseStringNotValid
                }
            }
            else {
                yTServerResponseStatus = YTHTTPResponseStatus.ServerResponseStatus.serverError(statusCode: statusCode, errorMessage: "Server Returned non 200 Status Code ")
            }
            print("response.dataString:\(stringData)")
            //No Data Or response Returned from server
            if self.incomingData.length == 0 {
                yTServerResponseStatus = YTHTTPResponseStatus.ServerResponseStatus.noDataError
            }
        }
        else {
            //General Handling Data Case
            yTServerResponseStatus = YTHTTPResponseStatus.ServerResponseStatus.failure(errorMessage: error!.localizedDescription)
        }
        
        let yTHTTPResponseStatus = YTHTTPResponseStatus(ytServerResponse:yTServerResponseStatus)
        
        //SC
        
        //Create YT response object
        
        let ytResponse = YTResponse(yTHTTPResponseStatus:yTHTTPResponseStatus , nsurlResponseObject: urlConnectionTuple, dataString: stringData ,timeTakenByRequest: self.timeTakenByRequest)
        
        //Calling the response block
        self.responseDataClosure?(Int64(self.incomingData.length), self.expectedContentLength)
        self.allRequestHandlerResponseDataClosure?(ytResponse)
        self.responseClosure?(ytResponse)
        self.finish()
    }
    
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        //TODO: Return error, is something
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        self.urlResponse = response
        //that means task has been cancelled
        if isCancelled {
            isFinished = true
            self.task?.cancel()
            return
        }
        //TODO:Handle expcted length -1
        self.expectedContentLength = response.expectedContentLength
        completionHandler(.allow)
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        if isCancelled {
            isFinished = true
            self.task?.cancel()
            return
        }
        self.incomingData.append(data)
        self.responseDataClosure?(Int64(self.incomingData.length), self.expectedContentLength)
    }
}

/*
 Extension whih defines the utilities
 */
//MARK:Utilities
extension NetworkDataRequestOperation {
    
    /// par
    /// another given dictionary.
    ///
    /// - Returns: An initialized dictionary—which might be different
    ///   than the original receiver—containing the keys and values
    ///   found in `otherDictionary`.
    func parseNSDataToDict(_ data: Data)-> NSDictionary?{
        
        let data: Data = data
        var jsonError: NSError?
        
        let decodedJson:Any?
        do {
            decodedJson = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments)
            
        } catch let error as NSError {
            jsonError = error
            decodedJson = nil
        }
        let jsonObject  =  decodedJson as? NSDictionary
        let json = NSString(data:data, encoding:String.Encoding.utf8.rawValue)
        print(json)
        //TODO: error handling
        return jsonObject
    }
    /// another given dictionary.
    ///
    /// - Returns: An initialized dictionary—which might be different
    ///   than the original receiver—containing the keys and values
    ///   found in `otherDictionary`.
    func parseNSDataToString(_ data:Data) throws -> String {
        
        let dataString = String(data: data, encoding: String.Encoding.utf8)
        if let _ = dataString {
            return dataString!
        }
        else {
            throw YTHTTPResponseStatus.ServerResponseStatus.responseStringNotValid
        }
    }
    /// parsedata
    /// another given dictionary.
    ///
    /// - Returns: An initialized dictionary—which might be different
    ///   than the original receiver—containing the keys and values
    ///   found in `otherDictionary`.
    func parsedata(_ data:Data)-> NSDictionary? {
        
        let data: Data = data
        var jsonError: NSError?
        //SC
        let decodedJson:Any?
        do {
            decodedJson = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments)
        } catch let error as NSError {
            jsonError = error
            decodedJson = nil
        }
        let jsonObject  =  decodedJson as? NSDictionary
        let json = NSString(data:data, encoding:String.Encoding.utf8.rawValue)
        return jsonObject
    }
}

