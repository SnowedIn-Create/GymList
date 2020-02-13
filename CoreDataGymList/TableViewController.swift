//
//  TableViewController.swift
//  CoreDataGymList
//
//  Created by Onur Com on 13.02.2020.
//  Copyright © 2020 Onur Com. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var workouts = [Workout]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Workouts.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
        performSegue(withIdentifier: "ExercisesSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ExercisesTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedWorkout = workouts[indexPath.row]
        }
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
