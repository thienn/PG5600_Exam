//
//  FilmsViewController.swift
//  PG5600_Exam
//
//  Created by Thien Nguyen on 22/11/2018.
//  Copyright © 2018 Thien Cong Pham. All rights reserved.
//

import UIKit
import Alamofire

class FilmsViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Store the movies that get come from results in API
    var films = [Film]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Just in case there is confusion, it adds the items in order to the Films array. However, the list
        // from the Api isn't in order of the released movies. Just to avoid confusion or thinking that maybe it's some
        // async issues. In the API A New Hope (First movie) then second object in there is Attack of the clones (4th movie released)
        
        
        // But from API endpoint it is in proper order
       // Commented out while developing other area
        getFilms() { (film) in }
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // Tell it to follow self to know which datasource
        tableView.dataSource = self
    
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return as many as the films array have
        return films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieCell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! FilmTableViewCell
        
        // return the cell in the UI for tableview with as! name of the file
        
        // then connect it with the title with the same indexPath
        movieCell.titleLabel.text = films[indexPath.row].title
        movieCell.selectionStyle = .none
        
        return movieCell
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Connect to the films api via Alamofire. Connect through Films model, results from there then follow the Film model
    // Store that results into Films Array.
    func getFilms(completion: @escaping FilmResponseCompletion) {
        
        // Network call with Almofire and Codable
        guard let url = URL(string: "https://swapi.co/api/films/" ) else { return }
        //print(url)
        Alamofire.request(url).responseJSON { ( response ) in
            if let error = response.result.error {
                debugPrint(error.localizedDescription)
                 completion(nil)
                return
            }
            
            guard let data = response.data else { return completion(nil) }
            let jsonDecoder = JSONDecoder()
            
            do {
                let film = try jsonDecoder.decode(FilmsList.self, from: data)
                
                // Set the results from Films object (which is array of films) into local films array
                self.films = film.results
                
                completion(film)
                
                self.tableView.reloadData()
                
                //print(film)
                
            } catch {
                debugPrint(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    
    // Segue to detail page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Use indexPath of the selected item as the identifier to show details for
        if let movieDetailVC = segue.destination as? DetailFilmViewController, let indexPath = tableView.indexPathForSelectedRow {
            let film = films[indexPath.row]
            movieDetailVC.film = film
        }
    }
    
}

