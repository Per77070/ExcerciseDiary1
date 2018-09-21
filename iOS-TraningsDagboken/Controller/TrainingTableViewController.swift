//
//  TrainingTableViewController.swift
//  iOS-TraningsDagboken
//
//  Created by Eddy Garcia on 2018-09-17.
//  Copyright © 2018 Eddy Garcia. All rights reserved.
//

import UIKit
import Firebase
class TrainingTableViewController: UITableViewController {
    //Array of gym names
    var gymNames = ["Sats", "Friskis & Svettis", "Actic", "Always Fitness 24","Fitness24Seven","Itrim","Puls & träning", "Nordic Wellness", "Nautilus", "WorldClass", "Medley", "Delta Gym", "Klättercentret", "Balance Training"]
    //Array of gym image names
    var gymImages = ["Sats", "Friskis&Svettis", "Actic", "AlwaysFitness24","Fitness24Seven","Itrim","Puls&Traning", "NordicWellness", "Nautilus", "WorldClass", "Medley", "DeltaGym", "Klattercentret", "BalanceTraining"]
    
    var gymLocations = ["Kocksgatan 12", "Götgatan 78","Årstavägen 53","Elsa Brändströms gata 201","Blekingegatan 63","Magnus Ladulåsgatan 48","Timmermansgatan 34B-C", "Hornsgatan 67", "Skeppsmäklargatan 1" ,"Hornsgatan 8", "Griffelvägen 11", "Hälsingegatan 5", "Tellusgången 22-24", "Lästmakargatan 10"]
   
    var trainingType = ["Gym & Pass","Gym & Pass","Crossfit","Gym 24/7","Gym 24/7","Viktminskning","Gym","Gym & Pass","Crossfit","Gym & Pass", "Gym & Simning", "Gym & PT","Bouldergym","Gym & PT"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //set cellIdentifier to 
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TrainingTableViewCell //as! is for setting the cell to our own custom one named TrainingTableViewCell
        
        cell.nameLabel?.text = gymNames[indexPath.row]
        cell.thumbnailImageView?.image = UIImage(named: gymImages[indexPath.row])
        
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gymNames.count
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
