//
//  RadioRockModel.swift
//  TocouNa89FM
//
//  Created by Fernando Crespo on 03/03/19.
//  Copyright © 2019 Fernando Crespo. All rights reserved.
//

import Foundation


struct RadioRockModel: Decodable {

    var cantor: String
    var musica: String
    var cover: URL?

    private enum CodingKeys: String, CodingKey {
        case musicas
        case tocando
        case cantor = "singer"
        case musica = "song"
        case cover

    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let musicas = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .musicas)
        let tocando = try musicas.nestedContainer(keyedBy: CodingKeys.self, forKey: .tocando)
        cantor = try tocando.decode(String.self, forKey: .cantor)
        musica = try tocando.decode(String.self, forKey: .musica)
        cover = try tocando.decode(URL.self, forKey: .cover)

    }
}
