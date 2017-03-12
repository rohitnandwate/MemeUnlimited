//
//  SavedMemeDataSource.swift
//  MemeUnlimited
//
//  Created by Nandwate, Rohit on 3/5/17.
//  Copyright © 2017 Nandwate, Rohit. All rights reserved.
//

import Foundation
import UIKit

class SavedMemeDataSoure : NSObject {
    var savedMemes: [Meme]
    
    init(savedMemes: [Meme]) {
        self.savedMemes = savedMemes
    }
    
    func add(newMeme: Meme) {
        savedMemes.append(newMeme)
    }
}

extension SavedMemeDataSoure: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedMemes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SavedMemeCell.self)) as! SavedMemeCell
        let meme = savedMemes[indexPath.row]
        cell.topText = meme.topText
        cell.bottomText = meme.bottomText
        cell.memeImage = meme.orignalImage
        return cell
    }
}
