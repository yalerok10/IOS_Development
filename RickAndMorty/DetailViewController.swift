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
    
    var character: CharacterModel?
    var episode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        if let character = character {
            guard let url = URL(string:character.image) else { return }
            downloadImage(from: url)
            Name.text = character.name
            Status.text = character.status
            Location.text = character.location.name
            Episode.text = episode
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
