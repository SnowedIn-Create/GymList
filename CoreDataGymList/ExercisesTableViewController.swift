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
        // #warning Incomplete implementation, return the number of rows
        return exerciseArray.count
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
    
    
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
