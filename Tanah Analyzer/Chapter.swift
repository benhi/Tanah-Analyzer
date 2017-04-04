//
//  Chapter.swift
//  Tanah Analyzer
//
//  Created by Benjamin HALIMI on 23/03/2017.
//  Copyright © 2017 Benjamin HALIMI. All rights reserved.
//

import UIKit
import CoreData

class Chapter: NSManagedObject
{

    static func findOrCreatChapter(unique: String,
                                   countVerses: Int16,
                                   number: Int16,
                                   heNumber: String,
                                   book: Book,
                                   in context: NSManagedObjectContext) throws -> Chapter
    {
        
        let request: NSFetchRequest<Chapter> = Chapter.fetchRequest()
        request.predicate = NSPredicate(format: "unique = %@", unique)
        
        do
        {
            let matches = try context.fetch(request)
            if matches.count > 0
            {
                assert(matches.count > 1, "Verse.findOrCreatChapter -- database inconsistency")
                return matches[0]
            }
        }
        catch
        {
            throw error
        }
        
        let chapter = Chapter(context: context)
        chapter.unique = unique
        chapter.countVerses = countVerses
        chapter.number = number
        chapter.heNumber = heNumber
        chapter.book = book
        return chapter
    }

}
