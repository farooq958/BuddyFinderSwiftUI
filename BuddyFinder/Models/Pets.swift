import Foundation

struct Pet: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let breedGroup: String?
    let temperament: String?
    let image: PetImage?
    
    // We'll create a dummy price based on ID for the sorting exercise
    var price: Int { id * 5 + 50 }

    enum CodingKeys: String, CodingKey {
        case id, name, temperament, image
        case breedGroup = "breed_group"
    }
}

struct PetImage: Codable, Hashable {
    let url: String
}
