//
//  TableScoreViewController.swift
//  racing2DGame
//
//  Created by Денис Винокуров on 05.05.2021.
//

import UIKit

class TableScoreViewController: CustomViewController {

    private let userDefaults = UserDefaults.standard
    private var usersScoreArray: [GameScoreClass] = []
    @IBOutlet weak var gameScoreTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Table score"
        
        gameScoreTableView.delegate = self
        gameScoreTableView.dataSource = self
        
        let nib = UINib(nibName: String(describing: GameScoreViewCell.self), bundle: nil)
        gameScoreTableView.register(nib, forCellReuseIdentifier: GameScoreViewCell.identifier)
        
        if let gameScoresData = userDefaults.value(forKey: .gameScore) as? Data {
            do {
                usersScoreArray = try JSONDecoder().decode([GameScoreClass].self, from: gameScoresData)
                gameScoreTableView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = .systemYellow
        if let font = UIFont.chernobylFont(of: 25) {
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font: font]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
}
extension TableScoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersScoreArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GameScoreViewCell.identifier) as? GameScoreViewCell else {
            return UITableViewCell()
        }
        
        cell.setup(with: usersScoreArray[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
