
# 🐾 Buddy Finder

**Buddy Finder** is a modern, high-performance iOS application built to help users discover and favorite their future furry friends. This project demonstrates industry-standard iOS architecture, moving from Flutter concepts to native Swift excellence.

---

## ✨ Features

* **Dynamic Grid Layout**: A pixel-perfect, responsive `LazyVGrid` with consistent card sizing and aspect-ratio-locked imagery.
* **Protocol-Oriented DI**: Decoupled networking logic using Swift Protocols for high testability.
* **Favorites System**: Local persistence using `UserDefaults` (equivalent to Shared Preferences) with a reactive UI.
* **Advanced Animations**: Spring-based heart animations and asynchronous image loading.
* **Native Theming**: Full support for **Dark Mode** using `@AppStorage`.
* **Search & Sort**: Real-time filtering and multi-criteria sorting (Price, Breed).

---

## 🏗️ Architecture (MVVM + DI)

The app follows the **Model-View-ViewModel** design pattern to ensure a clean separation of concerns:

1. **Model**: `Pet.swift` handles data parsing and contains computed properties for dynamic image URL construction.
2. **View**: Declarative SwiftUI views (`PetCard`, `DashboardView`) that react to state changes.
3. **ViewModel**: `PetViewModel.swift` manages the business logic, state (`@Published`), and dependency injection.
4. **Service (Protocol)**: `PetServiceProtocol` defines the contract for data fetching, allowing for easy mocking during Unit Testing.

---

## 🛠️ Tech Stack

* **UI**: SwiftUI 5
* **Concurrency**: Swift Concurrency (`async/await`)
* **Storage**: `@AppStorage` & `UserDefaults`
* **API**: [The Dog API](https://thedogapi.com/)
* **Networking**: `URLSession` with JSON Decoding

---

## 📸 UI Snapshots


<img width="642" height="1389" alt="Screenshot 2025-12-28 at 10 07 22 PM" src="https://github.com/user-attachments/assets/4b494f1a-a22e-400d-b3d4-de9d58cba4b7" />

| Dashboard (Uniform Grid) | Pet Details | Settings (Dark Mode) |
| --- | --- | --- |
|  |  |  |

---

## 🚀 Getting Started

1. **Clone the repo:**
```bash
git clone https://github.com/yourusername/BuddyFinder-iOS.git

```


2. **Open in Xcode:**
Open `BuddyFinder.xcodeproj`.
3. **Build and Run:**
Select your favorite Simulator (e.g., iPhone 15) and hit `Cmd + R`.

---

## 📝 To-Do / Roadmap

* [ ] Add Unit Tests for `PetViewModel`.
* [ ] Implement Skeleton/Shimmer loading effect.
* [ ] Add a "Favorites Only" filter toggle.
* [ ] Support for iPad (SplitView).

---

## 🤝 Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request.

**Developed with ❤️ by [Farooq]**

---

### How to add this to your project:

1. In your project root folder (in the Terminal), type: `touch README.md`.
2. Open it in any text editor (or Xcode) and paste the code block above.
3. Replace the placeholders (like `yourusername`) with your actual details.
4. **Commit it:** `git add README.md && git commit -m "Add professional README"`

