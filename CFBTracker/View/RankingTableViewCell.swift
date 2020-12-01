//
//  RankingTableViewCell.swift
//  CFBTracker
//
//  Created by Terry Wang on 11/19/20.
//  terrywangce@gmail.com
//

import UIKit

class RankingTableViewCell: UITableViewCell {

    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    @IBOutlet weak var teamImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
