//
//  ViewController.swift
//  AppBundleReader
//
//  Created by Eliel A. Gordon on 10/26/17.
//  Copyright © 2017 Eliel Gordon. All rights reserved.
//

import UIKit

struct Robot: Codable {
    var name: String
    var personality: String
    var image: String
    var phrase: String
}
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var robotTableView: UITableView!
    var robots = [Robot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let path = Bundle.main.path(forResource: "robo-profiles", ofType: ".json")
        if let path = path {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let jsonRobots = try? JSONDecoder().decode([Robot].self, from: data)
                if let robots = jsonRobots {
                    self.robots = robots
                }
            } catch {
                print("caught")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return robots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = robotTableView.dequeueReusableCell(withIdentifier: "robotCell") as! RobotsTableViewCell
        let robot = robots[indexPath.row]
        cell.nameLabel.text = robot.name
        cell.personalityLabel.text = robot.personality
        cell.phraseLabel.text = robot.phrase
//        let robotImage = UIImage(imageNamed:)
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

