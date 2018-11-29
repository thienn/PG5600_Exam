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
        
        // Modify so this is only run once
        for i in 1...3 {
            getCharacters(pageNum: i) { (character) in }
            
        }
        
        self.loadData()

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Be false by default unless told so. Which means it will be black background by default
        var savedCheck = false
        
        // Check with the function checkFavorites that will communicate with the Core Data
        // If it finds a record of the character it will return true back for savedCheck
        savedCheck = checkFavorites(savedCheck: savedCheck, indexPath: indexPath)
       
        // Send data to View to set up character cell based on the characters properties in array and savedCheck if it's true or false
        if let charCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? CharacterCell {
            let selectedCharacter = characters[indexPath.row]
            charCell.configureCell(char: selectedCharacter, saved: savedCheck)
         
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

        // savedCheck value that checks in with the checkFavorites, if it finds it in the records. Delete the character
        // If not then add the character to the records.
        var savedCheck = false
        savedCheck = checkFavorites(savedCheck: savedCheck, indexPath: indexPath)
        
        if savedCheck {
            deleteCharacter(indexPath: indexPath)
        } else {
            addCharacter(indexPath: indexPath)
        }
        
        self.loadData() // Reload the collectionView after each click
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
    
    // Add character to Favorites (Characters entity) based on the selected indexPath
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
        } catch {
            print("Failed to save to DB")
        }
    }
    
    
   // Dete character from Favorites (Characters entity) based on the selected indexPath
    func deleteCharacter(indexPath: IndexPath) {
        // Connect to the context specifically the entity Characters, then fetch the data from the context (CoreData)
        // with the key title (Like SQL queries where name ==). Then delete that record
        // as it should only return 1 record, therefore the index 0 should always be right
        // then save it, and refresh the view
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Characters")
       fetchRequest.predicate = NSPredicate(format: "name =%@", characters[indexPath.row].name)
        
        do {
            let record = try context.fetch(fetchRequest)
            let objectToDelete = record[0] as! NSManagedObject
            context.delete(objectToDelete)
            
            do {
               print("Deleted \(characters[indexPath.row].name) from CoreData")
                try context.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        
    }
    
    // func to call for checking with the CoreData if that character exist in the records.
    // Based on name and returns true if it finds it, or else it's false by default
    func checkFavorites(savedCheck: Bool, indexPath: IndexPath) -> Bool {
        var savedCheck = savedCheck
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Characters")
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                //print(data.value(forKey: "name") as! String)
                if data.value(forKey: "name") as! String == characters[indexPath.row].name {
                    savedCheck = true
                }
            }
           // print("---")
        } catch {
            print("Failed to get data")
        }
        return savedCheck
    }

    func loadData() {
        collectionView.reloadData()
    }
}
