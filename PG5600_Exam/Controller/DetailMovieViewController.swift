//
//  DetailMovieViewController.swift
//  PG5600_Exam
//
//  Created by Thien Nguyen on 22/11/2018.
//  Copyright © 2018 Thien Cong Pham. All rights reserved.
//

import UIKit

class DetailMovieViewController: UIViewController {
    
    var film: Film!
    

    @IBOutlet weak var stackBackground: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var crawlText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        crawlText.isEditable = false
    
        // Connect the data sent in with the labels
        titleLabel.text = film.title
        episodeLabel.text = film.episodeid.description // As it's not straight string, so need to specify the content of description
        directorLabel.text = film.director
        producerLabel.text = film.producer
        releaseDateLabel.text = film.releaseDate
        crawlText.text = film.crawl
        
        stackBackground.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
