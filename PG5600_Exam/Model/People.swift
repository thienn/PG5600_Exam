//
//  People.swift
//  PG5600_Exam
//
//  Created by Thien Nguyen on 24/11/2018.
//  Copyright © 2018 Thien Cong Pham. All rights reserved.
//

import Foundation

struct People: Codable {
    //let count: Int
    let next: String
    let results: [Person]

    /*
     enum CodingKeys: String, CodingKey {
     case count
     case results
 
     }
     */
    /*
     init(from decoder: Decoder) throws {
     let container = try decoder.container(keyedBy: CodingKeys.self)
     let resultData = try container.decode([String: Filmk].self, forKey: .results)
     results = Array(resultData.values)
     }
     */
}

