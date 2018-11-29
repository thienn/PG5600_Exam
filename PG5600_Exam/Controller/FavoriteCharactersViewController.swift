//
//  FavoriteCharactersViewController.swift
//  PG5600_Exam
//
//  Created by Thien Nguyen on 26/11/2018.
//  Copyright © 2018 Thien Cong Pham. All rights reserved.
//

import UIKit
import CoreData

class FavoriteCharactersViewController: UIViewController, UITableViewDataSource, UITabBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // fetchedResults instance to connect and handle the communication with the Core data Characters entity
    // throughout the class to populate, update / refresh the table View
    private var fetchedResultsController: NSFetchedResultsController<Characters>?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController = getCharacters(moc: context)
        
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // check in with the fetchedResultsController to see how many objects is in there.
        // Then return that amount of rows or else 0 by default
        
        if let sections = fetchedResultsController?.sections {
            return sections[section].numberOfObjects
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Connect cell to the favoriteCharCell View. Configure the cell based on the data it finds at the indexPath and populate same
        // indexPath via configureCell from cell View
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCharCell", for: indexPath) as! FavoriteCharTableViewCell
        if let character = fetchedResultsController?.object(at: indexPath) {
            cell.configureCell(characters: character)
        }
        cell.selectionStyle = .none
 
        return cell
    }
    
    
    // Connects to the Core Data via NSFetchedResultsController that is made for tableView handling
    // Sort it by the character name A-Z. Try to perfom fetch, if not then error. Set itself as the delegator to handle the view
    func getCharacters(moc: NSManagedObjectContext) -> NSFetchedResultsController<Characters> {
        let fetchedResultsController: NSFetchedResultsController<Characters>
        
        let request: NSFetchRequest<Characters> = Characters.fetchRequest()
        let titleSort = NSSortDescriptor(key: "name", ascending: true)
        
        request.sortDescriptors = [titleSort] // Connect the descriptors as you can have multiple
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Error Fetching records in favorite characters")
        }
        fetchedResultsController.delegate = self // Set this view controller as the delegator
        
        return fetchedResultsController
        
    }

}

// Delegate extension to handle the updates to the tableView after it's initial setup
extension FavoriteCharactersViewController: NSFetchedResultsControllerDelegate {
    // For when it detects updates
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    // For when it has finished updated
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // The func that actually do something with the update depending on what changed - happens between the two functions above
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        // Since we only add or delete something from the CoreData, never update or move anything
        // It doesn't need to contain logic in those cases for now, but is required to have the case there due to it being mandatory
        switch(type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
                //print("insert")
            }
            break
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
                //print("delete")
            }
            break
        case .move:
            break
        case .update:
            break
        }
    }
    
}
