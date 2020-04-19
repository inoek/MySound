//
//  NetworkService.swift
//  MySound
//
//  Created by Игорь Ноек on 19.04.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import UIKit
import Alamofire

class NetworkService {
    
    func fetchTracks(searchText: String, completion: @escaping (RespondModel?) -> Void) {
        
        let url = "https://itunes.apple.com/search"
        let parametrs = ["term":"\(searchText)",
            "limit":"\(10)",
            "media": "music"]//фильтруем выборку по музыкальному контенту
        AF.request(url, method: .get, parameters: parametrs, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            
            
            if let error = dataResponse.error {
                print("error\(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = dataResponse.data else {return}
            
            let decoder = JSONDecoder()
            
            do {
                let objects = try decoder.decode(RespondModel.self, from: data)
                print("objects", objects)
                completion(objects)

            } catch let jsonError {
                print("Ошибка при декодировании", jsonError)
                completion(nil)
            }
            
            //                let someString = String(data: data, encoding: .utf8)
            //                print(someString ?? "")
        }
    }
    
}
