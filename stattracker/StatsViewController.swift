//
//  BoxScoreViewController.swift
//  stattracker
//
//  Created by Vithushan Namasivayasivam on 7/22/19.
//  Copyright © 2019 CardillSports. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class StatsViewController: UICollectionViewController {
    
    private let reuseIdentifier = "BoxScoreCell"
    private let itemsPerRow: CGFloat = 5
    private let sectionInsets = UIEdgeInsets(top: 0.0,
                                             left: 0.0,
                                             bottom: 0.0,
                                             right: 0.0)
    
    let cardillService = CardillService()
    
    var titleStringViaSegue: String!
    var boxScoreViaSegue: GameDayResponse?
    var stats: StatsResponse?
    
    @IBOutlet weak var gridLayout: StickyGridCollectionViewLayout! {
        didSet {
            gridLayout.stickyRowsCount = 0
            gridLayout.stickyColumnsCount = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchStats()
    }
    
    func fetchStats() {
        cardillService.getStats(completionHandler: { statsResponse in
            self.stats = statsResponse
            self.collectionView.reloadData()
        })
    }
}

// MARK: - UICollectionViewDataSource
extension StatsViewController {
    
    //1
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return stats != nil ? stats!.playerStatsResponses.count : 1
    }
    
    //2
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    //3
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
        
        //1
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! BoxScoreCollectionViewCell
        
  
        if (indexPath.section == 0) {
            cell.title.text = getColumnHeaderTitle(withColumnIndex: indexPath.row)
            cell.title.textColor = .black
            cell.backgroundColor = .init(red: 0.82, green: 0.82, blue: 0.5, alpha: 1.0)
            cell.title.backgroundColor = .init(red: 0.82, green: 0.82, blue: 0.5, alpha: 1.0)
        } else {

            if (indexPath.row == 0) {
                cell.backgroundColor = .init(red: 0.82, green: 0.82, blue: 0.5, alpha: 1.0)
                cell.title.backgroundColor = .init(red: 0.82, green: 0.82, blue: 0.5, alpha: 1.0)
                cell.title.textColor = .black
            } else {
                cell.backgroundColor = .white
                cell.title.backgroundColor = .white
            }
            if (stats != nil) {
                cell.title.text = getStatText(withStats: stats!, andRowIndex: indexPath.section, andColumnIndex: indexPath.row)
            } else {
                cell.title.text = ""
            }
        }
        
        return cell
    }
    
    func getColumnHeaderTitle(withColumnIndex index: Int) -> String {
        var columnHeaders = ["Name", "Games", "Wins", "FGM", "FGA", "Rebounds", "Assists", "Steals", "Blocks", "Turnover"]
        return columnHeaders[index]
    }
    
    func getStatText(withStats stats: StatsResponse, andRowIndex rowIndex: Int, andColumnIndex colIndex: Int) -> String?  {
        
        
        let playerStats = stats.playerStatsResponses[rowIndex].totalStats
        
        switch colIndex {
        case 0:
            return playerStats.firstName
        case 1:
            return String(playerStats.gamesPlayed)
        case 2:
            return String(playerStats.gamesWon)
        case 3:
            return String(playerStats.fieldGoalsMade)
        case 4:
            return String(playerStats.fieldGoalsAttempted)
        case 5:
            return String(playerStats.rebounds)
        case 6:
            return String(playerStats.assists)
        case 7:
            return String(playerStats.steals)
        case 8:
            return String(playerStats.blocks)
        case 9:
            return String(playerStats.turnovers)
        default:
            return nil
        }
    }
}

// MARK: - Collection View Flow Layout Delegate
extension StatsViewController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
