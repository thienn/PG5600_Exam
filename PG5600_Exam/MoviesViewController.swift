//
//  ViewController.swift
//  PG5600_Exam
//
//  Created by Thien Nguyen on 22/11/2018.
//  Copyright © 2018 Thien Cong Pham. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var personApi = PersonApi()
    
    var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        personApi.getRandomPersonUrlSession()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Refresh button
        
        // Tell it to follow self to know which datasource
        tableView.dataSource = self
        
        // Call the method that will refresh
        refreshMovies()
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return as many as the movies array have
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieCell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        
        // return the cell in the UI for tableview with as! name of the file
        
        // then connect it with the text
        
        
        movieCell.titleLabel.text = movies[indexPath.row].title
        
        movieCell.selectionStyle = .none
        
        return movieCell
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @objc
    func refreshMovies() {
        // Network call with REST-API - JSON
        let task = URLSession.shared.dataTask(with: URL.init(string: "https://swapi.co/api/films/1")!) { (data, response, error) in
            
            // print out from optional / (binary) to porper readable data
            if let actualData = data {
                let responseString = String.init(data: actualData, encoding: String.Encoding.utf8)
                
                let decoder = JSONDecoder();
                
                do {
                    let movies = try decoder.decode([Movie].self, from: actualData)
                    
                    // populate the empty array with movies
                    self.movies = movies
                    
                    // Main thread should only be used for UI elements, the rest of the threads should take care of tasks
                    // like refresh and update the incoming data. Which can be done with DispatchQueue
                    DispatchQueue.main.sync {
                        self.tableView.reloadData()
                    }
                    
                    for movie in movies {
                        print(movie.title)
                    }
                    
                } catch let error {
                    print(error)
                }
                
                // Print responsestring?
            }
            
        }
        
        task.resume()
    }
    
    


}

