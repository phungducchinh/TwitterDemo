
//
//  TwitterClient.swift
//  TwitterDemo
//
//  Created by phungducchinh on 7/1/17.
//  Copyright © 2017 phungducchinh. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
        static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com/")! as URL!, consumerKey: "xw8YeqE6GdWXeehdYAtdnpq4Y", consumerSecret: "ToxKKi42TOintVfk2aPyDuEq9zBjdhAJJMtLpkcg7MjSCBiF2s")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    let API_POST_NEW_FAVORITE = "1.1/favorites/create.json"
    let API_POST_DETROY_FAVORITE = "1.1/favorites/destroy.json"
    let API_POST_NEW_STATUS = "1.1/statuses/update.json"
    
    func homeTimeLine(success: @escaping ([Tweet]) -> (), failure: @escaping (NSError) -> () ){
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error!) in
            failure(error as! NSError)
        })

    }

    
    func logIn(success: @escaping () -> (), failure: @escaping (NSError) -> ()){
        
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string: "mytwitterdemo://oauth") as! URL, scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            print("I got token")
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)")!
            UIApplication.shared.open(url as! URL)
            
            
            
        },failure:  { (error: Error!)  in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error as! NSError)
        })
    
    }
    
    func logout(){
        User.currentUser = nil
        
        deauthorize()
        //NotificationCenter.default.post(User.userDidLogoutNotification as! NSNotification, object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
//TwitterClient.sharedInstance?.handleOpenUrl(url: url as NSURL)
    func handleOpenUrl(url: NSURL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token" , method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            print("I got a accessToken")
            
            self.currentAcount(succsess: { (user: User) in
                
                User._currentUser = user
                self.loginSuccess?()
            }, failure: { (error: NSError) in
                self.loginFailure?(error as! NSError)
            })
            
        }, failure:  { (error: Error!)  in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error as! NSError)
        })

    }
    
    func handleRetweet(tweetId: String, isRetweet: Bool, completion: @escaping (_ response: Any?, _ error: NSError?) -> ()) {
        var params = [String : String]()
        params["id"] = tweetId
        
        if isRetweet {
            post("1.1/statuses/retweet/\(tweetId).json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
                completion(response, nil)
                print("Retweeded!")
                
            }) { (operation: URLSessionDataTask?, error: Error) in
                print("Retweeded error")
            }
        }else {
            post("1.1/statuses/unretweet/\(tweetId).json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
                completion(response, nil)
                print("Detroy Unretweed!")
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                print("Detroy Unretweed error")
            })
        }
    }
    
    func handleFavorite(tweetId: String, isFavorite: Bool, completion: @escaping (_ response: Any?, _ error: NSError?) -> ()) {
        var params = [String : String]()
        params["id"] = tweetId
        
        if isFavorite {
            post(API_POST_NEW_FAVORITE, parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
                completion(response, nil)
                print("Favorited!")
                
            }) { (operation: URLSessionDataTask?, error: Error) in
                print("Favorite error")
            }
        }else {
            post(API_POST_DETROY_FAVORITE, parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
                completion(response, nil)
                print("Detroy Favorite!")
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                print("Detroy Favorite error")
            })
        }
        
    }

    func currentAcount(succsess: @escaping (User) -> (), failure: @escaping (NSError) -> () ){
      
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            //print("account: \(response)")
            let userDictionary = response as! NSDictionary
            //print("user: \(user["name"])")
            let user = User(dictionary: userDictionary)
            
            succsess(user)
            
            //print("name: \(user.name)")
            
        }, failure: { (task: URLSessionDataTask?, error: Error!) in
                failure(error as! NSError)
        })
    }
    
    func updateNewTweet(tweet: String, completion: @escaping (_ response: Any?, _ error: NSError?) -> () ) {
        var params = [String : String]()
        params["status"] = tweet
        TwitterClient.sharedInstance?.post(API_POST_NEW_STATUS, parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any ) in
            print("update status success")
            completion(response, nil)
        }, failure: { (task: URLSessionDataTask?, error) in
            completion(nil, error as NSError?)
            print("update status fail")
        })
        
    }

    
}
