//
//  FeedCell.swift
//  SnapchatClone
//
//  Created by Burak Afyonlu on 12.03.2023.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
