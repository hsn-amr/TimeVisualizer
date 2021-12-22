//
//  StatisticsTableViewCell.swift
//  Time Visualizer
//
//  Created by administrator on 19/12/2021.
//

import UIKit

class StatisticsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var sunLabel: UILabel!
    @IBOutlet weak var monLabel: UILabel!
    @IBOutlet weak var tueLabel: UILabel!
    @IBOutlet weak var wenLabel: UILabel!
    @IBOutlet weak var thuLabel: UILabel!
    @IBOutlet weak var friLabel: UILabel!
    @IBOutlet weak var satLabel: UILabel!
    
    @IBOutlet weak var sunNoteLabel: UILabel!
    @IBOutlet weak var monNoteLabel: UILabel!
    @IBOutlet weak var tueNoteLabel: UILabel!
    @IBOutlet weak var wenNoteLabel: UILabel!
    @IBOutlet weak var thuNoteLabel: UILabel!
    @IBOutlet weak var friNoteLabel: UILabel!
    @IBOutlet weak var satNoteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
