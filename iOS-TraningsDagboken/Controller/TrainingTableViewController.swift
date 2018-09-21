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
    //Array of gym locations
    var gymLocations = ["Kocksgatan 12", "Götgatan 78","Årstavägen 53","Elsa Brändströms gata 201","Blekingegatan 63","Magnus Ladulåsgatan 48","Timmermansgatan 34B-C", "Hornsgatan 67", "Skeppsmäklargatan 1" ,"Hornsgatan 8", "Griffelvägen 11", "Hälsingegatan 5", "Tellusgången 22-24", "Lästmakargatan 10"]
   //type of training
    var trainingType = ["Gym & Pass","Gym & Pass","Crossfit","Gym 24/7","Gym 24/7","Viktminskning","Gym","Gym & Pass","Crossfit","Gym & Pass", "Gym & Simning", "Gym & PT","Bouldergym","Gym & PT"]
    //bugfix for tableview reusing cells
    var gymsIsVisited = Array(repeating: false, count: 14)
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
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
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gymNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //set cellIdentifier to 
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TrainingTableViewCell //as! is for setting the cell to our own custom one named TrainingTableViewCell
        
        cell.nameLabel.text = gymNames[indexPath.row]
        cell.thumbnailImageView.image = UIImage(named: gymImages[indexPath.row])
        cell.descriptionLabel.text = trainingType[indexPath.row]
        cell.locationLabel.text = gymLocations[indexPath.row]
       
        cell.heartImageView.isHidden = gymsIsVisited[indexPath.row] ? false : true
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //create option menu as action sheet
        let optionMenu =  UIAlertController(title: nil, message: "What would you like to do", preferredStyle: .actionSheet)
        
        if let popoverController = optionMenu.popoverPresentationController {
            if let cell = tableView.cellForRow(at: indexPath) {
                popoverController.sourceView = cell
                popoverController.sourceRect = cell.bounds
            }
        }
        //create actions and adding them
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        
        //defining the handler and adding call action
          let callActionHandler = {(action:UIAlertAction!)-> Void in
            let alertMessage = UIAlertController(title: "Service Unavailable", message: "Sorry the call feature is not avaiable yet", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "Ok", style: .default , handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
        }
            
        let callAction = UIAlertAction(title: "Call " + "123-000-\(indexPath.row)", style: .default , handler: callActionHandler)
        optionMenu.addAction(callAction)
        
        let checkActionTitle = (gymsIsVisited[indexPath.row]) ? "Undo Check in" : "Check in"
        
            //defining the handler in a different way
        let checkInAction = UIAlertAction(title: checkActionTitle, style: .default, handler: {(action:UIAlertAction!) -> Void in
           
            let cell = tableView.cellForRow(at: indexPath) as! TrainingTableViewCell
            self.gymsIsVisited[indexPath.row] = (self.gymsIsVisited[indexPath.row]) ? false : true
            // Use the isHidden property to control the appearance of the heart icon
            cell.heartImageView.isHidden = self.gymsIsVisited[indexPath.row] ? false : true
            
        })
        optionMenu.addAction(checkInAction)
        //present menu
        present(optionMenu, animated: true, completion: nil)
        //deselect row
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    //delete
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            (action, sourceView, completionHandler) in
        // Delete the row from the data source
        self.gymNames.remove(at: indexPath.row)
        self.gymLocations.remove(at: indexPath.row)
        self.trainingType.remove(at: indexPath.row)
        self.gymsIsVisited.remove(at: indexPath.row)
        self.gymImages.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .fade)
        // Call completion handler to dismiss the action button
        completionHandler(true)
        
        }
        //share
        let shareAction = UIContextualAction(style: .normal, title: "Share") {
            (action , sourceView, completionHandler) in
            let defaultText = "Just checking in at " + self.gymNames[indexPath.row]
           
            let activityController : UIActivityViewController
            
            //Image sharing  if let to verify if imageToShare contains a value or not
            if let imageToShare =  UIImage(named: self.gymImages[indexPath.row]){
                activityController = UIActivityViewController(activityItems: [defaultText, imageToShare],applicationActivities: nil)
            } else {//no Image
                activityController = UIActivityViewController(activityItems: [defaultText],applicationActivities : nil)
            }
            
            self.present(activityController, animated: true, completion: nil)
              // Call completion handler to dismiss the action button
            completionHandler(true)
            
        }
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        
        return swipeConfiguration
        
    }
        

    
//    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//    }
    

    
/*Swipe to delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            gymNames.remove(at: indexPath.row)
            gymLocations.remove(at: indexPath.row)
            trainingType.remove(at: indexPath.row)
            gymsIsVisited.remove(at: indexPath.row)
            gymImages.remove(at: indexPath.row)
            
        }
        //deletes row with animation
        tableView.deleteRows(at: [indexPath], with: .fade)
        //tableView.reloadData() reloads the data
        //debugging to see if names where deleted
        print("Total item: \(gymNames.count)")
        for name in gymNames {
            print(name)
            
        }
           
        
        
    }*/
    
    

}

