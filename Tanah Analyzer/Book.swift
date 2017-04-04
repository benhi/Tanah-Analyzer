//
//  Book.swift
//  Tanah Analyzer
//
//  Created by Benjamin HALIMI on 23/03/2017.
//  Copyright © 2017 Benjamin HALIMI. All rights reserved.
//

import UIKit
import CoreData

class Book: NSManagedObject
{
    static func findOrCreatBook(bhBookTitle: String,
                                bhBookHeTitle: String,
                                bhBookCountChapters: Int16,
                                in context: NSManagedObjectContext) throws -> Book
    {
        
        let request: NSFetchRequest<Book> = Book.fetchRequest()
        request.predicate = NSPredicate(format: "title = %@", bhBookTitle)
        
        do
        {
            let matches = try context.fetch(request)
            if matches.count > 0
            {
                assert(matches.count > 1, "Book.findOrCreatChapter -- database inconsistency")
                return matches[0]
            }
        }
        catch
        {
            throw error
        }
        
        let book = Book(context: context)
        book.title = bhBookTitle
        book.heTitle = bhBookHeTitle
        book.countChapters = bhBookCountChapters
        
        return book
    }
    
}
