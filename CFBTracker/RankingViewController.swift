//
//  RankingViewController.swift
//  CFBTracker
//
//  Created by Terry Wang on 11/19/20.
//  terrywangce@gmail.com
//

import UIKit

class RankingViewController: SuperViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableRank: UITableView!
    
    private var cfbAPI = APIcfb()
    private var teams:[Team]?
    private var officialTeamList = [Team]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableRank.delegate = self
        tableRank.dataSource = self
        
        cfbAPI.getRankings{[weak self] (teams) in
            self?.teams = teams
            DispatchQueue.main.async {
                self?.tableRank.reloadData()
            }
        }
        
        //Official team list created to get images
        if let teamList = cfbAPI.getTeamList(fileName: "officialTeams"){
            officialTeamList = cfbAPI.convertJSONtoTeamList(jsonData: teamList)
            
        }
        // Table settings change
        tableRank.rowHeight = UITableView.automaticDimension
        tableRank.estimatedRowHeight = 100
        self.tableRank.layer.cornerRadius = 15.0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = teams?.count{
            return count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var url: URL!
        let cell = tableView.dequeueReusableCell(withIdentifier: "RankingTableViewCell", for: indexPath) as! RankingTableViewCell
        // Configure the cell...
        if let teamRanking = teams{
            cell.teamLabel.text = teamRanking[indexPath.row].school
            if let rank = teamRanking[indexPath.row].rank{
                cell.rankLabel.text = String(rank)
            }
            cell.teamImageView.image = UIImage(named: "emperorpenguin")
            
            if let urlString = searchOfficialTeamsList(teamName: teamRanking[indexPath.row].school)?.getFirstLogoLink(){
                if let newURL = URL(string: urlString){
                    url = newURL
                }
            }

            // Classic if url is nil then dont
            if url != nil{
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url){
                        DispatchQueue.main.async {
                            cell.teamImageView.image = UIImage(data: data)
                            self.tableRank.layoutIfNeeded()
                        }
                    }
                }
            }
        }
        return cell
        }

    
    /// Searchs through the officalList for a team given a team name
    ///
    /// - Parameter teamName: name of the team
    /// - Returns: A team if there is a match
    func searchOfficialTeamsList(teamName: String) -> Team?{
        //O(n)
        for team in officialTeamList{
            if team.school.lowercased() == (teamName.lowercased()){
                return team
            }
        }
        return nil
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
