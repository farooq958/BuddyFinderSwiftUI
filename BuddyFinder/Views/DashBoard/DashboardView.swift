import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            SettingsView() // Placeholder for Settings
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .accentColor(.blue) // The "Primary Color" for your theme
    }
}




struct DashboardView: View {
    @StateObject var viewModel = PetViewModel(service: DogAPIService())
    @State private var showSortOptions = false
    
    // Adaptive columns: on iPad it will show more, on iPhone just 2
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    if viewModel.isLoading {
                        VStack {
                            Spacer()
                            ProgressView("Finding Buddies...")
                            Spacer()
                        }.frame(minHeight: 400)
                    } else {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.filteredPets) { pet in
                                NavigationLink(value: pet) {
                                    PetCard(pet: pet, viewModel: viewModel)
                                }
                                .buttonStyle(PlainButtonStyle()) // Prevents the grey flash on tap
                            }
                        }
                        .padding(16)
                    }
                }
                
                // FAB
                Button {
                    showSortOptions = true
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle.fill")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 64, height: 64)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                }
                .padding(25)
            }
            .navigationTitle("Buddy Finder")
            .searchable(text: $viewModel.searchText)
            .navigationDestination(for: Pet.self) { pet in
                PetDetailView(pet: pet, viewModel: viewModel)
            }
            .confirmationDialog("Sort By", isPresented: $showSortOptions) {
                Button("Price") { viewModel.sortPets(by: "Price") }
                Button("Category") { viewModel.sortPets(by: "Category") }
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
    @ObservedObject var viewModel: PetViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 1. IMAGE SECTION: Fixed Ratio
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: pet.imageUrl)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        // Placeholder prevents "jumping" when image loads
                        Color.gray.opacity(0.1)
                            .overlay(Image(systemName: "pawprint").foregroundColor(.gray))
                    }
                }
                .frame(height: 140)
                // This makes the image container fill the grid cell width
                .frame(maxWidth: .infinity)
                .clipped()
                
                // Favorite Heart
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
            
            // 2. TEXT SECTION: Forced Expansion
            VStack(alignment: .leading, spacing: 4) {
                Text(pet.name)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text("$\(pet.price)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
            .padding(12)
            // CRITICAL: This fills the background to the edges of the card
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
        }
        .frame(maxWidth: .infinity) // Ensures the whole card fills the grid slot
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.primary.opacity(0.1), lineWidth: 0.5)
        )
    }
}
//#Preview {
//    MainTabView()
//}

struct SettingsView: View {
    // Shared Preferences equivalent - automatically persists to disk
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("userName") private var userName = "Buddy Lover"
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Profile")) {
                    TextField("User Name", text: $userName)
                    Text("Welcome back, \(userName)!")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }
                
                Section(header: Text("Preferences")) {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                    
                    Button(role: .destructive) {
                        // Logic to clear favorites could go here
                        print("Clearing cache...")
                    } label: {
                        Text("Clear App Cache")
                    }
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
