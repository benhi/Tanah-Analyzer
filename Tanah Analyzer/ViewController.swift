//
//  ViewController.swift
//  Tanah Analyzer
//
//  Created by Benjamin HALIMI on 23/03/2017.
//  Copyright © 2017 Benjamin HALIMI. All rights reserved.
//

import UIKit
import Foundation
import CoreData

enum Find {
    case Verse
    case Word
    case Book
}

struct GetTag
{
    static let Book    = 10
    static let Chapter = 20
    static let Verse   = 30
    static let Data    = 40
}

class ViewController: UIViewController, NSFetchedResultsControllerDelegate
{
    
    @IBOutlet weak var TextFieldSearchBook: UITextField!
    @IBOutlet weak var textFieldSearchGroupOfWordInVerse: UITextField!
    @IBOutlet weak var textFieldContainsStringInWord: UITextField!
    @IBOutlet weak var textFieldSearchWord: UITextField!
    @IBOutlet weak var textFieldNumOfWordInVerse: UITextField!
    
    @IBOutlet weak var tableViewAnalizer: UITableView!
    @IBOutlet weak var tableViewAutoComplete: UITableView!
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    var fetchedResultsControllerVerse: NSFetchedResultsController<Verse>?
    var fetchedResultsControllerWord: NSFetchedResultsController<Word>?
    var fetchedResultsControllerBook: NSFetchedResultsController<Book>?
    
    var find: Find = .Verse
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        if let firstLaunching = UserDefaults.standard.value(forKey: "firstLaunching") as? Bool
//        {
//            if firstLaunching == true
//            {
//                let start = 1
//                let end = 5
//                UserDefaults.standard.setValue(start, forKey: "start")
//                UserDefaults.standard.setValue(end, forKey: "end")
//            }
//        }
//        
//        
//        if let start = UserDefaults.standard.value(forKey: "start") as? Int, let end = UserDefaults.standard.value(forKey: "end") as? Int
//        {
//            for i in start...end
//            {
//                if let b = Util.getJsonDictFromFileAndParseToBHBook(fileName: Util.getBookNameMapFrom(index: i)!)
//                {
//                    self.insertBHBookToTheDB(bhBook: b)
//                }
//            }
//        }
        
        tableViewAutoComplete.isHidden = true
        tableViewAutoComplete.backgroundColor = UIColor.clear
        tableViewAutoComplete.tableFooterView = UIView()

    }
    
    private func insertBHBookToTheDB(bhBook: BHBook)
    {
        if let context = container?.viewContext {
//        container?.performBackgroundTask { [weak self] context in
        
            print("Start: \(bhBook.heTitle)")
            if let DBBook = try? Book.findOrCreatBook(bhBookTitle: bhBook.title,
                                                      bhBookHeTitle: bhBook.heTitle,
                                                      bhBookCountChapters: Int16(bhBook.text.count),
                                                      in: context)
            {
                for (i, chapter) in bhBook.text.enumerated()
                {
                    if let DBChapter = try? Chapter.findOrCreatChapter(unique: UUID().uuidString,
                                                                       countVerses: Int16(chapter.count),
                                                                       number: Int16(i+1),
                                                                       heNumber: Util.getHebrewNumeralFrom(arabicNumeral: Int16(i+1))!,
                                                                       book: DBBook,
                                                                       in: context)
                    {
                        try? context.save()
                        for (j, verse) in chapter.enumerated()
                        {
                            
                            let split = verse.characters.split { [" ", "־"].contains(String($0)) }
                            
                            //trim
                            let wordArray = split.map { String($0).trimmingCharacters(in: .whitespaces) }
                            
                            if let DBVerse = try? Verse.findOrCreatVerse(unique: UUID().uuidString,
                                                                         countWords: Int16(wordArray.count),
                                                                         heNumber: Util.getHebrewNumeralFrom(arabicNumeral: Int16(j+1))!,
                                                                         number: Int16(j+1),
                                                                         text: verse,
                                                                         chapter: DBChapter,
                                                                         in: context)
                            {
                                try? context.save()
                                for (k, word) in wordArray.enumerated()
                                {
                                    _ = try? Word.findOrCreatWord(unique: UUID().uuidString,
                                                                  countCharacter: Int16(word.characters.count),
                                                                  index: Int16(k+1),
                                                                  text: word,
                                                                  verse: DBVerse,
                                                                  in: context)
                                    try? context.save()
                                }
                            }
                        }
                    }
                }
            }
            try? context.save()
            self.printDatabaseStatistics()
        }
    }
    
    private func printDatabaseStatistics()
    {
        if let context = container?.viewContext
        {
            let request: NSFetchRequest<Word> = Word.fetchRequest()
            if let wordCount = (try? context.fetch(request))?.count
            {
                print("There is \(wordCount) in the database")
            }
        }
    }
    
    
    
    
    @IBAction func textFieldSearchBookDidChange(_ sender: UITextField)
    {
        self.find = .Book
        if let book = sender.text, !book.isEmpty
        {
            if let context = self.container?.viewContext
            {
                
                let request: NSFetchRequest<Book> = Book.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: "heTitle",ascending: true)]
                request.predicate = NSPredicate(format: "any heTitle contains[c] %@", book)
                
                self.fetchedResultsControllerBook = NSFetchedResultsController<Book>(fetchRequest: request,
                                                                                     managedObjectContext: context,
                                                                                     sectionNameKeyPath: nil,
                                                                                     cacheName: nil)
                self.fetchedResultsControllerBook?.delegate = self
                try? self.fetchedResultsControllerBook?.performFetch()
                self.tableViewAutoComplete.reloadData()
                self.tableViewAutoComplete.isHidden = false
            }
        }
    }
    
    
    
    
    
    @IBAction func textFieldContainsStringInWordDidChange(_ sender: UITextField)
    {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            self.find = .Word
            if let word = sender.text, !word.isEmpty
            {
                if let context = self.container?.viewContext
                {
                    
                    let request: NSFetchRequest<Word> = Word.fetchRequest()
                    request.sortDescriptors = [NSSortDescriptor(key: "verse",ascending: true)]
                    request.predicate = NSPredicate(format: "any text contains[c] %@", word)
                    
                    if let words = (try? context.fetch(request))
                    {
                        let wordCount = words.count
                        self.title = "Il y a \(wordCount) fois le mot \(word) dans le תנ״ך"
                    }
                    
                    self.fetchedResultsControllerWord = NSFetchedResultsController<Word>(fetchRequest: request,
                                                                                    managedObjectContext: context,
                                                                                    sectionNameKeyPath: nil,
                                                                                    cacheName: nil)
                    self.fetchedResultsControllerWord?.delegate = self
                    try? self.fetchedResultsControllerWord?.performFetch()
                    self.tableViewAnalizer.reloadData()
                    
                }
            }
        }

    }
    
    @IBAction func textFieldSearchGroupOfWordInVerseTextDidChange(_ sender: UITextField)
    {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            self.find = .Verse
            if let str = sender.text, !str.isEmpty
            {
                if let context = self.container?.viewContext
                {
                    
                    let request: NSFetchRequest<Verse> = Verse.fetchRequest()
                    request.sortDescriptors = [NSSortDescriptor(key: "number",ascending: true)]
                    request.predicate = NSPredicate(format: "any text contains[c] %@", str)
                    
                    if let strs = (try? context.fetch(request))
                    {
                        let strCount = strs.count
                        self.title = "Il y a \(strCount) fois \(str) dans le תנ״ך"
                    }
                    
                    self.fetchedResultsControllerVerse = NSFetchedResultsController<Verse>(fetchRequest: request,
                                                                                         managedObjectContext: context,
                                                                                         sectionNameKeyPath: nil,
                                                                                         cacheName: nil)
                    self.fetchedResultsControllerVerse?.delegate = self
                    try? self.fetchedResultsControllerVerse?.performFetch()
                    self.tableViewAnalizer.reloadData()
                    
                }
                
            }
        }

        
        
        
    }
    
    @IBAction func textFieldSearchWordTextDidChange(_ sender: UITextField)
    {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            self.find = .Word
            if let word = sender.text, !word.isEmpty
            {
                if let context = self.container?.viewContext
                {
                    
                    let request: NSFetchRequest<Word> = Word.fetchRequest()
                    request.sortDescriptors = [NSSortDescriptor(key: "verse",ascending: true)]
                    request.predicate = NSPredicate(format: "text == %@", word)
                    
                    if let words = (try? context.fetch(request))
                    {
                        let wordCount = words.count
                        self.title = "Il y a \(wordCount) fois le mot \(word) dans le תנ״ך"
                    }
                    
                    self.fetchedResultsControllerWord = NSFetchedResultsController<Word>(fetchRequest: request,
                                                                                    managedObjectContext: context,
                                                                                    sectionNameKeyPath: nil,
                                                                                    cacheName: nil)
                    self.fetchedResultsControllerWord?.delegate = self
                    try? self.fetchedResultsControllerWord?.performFetch()
                    self.tableViewAnalizer.reloadData()
                    
                }
                
            }
        }
        
    }
    
    
    
    func searchAndDisplayBook(bookName: String?)
    {
        find = .Verse
        tableViewAutoComplete.isHidden = true
        if let titleBook = bookName, !titleBook.isEmpty
        {
            
            if let context = container?.viewContext
            {
                let request: NSFetchRequest<Verse> = Verse.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: "chapter.number",ascending: true), NSSortDescriptor(key: "number",ascending: true)]
                request.predicate = NSPredicate(format: "chapter.book.heTitle == %@", titleBook)
                
                if let verse = (try? context.fetch(request))
                {
                    title = verse.first?.chapter?.book?.heTitle
                }
                
                fetchedResultsControllerVerse = NSFetchedResultsController<Verse>(fetchRequest: request,
                                                                                  managedObjectContext: context,
                                                                                  sectionNameKeyPath: nil,
                                                                                  cacheName: nil)
                fetchedResultsControllerVerse?.delegate = self
                try? fetchedResultsControllerVerse?.performFetch()
                tableViewAnalizer.reloadData()
                
                
            }
        }

    }
    
}

extension ViewController: UITextFieldDelegate
{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        
        textField.resignFirstResponder()

        if textField == TextFieldSearchBook
        {
            searchAndDisplayBook(bookName: textField.text)
        }
        
        if textField == textFieldNumOfWordInVerse
        {
            find = .Verse
            
            if let num = textField.text, !num.isEmpty
            {
                
                if let context = container?.viewContext
                {
                    
                    let request: NSFetchRequest<Verse> = Verse.fetchRequest()
                    request.sortDescriptors = [NSSortDescriptor(key: "number",ascending: true)]
                    request.predicate = NSPredicate(format: "countWords == %d", Int16(num)!)
                    
                    if let verse = (try? context.fetch(request))
                    {
                        let verseCount = verse.count
                        title = "Il y a \(verseCount) פסוקים avec \(num) mots dans le תנ״ך"
                    }
                    
                    fetchedResultsControllerVerse = NSFetchedResultsController<Verse>(fetchRequest: request,
                                                                                      managedObjectContext: context,
                                                                                      sectionNameKeyPath: nil,
                                                                                      cacheName: nil)
                    fetchedResultsControllerVerse?.delegate = self
                    try? fetchedResultsControllerVerse?.performFetch()
                    tableViewAnalizer.reloadData()
                    
                }
            }
        }
        return true
    }
}

extension ViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let book = fetchedResultsControllerBook?.object(at: indexPath)
        {
            TextFieldSearchBook.text = book.heTitle
            searchAndDisplayBook(bookName: book.heTitle)
        }
        tableViewAutoComplete.isHidden = true
        tableView.deselectRow(at: indexPath, animated: true)
        view.endEditing(true)
        
        
    }
    
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView)
    {
        view.endEditing(true)
    }

}

extension ViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if tableView == tableViewAnalizer
        {
            if find == Find.Verse
            {
                return fetchedResultsControllerVerse?.sections?.count ?? 1
            }
            if find == Find.Word
            {
                return fetchedResultsControllerWord?.sections?.count ?? 1
            }
        }
        
        if tableView == tableViewAutoComplete
        {
            return fetchedResultsControllerBook?.sections?.count ?? 1
        }
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == tableViewAnalizer
        {
            if find == Find.Verse
            {
                if let sections = fetchedResultsControllerVerse?.sections, sections.count > 0
                {
                    return sections[section].numberOfObjects
                }
                else
                {
                    return 0
                }
            }
            if find == Find.Word
            {
                if let sections = fetchedResultsControllerWord?.sections, sections.count > 0
                {
                    return sections[section].numberOfObjects
                }
                else
                {
                    return 0
                }
            }
        }
        
        if tableView == tableViewAutoComplete
        {
            if let sections = fetchedResultsControllerBook?.sections, sections.count > 0
            {
                return sections[section].numberOfObjects
            }
            else
            {
                return 0
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        var cell = UITableViewCell()
        
        if tableView == tableViewAnalizer
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            if find == Find.Verse
            {
                    if let verse = fetchedResultsControllerVerse?.object(at: indexPath)
                    {
                        if let label1 = cell.viewWithTag(GetTag.Data) as? UILabel
                        {
                            label1.text = verse.text
                        }
                        if let label2 = cell.viewWithTag(GetTag.Book) as? UILabel
                        {
                            label2.text = verse.chapter?.book?.heTitle
                        }
                        if let label3 = cell.viewWithTag(GetTag.Chapter) as? UILabel
                        {
                            label3.text = verse.chapter?.heNumber
                        }
                        if let label4 = cell.viewWithTag(GetTag.Verse) as? UILabel
                        {
                            label4.text = verse.heNumber
                        }
                        
                    }
            
            }
            
            if find == Find.Word
            {
                
                if let word = fetchedResultsControllerWord?.object(at: indexPath)
                {
                    if let label1 = cell.viewWithTag(GetTag.Data) as? UILabel
                    {
                        label1.text = word.verse?.text
                    }
                    if let label2 = cell.viewWithTag(GetTag.Book) as? UILabel
                    {
                        label2.text = word.verse?.chapter?.book?.heTitle
                    }
                    if let label3 = cell.viewWithTag(GetTag.Chapter) as? UILabel
                    {
                        label3.text = word.verse?.chapter?.heNumber
                    }
                    if let label4 = cell.viewWithTag(GetTag.Verse) as? UILabel
                    {
                        label4.text = word.verse?.heNumber
                    }
                    
                }
            
            }
            
        }
        
        if tableView == tableViewAutoComplete
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "bookNameCell", for: indexPath)
            if let book = fetchedResultsControllerBook?.object(at: indexPath)
            {
                if let label = cell.viewWithTag(100) as? UILabel
                {
                    label.text = book.heTitle
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == tableViewAnalizer
        {
            if let cell = tableView.visibleCells.last
            {
                if let verse = fetchedResultsControllerVerse?.object(at: indexPath)
                {
                    if let label1 = cell.viewWithTag(GetTag.Data) as? UILabel
                    {
                        let tempLabel = UILabel()
                        tempLabel.numberOfLines = 0
                        tempLabel.text = verse.text
                        tempLabel.frame.size.width = label1.frame.size.width
                        tempLabel.font = label1.font
                        tempLabel.sizeToFit()
                        return 45 + tempLabel.frame.size.height
                    }
                }
            }
            return 66
        }
        
        if tableView == tableViewAutoComplete
        {
            return 37
        }
        
        return 0
        
    }

}



