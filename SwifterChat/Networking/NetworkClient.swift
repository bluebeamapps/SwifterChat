//
//  BaseService.swift
//  SurveyMobile
//
//  Created by Bruno Aguiar on 12/13/15.
//  Copyright © 2015 Bluebeam Apps. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration

class NetworkClient {
    
    var identifier: Int?
    
    var defaultHost = "www.mocky.io/v2"
    
    func httpGet(var host: String?, path: String!, callback: (data: NSData?, response: NSHTTPURLResponse?, error: NSError?) -> Void) {
        
        if host == nil {
            host = defaultHost
        }
        
        //Initialize the URL and the request.
        let url = NSURLComponents(string: "http://\(host! + path)")
        let request = NSURLRequest(URL: url!.URL!)
        
        //Initialize the session.
        let session = NSURLSession.sharedSession();
        
        let task = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            let httpResponse = response as? NSHTTPURLResponse
            
            print(error != nil ? error!.description : "\(httpResponse!.statusCode): \(url!.string!)");
            
            callback(data: data, response: httpResponse, error: error)
        }
        
        task.resume()
    }
    
    class func showNetworkIndicator() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    class func hideNetworkIndicator() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    class func isConnectedToNetwork() -> Bool {
        return Reachability.isConnectedToNetwork()
    }
}

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        
        var flags = SCNetworkReachabilityFlags()
        
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection)
    }
}
