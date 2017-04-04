//
//  Util.swift
//  Tanah Analyzer
//
//  Created by Benjamin HALIMI on 27/03/2017.
//  Copyright © 2017 Benjamin HALIMI. All rights reserved.
//

import Foundation

class Util
{
    class func getHebrewNumeralFrom(arabicNumeral: Int16) -> String?
    {
        if let path = Bundle.main.path(forResource: "Hebrew Numeral Map", ofType: "plist")
        {
            if let hebrewNumeralMap = NSDictionary(contentsOfFile: path) as? [String: String]
            {
                return hebrewNumeralMap[String(arabicNumeral)]
            }
        }
        return nil
    }

    class func getBookNameMapFrom(index: Int) -> String?
    {
        if let path = Bundle.main.path(forResource: "Book Name Map", ofType: "plist")
        {
            if let bookNameMap = NSDictionary(contentsOfFile: path) as? [String: String]
            {
                return bookNameMap[String(index)]
            }
        }
        return nil
    }

    class func getJsonDictFromFileAndParseToBHBook(fileName: String) -> BHBook?
    {
        
        if let path = Bundle.main.path(forResource: fileName, ofType: "json")
        {
            if let jsonString = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
            {
                if let data = jsonString.data(using: .utf8)
                {
                    do
                    {
                        if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        {
                            return Parser.parseBHBookFrom(data: jsonDict)
                        }
                    }
                    catch
                    {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
        return nil
        
    }

}
