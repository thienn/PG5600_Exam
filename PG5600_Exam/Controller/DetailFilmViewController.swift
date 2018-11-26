//
//  DetailFilmViewController.swift
//  PG5600_Exam
//
//  Created by Thien Nguyen on 22/11/2018.
//  Copyright © 2018 Thien Cong Pham. All rights reserved.
//

import UIKit
import CoreData

class DetailFilmViewController: UIViewController {
    
    var film: Film!
    

    @IBOutlet weak var stackBackground: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var crawlText: UITextView!
    
    // Button for CoreData functions Add / remove from list with name of favorite
    
    @IBOutlet weak var favoriteButton: UIButton!
    
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
    
    // When clicking the button it should add or remove from the Core data
    @IBAction func addToDB(_ sender: UIButton) {
        sender.setTitle("Add to favorite", for: .normal)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Films", in: context)
        let newFilm = NSManagedObject(entity: entity!, insertInto: context)
        
        newFilm.setValue(film.title, forKey: "title")
        newFilm.setValue(film.episodeid, forKey: "episodeid")
        newFilm.setValue(film.director, forKey: "director")
        newFilm.setValue(film.producer, forKey: "producer")
        newFilm.setValue(film.releaseDate, forKey: "releaseDate")
        newFilm.setValue(film.crawl, forKey: "crawl")
        
        do {
            try context.save()
        } catch {
            print("Failed to save to DB")
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Films")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "title") as! String)
            }
        } catch {
            print("Failed to get data")
        }
        
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
