//
//  TableViewController.swift
//  CoreDataGymList
//
//  Created by Onur Com on 13.02.2020.
//  Copyright © 2020 Onur Com. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class TableViewController: UITableViewController {
    
    var workouts = [Workout]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Workouts.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var taskSound: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
        
        loadWorkouts()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return workouts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutsCell", for: indexPath)
        
        let workout = workouts[indexPath.row]
        // Configure the cell...
        cell.textLabel?.text = workout.name
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let path = Bundle.main.path(forResource: "completechime", ofType: ".mp3")!
        let url = URL(fileURLWithPath: path)

        //Sound Player
//        do {
//            taskSound = try AVAudioPlayer(contentsOf: url)
//            taskSound?.play()
//        } catch {
//            // couldn't load file :(
//        }
        
        performSegue(withIdentifier: "ExercisesSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ExercisesTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedWorkout = workouts[indexPath.row]
        }
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            context.delete(workouts[indexPath.row])
            
            do {
                try context.save()
            } catch {
                print("Error While Deleting Note: \(error)")
            }
            
            self.loadWorkouts()
            
        } else {
            return
        }
        
        
    }
    
    
    
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
         let movedObject = workouts[fromIndexPath.row]
         workouts.remove(at: fromIndexPath.row)
         workouts.insert(movedObject, at: to.row)
        
     }
     
    
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Workout", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Workout", style: .default) { (action) in
            //What's gonna happen when the user clicks add item
            
            let newWorkout = Workout(context: self.context)
            newWorkout.name = textField.text!
            
            self.workouts.append(newWorkout)
            
            self.saveWorkouts()
            
        }
        
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func saveWorkouts() {
        
        //Encoder for creatig a plist to save to local documents
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        
        tableView.reloadData()
    }
    
    func loadWorkouts(with request: NSFetchRequest<Workout> = Workout.fetchRequest()) {
        
        do {
            workouts = try context.fetch(request)
        } catch {
            print("Error fething data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    
}

extension TableViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
    
    
}

extension TableViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
        let destinationIndexPath: IndexPath
         
         
         if let indexPath = coordinator.destinationIndexPath {
             destinationIndexPath = indexPath
//             for workout in workouts {
//                 workout.position = String(destinationIndexPath.row)
//
//
//
//             }
             
         } else {
             // Get last index path of table view.
             let section = tableView.numberOfSections - 1
             let row = tableView.numberOfRows(inSection: section)
             destinationIndexPath = IndexPath(row: row, section: section)
             
             
         }
        
         
         }
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {

        if session.localDragSession != nil { // Drag originated from the same app.
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            
        }

        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    
    
}
