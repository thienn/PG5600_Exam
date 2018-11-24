//
//  Film.swift
//  PG5600_Exam
//
//  Created by Thien Nguyen on 23/11/2018.
//  Copyright © 2018 Thien Cong Pham. All rights reserved.
//

import Foundation

struct Film: Codable {
    let title: String
    let episodeid: Int
    let director: String
    let producer: String
    let releaseDate: String
    let crawl: String
    
    
    enum CodingKeys: String, CodingKey {
        case title
        case episodeid = "episode_id"
        case director
        case producer
        case releaseDate = "release_date"
        case crawl = "opening_crawl"
    }
    
}
