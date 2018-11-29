//
//  CharacterCell.swift
//  PG5600_Exam
//
//  Created by Thien Nguyen on 24/11/2018.
//  Copyright © 2018 Thien Cong Pham. All rights reserved.
//

import UIKit

class CharacterCell: UICollectionViewCell {
    @IBOutlet weak var characterImg: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // Not in use atm
    func configureCell(char: Person, saved: Bool) {
        // saved value means that it exist in the CoreData
        // Thefore saved then orange or else Black for visuals
        if saved {
            characterName.text = char.name
            characterImg.backgroundColor = UIColor.orange
        } else {
            characterName.text = char.name
           characterImg.backgroundColor = UIColor.black
        }
        
    }
    
}
