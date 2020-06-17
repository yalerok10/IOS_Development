//
//  Client.swift
//  RickAndMorty
//
//  Created by Валерия Самонина on 13.06.2020.
//  Copyright © 2020 Валерия Самонина. All rights reserved.
//

import Foundation

public struct Client {
    
    public init() {}

    public func character() -> Character {
        let character = Character(client: self)
        return character
    }

    public func episode() -> Episode {
        let episode = Episode(client: self)
        return episode
    }
}
