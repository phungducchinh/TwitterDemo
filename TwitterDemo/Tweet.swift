
//
//  Tweet.swift
//  TwitterDemo
//
//  Created by phungducchinh on 6/30/17.
//  Copyright © 2017 phungducchinh. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favouritesCount: Int = 0
    var timeString: String?
    
    var user: User?
    //    var profileImgUrl: NSURL?
    var retweetBy: String?
    //    var screenName:String?
    //    var profileName: String?
    
    var id_str: String?
    var createdAt: String?
    

    var isRetweeted = false
    var isFavorited = false
    
    
    
    
    var retweet: Tweet?

    
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as! NSString
        
        retweetCount = (dictionary["retweet_count"] as? Int)!
        favouritesCount = (dictionary["favorite_count"] as? Int)!
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        let timestampString = dictionary["created_at"] as? String
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        retweetBy = (dictionary.value(forKey: "user") as! NSDictionary).value(forKey: "name") as! String?
//        isRetweeted = true
        if let timestampString = timestampString{
            
            timestamp = formatter.date(from: timestampString) as! NSDate
            formatter.dateFormat = "dd/MM/yyyy hh:mm"
            timeString = formatter.string(from: timestamp as! Date)
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in dictionaries{
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
           
        }
        
        return tweets
    }

}
