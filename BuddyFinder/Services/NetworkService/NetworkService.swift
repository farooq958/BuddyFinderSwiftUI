import Foundation

class NetworkManager {
    static let shared = NetworkManager() // Singleton
    private let urlString = "https://api.thedogapi.com/v1/breeds?limit=20"
    
    func fetchPets() async throws -> [Pet] {
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        
        // await is used just like in Flutter
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // JSONDecoder is like jsonDecode() in Dart
        let decoder = JSONDecoder()
        return try decoder.decode([Pet].self, from: data)
    }
}
