//
//  EntryController.swift
//  Journal_v5
//
//  Created by Taylor Bills on 1/25/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import Foundation

class EntryController {
    
    // MARK:    Properties
    
    static var shared = EntryController()
    var entries: [Entry] = []
    
    // MARK:    Initializer
    init() {
        self.entries = loadFromPersistentStorage()
    }
    
    // MARK:    Create
    
    // Add Entry
    func addEntryWith(title: String, body: String) {
        let entry = Entry(title: title, body: body)
        entries.append(entry)
        saveToPersistence()
    }
    
    // MARK:    Read
    
    // Find Save Location
    func fileURL() -> URL {
        // find your array of paths
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        // assign our documents to a spot in the path
        let documentDirectory = paths[0]
        // name the file
        let fileName = "entries.json"
        // make the url by finding our assigned spot and appending our filename to it
        let url = documentDirectory.appendingPathComponent(fileName)
        // return our newly created url
        return url
    }
    
    // Save Files
    func saveToPersistence() {
        // Get your jsonEncoder
        let jsonEncoder = JSONEncoder()
        do {
            // try to encode our stuff into data
            let data = try jsonEncoder.encode(entries)
            // try to write to our location
            try data.write(to: fileURL())
            // catch the error if it cannot save
        } catch let error {
            print("Error saving to disk: \(error)")
        }
    }
    
    // Load Files
    func loadFromPersistentStorage() -> [Entry] {
        // get your jsonDecoder
        let jsonDecoder = JSONDecoder()
        do {
            // try to create a data property to find our save location
            let data = try Data(contentsOf: fileURL())
            // try to decode our data
            let entries = try jsonDecoder.decode([Entry].self, from: data)
            // return our type
            return entries
        } catch let error {
            // if error thrown, return an empty array
            print("Error loading from disk \(error)")
            return []
        }
    }
    
    // MARK:    Update
    
    // Update existing entry
    func updateExistingEntry(entry: Entry, newTitle: String, newBody: String) {
        entry.title = newTitle
        entry.body = newBody
        saveToPersistence()
    }
    
    // MARK:    Delete
    
    // Delete existing entry
    func deleteEntry(entry: Entry) {
        guard let index = entries.index(of: entry) else { return }
        entries.remove(at: index)
        saveToPersistence()
    }
}
