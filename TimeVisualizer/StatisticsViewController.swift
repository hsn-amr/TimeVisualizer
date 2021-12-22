
//
//  StatisticsViewController.swift
//  Time Visualizer
//
//  Created by administrator on 19/12/2021.
//

import UIKit
import Charts
import CoreData

class StatisticsViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var pieView: PieChartView!
    @IBOutlet weak var barView: BarChartView!
    @IBOutlet weak var lineView: LineChartView!
    
    var keyWords = [KeyWords]()
    var notes = [Notes]()
    override func viewDidLoad() {
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchAllKeyWords()
        fetchAllNotes()
        makeStatistics()
        
        setUpPieChart()
        setUpBarChart()
        setUpLineChart()
    }
    
    
    func fetchAllKeyWords(){
        let requast = NSFetchRequest<NSFetchRequestResult>(entityName: "KeyWords")
        
        do{
            let result = try context.fetch(requast)
            keyWords = result as! [KeyWords]
            print("Fetched")
        } catch {
            print("Error Of Fetching KeyWords: \(error.localizedDescription)")
        }
    }
    
    func fetchAllNotes(){
        let requast = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        
        do{
            let result = try context.fetch(requast)
            notes = result as! [Notes]
            print("Fetched")
        } catch {
            print("Error Of Fetching KeyWords: \(error.localizedDescription)")
        }
    }
    
    func makeStatistics(){
        if !keyWords.isEmpty && !notes.isEmpty{
            for note in notes{
                for word in keyWords{
                    if note.text!.lowercased().contains(word.word!.lowercased()){
                        word.counter += 1
                        saveChamges()
                    }
                }
            }
        }
    }
    
    func saveChamges(){
        if context.hasChanges {
            do {
                try context.save()
                print("Saved")
            } catch {
                print("Saving error : \(error.localizedDescription)")
            }
        }
    }
    
    
    func setUpPieChart() {
        
        pieView.chartDescription.enabled = false
        pieView.drawHoleEnabled = true
        pieView.rotationAngle = 0
        pieView.rotationEnabled = false
        
        // data we want to entry into pie we will use this entries
        var entries: [PieChartDataEntry] = Array()
        // entry data into pie
        for word in keyWords {
            print(Double(word.counter))
            entries.append(PieChartDataEntry(value: Double(word.counter), label: word.word))
        }
        
        let dataSet = PieChartDataSet(entries: entries, label: "")
        
        var colors = [NSUIColor]()
        for color in Colors.allCases{
            colors.append(NSUIColor(hex: color.rawValue))
        }
        dataSet.colors = colors
        dataSet.drawValuesEnabled = false
        
        pieView.data = PieChartData(dataSet: dataSet)
    }
    
    func setUpBarChart() {
        
        // data we want to entry into pie we will use this entries
        var entries: [BarChartDataEntry] = Array()
        // entry data into pie
        for i in 0..<keyWords.count {
            entries.append(BarChartDataEntry(x: Double(i), y: Double(keyWords[i].counter)))
        }
        
        let dataSet = BarChartDataSet(entries: entries, label: "KeyWords")
        
        var colors = [NSUIColor]()
        for color in Colors.allCases{
            colors.append(NSUIColor(hex: color.rawValue))
        }
        dataSet.colors = colors
        
        barView.data = BarChartData(dataSet: dataSet)
    }

    
    func setUpLineChart() {
        
        // data we want to entry into pie we will use this entries
        var entries: [ChartDataEntry] = Array()
        // entry data into pie
        for i in 0..<keyWords.count {
            entries.append(ChartDataEntry(x: Double(i), y: Double(keyWords[i].counter)))
        }
        
        let dataSet = LineChartDataSet(entries: entries, label: "KeyWords")
        
        var colors = [NSUIColor]()
        for color in Colors.allCases{
            colors.append(NSUIColor(hex: color.rawValue))
        }
        dataSet.colors = colors
        
        lineView.data = LineChartData(dataSet: dataSet)
    }
}
