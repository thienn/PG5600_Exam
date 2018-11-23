//
//  PersonApi.swift
//  PG5600_Exam
//
//  Created by Thien Nguyen on 23/11/2018.
//  Copyright © 2018 Thien Cong Pham. All rights reserved.
//

import Foundation

class PersonApi {
    
    func getRandomPersonUrlSession() {
        
        guard let url = URL(string: URL_PERSON) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // In case of error - return a print, or else nothing
            guard error == nil else {
                debugPrint(error.debugDescription)
                return
            }
            
            // Unwrap the optional type data for use
            guard let data = data else { return }
            
            do {
                // Do with data, and options empty array for now
                let jsonAny = try JSONSerialization.jsonObject(with: data, options: [])
                guard let json = jsonAny as? [String: Any] else { return }
               // print(json)
                
                //Call the parsing method - self as it is in closure
                let person = self.parsePersonManual(json: json)
                
                print(person.name)
                print(person.filmUrls)
                
            } catch {
                debugPrint(error.localizedDescription)
                return
            }
            
            print("Data = \(data)")
            print("Response = \(response)")
        }
        task.resume() // Since the task start in a suspended state. It's a must to "resume" the task 
    }
    
    private func parsePersonManual(json: [String: Any]) -> Person {
        /*
        let names = ["nameOne":"Thien", "nameTwo":"OtherName"]
        
        let thien = names["nameOne"]
        print(thien)
         */
        
        // ?? for default value if there is none given
        let name = json["name"] as? String ?? ""
        let height = json["height"] as? String ?? ""
        let mass = json["mass"] as? String ?? ""
        let hair = json["hair_color"] as? String ?? ""
        let birthYear = json["birth_year"] as? String ?? ""
        let gender = json["gender"] as? String ?? ""
        let homeworldUrl = json["homeworld"] as? String ?? ""
        let filmUrls = json["films"] as? [String] ?? [String]()
        let vehicleUrls = json["vehicles"] as? [String] ?? [String]()
        let starshipsUrls = json["starships"] as? [String] ?? [String]()
    
        /*
            Long version let person = Person and return person.
            short is replace that with return at front
         */
        return Person(name: name, height: height, mass: mass, hair: hair, birthYear: birthYear,
                            gender: gender, homeworldUrl: homeworldUrl, filmUrls: filmUrls,
                            vehicleUrls: vehicleUrls, starshipUrls: starshipsUrls)
        
    }
 
}
