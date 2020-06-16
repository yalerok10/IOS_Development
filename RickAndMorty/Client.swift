//
//  Client.swift
//  RickAndMorty
//
//  Created by Валерия Самонина on 13.06.2020.
//  Copyright © 2020 Валерия Самонина. All rights reserved.
//

import Foundation

/**
 API Client for Rick and Morty API.
 */
public struct Client {
    
    public init() {}
    
    /**
     Access character struct.
     - Returns: Character struct.
     */
    public func character() -> Character {
        let character = Character(client: self)
        return character
    }
    
    /**
     Access episode struct.
     - Returns: Episode struct.
     */
    public func episode() -> Episode {
        let episode = Episode(client: self)
        return episode
    }
    
    /**
     Access location struct.
     - Returns: Location struct.
     */
    public func location() -> Location {
        let location = Location(client: self)
        return location
    }
}
