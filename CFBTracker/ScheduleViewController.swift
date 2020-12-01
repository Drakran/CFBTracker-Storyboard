//
//  ScheduleViewController.swift
//  CFBTracker
//
//  Created by Terry Wang on 11/19/20.
//  terrywangce@gmail.com
//

import UIKit
import EventKit



class ScheduleViewController: SuperViewController, UITableViewDelegate, UITableViewDataSource, CellDelegate {

    

    @IBOutlet weak var scheduleTable: UITableView!
    
    // Instance Variables
    private var cfbAPI = APIcfb()
    var schedule: [Schedule]?
    let userModel = UserTeamModel.shared
    let eventStore : EKEventStore = EKEventStore()
    var officialTeamList = [Team]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scheduleTable.delegate = self
        scheduleTable.dataSource = self
        scheduleTable.reloadData()
        if let teamList = cfbAPI.getTeamList(fileName: "officialTeams"){
            officialTeamList = cfbAPI.convertJSONtoTeamList(jsonData: teamList)
        }
        //Table UI setup
        scheduleTable.rowHeight = UITableView.automaticDimension
        scheduleTable.estimatedRowHeight = 100
        self.scheduleTable.layer.cornerRadius = 15.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scheduleTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userModel.numberOfSchedules()
    }
    
    /// This tableView gets two URLs for the images + formats the date into a cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var urlOne: URL!
        var urlTwo: URL!
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath) as! ScheduleTableViewCell
        cell.cellDelegate = self
        //If there is something in the schedule array
        if(userModel.numberOfSchedules() > 0){
            // Creating the date formatter
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let calendar = Calendar.current
            let sched = userModel.getSchedules()
            cell.firstTeamLabel.text = sched[indexPath.row].home_team
            cell.secondTeamLabel.text = sched[indexPath.row].away_team
            //Just parsing the date for the cell
            if let dateString = sched[indexPath.row].date{
                 let newDate = dateFormatter.string(from: dateString)
                 let hour = calendar.component(.hour, from: dateString)
                 let minute = calendar.component(.minute, from: dateString)
                 cell.dateLabel.text = newDate + "\n" + String(hour) + ":" +  String(format: "%02d", minute)
            }
            else{
                cell.dateLabel.text = "TBD"
            }
            
            //Default sets the images
            cell.firstTeamImageView.image = UIImage(named: "cfb")
            cell.secondTeamImageView.image = UIImage(named: "cfb")
            
            // Async get the teams from URL
            if let urlStringOne = searchOfficialTeamsList(teamName: sched[indexPath.row].home_team)?.getFirstLogoLink(){
                if let newURL = URL(string: urlStringOne){
                    urlOne = newURL
                }
            }
            if let urlStringTwo = searchOfficialTeamsList(teamName: sched[indexPath.row].away_team)?.getFirstLogoLink(){
                if let newURL = URL(string: urlStringTwo){
                    urlTwo = newURL
                }
            }
            if urlOne != nil && urlTwo != nil{
                    DispatchQueue.global().async {
                        if let data = try? Data(contentsOf: urlOne), let dataTwo = try? Data(contentsOf: urlTwo){
                            DispatchQueue.main.async {
                                cell.firstTeamImageView.image = UIImage(data: data)
                                cell.secondTeamImageView.image = UIImage(data: dataTwo)
                                self.scheduleTable.layoutIfNeeded()
                            }
                        }
                    }
            }
        }
        else{
            cell.textLabel?.text = "Nothing's here"
        }
        return cell
    }
    
    /// Implementation of delegate function that checks if cell is pressed
    ///
    /// - Parameter cell: Is a cell from the table given to delegation
    func didPressButton(cell: ScheduleTableViewCell) {
        
        // Alerts here for feedback to user
        let alertController = UIAlertController(title: "Event Added",
        message: "Game Set",
        preferredStyle: .alert)
        
        let badAlertController = UIAlertController(title: "Can't add events",
                                                   message: "Change settings to add",
                                                   preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            print("Hello")
        } )
        
        // If a path is avaliable add an event
        if let indexPath = scheduleTable.indexPath(for: cell){
            eventStore.requestAccess(to: .event) { (granted, error) in
              if (granted) && (error == nil) {
                  print("granted \(granted)")
                  print("error \(String(describing: error))")
                  
                let event:EKEvent = EKEvent(eventStore: self.eventStore)
                let sched = self.userModel.getSchedules()
                
                  
                DispatchQueue.main.async {
                    let firstTeam = cell.firstTeamLabel.text ?? "Team1"
                    let secondTeam = cell.secondTeamLabel.text ?? "Team2"
                    event.title = firstTeam + " vs." + secondTeam
                }
                event.startDate = sched[indexPath.row].date
                event.endDate = sched[indexPath.row].date?.addingTimeInterval(180 * 60)
                  event.notes = "Cool Game bruh"
                  event.calendar = self.eventStore.defaultCalendarForNewEvents
                  do {
                    try self.eventStore.save(event, span: .thisEvent)
                  } catch let error as NSError {
                      print("failed to save event with error : \(error)")
                  }
                  print("Saved Event")
                DispatchQueue.main.async {
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
              }
              else{
                print("failed to save event with error : \(String(describing: error)) or access not granted")
                DispatchQueue.main.async {
                    badAlertController.addAction(okAction)
                    self.present(badAlertController, animated: true, completion: nil)
                }
              }
            }
        }


        

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
