//
//  TimeLineCell.swift
//  TwitterDemo
//
//  Created by phungducchinh on 7/3/17.
//  Copyright © 2017 phungducchinh. All rights reserved.
//

import UIKit

protocol TweetCellDelegate {
    func onRetweet ()
    func onFavorite ()
}

class TimeLineCell: UITableViewCell {

    @IBOutlet weak var heightAuto: NSLayoutConstraint!
    
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
    
    
    var tweetId: String = ""
    var delegate: TweetCellDelegate!
    
    
    var tweetItem: Tweet? {
        didSet {
            
            faveriteCountLabel.text = self.tweetItem?.favouritesCount.description
            retweetCountLabel.text = self.tweetItem?.retweetCount.description
            tweetTextLabel.text = self.tweetItem?.text as String?
            userNamLAbel.text = "@\(self.tweetItem!.user!.screenname!)"
            profileLabel.text = self.tweetItem?.user?.name as! String
            tweetId = (tweetItem?.id_str)!
            
            if let retweet = tweetItem!.retweetBy {
                retweetLabel.text = "\(retweet) Retweeted"
                retweetImage.image = #imageLiteral(resourceName: "retweet-action-on")
                heightAuto.constant = CGFloat(20)
            }else {
                heightAuto.constant = CGFloat(0)
            }
            
            let data = try! Data(contentsOf: tweetItem?.user?.profileUrl as! URL)
            profileImage.image = UIImage(data: data)
            
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
        }
        
    }

    @IBAction func onRetweet(_ sender: UIButton) {
        if retweetActionImage.isSelected {
            retweetActionImage.isSelected = false
        }else {
            retweetActionImage.isSelected = true
        }
        TwitterClient.sharedInstance?.handleRetweet(tweetId: tweetId, isRetweet: retweetActionImage.isSelected, completion: { (response, error) in
            
            self.delegate.onRetweet()
            
        })
        
    }
    
    @IBAction func onFavorite(_ sender: UIButton) {
        if favoriteActionImage.isSelected {
            favoriteActionImage.isSelected = false
        } else {
            favoriteActionImage.isSelected = true
        }
        
        TwitterClient.sharedInstance?.handleFavorite(tweetId: tweetId, isFavorite: favoriteActionImage.isSelected, completion: { (response, error) in
            
            self.delegate.onFavorite()
            
        })
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        retweetActionImage.setImage(#imageLiteral(resourceName: "retweet-action"), for: .normal)
        retweetActionImage.setImage(#imageLiteral(resourceName: "retweet-action-on"), for: .selected)
        favoriteActionImage.setImage(#imageLiteral(resourceName: "like-action-on"), for: .selected)
        favoriteActionImage.setImage(#imageLiteral(resourceName: "like-action"), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        // Configure the view for the selected state
    }

}
