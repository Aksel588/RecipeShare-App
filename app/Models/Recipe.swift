import SwiftUI

struct Recipe: Identifiable {
    let id: UUID
    var name: String
    var description: String
    var mealType: String
    var dietaryType: String
    var ingredients: [String]
    var imageSystemName: String
    var cookingTime: String
    var servings: Int
    var difficulty: String
    var isFavorite: Bool
    var backgroundColor: Color
    var image: UIImage?
    
    static let difficulties = ["Easy", "Medium", "Hard"]
    static let backgroundColors: [Color] = [.orange, .pink, .blue, .green, .purple]
    
    init(
        id: UUID = UUID(),
        name: String,
        description: String,
        mealType: String,
        dietaryType: String,
        ingredients: [String],
        imageSystemName: String,
        cookingTime: String,
        servings: Int,
        difficulty: String,
        isFavorite: Bool = false,
        backgroundColor: Color = .orange,
        image: UIImage? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.mealType = mealType
        self.dietaryType = dietaryType
        self.ingredients = ingredients
        self.imageSystemName = imageSystemName
        self.cookingTime = cookingTime
        self.servings = servings
        self.difficulty = difficulty
        self.isFavorite = isFavorite
        self.backgroundColor = backgroundColor
        self.image = image
    }
}

// Filtered Recipes (Only Two-Word Names)
extension Recipe {
    static let sampleRecipes: [Recipe] = [
        Recipe(name: "Grilled Salmon", description: "Perfectly grilled salmon with lemon and herbs", mealType: "Dinner", dietaryType: "Gluten-Free", ingredients: ["Salmon fillet", "Lemon", "Olive Oil", "Fresh herbs", "Garlic"], imageSystemName: "flame", cookingTime: "25 mins", servings: 2, difficulty: "Medium", backgroundColor: .pink),
        
        Recipe(name: "Quinoa Buddha", description: "Nutritious bowl with quinoa, roasted vegetables, and tahini dressing", mealType: "Lunch", dietaryType: "Vegan", ingredients: ["Quinoa", "Sweet potato", "Chickpeas", "Kale", "Tahini", "Lemon"], imageSystemName: "leaf.circle", cookingTime: "40 mins", servings: 2, difficulty: "Medium", backgroundColor: .blue),
       
        Recipe(name: "Chicken Alfredo", description: "Creamy Alfredo sauce with tender chicken and pasta", mealType: "Dinner", dietaryType: "Non-Vegetarian", ingredients: ["Chicken", "Pasta", "Cream", "Parmesan Cheese", "Garlic"], imageSystemName: "fork.knife", cookingTime: "30 mins", servings: 3, difficulty: "Medium", backgroundColor: .purple),
        
        Recipe(name: "Berry Smoothie", description: "A refreshing and healthy berry smoothie", mealType: "Beverage", dietaryType: "Vegan", ingredients: ["Strawberries", "Blueberries", "Banana", "Almond Milk"], imageSystemName: "cup.and.saucer", cookingTime: "5 mins", servings: 1, difficulty: "Easy", backgroundColor: .pink),
   
      
        Recipe(name: "Carbonara Pasta", description: "Traditional Italian pasta dish with creamy sauce", mealType: "Dinner", dietaryType: "Non-Vegetarian", ingredients: ["Pasta", "Eggs", "Pancetta", "Parmesan"], imageSystemName: "fork.knife", cookingTime: "20 mins", servings: 2, difficulty: "Medium", backgroundColor: .red),
        
        Recipe(name: "Greek Yogurt", description: "Healthy and delicious Greek yogurt layered with fruits", mealType: "Breakfast", dietaryType: "Vegetarian", ingredients: ["Greek Yogurt", "Granola", "Berries", "Honey"], imageSystemName: "cup.and.saucer", cookingTime: "5 mins", servings: 1, difficulty: "Easy", backgroundColor: .blue)
    ]
}
