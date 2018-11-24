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
    
   // var personApi = PersonApi()
    
   // var movies = [Movie]()
   // var film = FilmApi()
    //let api = FilmsApi()
   // var films = [Results]()
   // var films = [Film]()
    var films = [Film]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Just in case there is confusion, it adds the items in order to the Films array. However, the list
        // from the Api isn't in order of the released movies. Just to avoid confusion or thinking that maybe it's some
        // async issues. In the API A New Hope (First movie) then second object in there is Attack of the clones (4th movie released)
        
        
        // But from API endpoint it is in proper order
       // Commented out while developing other area
        refreshMovies() { (film) in }
        
            /*
            personApi.getRandomPersonAlamo(id: random) { (person) in
                if let person = person {
                    self.setupView(person: person)
                    self.person = person
                }
                */
        
        // Do any additional setup after loading the view, typically from a nib.
        
        // Refresh button
        
        // Tell it to follow self to know which datasource
        tableView.dataSource = self
        
        // Call the method that will refresh
       // refreshMovies()
    
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return as many as the movies array have
        return films.count
        //return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieCell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! FilmTableViewCell
        
        // return the cell in the UI for tableview with as! name of the file
        
        // then connect it with the text
        
        
        movieCell.titleLabel.text = films[indexPath.row].title
       // movieCell.titleLabel.text = films.results[indexPath.row].title
        //movieCell.titleLabel.text = films
        
        movieCell.selectionStyle = .none
        
        return movieCell
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
   // func refreshMovies(i: Int, completion: @escaping (Filmk?) -> Void) {
    // func refreshMovies(i: Int, completion: @escaping FilmResponseCompletion) {
    func refreshMovies(completion: @escaping FilmResponseCompletion) {
        // Read the count or so from the films. Currently going directly into the films which is bad
        // stringUrl = "https://swapi.co/api/films/\(i)"
        
        // Network call with Almofire and Codable
        //  guard let url = URL(string: "https://swapi.co/api/films/1") else { return }
        //guard let url = URL(string: "https://swapi.co/api/films/\(i)" ) else { return }
        guard let url = URL(string: "https://swapi.co/api/films/" ) else { return }
        print(url)
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
                /* Longer version of what is under
                for singleData in film.results {
                    self.films = [singleData]
                    print(singleData)
                }*/
                self.films = film.results
                
                completion(film)
                // something bytes, not interesting print(data) - film is the decoded version
                //self.films.append(film)
                //print(film.results)

                
                /*
                 self.jsonStrToPass = str
                 self.jsonStringArray.append(self.jsonStrToPass)
                 */
                
                self.tableView.reloadData()
                
                //print(film)
                
            } catch {
                debugPrint(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    
    
    
    /*
    @objc
    func refreshMovies() {
        // Network call with REST-API - JSON
        let task = URLSession.shared.dataTask(with: URL.init(string: "https://swapi.co/api/films/1")!) { (data, response, error) in
            
            // print out from optional / (binary) to porper readable data
            if let actualData = data {
                let responseString = String.init(data: actualData, encoding: String.Encoding.utf8)
                
                let decoder = JSONDecoder();
                
                do {
                    let films = try decoder.decode(Results.self, from: actualData)
                    
                    // populate the empty array with movies
                    self.films = films
                    
                    // Main thread should only be used for UI elements, the rest of the threads should take care of tasks
                    // like refresh and update the incoming data. Which can be done with DispatchQueue
                    DispatchQueue.main.sync {
                        self.tableView.reloadData()
                    }
                    
                    
                    for film in films {
                        print(film)
                    }
                    print(films)
                    
                } catch let error {
                    print(error)
                }
                
                // Print responsestring?
            }
            
        }
        
        task.resume()
    }
    
    */
    
    // Segue to detail page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Use indexPath of the selected item as the identifier to show details for
        if let movieDetailVC = segue.destination as? DetailFilmViewController, let indexPath = tableView.indexPathForSelectedRow {
            let film = films[indexPath.row]
            movieDetailVC.film = film
        }
    }
    
}

// Check if this is needed for CoreData
protocol FilmkProtocol {
    var film: Film! {get set}
}


