import SwiftUI

struct PetDetailView: View {
    let pet: Pet
    @ObservedObject var viewModel: PetViewModel
    @State private var animateIn = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header Image
                ZStack(alignment: .bottomLeading) {
                    AsyncImage(url: URL(string: pet.imageUrl)) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle().fill(Color.gray.opacity(0.2))
                    }
                    .frame(width: UIScreen.main.bounds.width, height: 350)
                    .clipped()
                    .scaleEffect(animateIn ? 1.0 : 1.1) // Subtle zoom in effect
                    
                    // Gradient overlay for better text readability
                    LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.4)]), startPoint: .top, endPoint: .bottom)
                        .frame(height: 100)
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    // Title and Fav Row
                    HStack(alignment: .firstTextBaseline) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(pet.name)
                                .font(.system(size: 34, weight: .bold))
                            Text(pet.breedGroup ?? "Classic Breed")
                                .font(.title3)
                                .foregroundColor(.blue)
                        }
                        
                        Spacer()
                        
                        Button {
                            withAnimation(.interpolatingSpring(stiffness: 170, damping: 15)) {
                                viewModel.toggleFavorite(id: pet.id)
                            }
                        } label: {
                            Image(systemName: viewModel.isFavorite(pet.id) ? "heart.fill" : "heart")
                                .font(.title)
                                .foregroundColor(.red)
                                .padding(12)
                                .background(Color.red.opacity(0.1))
                                .clipShape(Circle())
                        }
                    }
                    
                    Divider()
                    
                    // Info Section
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Temperament", systemImage: "info.circle.fill")
                            .font(.headline)
                        
                        Text(pet.temperament ?? "A friendly and loving companion.")
                            .font(.body)
                            .lineSpacing(6)
                            .foregroundColor(.secondary)
                    }
                    .padding(12)
                    .background(Color.blue.opacity(0.05))
                    .cornerRadius(12)
                    
                    // Action Button
                    Button(action: {}) {
                        Text("Adopt \(pet.name)")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(14)
                            .shadow(color: .blue.opacity(0.3), radius: 10, y: 5)
                    }
                    .padding(.top, 20)
                }
                .padding(20) // Responsive padding for content
            }
        }
        .ignoresSafeArea(edges: .top)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateIn = true
            }
        }
    }
}
