import Foundation

public protocol Endpoint {
    
    var path: String {get}
    var endPointName: String {get}
    var method: HTTPMethodType {get}
}

//This is structure which needs to be created when initializing request.There are two different initializers for GET, POST request
public struct YTRequest {
    
    //Can Be Set to nil initially
    public var baseURL: URL?
    
    //End Points
    public var route: Endpoint?
    
    ///This is custom attrubute.This dictionary would be used as base for
    ///sending request. It has three uses.In all other cases, this parameter wont be
    ///considered while making a request, its value would be ignored
    ///1. To send URL Encode in GET Request
    ///Content-Type
    ///2. To make        URL encoded body in POST request  Note that in this case Header should have value content type as application/url encoded
    
    ///3. To convert to json encoded body in POST request. Note that in this case Header should have value content type as application/json
    ///
    ///TODO: Deprecated this method for Get HIT. Instead use Initializers to make
    ///JSOn or Url encoded HIT
    public var urlArguments: Dictionary<String, AnyObject>?
    
    //Default Timeout. 3 mins default timeout
    public var timeOut : TimeInterval = 60*3
    
    ///
    public var headers:[HTTPHeader]?
    
    ///
    public var methodType: HTTPMethodType?
    
    ///
    public var routeAppendedPath:String?
    
    ///
    public var body: Data?
    
    //Should it fect data from dummy API
    public var isDataProvideByDummyAPI:Bool = false
    
    //After we set base irl and end point, we can get full URL of request
    public var fullURL : URL? {
        
        let endPointFullURL = self.route?.path
        if let _ = endPointFullURL,let _ = baseURL {
            let fullURl  = URL(string: self.baseURL!.absoluteString + endPointFullURL!)
            return fullURl
        }
        //If we have issue in base or end pint not set
        return nil
    }
    
    //GET Request
    public init(route: Endpoint,methodType: HTTPMethodType) {
        self.route = route
        self.methodType = methodType
    }
    
    //TODO: Endpoint and me
    ///POST,PUT,DELETE Request
    public init(route: Endpoint ,methodType: HTTPMethodType, urlArguments: Dictionary<String,String>?) {
        self.route = route
        self.methodType = methodType
        //SC
        self.urlArguments  = urlArguments as Dictionary<String, AnyObject>?
    }
}




