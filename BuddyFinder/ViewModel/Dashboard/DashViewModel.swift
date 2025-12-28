import Foundation
import SwiftUI

@MainActor // Crucial for SwiftUI lifecycle
class PetViewModel: ObservableObject {
    @Published var pets: [Pet] = []
    @Published var favorites: Set<Int> = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    
    private let service: PetServiceProtocol
    private let favKey = "user_favorites"
    
    init(service: PetServiceProtocol) {
        self.service = service
        loadFavorites()
    }
    
    // --- THIS IS THE METHOD THE COMPILER IS LOOKING FOR ---
    func sortPets(by criteria: String) {
        if criteria == "Price" {
            pets.sort { $0.price < $1.price }
        } else {
            // Sort by breed name/group safely
            pets.sort { ($0.breedGroup ?? "") < ($1.breedGroup ?? "") }
        }
    }
    
    func getPets() async {
        isLoading = true
        do {
            self.pets = try await service.fetchPets()
        } catch {
            print("Error: \(error)")
        }
        isLoading = false
    }
    
    func toggleFavorite(id: Int) {
        if favorites.contains(id) {
            favorites.remove(id)
        } else {
            favorites.insert(id)
        }
        UserDefaults.standard.set(Array(favorites), forKey: favKey)
    }
    
    func isFavorite(_ id: Int) -> Bool {
        favorites.contains(id)
    }
    
    private func loadFavorites() {
        if let savedIds = UserDefaults.standard.array(forKey: favKey) as? [Int] {
            self.favorites = Set(savedIds)
        }
    }
    
    var filteredPets: [Pet] {
        if searchText.isEmpty { return pets }
        return pets.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
}
