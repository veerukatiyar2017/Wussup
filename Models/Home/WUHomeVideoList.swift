//
//  WUHomeVideoList.swift
//  Wussup
//
//  Created by MAC219 on 8/23/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
/*
 "ID": "65",
 "Title": "Event3",
 "GUID": "228d4762-51bc-4284-8534-420a2b8ae288",
 "EventID": "48",
 "VideoURL": "https://wussup-sandbox.s3.amazonaws.com/App_Videos/V2_BurningMan.mp4"
 */
class WUHomeVideoList: NSObject,Decodable {
    var ID                  : String    = "0"
    var Title               : String    = ""
    var GUID                : String    = "0"
    var EventID             : String    = "0"
    var VideoURL            : String    = ""

    private enum CodingKeys: String, CodingKey {
        case ID
        case Title
        case GUID
        case EventID
        case VideoURL
    }
    
    override var description: String {
        var printString = ""
        printString += "\n*********************************"
        printString += "\n ID                  : \(ID)"
        printString += "\n Title               : \(Title)"
        printString += "\n GUID                : \(GUID)"
        printString += "\n EventID             : \(EventID)"
        printString += "\n ImageURL            : \(VideoURL)"
        printString += "\n*********************************\n"
        return printString
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let ID = try values.decodeIfPresent(String.self, forKey: .ID){
                self.ID = ID
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .ID) {
                self.ID = String(val)
            }
            Utill.printInTOConsole(printData:"type mismatched in WUHomeVideoList for ID ")
        }
        
        do {
            if let Title = try values.decodeIfPresent(String.self, forKey: .Title){
                self.Title = Title
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUHomeVideoList for Title ")
        }
        
        
        do {
            if let GUID = try values.decodeIfPresent(String.self, forKey: .GUID){
                self.GUID = GUID
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUHomeVideoList for GUID ")
        }
        
        do {
            if let EventID = try values.decodeIfPresent(String.self, forKey: .EventID){
                self.EventID = EventID
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .EventID) {
                self.EventID = String(val)
            }
            Utill.printInTOConsole(printData:"type mismatched in WUHomeVideoList for EventID ")
        }
        
        do {
            if let VideoURL = try values.decodeIfPresent(String.self, forKey: .VideoURL){
                if URL(string: VideoURL) != nil {
                    self.VideoURL = VideoURL
                }
                else {
                    self.VideoURL = VideoURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUHomeVideoList for VideoURL ")
        }
    }
}

extension WUHomeVideoList: Encodable {
    func encode(to encoder: Encoder) throws{
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ID, forKey: .ID)
        try container.encode(Title, forKey: .Title)
        try container.encode(GUID, forKey: .GUID)
        try container.encode(EventID, forKey: .EventID)
        try container.encode(VideoURL, forKey: .VideoURL)
    }
}
