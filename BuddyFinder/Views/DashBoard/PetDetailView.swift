import SwiftUI

struct PetDetailView: View {
    let pet: Pet
    @ObservedObject var viewModel: PetViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncImage(url: URL(string: pet.image?.url ?? "")) { image in
                    image.resizable().scaledToFill()
                } placeholder: { ProgressView() }
                .frame(maxWidth: .infinity)
                .frame(height: 350).clipped()
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(pet.name).font(.largeTitle.bold())
                        Spacer()
                        
                        // Favorite Toggle in Detail
                        Button {
                            viewModel.toggleFavorite(id: pet.id)
                        } label: {
                            Image(systemName: viewModel.isFavorite(pet.id) ? "heart.fill" : "heart")
                                .font(.title)
                                .foregroundColor(.red)
                        }
                    }
                    
                    Text(pet.breedGroup ?? "Breed").font(.title3).foregroundColor(.blue)
                    Divider()
                    Text("Temperament").font(.headline)
                    Text(pet.temperament ?? "Gentle and loving.").foregroundColor(.secondary)
                }
                .padding()
            }
        }
    }
}
