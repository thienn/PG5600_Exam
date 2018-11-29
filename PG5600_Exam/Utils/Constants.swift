//
//  Constants.swift
//  PG5600_Exam
//
//  Created by Thien Nguyen on 23/11/2018.
//  Copyright © 2018 Thien Cong Pham. All rights reserved.
//

import UIKit

// One spot for the CompletionHandlers so it can be changed easily at one place + for readability
typealias FilmResponseCompletion = (FilmsList?) -> Void
typealias CharacterResponseCompletion = (People?) -> Void

// Would add other global variables here like URLs etc, decided for the URLs it was easier to read when it was directly in the local code instead of split up
