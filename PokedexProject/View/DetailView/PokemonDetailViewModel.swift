//
//  PokemonDetailViewModel.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/18/24.
//

import Foundation
import SwiftUI

@Observable
class PokemonDataViewModel {
    
    private(set) var pokemonData: PokemonDetailData?
    private(set) var pokemonSpeciesData: PokemonSpeciesData?
    private(set) var pokemonMoveData: [PokemonMoveData]?
    
    var pokemonId: Int {
        pokemonData?.id ?? 1
    }
    
    @MainActor func fetch(urlString: String) async throws -> () {
        do {
            //fetch default data
            guard let url = URL(string: urlString) else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decodedData = try JSONDecoder().decode(PokemonDetailData.self, from: data)
            pokemonData = decodedData
            pokemonMoveData = decodedData.moves
            
            //fetch spicies data
            let speciesURLString = "https://pokeapi.co/api/v2/pokemon-species/\(pokemonId)"
            try await fetchSpicies(urlString: speciesURLString)
        } catch {
            print("fetchError: \(error)")
        }
    }
    
    func fetchSpicies(urlString: String) async throws -> () {
        do {
            guard let speciesURL = URL(string: urlString) else {
                return }
            let(data, _) = try await URLSession.shared.data(from: speciesURL)
            let decodedData = try JSONDecoder().decode(PokemonSpeciesData.self, from: data)
            pokemonSpeciesData = decodedData
        } catch {
            print("fetchSpiciesError: \(error)")
        }
    }
    
    func downloadFromURL(urlString: String) async throws -> URL {
        
        enum DownloadError: String, Error {
            case failedToUnwrap = "Failed to unwrap URL"
            case downloadError = "While downloading an error occurred"
        }
        
        guard let url = URL(string: urlString) else {
            print(DownloadError.failedToUnwrap.rawValue)
            throw DownloadError.failedToUnwrap
        }
        
        do {
            let fileManager = FileManager()
            let (responseURL, _) = try await URLSession.shared.download(from: url)
            let documentsURL = try FileManager.default.url(for: .documentDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: false)
            let savedURL = documentsURL
                .appendingPathComponent("\(pokemonData?.name ?? "untitledpokemon").ogg")
            
            if fileManager.fileExists(atPath: responseURL.absoluteString) {
                return savedURL
            } else {
                try? FileManager.default.removeItem(at: savedURL)
                try FileManager.default.moveItem(at: responseURL, to: savedURL)
                print("\(responseURL) -> \(savedURL)")
                return savedURL
            }
        } catch {
            print("Download Error -> \(error)")
            print(DownloadError.downloadError.rawValue)
            throw DownloadError.downloadError
        }
    }
    
    /// 포켓몬 타입 별 아이콘과 타입 별 색상을 튜플로 리턴
    func getPokemonTypeImageAndColor(type: String) -> (typeIconName: String, typeColor: UIColor) {
        
        switch type {
            case "normal":
                return (type, UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1))
            case "bug":
                return (type, UIColor(red: 132/255, green: 177/255, blue: 20/255, alpha: 1))
            case "dark":
                return (type, UIColor(red: 71/255, green: 69/255, blue: 79/255, alpha: 1))
            case "dragon":
                return (type, UIColor(red: 17/255, green: 85/255, blue: 190/255, alpha: 1))
            case "electric":
                return (type, UIColor(red: 250/255, green: 170/255, blue: 51/255, alpha: 1))
            case "fairy":
                return (type, UIColor(red: 228/255, green: 120/255, blue: 226/255, alpha: 1))
            case "fighting":
                return (type, UIColor(red: 194/255, green: 42/255, blue: 77/255, alpha: 1))
            case "fire":
                return (type, UIColor(red: 245/255, green: 17/255, blue: 54/255, alpha: 1))
            case "flying":
                return (type, UIColor(red: 145/255, green: 173/255, blue: 233/255, alpha: 1))
            case "ghost":
                return (type, UIColor(red: 76/255, green: 88/255, blue: 177/255, alpha: 1))
            case "grass":
                return (type, UIColor(red: 88/255, green: 179/255, blue: 64/255, alpha: 1))
            case "ground":
                return (type, UIColor(red: 189/255, green: 174/255, blue: 117/255, alpha: 1))
            case "ice":
                return (type, UIColor(red: 107/255, green: 200/255, blue: 180/255, alpha: 1))
            case "poison":
                return (type, UIColor(red: 163/255, green: 74/255, blue: 199/255, alpha: 1))
            case "psychic":
                return (type, UIColor(red: 143/255, green: 145/255, blue: 141/255, alpha: 1))
            case "rock":
                return (type, UIColor(red: 204/255, green: 102/255, blue: 58/255, alpha: 1))
            case "steel":
                return (type, UIColor(red: 74/255, green: 132/255, blue: 146/255, alpha: 1))
            case "water":
                return (type, UIColor(red: 71/255, green: 139/255, blue: 218/255, alpha: 1))
            default:
                return (type, UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1))
        }
    }
}
