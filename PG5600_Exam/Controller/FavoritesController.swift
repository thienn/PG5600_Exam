//
//  FavoritesController.swift
//  PG5600_Exam
//
//  Created by Thien Nguyen on 26/11/2018.
//  Copyright © 2018 Thien Cong Pham. All rights reserved.
//

import UIKit

class FavoritesController: UIViewController {
    @IBOutlet weak var filmsView: UIView!
    @IBOutlet weak var charactersView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func switchViews(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            filmsView.alpha = 1
            charactersView.alpha = 0
        } else {
            filmsView.alpha = 0
            charactersView.alpha = 1
        }
    }
    
}
