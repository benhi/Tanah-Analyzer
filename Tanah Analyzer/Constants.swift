//
//  Constants.swift
//  Tanah Analyzer
//
//  Created by Benjamin HALIMI on 29/03/2017.
//  Copyright © 2017 Benjamin HALIMI. All rights reserved.
//

import Foundation

struct Constants
{
    struct Bereshit
    {
        static let Title = "01 Genesis"
        static let Tag = 1
    }
    struct Chemot
    {
        static let Title = "02 Exodus"
        static let Tag = 2
    }
    struct Vaykra
    {
        static let Title = "03 Leviticus"
        static let Tag = 3
    }
    struct Bamidbar
    {
        static let Title = "04 Numbers"
        static let Tag = 4
    }
    struct Deverim
    {
        static let Title = "05 Deuteronomy"
        static let Tag = 5
    }
    
    
    static func getTagFrom(title: String) -> Int
    {
        switch title
        {
        case "Genesis": return 1
        case "Exodus": return 2
        case "Leviticus": return 3
        case "Numbers": return 4
        case "Deuteronomy": return 5
        case "Joshua": return 6
        case "Judges": return 7
        case "I Samuel": return 8
        case "II Samuel": return 9
        case "I Kings": return 10
        case "II Kings": return 11
        case "Isaiah": return 12
        case "Jeremiah": return 13
        case "Ezekiel": return 14
        case "Hosea": return 15
        case "Joel": return 16
        case "Amos": return 17
        case "Obadiah": return 18
        case "Jonah": return 19
        case "Micah": return 20
        case "Nahum": return 21
        case "Habakkuk": return 22
        case "Zephaniah": return 23
        case "Haggai": return 24
        case "Zechariah": return 25
        case "Malachi": return 26
        case "Psalms": return 27
        case "Proverbs": return 28
        case "Job": return 29
        case "Song of Songs": return 30
        case "Ruth": return 31
        case "Lamentations": return 32
        case "Ecclesiastes": return 33
        case "Esther": return 34
        case "Daniel": return 35
        case "Ezra": return 36
        case "Nehemiah": return 37
        case "I Chronicles": return 38
        case "II Chronicles": return 39
        default: return 0
        }
    }

    /*
    <key>1</key> <string></string>
    <key>2</key> <string></string>
    <key>3</key> <string></string>
    <key>4</key> <string></string>
    <key>5</key> <string></string>
    <key>6</key> <string>06 Joshua</string>
    <key>7</key> <string>07 Judges</string>
    <key>8</key> <string>08 I Samuel</string>
    <key>9</key> <string>09 II Samuel</string>
    <key>10</key> <string>10 I Kings</string>
    <key>11</key> <string>11 II Kings</string>
    <key>12</key> <string>12 Isaiah</string>
    <key>13</key> <string>13 Jeremiah</string>
    <key>14</key> <string>14 Ezekiel</string>
    <key>15</key> <string>15 Hosea</string>
    <key>16</key> <string>16 Joel</string>
    <key>17</key> <string>17 Amos</string>
    <key>18</key> <string>18 Obadiah</string>
    <key>19</key> <string>19 Jonah</string>
    <key>20</key> <string>20 Micah</string>
    <key>21</key> <string>21 Nahum</string>
    <key>22</key> <string>22 Habakkuk</string>
    <key>23</key> <string>23 Zephaniah</string>
    <key>24</key> <string>24 Haggai</string>
    <key>25</key> <string>25 Zechariah</string>
    <key>26</key> <string>26 Malachi</string>
    <key>27</key> <string>27 Psalms</string>
    <key>28</key> <string>28 Proverbs</string>
    <key>29</key> <string>29 Job</string>
    <key>30</key> <string>30 Song of Songs</string>
    <key>31</key> <string>31 Ruth</string>
    <key>32</key> <string>32 Lamentations</string>
    <key>33</key> <string>33 Ecclesiastes</string>
    <key>34</key> <string>34 Esther</string>
    <key>35</key> <string>35 Daniel</string>
    <key>36</key> <string>36 Ezra</string>
    <key>37</key> <string>37 Nehemiah</string>
    <key>38</key> <string>38 I Chronicles</string>
    <key>39</key> <string>39 II Chronicles</string>
    */
    
}
