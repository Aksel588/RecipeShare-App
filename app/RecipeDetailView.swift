import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @ObservedObject var recipeStore: RecipeStore
    @Environment(\.dismiss) var dismiss
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    @State private var selectedSection = 0
    @State private var animateHeader = false
    
    let sections = ["Overview", "Ingredients", "Steps", "Tips"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero Image Section with Enhanced Parallax
                GeometryReader { geometry in
                    let minY = geometry.frame(in: .global).minY
                    ZStack {
                        if let image = recipe.image {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: geometry.size.height + (minY > 0 ? minY : 0))
                                .clipped()
                                .offset(y: minY > 0 ? -minY : 0)
                                .overlay(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            .clear,
                                            .black.opacity(0.3),
                                            .black.opacity(0.7)
                                        ]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                        } else {
                            ZStack {
                                recipe.backgroundColor.opacity(0.15)
                                Image(systemName: recipe.imageSystemName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(recipe.backgroundColor)
                                    .shadow(color: recipe.backgroundColor.opacity(0.3), radius: 10)
                            }
                        }
                        
                        VStack {
                            Spacer()
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(recipe.name)
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    HStack(spacing: 12) {
                                        DetailTag(text: recipe.mealType, color: .white)
                                        DetailTag(text: recipe.dietaryType, color: .white)
                                    }
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 24)
                            .padding(.bottom, 24)
                        }
                    }
                }
                .frame(height: 400)
                
                // Content Section with Enhanced Design
                VStack(spacing: 24) {
                    // Section Picker
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(0..<sections.count, id: \.self) { index in
                                VStack(spacing: 8) {
                                    Text(sections[index])
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(selectedSection == index ? recipe.backgroundColor : .secondary)
                                    
                                    Rectangle()
                                        .fill(selectedSection == index ? recipe.backgroundColor : .clear)
                                        .frame(height: 2)
                                }
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3)) {
                                        selectedSection = index
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    // Dynamic Content based on selected section
                    switch selectedSection {
                    case 0:
                        OverviewSection(recipe: recipe)
                    case 1:
                        IngredientsSection(recipe: recipe)
                    case 2:
                        StepsSection(recipe: recipe)
                    case 3:
                        TipsSection(recipe: recipe)
                    default:
                        EmptyView()
                    }
                }
                .padding(.top, 16)
                .background(Color(.systemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 32))
                .offset(y: -35)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 16) {
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            recipeStore.toggleFavorite(recipe)
                        }
                    }) {
                        Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 22))
                            .foregroundColor(recipe.backgroundColor)
                    }
                    
                    Menu {
                        Button(action: { showingEditSheet = true }) {
                            Label("Edit Recipe", systemImage: "pencil")
                        }
                        Button(role: .destructive, action: { showingDeleteAlert = true }) {
                            Label("Delete Recipe", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(recipe.backgroundColor)
                    }
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            AddRecipeView(isPresented: $showingEditSheet, recipeStore: recipeStore, editingRecipe: recipe)
        }
        .alert("Delete Recipe", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                recipeStore.removeRecipe(recipe)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this recipe?")
        }
    }
}

// Overview Section
struct OverviewSection: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(spacing: 24) {
            Text(recipe.description)
                .font(.system(size: 17))
                .foregroundColor(.secondary)
                .lineSpacing(4)
                .padding(.horizontal, 24)
            
            // Info Cards
            HStack(spacing: 16) {
                InfoCard(
                    icon: "clock.fill",
                    title: "Cooking Time",
                    value: recipe.cookingTime,
                    color: recipe.backgroundColor
                )
                InfoCard(
                    icon: "person.2.fill",
                    title: "Servings",
                    value: "\(recipe.servings)",
                    color: recipe.backgroundColor
                )
                InfoCard(
                    icon: "chart.bar.fill",
                    title: "Difficulty",
                    value: recipe.difficulty,
                    color: recipe.backgroundColor
                )
            }
            .padding(.horizontal, 24)
            
            // Nutrition Info
            VStack(alignment: .leading, spacing: 16) {
                Text("Nutrition Info")
                    .font(.system(size: 20, weight: .bold))
                
                VStack(spacing: 12) {
                    NutritionRow(title: "Calories", value: "320 kcal", color: recipe.backgroundColor)
                    NutritionRow(title: "Protein", value: "12g", color: recipe.backgroundColor)
                    NutritionRow(title: "Carbs", value: "45g", color: recipe.backgroundColor)
                    NutritionRow(title: "Fat", value: "14g", color: recipe.backgroundColor)
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(color: recipe.backgroundColor.opacity(0.1), radius: 15)
            )
            .padding(.horizontal, 24)
        }
        .padding(.bottom, 24)
    }
}

// Ingredients Section
struct IngredientsSection: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ForEach(recipe.ingredients, id: \.self) { ingredient in
                HStack(spacing: 14) {
                    Circle()
                        .fill(recipe.backgroundColor)
                        .frame(width: 10, height: 10)
                    
                    Text(ingredient)
                        .font(.system(size: 17))
                    
                    Spacer()
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: recipe.backgroundColor.opacity(0.1), radius: 15)
        )
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
    }
}

// Steps Section
struct StepsSection: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ForEach(0..<5) { index in
                HStack(alignment: .top, spacing: 16) {
                    Text("\(index + 1)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(recipe.backgroundColor)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .fill(recipe.backgroundColor.opacity(0.15))
                        )
                    
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore.")
                        .font(.system(size: 17))
                        .lineSpacing(4)
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: recipe.backgroundColor.opacity(0.1), radius: 15)
        )
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
    }
}

// Tips Section
struct TipsSection: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ForEach(0..<3) { index in
                HStack(alignment: .top, spacing: 16) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 20))
                        .foregroundColor(recipe.backgroundColor)
                        .frame(width: 32, height: 32)
                    
                    Text("Pro tip \(index + 1): Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
                        .font(.system(size: 17))
                        .lineSpacing(4)
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: recipe.backgroundColor.opacity(0.1), radius: 15)
        )
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
    }
}

struct NutritionRow: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 17))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(color)
        }
    }
}

struct InfoCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 26))
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: color.opacity(0.1), radius: 15)
        )
    }
}

struct DetailTag: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.system(size: 15, weight: .medium))
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(color.opacity(0.15))
                    .overlay(
                        Capsule()
                            .strokeBorder(color.opacity(0.2), lineWidth: 1)
                    )
            )
            .foregroundColor(color)
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            let store = RecipeStore()
            RecipeDetailView(
                recipe: Recipe(
                    name: "Classic Pancakes",
                    description: "Fluffy homemade pancakes perfect for breakfast",
                    mealType: "Breakfast",
                    dietaryType: "Vegetarian",
                    ingredients: ["Flour", "Milk", "Eggs", "Sugar", "Baking Powder"],
                    imageSystemName: "fork.knife",
                    cookingTime: "20 mins",
                    servings: 4,
                    difficulty: "Easy",
                    isFavorite: false,
                    backgroundColor: .orange
                ),
                recipeStore: store
            )
        }
    }
} 