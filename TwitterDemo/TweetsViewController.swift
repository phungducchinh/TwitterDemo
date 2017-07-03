

//
//  TweetsViewController.swift
//  TwitterDemo
//
//  Created by phungducchinh on 7/1/17.
//  Copyright © 2017 phungducchinh. All rights reserved.
//

import UIKit


class TweetsViewController: UIViewController {
 
    var tweets = [Tweet]()

    let refreshControl = UIRefreshControl()
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadData()
        tableView.delegate = self
        tableView.dataSource = self

        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadData() {
        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]?) in
            
                self.tweets = tweets!
            
            
            self.tableView.reloadData()
        }, failure: { (error: NSError) in
            print("error: \(error.localizedDescription)")
        })
    }
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]?) in
            if let dictionaries =  tweets {
                self.tweets = dictionaries
            }
            
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }) {(error: NSError) in
            print("Error: \(error.localizedDescription)")
        }
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let cell = sender as! TimeLineCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets[(indexPath?.row)!]
            
            let navigation = segue.destination as! UINavigationController
            let destVC = navigation.topViewController as! TweetDetailViewController
            
            
            destVC.tweetItem = tweet
            destVC.delegate = self
            
            
            
            
            
        }
    }

    
    @IBAction func onLogoutBtn(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
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
extension TweetsViewController: UITableViewDelegate, UITableViewDataSource, TweetCellDelegate, TweetDetailViewControllerDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeLineCell") as! TimeLineCell
        cell.tweetItem = tweets[indexPath.row]
        //cell.delegate = self
        return cell
    }
    
    func didFinishUpdate() {
        refreshControlAction(refreshControl)
    }
    
    func onRetweet() {
        loadData()
        
    }
    
    func onFavorite() {
        loadData()
    }
    
    func onRetweetTweetDetail() {
        loadData()
    }
    func onFavoriteTweetDetail() {
        loadData()
    }
    
    
}

