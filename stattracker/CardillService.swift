//
//  CardillService.swift
//  stattracker
//
//  Created by Vithushan Namasivayasivam on 7/22/19.
//  Copyright © 2019 CardillSports. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CardillService: NSObject {
    
    func getLeagues( completionHandler: @escaping (JSON) -> Void) {
        let url = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as! String
        
        let idToken = UserDefaults.standard.string(forKey: "id_token")!
        let playerId = UserDefaults.standard.string(forKey: "player_id")!
        
        let headers: HTTPHeaders = [
            "Authorization": idToken,
            "Accept": "application/json"
        ]
        
        AF.request(url + "/player/leagues/" + playerId, headers: headers).responseJSON {
            (response) -> Void in
            completionHandler(try! JSON(response.result.get()))
        }
    }
    
    func getGameDays(completionHandler: @escaping (JSON) -> Void) {
        let url = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as! String
        
        let idToken = UserDefaults.standard.string(forKey: "id_token")!
        let headers: HTTPHeaders = [
            "Authorization": idToken,
            "Accept": "application/json"
        ]
        
        //let currentLeagueId = UserDefaults.standard.string(forKey: "current_league_id")!
        let currentLeagueId = "5bb15c65be2df207fc5a7221" //TODO stop hard coding this
        print("CURRENT LEAGUE ID: " + currentLeagueId)
        AF.request(url + "/stat/score/" + currentLeagueId, headers: headers).responseJSON {
            (response) -> Void in
            completionHandler(try! JSON(response.result.get()))
        }
    }
}
