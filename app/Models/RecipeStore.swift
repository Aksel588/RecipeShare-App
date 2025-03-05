import SwiftUI

final class RecipeStore: ObservableObject {
    @Published var recipes: [Recipe]
    
    init() {
        self.recipes = Recipe.sampleRecipes
    }
    
    func addRecipe(_ recipe: Recipe) {
        recipes.append(recipe)
    }
    
    func updateRecipe(_ recipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes[index] = recipe
        }
    }
    
    func removeRecipe(_ recipe: Recipe) {
        recipes.removeAll { $0.id == recipe.id }
    }
    
    func toggleFavorite(_ recipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes[index].isFavorite.toggle()
        }
    }
} 