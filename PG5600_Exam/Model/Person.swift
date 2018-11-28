//
//  Person.swift
//  PG5600_Exam
//
//  Created by Thien Nguyen on 23/11/2018.
//  Copyright © 2018 Thien Cong Pham. All rights reserved.
//

import Foundation

/*
struct Person : Codable {
    let name: String
    let height: String
    let mass: String
    let hair: String
    let birthYear: String
    let gender: String
    let homeworldUrl: String
    let filmUrls: [String]
    let vehicleUrls: [String]
    let starshipUrls: [String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case height
        case mass
        case hair = "hair_color"
        case birthYear = "birth_year"
        case gender
        case homeworldUrl = "homeworld"
        case filmUrls = "films"
        case vehicleUrls = "vehicles"
        case starshipUrls = "starships"
    }
}
 */

struct Person : Codable {
    let name: String
    let films: [String] // String of movies
}
