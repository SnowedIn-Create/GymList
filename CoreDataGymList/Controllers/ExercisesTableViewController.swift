//
//  ExercisesTableViewController.swift
//  CoreDataGymList
//
//  Created by Onur Com on 13.02.2020.
//  Copyright © 2020 Onur Com. All rights reserved.
//

import UIKit
import CoreData

class ExercisesTableViewController: UITableViewController {
    
    var exerciseArray = [Exercise] ()
    
    var selectedWorkout : Workout? {
        didSet {
            loadExercises()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Exercises.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up editing and updating
        //self.tableView.isEditing = true
        
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath)
        
        let exercise = exerciseArray[indexPath.row]
        
        // set up for sets and reps here
        cell.textLabel?.text = exercise.name
        cell.detailTextLabel?.text = String(exercise.sets) + " Sets " + String(exercise.reps) + " Reps"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseArray.count
    }
    
//        override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//            return .none
//        }
//
//        override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
//            return false
//        }
//
        override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            let movedObject = self.exerciseArray[sourceIndexPath.row]
            exerciseArray.remove(at: sourceIndexPath.row)
            exerciseArray.insert(movedObject, at: destinationIndexPath.row)

            exerciseArray[sourceIndexPath.row] = exerciseArray[destinationIndexPath.row]
            self.saveExercises()
//            self.tableView.isEditing = false
        }
    
    //MARK: - TableView Delegate Methods
    // Set up editing with UIAlert when tapped
    //Set up deleting and reordering
    // Connect changes to DataModel
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //functionality test
        //        let alert = UIAlertController(title: "Selected row", message: "", preferredStyle: .alert)
        //        let action = UIAlertAction(title: "OK", style: .default) { (action) in
        //            return
        //        }
        //        alert.addAction(action)
        //        present(alert, animated: true, completion: nil)
        
        var textField = UITextField()
        var textField2 = UITextField()
        var textField3 = UITextField()
        
        let alert = UIAlertController(title: "Edit Exercise", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Edit Exercise", style: .default) { (action) in
            //What's gonna happen when the user clicks the action
            
            //let newExercise = Exercise(context: self.context)
            self.exerciseArray[indexPath.row].name = textField.text!
            self.exerciseArray[indexPath.row].sets = Int16(textField2.text!) ?? 0
            self.exerciseArray[indexPath.row].reps = Int16(textField3.text!) ?? 0
            //Assigning the exercise to the workout selected
            //newExercise.parentCategory = self.selectedWorkout
            
            //self.exerciseArray.append(newExercise)
            
            self.saveExercises()
 
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Edit exercise"
            textField = alertTextField
            
        }
        
        alert.addTextField { (alertTextField2) in
            alertTextField2.placeholder = "Edit sets"
            textField2 = alertTextField2
            
        }
        
        alert.addTextField { (alertTextField3) in
            alertTextField3.placeholder = "Edit reps"
            textField3 = alertTextField3
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the data source
            
            context.delete(exerciseArray[indexPath.row])
            
            do {
                try context.save()
            } catch {
                print("Error While Deleting Note: \(error)")
            }
            
            self.loadExercises()
            
        } else {
            return
        }
        
        
    }
    
    
    
    //MARK: - Actions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // add extra lines for reps and sets
        
        var textField = UITextField()
        var textField2 = UITextField()
        var textField3 = UITextField()
        
        let alert = UIAlertController(title: "Add New Exercise", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Exercise", style: .default) { (action) in
            //What's gonna happen when the user clicks add item
            
            let newExercise = Exercise(context: self.context)
            newExercise.name = textField.text!
            newExercise.sets = Int16(textField2.text!) ?? 0
            newExercise.reps = Int16(textField3.text!) ?? 0
            //Assigning the exercise to the workout selected
            newExercise.parentCategory = self.selectedWorkout
            
            self.exerciseArray.append(newExercise)
            
            self.saveExercises()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new exercise"
            textField = alertTextField
            
        }
        
        alert.addTextField { (alertTextField2) in
            alertTextField2.placeholder = "Add sets"
            textField2 = alertTextField2
            
        }
        
        alert.addTextField { (alertTextField3) in
            alertTextField3.placeholder = "Add reps"
            textField3 = alertTextField3
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        tableView.isEditing = !tableView.isEditing
    }
    //MARK: - Core Data Methods
    
    func saveExercises() {
        
        //Encoder for creatig a plist to save to to local documents
        
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        
        self.tableView.reloadData()
    }
    
    func loadExercises(with request: NSFetchRequest<Exercise> = Exercise.fetchRequest(), predicate: NSPredicate? = nil ) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedWorkout!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            exerciseArray = try context.fetch(request)
        } catch {
            print("Error fething data from conetext \(error)")
        }
        
        tableView.reloadData()
        
    }
}
