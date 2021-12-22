//
//  KeyWordCollectionViewCell.swift
//  Time Visualizer
//
//  Created by administrator on 19/12/2021.
//

import UIKit

class KeyWordCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var keyWordLabel: UILabel!
    
    var deleteDelegate: KeyWordsDelegates?
    var index = 0
    
    @IBAction func deletWordButtonPressed(_ sender: UIButton) {
        deleteDelegate?.deletKeyWord(at: index)
    }
}
