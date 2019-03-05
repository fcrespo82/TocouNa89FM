//
//  RodioRockService.swift
//  TocouNa89FM
//
//  Created by Fernando Crespo on 03/03/19.
//  Copyright © 2019 Fernando Crespo. All rights reserved.
//

import Cocoa

class RadioRockService: NSObject {

    private static let DONWLOAD_URL = URL(string: "https://players.gc2.com.br/cron/89fm/results.json")

    static func downloadSong(finished: @escaping (_ data: RadioRockModel) -> Void) {
        let request = URLRequest(url: RadioRockService.DONWLOAD_URL!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 60.0)

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(RadioRockModel.self, from: data)

                finished(data)
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}
