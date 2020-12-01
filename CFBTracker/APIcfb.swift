//
//  APIcfb.swift
//  CFBTracker
//
//  Created by Terry Wang on 11/18/20.
//  terrywangce@gmail.com
//

import Foundation

class APIcfb{
    
    private var domainURL = "https://api.collegefootballdata.com"
    var year = "2020"

    /// Returns an array of teams with only the school name and ranking asynchronously
    ///
    /// - Parameter completetionHandler: Completetion Handler for async
    /// - Returns: Async array of teams
    func getRankings(completetionHandler: @escaping ([Team]) -> Void) {
        let url = URL(string: domainURL + "/rankings?year=\(year)&week=12&seasonType=regular")! //force
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data,response,error) in
            
            if let error = error{
                print(" Error with getting rankings: \(error)" )
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode)
            else{
                print("Error with code: \(String(describing: response))")
                return
            }
            
            if let data = data,
               let rankSummary = try? JSONDecoder().decode([Ranking].self, from: data){
                let teamArray = self.convertJSONtoTeamRanking(ranks: rankSummary)
                completetionHandler(teamArray)
                }
            })
        task.resume()
    }
    
    /// Returns the schedule of a team
    ///
    /// - Parameter team: Team is a string with the Team Name of the Schedule we want
    /// - Returns: An Array of Schedules that each contain the schedule for that week
    func getScheduleOfTeam(team: String, completetionHandler: @escaping ([Schedule]) -> Void){
        var urlString = domainURL + "/games?year=\(year)&seasonType=regular&team=\(team)"
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data,response,error) in
            
            if let error = error{
                print(" Error with getting schedule: \(error)" )
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode)
            else{
                print("Error with code: \(String(describing: response))")
                return
            }
            
            if let data = data,
               let scheduleSummary = try? JSONDecoder().decode([Schedule].self, from: data){
                    completetionHandler(scheduleSummary)
                }
            })
        
        task.resume()
    }
    
    /// Gets the teamList froma  file and returns the Data
    ///
    /// - Parameters fileName: the Filename
    /// - Returns: A data type of the JSON file
    func getTeamList(fileName: String) -> Data?{
        do{
            if let path = Bundle.main.path(forResource: fileName, ofType: "json"){
                if let json = try String(contentsOfFile: path).data(using: .utf8){
                    return json
                }
            }
            else{
                print("No path found")
            }
        }
        catch{
            print("Error info: \(error)")
        }
        return nil
    }
    
    /// Function converts the JSON of the team ranking to an array of teams
    ///
    /// - Parameter ranks: An array of rankings
    /// - Returns: An array of Teams
    func convertJSONtoTeamRanking(ranks: Array<Ranking>? ) -> Array<Team>{
        var teamRanking = [Team]()
        if let ranking = ranks{
            let apPoll = ranking[0].polls[1].ranks
            for rank in apPoll{
                teamRanking.append(Team(school: rank.school, rank: rank.rank))
            }
        }
        return teamRanking
    }
    
    /// Function to convert the JSON format of the teamList
    ///
    /// - Parameter jsonData: the json Data of the team list
    /// - Returns: An array of teams build from the decoded JSON file
    func convertJSONtoTeamList(jsonData: Data) -> Array<Team>{
        do{
            let data = try JSONDecoder().decode([Team].self, from: jsonData)
            return data
        }
        catch{
            print("error: + \(error)")
        }

        print("Error in converting JSON to TeamList")
        return [Team]() //Empty Team List
    }
}
