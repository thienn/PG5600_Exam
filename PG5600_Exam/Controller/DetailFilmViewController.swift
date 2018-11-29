//
//  DetailFilmViewController.swift
//  PG5600_Exam
//
//  Created by Thien Nguyen on 22/11/2018.
//  Copyright © 2018 Thien Cong Pham. All rights reserved.
//
// Examples on how to setup CoreData + CRUD from lectures + https://medium.com/@ankurvekariya/core-data-crud-with-swift-4-2-for-beginners-40efe4e7d1cc
//

import UIKit
import CoreData

class DetailFilmViewController: UIViewController {
    
    var film: Film!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var crawlText: UITextView!
    
    // Button for CoreData functions Add / remove from favorite list
    @IBOutlet weak var favoriteButton: UIButton!
    
    var checkStatus = false;
    
    // Global context the whole class can take use of for CoreData connection
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        crawlText.isEditable = false
    
        // Connect the data sent in with the labels
        titleLabel.text = film.title
        episodeLabel.text = film.episodeid.description
        directorLabel.text = film.director
        producerLabel.text = film.producer
        releaseDateLabel.text = film.releaseDate
        crawlText.text = film.crawl
 
        
        // Connect to the CoreData Films entity to check if the current Title exist in the records or not
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Films")
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                //print(data.value(forKey: "title") as! String)
                
                // If the title exist in the records turn the checkStatus true
                // This will ensure that whenever the user goes in and out of the details, it will run the check everytime.
                if data.value(forKey: "title") as! String == film.title {
                    checkStatus = true
                }
            }
             //print("---")
        } catch {
            print("Failed to get data")
        }
        
        // If it exist, then show the button as Delete else default will be Add
        if checkStatus == true {
            favoriteButton.setTitle("Delete from favorite", for: .normal)
        } else {
            favoriteButton.setTitle("Add to favorite", for: .normal)
        }
    }
    
    // Button to add / remove film from Core Data, based on if it's already there or not
    @IBAction func addToDB(_ sender: UIButton) {
        if checkStatus == true {
            deleteFilm()
        } else {
            addFilm()
        }
    }
    
    func addFilm() {
        // Connect to the context specifically the entity Films, then new object to insert into the context (CoreData)
        // Then save it, and refresh the view
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
           // print("Added \(film.title) to CoreData")
            self.viewDidLoad() // to refresh view for button - bad pratice, but doing it in controlled situation
        } catch {
            print("Failed to save to DB")
        }
    }
    
    func deleteFilm() {
        // Connect to the context specifically the entity Films, then fetch the data from the context (CoreData)
        // with the key title (Like SQL queries where title ==). Then delete that record
        // as it should only return 1 record, therefore the index 0 should always be right
        // then save it, and refresh the view
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Films")
        fetchRequest.predicate = NSPredicate(format: "title =%@", film.title)
        
        do {
            let record = try context.fetch(fetchRequest)
            let objectToDelete = record[0] as! NSManagedObject
            context.delete(objectToDelete)
            
            do {
              //  print("Deleted \(film.title) from CoreData")
                try context.save()
                checkStatus = false
                self.viewDidLoad() // to refresh view for button - bad pratice, but doing it in controlled situation
            } catch {
                print(error)
            }
          
        } catch {
            print(error)
        }
        
    }

}
