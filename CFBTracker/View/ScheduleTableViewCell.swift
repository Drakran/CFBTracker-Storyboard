//
//  ScheduleTableViewCell.swift
//  CFBTracker
//
//  Created by Terry Wang on 11/20/20.
//  terrywangce@gmail.com
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {
    
    weak var cellDelegate: CellDelegate?
    
    // All the Outlets for schedule
    @IBOutlet weak var firstTeamLabel: UILabel!
    @IBOutlet weak var secondTeamLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var firstTeamImageView: UIImageView!
    @IBOutlet weak var secondTeamImageView: UIImageView!
    @IBOutlet weak var addEventButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func eventButton(_ sender: UIButton){
        cellDelegate?.didPressButton(cell: self)
    }


}
