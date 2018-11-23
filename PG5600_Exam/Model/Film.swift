//
//  Film.swift
//  PG5600_Exam
//
//  Created by Thien Nguyen on 23/11/2018.
//  Copyright © 2018 Thien Cong Pham. All rights reserved.
//

import Foundation

/*
struct Film : Codable {
    let title: String
    let episode: Int
    let crawl: String
    let director: String
    let producer: String
    let releaseDate: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case episode = "episode_id"
        case crawl = "opening_crawl"
        case director
        case producer
        case releaseDate = "release_date"
    }
 */
struct Film: Decodable {
    let title : String
    let episode_id: Int
}
