//
//  APIModel.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/18/24.
//

import Foundation

//MARK: 리스트 - https://pokeapi.co/api/v2/pokemon?limit=649&offset=0
struct PokemonList: Codable {
    var count: Int
    var next: String?
    var previous: String?
    var defaultPrevious: String { previous ?? "" }
    var results: [PokemonListObject]
}

struct PokemonListObject: Codable, Hashable {
    var name: String
    var url: String
}

//MARK: 일반정보 상세 - https://pokeapi.co/api/v2/pokemon/25/
struct PokemonDetailData: Identifiable, Codable {
    let id: Int
    let height: Int
    let weight: Int
    let name: String
    let moves: [PokemonMoveData]
    let cries: PokemonCries
    let sprites: PokemonSprite
    let stats: [PokemonStat]
    let types: [PokemonTypeData]
}

struct PokemonMoveData: Codable {
    let moveDetail: PokemonMoveDetail
    
    enum CodingKeys: String, CodingKey {
        case moveDetail = "move"
    }
}

struct PokemonMoveDetail: Identifiable, Codable {
    var id: UUID {
        return UUID()
    }
    let name: String
    let url: String
}

struct PokemonTypeData: Codable {
    let slot: Int
    let type: PokemonType
}

struct PokemonType: Codable {
    let name: String
    let url: String
}

struct PokemonStat: Codable {
    let baseStat: Int
    let effort: Int
    let stat: PokemonStatType
    
    enum CodingKeys: String, CodingKey {
        case effort, stat
        case baseStat = "base_stat"
    }
}

struct PokemonStatType: Codable {
    let name: String
    let url: String
}

struct PokemonCries: Codable {
    let latest: String
}

struct PokemonSprite: Codable {
    let frontDefault: String
    let backDefault: String?
    let frontShiny: String?
    let backShiny: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case backDefault = "back_default"
        case frontShiny = "front_shiny"
        case backShiny = "back_shiny"
    }
}

//MARK: 포켓몬 종 상세 - https://pokeapi.co/api/v2/pokemon-species/1/
struct PokemonSpeciesData: Identifiable, Codable {
    let id: Int
    let baseHappiness: Int
    let captureRate: Int
    let name: String
    let names: [PokemonGlobalName]
    let genera: [PokemonGenera]
    
    enum CodingKeys: String, CodingKey {
        case id, name, names, genera
        case baseHappiness = "base_happiness"
        case captureRate = "capture_rate"
    }
}

struct PokemonGlobalName: Codable {
    let name: String
}

struct PokemonGenera: Codable {
    let genus: String
}

//MARK: 폭행몬 기술 상세 https://pokeapi.co/api/v2/move/5/
struct PokemonMoveDetailExtended: Codable {
    let accuracy: Int?
    let damageClass: PokemonDamageClass?
    let power: Int?
    let pp: Int?
    let names: [PokemonMoveName?]
    
    enum CodingKeys: String, CodingKey {
        case names, accuracy, power, pp
        case damageClass = "damage_class"
    }
}

struct PokemonDamageClass: Codable {
    let name: String
    let url: String
}

struct PokemonMoveName: Hashable, Codable {
    let name: String?
}
