//
//  SavedMemeViewController.swift
//  MemeUnlimited
//
//  Created by Nandwate, Rohit on 3/5/17.
//  Copyright © 2017 Nandwate, Rohit. All rights reserved.
//

import Foundation
import UIKit

class SavedMemeViewController : UITableViewController {

    var datasource: SavedMemeDataSoure?
    var savedMemes: [Meme]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = datasource
        tableView.reloadData()
        
        self.navigationController?.navigationBar.isHidden = false
    }
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let mainViewController = segue.destination as! MemeEditorController
        
        if segue.identifier == "showSelectedMeme" {
            if let cell = sender as? SavedMemeCell {
                mainViewController.currentMeme = Meme(orignalImage: cell.memeImage,
                                                      memedImage: nil,
                                                      topText: cell.topText,
                                                      bottomText: cell.bottomText)
            }
        }
    }
    
}
