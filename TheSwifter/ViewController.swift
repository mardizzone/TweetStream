//
//  ViewController.swift
//  TheSwifter
//
//  Created by Michael Ardizzone on 5/15/18.
//  Copyright © 2018 Michael Ardizzone. All rights reserved.
//

import UIKit
import SwifteriOS

class ViewController: UIViewController, DataManagerDelegate  {
    @IBOutlet weak var tweetTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    var currentSearchingState : SearchingState = SearchingState.isSearching {
        didSet {
            updateButtonText()
        }
    }
    
    var currentSearchTerm : String?
    
    var currentTweets = DataManager.shared.currentListOfTweets {
        didSet {
            currentTweets.reverse()
            tweetTableView.reloadData()
        }
    }
    
    func loadNewCells(listOfTweets: [Tweet]) {
        pauseButton.isHidden = false
        instructionsLabel.isHidden = true
        currentTweets = listOfTweets
    }
    
    func updateButtonText() {
        if currentSearchingState == .isPaused {
            pauseButton.setTitle("Resume", for: .normal)
        } else {
            pauseButton.setTitle("Pause", for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTableView.rowHeight = UITableViewAutomaticDimension
        pauseButton.makeoverButton()
        DataManager.shared.delegate = self
        
    }
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        if currentSearchingState == .isSearching {
            DataManager.shared.stopLoadingTweets()
            currentSearchingState = .isPaused
        } else {
            guard let currentSearchTerm = currentSearchTerm else {return}
            DataManager.shared.startLoadingTweets(searchTerm: currentSearchTerm)
            currentSearchingState = .isSearching
        }
        
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let textInSearchField = searchBar.text {
            DataManager.shared.emptyCurrentListOfTweets()
            currentSearchTerm = textInSearchField
            DataManager.shared.startLoadingTweets(searchTerm: textInSearchField)
            currentSearchingState = .isSearching
            self.view.endEditing(true)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(currentTweets.count)
        return currentTweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tweetTableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! StreamingTweetCell
        cell.tweetText.text = currentTweets[indexPath.row].text
        cell.nameText.text = currentTweets[indexPath.row].user
        return cell
    }
    
    
}

class DataManager {
    
    var delegate: DataManagerDelegate?
    
    var currentListOfTweets = [Tweet]()
    
    let swifter = Swifter(consumerKey: "mTahSWW19W3HHVEhpx0Jtak59", consumerSecret: "1HYnGZarhUgDBrF2JU62IwjgNbNmTekAYYT520yvonkxJKfUX5", oauthToken: "751178350111055872-I55bOJknyRyBW1lpRkeNiGjZezeQSoE", oauthTokenSecret: "yDvfTJ37KnkgwAaFIuqIS6yFKrT0ecNqROUERgQAz60zs")
    
    static let shared = DataManager()
    
    var wordToTrack = "balls"
    
    var streamRequest : HTTPRequest?
    
    func startLoadingTweets(searchTerm: String) {
        streamRequest = swifter.postTweetFilters(follow: nil, track: [searchTerm], locations: nil, delimited: true, stallWarnings: nil, filterLevel: nil, language: nil, progress: { status in
            if let tweetText = status["text"].string, let userText = status["user"]["screen_name"].string {
                let tweet = Tweet(text: tweetText, user: userText)
                self.currentListOfTweets.append(tweet)
                self.delegate?.loadNewCells(listOfTweets: self.currentListOfTweets)
            }

        },
            stallWarningHandler: nil, failure: nil)
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


protocol DataManagerDelegate {
    func loadNewCells(listOfTweets: [Tweet])
}
