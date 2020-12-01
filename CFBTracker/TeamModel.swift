//
//  TeamModel.swift
//  CFBTracker
//
//  Class designed to keep track of the User's Teams
//  Created by Terry Wang on 11/19/20.
//

import Foundation

class UserTeamModel: NSObject{
    public let shared  = UserTeamModel()
    
    private var teams = [Team]()
    
    func numberOfTeams(){
        
    }
}
