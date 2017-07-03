//
//  TweetDetailViewController.swift
//  TwitterDemo
//
//  Created by phungducchinh on 7/3/17.
//  Copyright © 2017 phungducchinh. All rights reserved.
//

import UIKit
protocol TweetDetailViewControllerDelegate {
    func onRetweetTweetDetail ()
    func onFavoriteTweetDetail ()
}

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var userNamLAbel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var retweetLabel: UILabel!
    
    @IBOutlet weak var retweetActionImage: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    @IBOutlet weak var favoriteActionImage: UIButton!
    @IBOutlet weak var faveriteCountLabel: UILabel!
    
    var tweetId = ""
    var delegate: TweetCellDelegate!
    
    var tweetItem: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retweetActionImage.setImage(UIImage(named: "retweet_off"), for: .normal)
        retweetActionImage.setImage(UIImage(named: "retweet_on"), for: .selected)
        favoriteActionImage.setImage(UIImage(named: "like_on"), for: .selected)
        favoriteActionImage.setImage(UIImage(named: "like_off"), for: .normal)
        
        faveriteCountLabel.text = self.tweetItem?.favouritesCount.description
        retweetCountLabel.text = tweetItem?.retweetCount.description
        tweetTextLabel.text = tweetItem?.text as String?
        userNamLAbel.text = "@\(tweetItem?.user?.screenname!)"
        profileLabel.text = tweetItem?.user?.name
        //tweetId = (tweetItem?.id_str)!
        
        if let retweet = tweetItem!.retweetBy {
            retweetLabel.text = "\(retweet) Retweeted"
            retweetImage.image = UIImage(named: "retweet_on")

            //heightAuto.constant = CGFloat(20)
        }
            //else {
//            //heightAuto.constant = CGFloat(0)
//        }
        
//        let data = try! Data(contentsOf: tweetItem?.user?.profileImageUrl as! URL)
//        profileImage.image = UIImage(data: data)
        
        if (tweetItem?.isFavorited)! {
            favoriteActionImage.isSelected = true
        }else {
            favoriteActionImage.isSelected = false
        }
        
        if(tweetItem?.isRetweeted)! {
            retweetActionImage.isSelected = true
        }else {
            retweetActionImage.isSelected = false
        }
        timeLabel.text = tweetItem?.createdAt
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRetweet(_ sender: UIButton) {
        if retweetActionImage.isSelected {
            retweetActionImage.isSelected = false
            retweetCountLabel.text = "\(tweetItem.retweetCount - 1)"
            tweetItem.retweetCount -= 1
        }else {
            retweetActionImage.isSelected = true
            retweetCountLabel.text = "\(tweetItem.retweetCount + 1)"
            tweetItem.retweetCount += 1
        }
        TwitterClient.sharedInstance?.handleRetweet(tweetId: tweetId, isRetweet: retweetActionImage.isSelected, completion: { (response, error) in
            
            self.delegate.onRetweet()
            
        })
        
    }
    
    @IBAction func onFavorite(_ sender: UIButton) {
        if favoriteActionImage.isSelected {
            favoriteActionImage.isSelected = false
            faveriteCountLabel.text = "\(tweetItem.favouritesCount - 1)"
            tweetItem.favouritesCount -= 1
        } else {
            favoriteActionImage.isSelected = true
            faveriteCountLabel.text = "\(tweetItem.favouritesCount + 1)"
            tweetItem.favouritesCount += 1
        }
        
        TwitterClient.sharedInstance?.handleFavorite(tweetId: tweetId, isFavorite: favoriteActionImage.isSelected, completion: { (response, error) in
            
            self.delegate.onFavorite()
            
        })
    }
    
    @IBAction func onBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
