//
//  Verse.swift
//  Tanah Analyzer
//
//  Created by Benjamin HALIMI on 26/03/2017.
//  Copyright © 2017 Benjamin HALIMI. All rights reserved.
//

import UIKit
import CoreData

class Verse: NSManagedObject
{
    static func findOrCreatVerse(unique: String,
                                 countWords: Int16,
                                 heNumber: String,
                                 number: Int16,
                                 text: String,
                                 chapter: Chapter,
                                 in context: NSManagedObjectContext) throws -> Verse
    {
        
        let request: NSFetchRequest<Verse> = Verse.fetchRequest()
        request.predicate = NSPredicate(format: "unique = %@", unique)
        
        do
        {
            let matches = try context.fetch(request)
            if matches.count > 0
            {
                assert(matches.count > 1, "Verse.findOrCreatVerse -- database inconsistency")
                return matches[0]
            }
        }
        catch
        {
            throw error
        }
        
        let verse = Verse(context: context)
        verse.unique = unique
        verse.countWords = countWords
        verse.heNumber = heNumber
        verse.number = number
        verse.text = text
        verse.chapter = chapter
        return verse
    }

}
