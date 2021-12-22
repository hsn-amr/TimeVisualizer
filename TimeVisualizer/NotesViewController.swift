//
//  NotesViewController.swift
//  Time Visualizer
//
//  Created by administrator on 19/12/2021.
//

import UIKit
import CoreData

class NotesViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var daysPicker: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    
    var days :[String] = [String]()
    var selectedDay = ""
    var hours: [String] = [String]()
    var notes = [Notes]()
    var keyWords = [KeyWords]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        daysPicker.dataSource = self
        daysPicker.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        getAllDays()
        selectedDay = days[0]
        getAllHours()
        fetchAllNotes()
        // Do any additio
    }
    
    func getAllDays(){
        for day in Days.allCases {
            days.append(day.rawValue)
        }
    }
    
    func getAllHours(){
        for hour in 0..<24{
            hours.append("\(hour):00")
            hours.append("\(hour):30")
        }
    }
    
    func fetchAllNotes(){
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        do {
            let result = try context.fetch(request)
            notes = result as! [Notes]
            print("Fetched - \(notes.count)")
        } catch {
            print("Fetching Notes Error: \(error.localizedDescription)")
        }
    }
    
    func zeroCountersOfKeyWords(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "KeyWords")
        do {
            let result = try context.fetch(request)
            let keyWords = result as! [KeyWords]
            for word in keyWords{
                word.counter = 0
            }
        } catch {
            print("Fetching Notes Error: \(error.localizedDescription)")
        }
    }
    
    @IBAction func newWeekButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Start New Week", message: "Are You Sure You Want To Start New Week?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: {
            action in
            self.deleteAllNotesInWeek()
        })
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteAllNotesInWeek(){
        for note in notes {
            context.delete(note)
        }
        zeroCountersOfKeyWords()
        if saveChanges(){
            notes.removeAll()
            tableView.reloadData()
        }
    }
    
    func saveChanges() -> Bool{
        var done = false
        if context.hasChanges {
            do {
                try context.save()
                print("Saved")
                done = true
            } catch {
                print("Saving New Note error: \(error.localizedDescription)")
            }
        }
        return done
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

extension NotesViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return days.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return days[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDay = days[row]
        self.tableView.reloadData()
    }
}

extension NotesViewController: DaysDelegates, NotesDelegates ,KeyWordsDelegates{
    
    func getCurrentDay() -> String {
        return selectedDay
    }
    
    func saveNewNote(text: String, time: String, day: String) {
        
        if !notes.isEmpty{
            for i in 0..<notes.count{
                if notes[i].time == time && notes[i].day == day{
                    notes[i].text = text
                    print("update")
                    break
                }else if i == notes.count-1 {
                    let newNote = Notes(context: context)
                    newNote.text = text
                    newNote.time = time
                    newNote.day = day
                    notes.append(newNote)
                    print("append")
                }
            }
        }else{
            let newNote = Notes(context: context)
            newNote.text = text
            newNote.time = time
            newNote.day = day
            notes.append(newNote)
            print("append")
        }
        saveChanges()
    }
    
    func getAllNotes() -> [Notes] {
        return notes
    }
    
    func getAllKeyWords() -> [KeyWords] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "KeyWords")
        do {
            let result = try context.fetch(request)
            keyWords = result as! [KeyWords]
            print("Fetched")
        } catch {
            print("Fetching NKeyWordsotes Error: \(error.localizedDescription)")
        }
        return keyWords
    }
    
    func updateCounter(count: Int64, at index: Int) {
        let keyword = keyWords[index]
        keyword.counter = count
        _ = saveChanges()
    }
    
    func deletKeyWord(at index: Int) {
        
    }
    
}


extension NotesViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hours.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteTableViewCell
        
        cell.timeLabel.text = hours[indexPath.row]
        print(notes.count)
        if !notes.isEmpty{
            for note in notes{
                if note.time == hours[indexPath.row] && note.day == selectedDay{
                    cell.noteTextField.text = note.text
                    break
                }else{
                    cell.noteTextField.text = ""
                }
            }
        }else{
            cell.noteTextField.text = ""
        }
        
        cell.addNoteButton.isHidden = true
        cell.daysDelegate = self
        cell.notesDelegates = self
        
        return cell
    }
    
    
}


