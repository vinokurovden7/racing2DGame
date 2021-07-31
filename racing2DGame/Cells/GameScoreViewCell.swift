//
//  GameScoreViewCell.swift
//  racing2DGame
//
//  Created by Денис Винокуров on 05.07.2021.
//

import UIKit

class GameScoreViewCell: UITableViewCell {

    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var gameScoreLabel: UILabel!
    @IBOutlet weak var dateScoreLabel: UILabel!
    
    static let identifier = "GameScoreViewCell"
    fileprivate var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY hh:mm"
        return dateFormatter
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let playerNameFont = UIFont.chernobylFont(of: 30) else {return}
        guard let gameScoreFont = UIFont.chernobylFont(of: 25) else {return}
        guard let dateScoreFont = UIFont.chernobylFont(of: 20) else {return}
        playerNameLabel.font = playerNameFont
        gameScoreLabel.font = gameScoreFont
        dateScoreLabel.font = dateScoreFont
        
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    func setup(with score: GameScoreClass) {
        self.playerNameLabel.text = score.playerName
        self.gameScoreLabel.text = "\(score.score)"
        self.dateScoreLabel.text = dateFormatter.string(from: score.dateScore)
    }
    
}
