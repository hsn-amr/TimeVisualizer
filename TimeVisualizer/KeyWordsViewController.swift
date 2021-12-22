//
//  ViewController.swift
//  Time Visualizer
//
//  Created by administrator on 19/12/2021.
//

import UIKit
import CoreData

class KeyWordsViewController: UIViewController {

    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var keyWords = [KeyWords]()
    
    @IBOutlet weak var colliction: UICollectionView!
    @IBOutlet weak var KeyWordTextField: UITextField!
    
   
    let columnLayout = ColumnFlowLayout(
           cellsPerRow: 2,
           minimumInteritemSpacing: 10,
           minimumLineSpacing: 10,
           sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
       )

       override func viewDidLoad() {
           super.viewDidLoad()
           
           colliction.dataSource = self
           
           colliction?.collectionViewLayout = columnLayout
           colliction?.contentInsetAdjustmentBehavior = .always
           colliction?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "keywordCell")
           
           fetchAllKeyWords()
       }


    @IBAction func deleteAllWordsButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Delete All KeyWords?", message: nil, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: {
            action in
            self.deleteAllKeyWords()
        })
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
       
    }
    
    func deleteAllKeyWords(){
        for word in keyWords {
            managedObjectContext.delete(word)
        }
        if saveChanges() {
            keyWords.removeAll()
            colliction.reloadData()
        }
    }
    @IBAction func addButtonPressed(_ sender: UIButton) {
        if let word = KeyWordTextField.text {
            if !word.isEmpty{
                let newKeyWord = KeyWords(context: managedObjectContext)
                newKeyWord.word = word
                if saveChanges() {
                    keyWords.append(newKeyWord)
                    KeyWordTextField.text = ""
                    colliction.reloadData()
                }
            }
        }
    }
    
    func fetchAllKeyWords(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "KeyWords")
        
        do {
            let result = try managedObjectContext.fetch(request)
            keyWords = result as! [KeyWords]
            colliction.reloadData()
            print("Fetched")
        } catch {
            print("Fetching Error: \(error.localizedDescription)")
        }
    }
    
    func saveChanges() -> Bool{
        var done = false
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                print("Saved")
                done = true
            } catch {
                print("Saving Error : \(error.localizedDescription)")
            }
        }
        return done
    }
}


extension KeyWordsViewController: UICollectionViewDataSource{
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "keyWordCell", for: indexPath) as! KeyWordCollectionViewCell
         
         cell.keyWordLabel.text = keyWords[indexPath.row].word
         cell.deleteDelegate = self
         cell.index = indexPath.row
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keyWords.count
    }
    
}

extension KeyWordsViewController: KeyWordsDelegates{
    // keep it empty better than make it optianle by @objc
     
    func getAllKeyWords() -> [KeyWords] {
        return []
    }
    
    func updateCounter(count: Int64, at index: Int) {
        
    }
    
    func deletKeyWord(at index: Int) {
        managedObjectContext.delete(keyWords[index])
        if saveChanges() {
            keyWords.remove(at: index)
            colliction.reloadData()
        }
    }
    
    
}
