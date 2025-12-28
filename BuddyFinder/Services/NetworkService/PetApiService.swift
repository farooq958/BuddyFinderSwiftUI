import Foundation

// 1. The Contract (Interface)
protocol PetServiceProtocol {
    func fetchPets() async throws -> [Pet]
}

// 2. The Implementation (Real API)
class DogAPIService: PetServiceProtocol {
    private let urlString = "https://api.thedogapi.com/v1/breeds?limit=25"
    
    func fetchPets() async throws -> [Pet] {
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Pet].self, from: data)
    }
}
