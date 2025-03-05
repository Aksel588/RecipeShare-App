import SwiftUI

struct ContentView: View {
    @StateObject private var recipeStore = RecipeStore()
    @State private var showingAddSheet = false
    @State private var searchText = ""
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var filteredRecipes: [Recipe] {
        if searchText.isEmpty {
            return recipeStore.recipes
        } else {
            return recipeStore.recipes.filter { recipe in
                recipe.name.localizedCaseInsensitiveContains(searchText) ||
                recipe.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(filteredRecipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe, recipeStore: recipeStore)) {
                            RecipeCard(recipe: recipe, recipeStore: recipeStore)
                        }
                    }
                }
                .padding(16)
            }
            .searchable(text: $searchText, prompt: "Search recipes")
            .navigationTitle("Recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.orange)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddRecipeView(isPresented: $showingAddSheet, recipeStore: recipeStore)
            }
        }
    }
}

struct RecipeCard: View {
    let recipe: Recipe
    @ObservedObject var recipeStore: RecipeStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Image or Icon
            ZStack {
                if let image = recipe.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    recipe.backgroundColor.opacity(0.15)
                    Image(systemName: recipe.imageSystemName)
                        .font(.system(size: 30))
                        .foregroundColor(recipe.backgroundColor)
                }
            }
            .frame(height: 160)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            // Recipe Info
            VStack(alignment: .leading, spacing: 8) {
                Text(recipe.name)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(recipe.description)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Label(recipe.cookingTime, systemImage: "clock")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            recipeStore.toggleFavorite(recipe)
                        }
                    }) {
                        Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 16))
                            .foregroundColor(recipe.backgroundColor)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
}

#Preview {
    ContentView()
} 