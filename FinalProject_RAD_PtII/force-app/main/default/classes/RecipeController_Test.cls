@isTest
public with sharing class RecipeController_Test {
    public RecipeController_Test() {

    }

@isTest 
static void testAddIngredient(){
    TestFactory.generateIngredients(5); // Call generateIngredients method in the TestFactory class passing in the number of Ingredients to be created
}

//@isTest
//public static void testGenerateGroceryList() {
    
//}

//@isTest
//public static void testScaleRecipeForServings() {
    
//}
}
