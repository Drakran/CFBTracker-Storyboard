//
//  Team.swift
//  CFBTracker
//
//  Created by Terry Wang on 11/18/20.
//  terrywangce@gmail.com
//

import Foundation

class Team: Equatable, Codable{
    static func == (lhs: Team, rhs: Team) -> Bool {
        return lhs.school == rhs.school
    }
    
    //Instance Variables - Defaults to internal
    var school: String = "USC" // Default
    var abbreviation: String?
    var conference: String?
    var mascot: String?
    var rank: Int?
    var schedule: Array<Schedule>?
    var logos: [String]?
    // Lol no CoreData
    
    init(school: String){
        self.school = school
    }
    
    init(school: String, logos: [String]){
        self.school = school
        self.logos = logos
    }
    
    
    //For ranking
    init(school: String, rank: Int){
        self.school = school
        self.rank = rank
    }
    
    init(school: String, abbreviation:String, conference: String){
        self.school = school
        self.abbreviation = abbreviation
        self.conference = conference
    }
    
    func getFirstLogoLink() -> String{
        if let logo = logos?[0]{
            let replaced = logo.replacingOccurrences(of: "http", with: "https")
            return replaced
        }
        return ""
    }
}

