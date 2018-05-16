//
//  StreamingTweetCell.swift
//  TheSwifter
//
//  Created by Michael Ardizzone on 5/16/18.
//  Copyright © 2018 Michael Ardizzone. All rights reserved.
//

import UIKit

class StreamingTweetCell: UITableViewCell {

    @IBOutlet weak var nameText: UILabel!
    
    @IBOutlet weak var tweetText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
