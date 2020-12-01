//
//  SuperViewController.swift
//  CFBTracker
//
//  Super class for view controller designed to
//  create the navBar items and background
//
//  Created by Terry Wang on 11/20/20.
//  terrywangce@gmail.com
//

import UIKit

class SuperViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Navcontroller UI setup
        let navColor = UIColor(red: 4.0/255, green: 146.0/255, blue: 1.0/255, alpha: 1)
        let offWhite = UIColor(red: 242.0/255, green: 243.0/255, blue: 244.0/255, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = navColor
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // Setting the images and title of Navbar
        var logo = UIImage(named: "cfb")
        logo = logo?.resize(targetSize: CGSize(width: 35, height: 35))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        imageView.image = logo
        let item = UIBarButtonItem(customView: imageView)
        self.navigationItem.rightBarButtonItem = item
        self.navigationItem.title = "CFBTracker"
        self.view.backgroundColor = offWhite
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
