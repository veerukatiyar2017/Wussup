//
//  WUDateWiseEvents.swift
//  Wussup
//
//  Created by MAC26 on 04/06/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit


/*
 "ThisWeekEvents":{
 "EventDate": "06/04/2018",
 "Events":[
 {"ID": "6", "Name": "Event1", "Description": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Why do we use it? It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",…},
 {"ID": "8", "Name": "Event3", "Description": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Why do we use it? It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",…},
 {"ID": "7", "Name": "Event2", "Description": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Why do we use it? It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",…}
 ]
 },*/
class WUDateWiseEvents: NSObject, Decodable, Copying {
  
    var EventDate               : String            = "0"
    var Events                  : [WUEvent]         = []

    
    required init(original: WUDateWiseEvents) {
        self.EventDate = original.EventDate
        self.Events = original.Events
    }
    
    private enum CodingKeys: String, CodingKey {
        
        case EventDate
        case Events
    }
    
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        
        do {
            if let eventDate = try values.decodeIfPresent(String.self, forKey: .EventDate){
                self.EventDate = eventDate
            }
        } catch DecodingError.typeMismatch {
           
             Utill.printInTOConsole(printData:"type mismatched in WUDateWiseEvents for EventDate ")
        }
        
        
        do {
            if let events = try values.decodeIfPresent([WUEvent].self, forKey: .Events){
                self.Events = events
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUDateWiseEvents for Events ")
        }
        
    }
}

extension WUDateWiseEvents: Encodable
{
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(EventDate, forKey: .EventDate)
        try container.encode(Events, forKey: .Events)
      
    }
}

