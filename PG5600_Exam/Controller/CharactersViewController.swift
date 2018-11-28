//
//  CharactersViewController.swift
//  PG5600_Exam
//
//  Created by Thien Nguyen on 24/11/2018.
//  Copyright © 2018 Thien Cong Pham. All rights reserved.
//

import UIKit
import Alamofire

class CharactersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var characters = [Person]()
    
   // var character: Person
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Run the loop 3 times, and change the page number in the call to next page
        /*
            Since these are async calls, they sometimes don't come back in order they got requested
            Don't know if it was a hard requirement or not. According to the text it only mention that
            you need to do the calls to the 3 pages or more. But nothing about order.
            Therefore I have taken it as it doesn't matter.
            Looked into different methods for signaling wait and continue, but decided not to do this
            because of performance hit if unnecessary.
        */
        
        for i in 1...3 {
            getCharacters(pageNum: i) { (character) in }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let charCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? CharacterCell {
            
            /*
            cell.titleLabel.text = films[indexPath.row].title
            // movieCell.titleLabel.text = films.results[indexPath.row].title
            //movieCell.titleLabel.text = films
            
            movieCell.selectionStyle = .none
             */
            
            charCell.characterName.text = characters[indexPath.row].name
        
            return charCell
        }
        return UICollectionViewCell()
    }
    
    
     // To tell the view to take up half the Row for each item, so you have space for 2 items on the grid row
     // Then add - 15 for padding
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
        let width = view.bounds.width // Get the width of the device it is running on
        let cellSize = (width / 2) - 15
        return CGSize(width: cellSize, height: cellSize)
 

    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Add to favorite logic
        // Method call or so to select the right cell?
        
        let selectedCell:UICollectionViewCell = collectionView.cellForItem(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.orange
 
        /*
        let charCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? CharacterCell {
            
            /*
             cell.titleLabel.text = films[indexPath.row].title
             // movieCell.titleLabel.text = films.results[indexPath.row].title
             //movieCell.titleLabel.text = films
             
             movieCell.selectionStyle = .none
             */
            
            charCell?.configureCell(backgroundColor = UIColor.orange)
            
            return charCell
         */
        
       // self.collectionView.reloadData()
    }
    
    func getCharacters( pageNum: Int, completion: @escaping CharacterResponseCompletion) {
        // Convert the link into the accepting the id for page 1-3? or use the next tag
        guard let url = URL(string: "https://swapi.co/api/people/?page=\(pageNum)") else { return }
        print(url)
        Alamofire.request(url).responseJSON { ( response ) in
            // If there is any error
            if let error = response.result.error {
                debugPrint(error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let data = response.data else { return completion(nil) }
            let jsonDecoder = JSONDecoder()
            
            do {
                let character = try jsonDecoder.decode(People.self, from: data)
                //self.characters = character.results
                //self.characters.append(character.results)
                //characters.append(character.results) //or items += [item]
                // Add the new characters to the array (can't overwrite like in movies)
                completion(character)
                //print(pageNum)
               // print(character.results)
                self.characters += character.results
               // print(self.characters)

               /*
                let copy = self.characters
                let tempArray = []
                tempArray.append(contentsOf: copy)
                tempArray.append(character.results)
                self.characters = tempArray
            */
             
                
                
                // Refresh the data after it has been populated
                self.collectionView.reloadData()
                
            } catch {
                debugPrint(error.localizedDescription)
                completion(nil)
            }
            
            
        }
    }
    /*
    func addFilm() {
        // Creates the context, then new object to insert into the context (CoreData)
        // Then save it, and refresh the view
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
      //  let entity = NSEntityDescription.entity(forEntityName: "Films", in: context)
       // let newFilm = NSManagedObject(entity: entity!, insertInto: context)
        
        /*
        newFilm.setValue(film.title, forKey: "title")
        newFilm.setValue(film.episodeid, forKey: "episodeid")
        newFilm.setValue(film.director, forKey: "director")
        newFilm.setValue(film.producer, forKey: "producer")
        newFilm.setValue(film.releaseDate, forKey: "releaseDate")
        newFilm.setValue(film.crawl, forKey: "crawl")
        */
        
        do {
            try context.save()
         //   print("Added \(film.title) to CoreData")
            self.viewDidLoad() // to refresh view for button
        } catch {
            print("Failed to save to DB")
        }
    }
    
    // function for delete
    func deleteFilm() {
        // Creates the context, then fetch the data from the context (CoreData)
        // with the key title (Like SQL queries where title ==). Then delete that record
        // as it should only return 1 record, therefore the index 0 should always be right
        // then save it, and refresh the view
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
 //       let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Films")
 //       fetchRequest.predicate = NSPredicate(format: "title =%@", film.title)
        
        do {
          //  let test = try context.fetch(fetchRequest)
            let objectToDelete = test[0] as! NSManagedObject
            context.delete(objectToDelete)
            
            do {
       //         print("Deleted \(film.title) from CoreData")
                try context.save()
        //        checkStatus = false
                self.viewDidLoad() // to refresh view for button
            } catch {
                print(error)
            }
            
        } catch {
            print(error)
        }
        
    }
     */
    
}
