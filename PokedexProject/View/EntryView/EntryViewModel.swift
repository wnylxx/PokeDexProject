//
//  EntryViewModel.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/18/24.
//

import Foundation
import Observation

@Observable
class EntryViewModel {
    
    private(set) var pokeList: [PokemonListObject] = []
    private(set) var initialFetchedResult: [PokemonListObject] = []
    
    var urlString: String
    var limit: Int
    var offset: Int
    
    init(urlString: String = "", limit: Int, offset: Int) {
        self.limit = limit
        self.offset = offset
        self.urlString = "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)"
        
        Task {
            try await initialFetch()
        }
    }
    
    @MainActor func initialFetch() async throws -> [PokemonListObject] {
        guard let url = URL(string: urlString) else { return [] }
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let decodedData = try? JSONDecoder().decode(PokemonList.self, from: data) else { return [] }
        pokeList = decodedData.results
        initialFetchedResult = decodedData.results
        return pokeList
    }
    
    func search(searchKeyword: String) -> [PokemonListObject] {
        return initialFetchedResult.filter{ $0.name.contains(searchKeyword.lowercased()) }
    }
    
}
