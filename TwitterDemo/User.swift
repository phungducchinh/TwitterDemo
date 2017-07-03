//
//  User.swift
//  TwitterDemo
//
//  Created by phungducchinh on 6/30/17.
//  Copyright © 2017 phungducchinh. All rights reserved.
//

import UIKit

class User: NSObject {

    var name: String?
    var screenname: String?
    var profileUrl: URL?
    var tagline: String?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
       self.dictionary = dictionary
        name = dictionary["name"]  as? String
        screenname = dictionary["screen_name"]  as? String
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        
        if let profileUrlString = profileUrlString{
            profileUrl = URL(string: profileUrlString)
        }
        
        tagline = dictionary["description"]  as? String
    }
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil{
                let defaults = UserDefaults.standard
            
                let userData = defaults.object(forKey: "currentUserData") as? Data
            
                if let userDta = userData{
//                    let dictionary = try! JSONSerialization.data(withJSONObject: userData, options: [])
//                    _currentUser = User(dictionary: dictionary)
                    if let dictionary: NSDictionary = NSKeyedUnarchiver.unarchiveObject(with: userDta) as? NSDictionary{
                        _currentUser = User(dictionary: dictionary)
                    }
                    
                    
                }
            }
            return _currentUser
        }
        set(user){
            _currentUser = user
            let defaults = UserDefaults.standard
            
            if let user = user{
                let data: Data = NSKeyedArchiver.archivedData(withRootObject: user.dictionary)
//                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                
                defaults.set(data, forKey: "currentUserData")
            }else{
                defaults.set(nil, forKey: "currentUserData")
            }
            user?.dictionary
            defaults.set(user, forKey: "currentUser")
            
            defaults.synchronize()
        }
    }
    
}
