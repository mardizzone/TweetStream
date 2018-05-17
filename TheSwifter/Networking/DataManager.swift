//
//  DataManager.swift
//  TheSwifter
//
//  Created by Michael Ardizzone on 5/17/18.
//  Copyright © 2018 Michael Ardizzone. All rights reserved.
//

import Foundation
import SwifteriOS

class DataManager {
    var delegate: DataManagerDelegate?

    var currentListOfTweets = [Tweet]()
    
    //In a production app, we would protect these creds
    let swifter = Swifter(consumerKey: "mTahSWW19W3HHVEhpx0Jtak59", consumerSecret: "1HYnGZarhUgDBrF2JU62IwjgNbNmTekAYYT520yvonkxJKfUX5", oauthToken: "751178350111055872-I55bOJknyRyBW1lpRkeNiGjZezeQSoE", oauthTokenSecret: "yDvfTJ37KnkgwAaFIuqIS6yFKrT0ecNqROUERgQAz60zs")
    
    static let shared = DataManager()
        
    var streamRequest : HTTPRequest?
    
    func createTwitterSearchTermSearch(with searchTerm: String) {
        streamRequest = swifter.postTweetFilters(follow: nil, track: [searchTerm], locations: nil, delimited: true, stallWarnings: nil, filterLevel: nil, language: nil, progress: { status in self.ingestTweets(status)}, stallWarningHandler: nil, failure: nil)
    }
    
    func ingestTweets(_ input: JSON) {
        if let tweetText = input["text"].string, let userText = input["user"]["screen_name"].string {
            let tweet = Tweet(text: tweetText, user: userText)
            self.currentListOfTweets.append(tweet)
            self.delegate?.loadNewCells(listOfTweets: self.currentListOfTweets)
        }
    }
    
    func stopLoadingTweets() {
        streamRequest?.stop()
    }
    
    func emptyCurrentListOfTweets() {
        currentListOfTweets = [Tweet]()
    }
}
