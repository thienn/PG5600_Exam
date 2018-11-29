//
//  FavoriteFilmsViewController.swift
//  PG5600_Exam
//
//  Created by Thien Nguyen on 26/11/2018.
//  Copyright © 2018 Thien Cong Pham. All rights reserved.
//

import UIKit
import CoreData

class FavoriteFilmsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // fetchedResults instance to connect and handle the communication with the Core data Films entity
    // throughout the class to populate, update / refresh the table View
    private var fetchedResultsController: NSFetchedResultsController<Films>?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchedResultsController = getFilms(moc: context)
        
        tableView.dataSource = self
        
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
        
        // Connect cell to the favoriteFilmCell View. Configure the cell based on the data it finds at the indexPath and populate same
        // indexPath via configureCell from cell View
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteFilmCell", for: indexPath) as! FavoriteFilmTableViewCell
        if let film = fetchedResultsController?.object(at: indexPath) {
            cell.configureCell(films: film)
        }
        cell.selectionStyle = .none
        
       return cell
    }
    
    // May remove as it isn't important for current use
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Connects to the Core Data via NSFetchedResultsController that is made for tableView handling
    // Sort it by the title A-Z. Try to perfom fetch, if not then error. Set itself as the delegator to handle the view
    func getFilms(moc: NSManagedObjectContext) -> NSFetchedResultsController<Films> {
        let fetchedResultsController: NSFetchedResultsController<Films>
        
        let request: NSFetchRequest<Films> = Films.fetchRequest()
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [titleSort] // Connect the descriptors as you can have multiple
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Fetching records in favorite films")
        }
        fetchedResultsController.delegate = self // Set this view controller as the delegator
        
        return fetchedResultsController
      
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Use indexPath of the selected item as the identifier to show details for
        if let filmDetailVC = segue.destination as? DetailFilmViewController, let indexPath = tableView.indexPathForSelectedRow {
            
            // Create temporary variables for converting Int16 (Core data - type) to normal Int to pass to Film Model
            let episodeInt16: Int16 = (fetchedResultsController?.object(at: indexPath).episodeid)!
            let episodeInt = Int(episodeInt16)
            
            // Make an intance of Film Model, populate the data with the ones from Core data at current selected row. Pass that instance to DetailFilmViewController
            // This makes it possible to reuse the same detail page as it's not depended on the core data. So it's possible to delete the data from core Data (remove from Favorites)
            // in the detail Page without removing the current values in the detailPage as it refreshes the View after each action in there
            let filmTemporary = Film(
                title: (fetchedResultsController?.object(at: indexPath).title)!,
                episodeid: episodeInt, // Grab from the converted version
                director: (fetchedResultsController?.object(at: indexPath).director)!,
                producer: (fetchedResultsController?.object(at: indexPath).producer)!,
                releaseDate: (fetchedResultsController?.object(at: indexPath).releaseDate)!,
                crawl: (fetchedResultsController?.object(at: indexPath).crawl)!)
            filmDetailVC.film = filmTemporary // Pass the intance of Film to the DetailPage
            // print(filmTemporary)
        }
    }
}

// Delegate extension to handle the updates to the tableView after it's initial setup
extension FavoriteFilmsViewController: NSFetchedResultsControllerDelegate {
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
