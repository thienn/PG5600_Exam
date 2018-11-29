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
    func configureCell() {
        backgroundColor = UIColor.black
        // Code where if this is a item in the CoreData turn the cell orange
        //characterName.text
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        backgroundColor = UIColor.white
    }
    
    
}
