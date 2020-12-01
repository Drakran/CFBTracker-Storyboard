//
//  Ranking.swift
//  CFBTracker
//  For the JSON data parsing
//  Created by Terry Wang on 11/19/20.
//  terrywangce@gmail.com
//

import Foundation

struct rank: Codable{
    var rank: Int
    var school: String
    var conference: String
    var points: Int
}

struct onePoll: Codable{
    var poll: String
    var ranks = [rank]()
}

struct Ranking: Codable{
    var season: Int
    var seasonType: String
    var week: Int
    var polls = [onePoll]()
}
