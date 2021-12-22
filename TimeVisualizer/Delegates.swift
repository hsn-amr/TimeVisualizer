//
//  Delegates.swift
//  TimeVisualizer
//
//  Created by administrator on 21/12/2021.
//

import Foundation

protocol DaysDelegates {
    func getCurrentDay() -> String
}

protocol NotesDelegates{
    func saveNewNote(text: String, time: String, day: String)
    func getAllNotes() -> [Notes]
}


protocol KeyWordsDelegates {
    func getAllKeyWords() -> [KeyWords]
    func updateCounter(count: Int64, at index: Int)
    func deletKeyWord(at index: Int)
}
