//
//  FilmApi.swift
//  PG5600_Exam
//
//  Created by Thien Nguyen on 23/11/2018.
//  Copyright © 2018 Thien Cong Pham. All rights reserved.
//

import Foundation
import Alamofire

class FilmsApi {
    
    func getFilm(url: String, completion: @escaping FilmResponseCompletion) {
        guard let url = URL(string: url) else { return }
        Alamofire.request(url).responseJSON { (response) in
            if let error = response.result.error {
                debugPrint(error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let data = response.data else { return completion(nil)}
            let jsonDecoder = JSONDecoder()
            do {
                let film = try jsonDecoder.decode(Filmk.self, from: data)
                completion(film)
            } catch {
                debugPrint(error.localizedDescription)
                completion(nil)
            }
            
        }
    }
}

