//
//  SearchViewController.swift
//  CFBTracker
//
//  Created by Terry Wang on 11/20/20.
//  terrywangce@gmail.com
//

import UIKit

class SearchViewController: SuperViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var teamTable: UITableView!
    
    private var cfbAPI = APIcfb()
    let userModel = UserTeamModel.shared
    var officialTeamList = [Team]()
    var filteredTeams = [Team]()
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamTable.delegate = self
        teamTable.dataSource = self
        // Sets up the seaerch controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Teams"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        if let teamList = cfbAPI.getTeamList(fileName: "officialTeams"){
            officialTeamList = cfbAPI.convertJSONtoTeamList(jsonData: teamList)
        }
        self.view.backgroundColor = UIColor.red
        
        teamTable.rowHeight = UITableView.automaticDimension
        teamTable.estimatedRowHeight = 100

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering{
            return filteredTeams.count
        }
        return officialTeamList.count
    }
    
    // This tableview is creating cells for A, if its not searching, or B if it is searching
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTeamCell", for: indexPath)
        cell.imageView?.image = UIImage(named: "cfb")
        let team: Team
        var url: URL!
        
        // Check if filtering or not and get the team from the right array
        if isFiltering{
            team = filteredTeams[indexPath.row]
            let urlString = filteredTeams[indexPath.row].getFirstLogoLink()
            if let newURL = URL(string: urlString){
                url = newURL
            }
        }
        else{
            team = officialTeamList[indexPath.row]
            let urlString = officialTeamList[indexPath.row].getFirstLogoLink()
            if let newURL = URL(string: urlString){
                url = newURL
            }
        }
        
        if url != nil{
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url){
                    DispatchQueue.main.async {
                        cell.imageView?.image = UIImage(data: data)
                        self.teamTable.layoutIfNeeded()
                    }
                }
            }
        }


        cell.textLabel?.text = team.school
        
        return cell
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // Filters the table for earch
    func filterContentForSearchText(_ searchText: String) {
      filteredTeams = officialTeamList.filter { (team: Team) -> Bool in
        return team.school.lowercased().contains(searchText.lowercased())
      }
      
      teamTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if isFiltering{
            userModel.insertTeam(team: filteredTeams[indexPath.row])
        }
        else{
            userModel.insertTeam(team: officialTeamList[indexPath.row])
        }
        self.view?.window?.rootViewController?.dismiss(animated: true, completion: nil)
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

/// Extension updates the searchresults based on team
extension SearchViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)
  }
}
