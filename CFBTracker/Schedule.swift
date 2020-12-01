//
//  Schedule.swift
//  CFBTracker
//
//  For collecting JSON data from Schedule
//
//  Created by Terry Wang on 11/19/20.
//  terrywangce@gmail.com
//

import Foundation

struct Schedule : Codable{
    var season: Int
    var week: Int
    var start_date: String
    var home_team: String
    var away_team: String
    var home_points: Int?
    var away_points: Int?
    var date: Date?
}


