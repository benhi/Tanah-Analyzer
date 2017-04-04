//
//  Word.swift
//  Tanah Analyzer
//
//  Created by Benjamin HALIMI on 26/03/2017.
//  Copyright © 2017 Benjamin HALIMI. All rights reserved.
//

import UIKit
import CoreData

class Word: NSManagedObject
{
    static func findOrCreatWord(unique: String,
                                countCharacter: Int16,
                                index: Int16,
                                text: String,
                                verse: Verse,
                                in context: NSManagedObjectContext) throws -> Word
    {
        
        let request: NSFetchRequest<Word> = Word.fetchRequest()
        request.predicate = NSPredicate(format: "unique = %@", unique)
        
        do
        {
            let matches = try context.fetch(request)
            if matches.count > 0
            {
                assert(matches.count > 1, "Word.findOrCreatWord -- database inconsistency")
                return matches[0]
            }
        }
        catch
        {
            throw error
        }
        
        let word = Word(context: context)
        word.unique = unique
        word.countCharacter = countCharacter
        word.index = index
        word.text = text
        word.verse = verse
        return word
    }
    
}
