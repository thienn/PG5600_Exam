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
    
    private var fetchedResultsController: NSFetchedResultsController<Characters>?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            fetchedResultsController = getCharacters(moc: context)
        
            tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController?.sections {
            return sections[section].numberOfObjects
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCharCell", for: indexPath) as! FavoriteCharTableViewCell
        if let character = fetchedResultsController?.object(at: indexPath) {
            cell.configureCell(characters: character)
        }
        cell.selectionStyle = .none
 
        return cell
    }
    
    // May remove as it isn't important for current use
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func getCharacters(moc: NSManagedObjectContext) -> NSFetchedResultsController<Characters> {
        let fetchedResultsController: NSFetchedResultsController<Characters>
        
        let request: NSFetchRequest<Characters> = Characters.fetchRequest()
        let titleSort = NSSortDescriptor(key: "name", ascending: true)
        
        request.sortDescriptors = [titleSort]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Error Fetching records in favorite characters")
        }
        fetchedResultsController.delegate = self // Set this view controller as the delegator
        
        return fetchedResultsController
        
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


extension FavoriteCharactersViewController: NSFetchedResultsControllerDelegate {
    // For when it detects updates
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    // For when it has finished updated
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // The func that actually do something with the update depending on what changed
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        // Since we only add or delete something from the CoreData, never update or move anything
        // It doesn't need to contain logic in those cases for now, but is required to have the case there due to it being mandatory
        
        switch(type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
                print("insert")
            }
            break
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
                print("delete")
            }
            break
        case .move:
            /*
             if let indexPath = indexPath {
             tableView.deleteRows(at: [indexPath], with: .fade)
             }
             
             if let newIndexPath = newIndexPath {
             tableView.insertRows(at: [newIndexPath], with: .fade)
             }
             print("move") */
            break
        case .update:
            /*
             if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) {
             // cell.configureCell(cell, at: indexPath)
             }
             print("update") */
            break
        }
    }
    
    
}
