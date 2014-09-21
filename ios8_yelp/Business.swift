//
//  Business.swift
//  ios8_yelp
//
//  Created by Stanley Ng on 9/20/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

import UIKit

class Business: MTLModel, MTLJSONSerializing {
    var id: NSString!
    
    class func JSONKeyPathsByPropertyKey() -> [NSObject: AnyObject]! {
        return [
            "id": "id"
        ]
    }
    
    class func parseBusiness(response: [NSObject: AnyObject]!) -> AnyObject {
        return MTLJSONAdapter.modelOfClass(Business.self, fromJSONDictionary: response, error: nil)
    }

    class func parseBusinesses(response: AnyObject!) -> [AnyObject] {
        let responseDict = response as NSDictionary

        var businesses: [Business] = Array()
        
        var items = responseDict["businesses"] as [NSDictionary]
        for item in items {
            var business = Business.parseBusiness(item) as Business
            //dump(business)
            businesses.append(business)
        }
        
        return businesses
    }
}