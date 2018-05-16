//
//  Model.swift
//  TheSwifter
//
//  Created by Michael Ardizzone on 5/15/18.
//  Copyright © 2018 Michael Ardizzone. All rights reserved.
//

import Foundation

struct Tweet {
    let text: String
    let user: String
}

enum SearchingState {
    case isPaused
    case isSearching
}
