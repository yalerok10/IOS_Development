//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Валерия Самонина on 13.06.2020.
//  Copyright © 2020 Валерия Самонина. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    
    var characters : [CharacterModel] = []
    var episodes : [String : String] = Dictionary<String, String>()
    let reuseIdentifier = "characterTableViewCell"


    @IBAction func Update(_ sender: Any) {
        characters = []
        self.tableView.reloadData()
        update()
    }
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
       let image: UIImage = UIImage(named: "rick.png")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        self.navigationItem.titleView = imageView
        
        update()
        
        tableView.register(UINib(nibName: "CharacterTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CharacterTableViewCell
        let character = characters[indexPath.row]
        cell.Title.text = character.name
        cell.Status.text = "\(character.status)"
        cell.Location.text = "\(character.location.name)"
        cell.Episode.text = "\(episodes[character.episode[0]] ?? "0")"
        cell.firstSeenIn.text = "First seen in:"
        cell.lastKnownlocation.text = "Last known location:"
        
        switch character.status {
        case "Alive":
            cell.statusCircle.tintColor = UIColor.green
        case "unknown":
            cell.statusCircle.tintColor = UIColor.gray
        default:
            cell.statusCircle.tintColor = UIColor.red
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                guard let detailViewController = mainStoryboard.instantiateViewController(withIdentifier: "detailViewController") as? DetailViewController else{ return}
        navigationController?.pushViewController(detailViewController, animated: false)
        detailViewController.episode = episodes[characters[indexPath.row].episode[0]]
        detailViewController.character = characters[indexPath.row]
    }
    
    func update() {
        let rmClient = Client()
        rmClient.character().getAllCharacters() {result in switch result {
        case .success(let characters):
            self.characters = characters
            self.tableView.reloadData()
        case .failure(let error):
            print(error)
            }
        }
        
        rmClient.episode().getAllEpisodes() {result in switch result {
        case .success(let episodes):
            episodes.forEach { (item) in
                self.episodes[item.url] = item.name
            }
            self.tableView.reloadData()
        case .failure(let error):
            print(error)
            }
        }
    }
    
}

