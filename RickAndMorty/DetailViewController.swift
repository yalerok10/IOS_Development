//
//  DetailViewController.swift
//  RickAndMorty
//
//  Created by Валерия Самонина on 15.06.2020.
//  Copyright © 2020 Валерия Самонина. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Status: UILabel!
    @IBOutlet weak var Location: UILabel!
    @IBOutlet weak var Episode: UILabel!
    @IBOutlet weak var lastLocation: UILabel!
    @IBOutlet weak var firstSeen: UILabel!
    @IBOutlet weak var circle: UIImageView!
    
    var character: CharacterModel?
    var episode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        lastLocation.text = "Last known location:"
        firstSeen.text = "First seen in:"
                
        if let character = character {
            guard let url = URL(string:character.image) else { return }
            downloadImage(from: url)
            Name.text = character.name
            Status.text = character.status
            Location.text = character.location.name
            Episode.text = episode
            switch character.status {
            case "Alive":
                circle.tintColor = UIColor.green
            case "unknown":
                circle.tintColor = UIColor.gray
            default:
                circle.tintColor = UIColor.red
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.Image.image = UIImage(data: data)
            }
        }
    }

}
