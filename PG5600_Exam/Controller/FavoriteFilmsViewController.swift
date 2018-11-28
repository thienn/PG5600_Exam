//
//  FavoriteFilmsViewController.swift
//  PG5600_Exam
//
//  Created by Thien Nguyen on 26/11/2018.
//  Copyright © 2018 Thien Cong Pham. All rights reserved.
//

import UIKit
import CoreData

class FavoriteFilmsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var characters = [Films]()
    
    
    
    private var fetchedResultsController: NSFetchedResultsController<Films>?
    
    //let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //let context = appDelegate.persistentContainer.viewContext
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       // loadFilms()
        //print(characters)
       //characters = fetchAllCharacters()
       
        //loadData()
        fetchedResultsController = getMovies(moc: context)
        
        tableView.dataSource = self
        
        /*
        func controllerWillChangeContent(controller: NSFetchedResultsController<NSFetchRequestResult><NSFetchRequestResult>) {
            tableView.beginUpdates()
        }
        
        func controllerDidChangeContent(controller: NSFetchedResultsController<NSFetchRequestResult>) {
            tableView.endUpdates()
        }
        
        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
            
            switch type {
            case .update:
                if let cell = self.tableView.cellForRow(at: indexPath!) {
                    self.configureCell(cell, indexPath : indexPath)
                }
            case .delete:
                tableView.deleteRows(at: [indexPath], with: CAAnimation)
            default:
                break
            }
        }*/
        
    }
    
    /*
    func numberOfSections(_ tableView: UITableView) -> Int {
        if let sections = fetchedResultsController?.sections {
            return sections.count
        }
        return 0
    }*/
    
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return characters.count
       /* if let sections = fetchedResultsController?.sections {
            return sections.count
        } */
        // return 0
        
        
        if let sections = fetchedResultsController?.sections {
            return sections[section].numberOfObjects
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
        let character = characters[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteFilmCell",
                                                 for: indexPath)
        cell.textLabel?.text = character.value(forKeyPath: "title") as? String
        return cell
         */
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteFilmCell", for: indexPath) as! FavoriteFilmTableViewCell
        if let film = fetchedResultsController?.object(at: indexPath) {
            cell.configureCell(films: film)
        }
       // cell.titleLabel.text = "Jupp"
       return cell
    }
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    func getMovies(moc: NSManagedObjectContext) -> NSFetchedResultsController<Films> {
        let fetchedResultsController: NSFetchedResultsController<Films>
        
        let request: NSFetchRequest<Films> = Films.fetchRequest()
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [titleSort]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Fetching records in favorite films")
        }
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

/*
// Extension delegate to handle updates / refreshes to the tableView
extension FavoriteFilmsViewController: NSFetchedResultsControllerDelegate {
    // Start the update on noticing a change
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
        
    }
    
    // For handling the update
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let indexPath = indexPath else { return } // If it cant find the indexpath then stop the execution or else run like it should
        switch type {
        case .update:
            tableView.reloadRows(at: [indexPath], with: .fade)
            break
        case .delete:
            tableView.reloadRows(at: [indexPath], with: .fade)
        default:
            break
        }
        
        
    }
    
    // End the update after / save
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}
 */
