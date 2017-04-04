//
//  Parser.swift
//  Tanah Analyzer
//
//  Created by Benjamin HALIMI on 26/03/2017.
//  Copyright © 2017 Benjamin HALIMI. All rights reserved.
//

import Foundation

class Parser
{
    
    class func parseArrayOfBHBookFrom(array :Array<Any>) -> Array<BHBook>
    {
        var temp = Array<BHBook>()
        for item in array
        {
            temp.append(parseBHBookFrom(data: item as! [String : Any]))
        }
        return temp
    }
    
    class func parseBHBookFrom(data :[String: Any]) -> BHBook
    {
        return BHBook(status: data["status"] as! String,
                      versionTitle: data["versionTitle"] as! String,
                      sectionNames: data["sectionNames"] as! Array<String>,
                      license: data["license"] as! String,
                      language: data["language"] as! String,
                      title: data["title"] as! String,
                      licenseVetted: (data["licenseVetted"] != nil),
                      text: data["text"] as! Array<Array<String>>,
                      versionSource: data["versionSource"] as! String,
                      heTitle: data["heTitle"] as! String,
                      categories: data["categories"] as! Array<String>)
    }
    
}
