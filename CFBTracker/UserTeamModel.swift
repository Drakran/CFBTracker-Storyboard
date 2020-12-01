//
//  TeamModel.swift
//  CFBTracker
//
//  Class designed to keep track of the User's Teams
//  Created by Terry Wang on 11/19/20.
//  terrywangce@gmail.com
//

import Foundation

class UserTeamModel{
    
    public static let shared  = UserTeamModel()
    
    private var teams = [Team]()
    private var schedules = [Schedule]()
    private var cfbAPI = APIcfb()
    
    
    // filepath for saving to the Document directory
    private var filepath:String
    
    init(){
        /// Just loads in the file userTeams and loads in default Teams with just the School Name
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        
        filepath = url!.appendingPathComponent("userTeams.txt").path
        print("filepath=\(filepath)")
        
        // Saves the teams into a file in documents
        if manager.fileExists(atPath: filepath){
            do{
                let data = try String(contentsOfFile: filepath, encoding: .utf8)
                let myStrings = data.components(separatedBy: .newlines)
                for line in myStrings{
                    if !line.isEmpty{
                        if line.contains(","){
                            let attributes = line.split(separator: ",")
                            var stringArray = [String]()
                            stringArray.append(String(attributes[1]))
                            let newTeam = Team(school: String(attributes[0]), logos: stringArray)
                            teams.append(newTeam)
                        }
                        else{
                            teams.append(Team(school: String(line)))
                        }
                        
                    }
                }
                updateSchedule()
            }
            catch{
                print("Can't read files")
            }
        }
        //Else would be empty teams array thats cool too
    }
    
    func numberOfTeams() -> Int{
        return teams.count
    }
    
    func numberOfSchedules() -> Int{
        return schedules.count
    }
    
    func getTeams() -> Array<Team>{
        return teams
    }
    
    func getSchedules() -> Array<Schedule>{
        return schedules
    }
    
    func getTeamAt(at index: Int) -> Team{
        return teams[index]
    }
    
    func insertTeam(schoolName : String){
        teams.append(Team(school: schoolName))
        updateSchedule()
        save()
    }
    
    func insertTeam(team: Team){
        teams.append(team)
        updateSchedule()
        save()
    }
    
    func removeTeam(at index: Int){
        if index >= 0 && index < teams.count{
            teams.remove(at: index)
            updateSchedule()
            save()
        }
    }
    
    func searchTeam(teamName: String) -> Team?{
        //O(n)
        for team in teams{
            if team.school.contains(teamName.lowercased()){
                return team
            }
       
        }
        return nil
    }
    
    /// Update Schedule is a method that is called to update the shcedule array whenever a new team is added
    ///
    func updateSchedule(){
        let myGroup = DispatchGroup()
        schedules.removeAll()
        // Look at the async needed to get this work, locks and dispatch groups to
        // make sure teams is iterated appropriately
        // Also widely inefficient
        for team in teams{
            myGroup.enter()
            cfbAPI.getScheduleOfTeam(team: team.school, completetionHandler: {[weak self] (fullSchedule) in
                for var schedule in fullSchedule{
                    let dateString = schedule.start_date
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let today = Date()
                    let date = dateFormatter.date(from: dateString)
                    if let d = date{
                        if(d > today){
                            schedule.date = date
                            self?.schedules.append(schedule)
                        }
                    }
                }
                myGroup.leave()
            })
        }
        
        myGroup.notify(queue: .main){
            self.schedules = self.schedules.sorted(by: {$0.week < $1.week})
        }
       
    }
    
    /// Saves the teams of the user into a file
    func save(){
        var teamString = String()
        
        for item in teams{
            if let logo = item.logos?[0]{
                teamString.append(item.school + "," + logo + "\n")
            }
            else{
                teamString.append(item.school + "\n")
            }
        }
        do{
            try teamString.write(toFile: filepath, atomically: true, encoding: .utf8)
            
            
        }
        catch{
            print("Couldn't save to file Ripperino in Pepperinos")
        }
    }
}
