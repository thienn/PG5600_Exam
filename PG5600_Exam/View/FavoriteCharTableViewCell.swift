//
//  FavoriteCharTableViewCell.swift
//  PG5600_Exam
//
//  Created by Thien Nguyen on 28/11/2018.
//  Copyright © 2018 Thien Cong Pham. All rights reserved.
//

import UIKit

class FavoriteCharTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(characters: Characters) {
        nameLabel.text = characters.name
    }

}
