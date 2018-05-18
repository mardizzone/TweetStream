//
//  ViewController.swift
//  TheSwifter
//
//  Created by Michael Ardizzone on 5/15/18.
//  Copyright © 2018 Michael Ardizzone. All rights reserved.
//

import UIKit

class StreamingTweetsViewController: UIViewController  {
    @IBOutlet weak var tweetTableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var instructionsLabel: UILabel!
    var currentSearchTerm : String?
    var currentSearchingState : SearchingState = SearchingState.isSearching {
        didSet {
            updateButtonText()
        }
    }
    var currentTweets = DataManager.shared.currentListOfTweets {
        didSet {
            //show most recent tweets at top of tableview
            currentTweets.reverse()
            DispatchQueue.main.async {
                self.tweetTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
}

extension StreamingTweetsViewController: UISearchBarDelegate {
     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let textInSearchField = searchBar.text {
            updateSearchContext(with: textInSearchField)
            hideKeyboard()
            spinner.startAnimating()
        }
    }
}

extension StreamingTweetsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentTweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tweetTableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! StreamingTweetCell
        cell.tweetText.text = currentTweets[indexPath.row].text
        cell.nameText.text = currentTweets[indexPath.row].user.screen_name
        return cell
    }
}

//MARK: - UI Helper Methods
extension StreamingTweetsViewController: DataManagerDelegate {
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func configureView() {
        tweetTableView.rowHeight = UITableViewAutomaticDimension
        pauseButton.makeoverButton()
        tweetTableView.allowsSelection = false
        DataManager.shared.delegate = self
    }
    
    func loadNewCells(listOfTweets: [Tweet]) {
        currentTweets = listOfTweets
        hideUIElements()
    }
    
    func updateButtonText() {
        if currentSearchingState == .isPaused {
            pauseButton.setTitle("Resume", for: .normal)
        } else {
            pauseButton.setTitle("Pause", for: .normal)
        }
    }
    
    func hideUIElements() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.pauseButton.isHidden = false
            self.instructionsLabel.isHidden = true
        }
    }
}

//MARK: - Action Methods
extension StreamingTweetsViewController {
    @IBAction func pauseResumeButtonPressed(_ sender: UIButton) {
        sender.pulsate()
        if currentSearchingState == .isSearching {
            DataManager.shared.stopLoadingTweets()
            currentSearchingState = .isPaused
        } else {
            guard let currentSearchTerm = currentSearchTerm else {return}
            DataManager.shared.createTwitterSearchTermSearch(with: currentSearchTerm)
            currentSearchingState = .isSearching
        }
    }
    
    func updateSearchContext(with input: String) {
        DataManager.shared.emptyCurrentListOfTweets()
        currentSearchingState = .isSearching
        currentSearchTerm = input
        DataManager.shared.createTwitterSearchTermSearch(with: input)
    }
}


