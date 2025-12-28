import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            Text("Settings Page") // Placeholder for Settings
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .accentColor(.blue) // The "Primary Color" for your theme
    }
}


import SwiftUI

struct DashboardView: View {
    @StateObject var viewModel = PetViewModel(service: DogAPIService())
    @State private var showSortOptions = false
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    if viewModel.isLoading {
                        ProgressView("Finding Buddies...")
                            .padding(.top, 50)
                    } else {
                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(viewModel.filteredPets) { pet in
                                NavigationLink(value: pet) {
                                    PetCard(pet: pet, viewModel: viewModel)
                                }
                            }
                        }
                        .padding()
                    }
                }
                
                // Floating Action Button
                Button {
                    showSortOptions = true
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.blue)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .padding(25)
            }
            .navigationTitle("Buddy Finder")
            .searchable(text: $viewModel.searchText, prompt: "Search by name")
            .navigationDestination(for: Pet.self) { pet in
                PetDetailView(pet: pet, viewModel: viewModel)
            }
            // Use this simplified version to help the compiler
            .confirmationDialog("Sort By", isPresented: $showSortOptions) {
                Button("Price") {
                    viewModel.sortPets(by: "Price")
                }
                Button("Category") {
                    viewModel.sortPets(by: "Category")
                }
                Button("Cancel", role: .cancel) { }
            }
        }
        .task {
            await viewModel.getPets()
        }
    }
}
// Custom Widget for the Grid Item
struct PetCard: View {
    let pet: Pet
    @ObservedObject var viewModel: PetViewModel // Pass ViewModel to track favorites
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: pet.image?.url ?? "")) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Rectangle().fill(Color.gray.opacity(0.2))
                }
                .frame(height: 150)
                .cornerRadius(12)
                
                // Heart Toggle
                Button {
                    withAnimation(.spring()) {
                        viewModel.toggleFavorite(id: pet.id)
                    }
                } label: {
                    Image(systemName: viewModel.isFavorite(pet.id) ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.isFavorite(pet.id) ? .red : .white)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
                .padding(8)
            }
            
            Text(pet.name).font(.headline).lineLimit(1)
            Text("$\(pet.price)").font(.subheadline).foregroundColor(.secondary)
        }
        .padding(10)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(15)
    }
}
//#Preview {
//    MainTabView()
//}
