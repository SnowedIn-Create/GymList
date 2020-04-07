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
        print(exerciseArray)
        loadExercises()
        //Set up editing and updating
        //self.tableView.isEditing = true
        
        //long press
        
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
        tableView.rowHeight = 60.0
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saveExercises()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath)
        
        let exercise = exerciseArray[indexPath.row]
        
        // Setting the exercise objects position to equal the row position it was created in in coredata
        exercise.position = String(indexPath.row)
        print(exercise.position)
        
        cell.textLabel?.text = exercise.name
        cell.detailTextLabel?.text = String(exercise.sets) + " Sets " + String(exercise.reps) + " Reps"
        cell.backgroundColor = UIColor.systemOrange
        cell.layer.cornerRadius = 10
        //cell.layer.masksToBounds = true
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.textColor = UIColor.white
        //cell.layer.borderColor = CGColor
        cell.layer.borderWidth = 5
        
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
        let movedObject = exerciseArray[sourceIndexPath.row]
        exerciseArray.remove(at: sourceIndexPath.row)
        exerciseArray.insert(movedObject, at: destinationIndexPath.row)
        saveExercises()
        
    }
    
    //MARK: - TableView Delegate Methods
    // Set up editing with UIAlert when tapped
    //Set up deleting and reordering
    // Connect changes to DataModel
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print(exerciseArray[indexPath.row].position)
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
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            return
        }
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
        alert.addAction(cancel)
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
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let closeAction = UIContextualAction(style: .normal, title:  "Complete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("OK, marked as Closed")
            success(true)
        })
        //TODO: - Change cell backgdorund to blue
        closeAction.image = UIImage(named: "tick")
        closeAction.backgroundColor = .purple
        tableView.backgroundColor = UIColor.systemBlue
        
        return UISwipeActionsConfiguration(actions: [closeAction])
        
    }
    
    
    //MARK: - Actions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // add extra lines for reps and sets
        
        var textField = UITextField()
        var textField2 = UITextField()
        var textField3 = UITextField()
        
        let alert = UIAlertController(title: "Add New Exercise", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            return
        }
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
        alert.addAction(cancel)
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
        
        //sorting by cell position
        let sort = NSSortDescriptor(key: "position", ascending: true)
        request.sortDescriptors = [sort]
        
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

extension ExercisesTableViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}

extension ExercisesTableViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        
        if session.localDragSession != nil { // Drag originated from the same app.
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            
        }
        
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
        let destinationIndexPath: IndexPath
        
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
            for exercise in exerciseArray {
                exercise.position = String(destinationIndexPath.row)
                print("name: \(exercise.name) position: \(exercise.position)")
                
                
                
            }
            
        } else {
            // Get last index path of table view.
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
            
            
        }
        
        saveExercises()
        tableView.reloadData()
    }
    
    
}
