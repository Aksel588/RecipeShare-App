import SwiftUI
import PhotosUI

struct AddRecipeView: View {
    @Binding var isPresented: Bool
    @ObservedObject var recipeStore: RecipeStore
    var editingRecipe: Recipe?
    
    @State private var name = ""
    @State private var description = ""
    @State private var selectedMealType = "Breakfast"
    @State private var selectedDietaryType = "None"
    @State private var cookingTime = ""
    @State private var servings = ""
    @State private var currentIngredient = ""
    @State private var ingredients: [String] = []
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingTimePicker = false
    @State private var selectedDifficulty = "Easy"
    @State private var selectedColor = Color.orange
    @State private var showingColorPicker = false
    
    let mealTypes = ["Breakfast", "Lunch", "Dinner", "Dessert", "Snack"]
    let dietaryTypes = ["None", "Vegetarian", "Vegan", "Gluten-Free", "Dairy-Free", "Keto"]
    
    init(isPresented: Binding<Bool>, recipeStore: RecipeStore, editingRecipe: Recipe? = nil) {
        self._isPresented = isPresented
        self.recipeStore = recipeStore
        self.editingRecipe = editingRecipe
        
        if let recipe = editingRecipe {
            _name = State(initialValue: recipe.name)
            _description = State(initialValue: recipe.description)
            _selectedMealType = State(initialValue: recipe.mealType)
            _selectedDietaryType = State(initialValue: recipe.dietaryType)
            _cookingTime = State(initialValue: recipe.cookingTime)
            _servings = State(initialValue: String(recipe.servings))
            _ingredients = State(initialValue: recipe.ingredients)
            _selectedImage = State(initialValue: recipe.image)
            _selectedDifficulty = State(initialValue: recipe.difficulty)
            _selectedColor = State(initialValue: recipe.backgroundColor)
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Image Section
                Section {
                    VStack {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(12)
                                .transition(.scale)
                        }
                        
                        Button(action: {
                            showingImagePicker = true
                        }) {
                            HStack {
                                Image(systemName: "photo")
                                Text(selectedImage == nil ? "Add Image" : "Change Image")
                            }
                            .foregroundColor(selectedColor)
                        }
                    }
                }
                
                // Basic Information
                Section(header: Text("Basic Information")) {
                    TextField("Recipe Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextEditor(text: $description)
                        .frame(height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    
                    Picker("Meal Type", selection: $selectedMealType) {
                        ForEach(mealTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    Picker("Dietary Type", selection: $selectedDietaryType) {
                        ForEach(dietaryTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                // Cooking Details
                Section(header: Text("Cooking Details")) {
                    Button(action: {
                        showingTimePicker = true
                    }) {
                        HStack {
                            Text("Cooking Time")
                            Spacer()
                            Text(cookingTime.isEmpty ? "Set Time" : cookingTime)
                                .foregroundColor(cookingTime.isEmpty ? .gray : .primary)
                        }
                    }
                    
                    TextField("Number of Servings", text: $servings)
                        .keyboardType(.numberPad)
                    
                    Picker("Difficulty", selection: $selectedDifficulty) {
                        ForEach(Recipe.difficulties, id: \.self) { difficulty in
                            Text(difficulty).tag(difficulty)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Color Theme
                Section(header: Text("Color Theme")) {
                    ColorPicker("Recipe Color", selection: $selectedColor)
                }
                
                // Ingredients
                Section(header: Text("Ingredients")) {
                    HStack {
                        TextField("Add ingredient", text: $currentIngredient)
                        Button(action: addIngredient) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(selectedColor)
                        }
                        .disabled(currentIngredient.isEmpty)
                    }
                    
                    ForEach(ingredients, id: \.self) { ingredient in
                        Text(ingredient)
                            .transition(.slide)
                    }
                    .onDelete(perform: deleteIngredient)
                }
            }
            .navigationTitle(editingRecipe == nil ? "New Recipe" : "Edit Recipe")
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                },
                trailing: Button("Save") {
                    saveRecipe()
                }
                .disabled(!isValidRecipe)
            )
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $selectedImage)
            }
            .sheet(isPresented: $showingTimePicker) {
                TimePickerView(cookingTime: $cookingTime)
            }
        }
    }
    
    private var isValidRecipe: Bool {
        !name.isEmpty && !description.isEmpty && !ingredients.isEmpty &&
        !cookingTime.isEmpty && !servings.isEmpty
    }
    
    private func addIngredient() {
        withAnimation {
            guard !currentIngredient.isEmpty else { return }
            ingredients.append(currentIngredient)
            currentIngredient = ""
        }
    }
    
    private func deleteIngredient(at offsets: IndexSet) {
        withAnimation {
            ingredients.remove(atOffsets: offsets)
        }
    }
    
    private func saveRecipe() {
        let recipe = Recipe(
            id: editingRecipe?.id ?? UUID(),
            name: name,
            description: description,
            mealType: selectedMealType,
            dietaryType: selectedDietaryType,
            ingredients: ingredients,
            imageSystemName: "fork.knife",
            cookingTime: cookingTime,
            servings: Int(servings) ?? 1,
            difficulty: selectedDifficulty,
            isFavorite: editingRecipe?.isFavorite ?? false,
            backgroundColor: selectedColor,
            image: selectedImage
        )
        
        if editingRecipe != nil {
            recipeStore.updateRecipe(recipe)
        } else {
            recipeStore.addRecipe(recipe)
        }
        isPresented = false
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.image = image as? UIImage
                    }
                }
            }
        }
    }
}

#Preview {
    AddRecipeView(isPresented: .constant(true), recipeStore: RecipeStore())
} 