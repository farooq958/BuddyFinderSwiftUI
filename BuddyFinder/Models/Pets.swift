import Foundation

struct Pet: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let breedGroup: String?
    let temperament: String?
    let referenceImageId: String? // This matches the JSON key
    
    // The "Flutter Getter" equivalent in Swift
    var imageUrl: String {
        guard let id = referenceImageId else { return "" }
        return "https://cdn2.thedogapi.com/images/\(id).jpg"
    }

    var price: Int { id * 5 + 50 }

    enum CodingKeys: String, CodingKey {
        case id, name, temperament
        case breedGroup = "breed_group"
        case referenceImageId = "reference_image_id"
    }
}
