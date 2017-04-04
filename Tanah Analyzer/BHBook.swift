//
//  BHBook.swift
//  Tanah Analyzer
//
//  Created by Benjamin HALIMI on 26/03/2017.
//  Copyright © 2017 Benjamin HALIMI. All rights reserved.
//

struct BHBook
{
    
    var status: String              // "status"
    var versionTitle: String        // "versionTitle"
    var sectionNames: Array<String> // "sectionNames"
    var license: String             // "license"
    var language: String            // "language"
    var title: String               // "title"
    var licenseVetted: Bool         // "licenseVetted"
    var text: Array<Array<String>>  // "text"
    var versionSource: String       // "versionSource"
    var heTitle: String             // "heTitle"
    var categories: Array<String>   // "categories"
    
    init(status: String,
        versionTitle: String,
        sectionNames: Array<String>,
        license: String,
        language: String,
        title: String,
        licenseVetted: Bool,
        text: Array<Array<String>>,
        versionSource: String,
        heTitle: String,
        categories: Array<String>)
    {
        self.status = status
        self.versionTitle = versionTitle
        self.sectionNames = sectionNames
        self.license = license
        self.language = language
        self.title = title
        self.licenseVetted = licenseVetted
        self.text = text
        self.versionSource = versionSource
        self.heTitle = heTitle
        self.categories = categories
    }
    
}

