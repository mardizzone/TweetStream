//
//  Model.swift
//  TheSwifter
//
//  Created by Michael Ardizzone on 5/15/18.
//  Copyright © 2018 Michael Ardizzone. All rights reserved.
//

import Foundation

struct Tweet : Codable {
    let text: String
    let user: User
    
    static func createTweetObject(from data: Data) -> Tweet? {
        do {
            let tweet = try JSONDecoder().decode(Tweet.self, from: data)
            return tweet
        } catch {
            //handle error
            return nil
        }
    }
}

struct User : Codable {
    let screen_name : String
}

enum SearchingState {
    case isPaused
    case isSearching
}
