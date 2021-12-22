//
//  NoteTableViewCell.swift
//  Time Visualizer
//
//  Created by administrator on 19/12/2021.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    var daysDelegate : DaysDelegates?
    var notesDelegates: NotesDelegates?
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var noteTextField: UITextField!
    
    @IBOutlet weak var addNoteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
        

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

    @IBAction func noteTextFieldPreaaed(_ sender: UITextField) {
        addNoteButton.isHidden = false
    }
   
    @IBAction func addNoteButtonPressed(_ sender: UIButton) {
        if let text = noteTextField.text {
            if !text.isEmpty{
                let text = text
                let time = timeLabel.text
                let day = daysDelegate?.getCurrentDay()
                
                notesDelegates?.saveNewNote(text: text, time: time!, day: day!)
            }
        }
        noteTextField.endEditing(false)
        addNoteButton.isHidden = true
    }
    
}
