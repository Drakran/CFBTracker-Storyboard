//
//  UserViewController.swift
//  CFBTracker
//
//  Created by Terry Wang on 11/19/20.
//  terrywangce@gmail.com
//

import UIKit

class UserViewController: SuperViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var userTable: UITableView!
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    private var cfbAPI = APIcfb()
    let userModel = UserTeamModel.shared
    var officialTeamList = [Team]()
    override func viewDidLoad() {
        super.viewDidLoad()

        userTable.delegate = self
        userTable.dataSource = self
        
        if let teamList = cfbAPI.getTeamList(fileName: "officialTeams"){
            officialTeamList = cfbAPI.convertJSONtoTeamList(jsonData: teamList)
        }
        //self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.userTable.layer.cornerRadius = 15.0
        self.searchButton.layer.cornerRadius = 15.0
        self.userImageView.layer.cornerRadius = 15.0
        
        let logo = UIImage(named: "emperorpenguin")
        userImageView.image = logo
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userTable?.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userModel.numberOfTeams()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTeamCell", for: indexPath)
        let image = UIImage(named: "emperorpenguin")
        cell.imageView?.image = image
        
        if let url = URL(string: userModel.getTeamAt(at: indexPath.row).getFirstLogoLink()){
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url){
                    DispatchQueue.main.async {
                        cell.imageView?.image = UIImage(data: data)
                        self.userTable.layoutIfNeeded()
                    }
                }
            }
        }
        

        

        cell.textLabel?.text = userModel.getTeamAt(at: indexPath.row).school
        return cell
    }
    
    /// Removes from table
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            userModel.removeTeam(at: indexPath.row)
            
            //Deletes from tableView
            userTable.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
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
