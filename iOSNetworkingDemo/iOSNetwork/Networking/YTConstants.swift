//
//  YTServerUrl.swift
//  _Swift
//
//  Created by Alekh on 05/05/16.
//  Copyright © 2016 . All rights reserved.
//
import Foundation
enum ActivityServicesBaseURLs {
    
//    static let tenantID = "1303"
//    static let tenantProductString = "actios"
//    private static var IS_RFS: Bool {
//        guard let delegate = UIApplication.sharedApplication().delegate as? NSObject else { return true }
//        guard let isRFS = delegate.valueForKey("isRFS") as? Bool else { return true }
//        return isRFS
//    }
//    
//    private static var activitiesBaseURL : String  {
//        if ActivityServicesBaseURLs.IS_RFS {
//            return "http://172.16.1.131/actccwebapp"
//        }
//        return "https://secure..com/actccwebapp"
//    }
//    
//    static var activitiesSuffixURL : String  {
//        get {
//            return ActivityServicesBaseURLs.activitiesBaseURL + "/mobile/activities/" + tenantProductString
//        }
//    }
//    
//    static var activitiesProductSuffixURL : String  {
//        get {
//            return ActivityServicesBaseURLs.activitiesBaseURL + "/mobile/activitiesBook/" + tenantProductString
//        }
//    }
}

//Making this true will make manager fetch data from Dummy Api supplied in App
struct  DebugConstants {
    static let isDummyAPI:Bool             = false
    //Make it false when you dint want to show success/failure message in UI popup
    static let isDummyAPILogPrinting:Bool = true
}



