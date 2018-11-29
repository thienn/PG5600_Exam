//
//  CharactersViewController.swift
//  PG5600_Exam
//
//  Created by Thien Nguyen on 24/11/2018.
//  Copyright © 2018 Thien Cong Pham. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class CharactersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var characters = [Person]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var checkStatus = false;
    
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
            Therefore I have taken it as it doesn't matter to focus on other parts.
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
        // Add to favorite logic - Not implemented
        // Method call or so to select the right cell?
        
        let selectedCell:UICollectionViewCell = collectionView.cellForItem(at: indexPath)!
        //var selectedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? CharacterCell
            
            /*
             cell.titleLabel.text = films[indexPath.row].title
             // movieCell.titleLabel.text = films.results[indexPath.row].title
             //movieCell.titleLabel.text = films
             
             movieCell.selectionStyle = .none
             */
        
        // Call the add Character to core data with the indexPath as identifier
        addCharacter(indexPath: indexPath)
        
        
        
        if selectedCell.contentView.backgroundColor == UIColor.orange {
            selectedCell.contentView.backgroundColor = UIColor.white
            //selectedCell?.configureCell(backgroundColor: UIColor.white)
            
        } else {
            selectedCell.contentView.backgroundColor = UIColor.orange
        }
 
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
        // Get in a number through pageNum argument. Which means it's scaleable if needed to be
        
        // Connects to people API via Alamofire, add the results array (array of characters) into the end of local characters array.
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
                completion(character)
                
                // Add the new characters to the end of array (can't overwrite like in films)
                self.characters += character.results
                
                // Refresh the view after it has been populated
                self.collectionView.reloadData()
                
            } catch {
                debugPrint(error.localizedDescription)
                completion(nil)
            }
            
            
        }
    }
    
    // Add character to Favorites (Characters entity) from the selected indexPath
    func addCharacter(indexPath: IndexPath) {
        // Connect to the context specifically the entity Characters, then new object to insert into the context (CoreData)
        // Then save it, and refresh the view
        
        let entity = NSEntityDescription.entity(forEntityName: "Characters", in: context)
        let newFavChar = NSManagedObject(entity: entity!, insertInto: context)
        
        newFavChar.setValue(characters[indexPath.row].name, forKey: "name")
        //newFavChar.setValue(characters[indexPath.row].films, forKey: "films")
        
        do {
            try context.save()
            print("Added \(characters[indexPath.row].name) to CoreData")
            //self.viewDidLoad() // to refresh view for button
        } catch {
            print("Failed to save to DB")
        }
    }
    
    /*
    // function for delete
    func deleteCharacter() {
        // Connect to the context specifically the entity Characters, then fetch the data from the context (CoreData)
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
    
    /*
    func checkFavorites() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Characters")
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "name") as! String)
                // If the title exist in the records turn the checkStatus true
                // This will ensure that whenever the user goes in and out of the details, it will run the check always. Will try to move it out of the for loop if possible later
                if data.value(forKey: "name") as! String ==  {
                    checkStatus = true
                }
            }
            print("---")
        } catch {
            print("Failed to get data")
        }
        
        // If it exist, then show the button as delete else default will be Add
        if checkStatus == true {
            favoriteButton.setTitle("Delete from favorite", for: .normal)
        } else {
            favoriteButton.setTitle("Add to favorite", for: .normal)
        }
    }
    */

}
