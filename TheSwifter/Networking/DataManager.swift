//
//  DataManager.swift
//  TheSwifter
//
//  Created by Michael Ardizzone on 5/17/18.
//  Copyright © 2018 Michael Ardizzone. All rights reserved.
//

import Foundation
import Alamofire
import OAuthSwift

class DataManager {
    var delegate: DataManagerDelegate?

    var currentListOfTweets = [Tweet]()
    
    //In a production app, we would protect these creds
    let client = OAuthSwiftClient(consumerKey: "mTahSWW19W3HHVEhpx0Jtak59", consumerSecret: "1HYnGZarhUgDBrF2JU62IwjgNbNmTekAYYT520yvonkxJKfUX5", oauthToken: "751178350111055872-I55bOJknyRyBW1lpRkeNiGjZezeQSoE", oauthTokenSecret: "yDvfTJ37KnkgwAaFIuqIS6yFKrT0ecNqROUERgQAz60zs", version: .oauth1)
    
    static let shared = DataManager()
    
    let url = "https://stream.twitter.com/1.1/statuses/filter.json"
        
    var streamRequest : DataRequest?
    
    func createTwitterSearchTermSearch(with searchTerm: String) {
        streamRequest?.cancel()
        let parameters = ["track" : searchTerm]
        do {
            streamRequest = try Alamofire.request((client.makeRequest(url, method: .POST, parameters: parameters, headers: nil, body: nil)?.makeRequest())!).stream {data in
                if let tweet = Tweet.createTweetObject(from: data) {
                    self.ingestTweets(tweet)
                }
            }
            streamRequest?.resume()
        } catch {
           //handle error
        }
    }
    
    func ingestTweets(_ tweet: Tweet) {
        self.currentListOfTweets.append(tweet)
        self.delegate?.loadNewCells(listOfTweets: self.currentListOfTweets)
    }
    
    func stopLoadingTweets() {
        streamRequest?.cancel()
    }
    
    func emptyCurrentListOfTweets() {
        currentListOfTweets = [Tweet]()
    }
}
