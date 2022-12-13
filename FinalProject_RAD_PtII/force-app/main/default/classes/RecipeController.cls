public inherited sharing class RecipeController {
        
    //adds ingredients to recipe and saves to database
    @AuraEnabled
    public static void addIngredient(String ingredientName, Integer measurementAmount, String measurementType, ID recipeId){

	    //Create ingredient sObject in memory and insert to database
        Ingredient__c ingred = new Ingredient__c();

           //add ingredient data into the ingredient record for the recipe being passed in
           ingred.Recipe__c = recipeId;
           ingred.Name = ingredientName;
           ingred.Measurement__c = measurementAmount;
           ingred.Measurement_Type__c = measurementType; 
        
        //insert ingredients into the database
        insert ingred;
    }
    
    //this method gets the list of ingredients that are children of a Recipe. 
    @AuraEnabled
    public static List < Ingredient__c > generateGroceryList(Id recipeId){
        
	//queries for and returns the ingredient records and data for the recipe requested
	List < Ingredient__c > ingredList = [SELECT Id, Name, Measurement__c, Measurement_Type__c, Notes__c
                                         FROM Ingredient__c
                                         WHERE Recipe__c =: recipeId];
        
    System.Debug('Needed Ingredients' + ingredList);
        
    //return list of ingredients needed;
    return ingredList;    		
    }

    //Scale the recipe and return the list of scaled ingredients
    @AuraEnabled
public static List < Ingredient__c > scaleRecipeForServings(ID recipeId,Decimal desiredServings){
	
    //queries for and returns the ingredient records and data for recipe requested that we need to scale
    List < Ingredient__c > ingredListToScale = [SELECT Id, Name, Measurement__c, Measurement_Type__c, Notes__c
                                                FROM Ingredient__c
                                                WHERE Recipe__c =: recipeId];

    //queries for the serving size requested on the recipe being called
    Recipe__c servSize = [SELECT Servings__c FROM Recipe__c WHERE Id =: recipeId];
        
    //this method will calculate the amount to scale for desired servings
    Decimal scaledIngred = desiredServings / servSize.Servings__c;
        
        System.Debug('NewServSize = ' + scaledIngred);
        
    //loop through list of ingredients to calculate desired servings
        for (ingredient__c ingred : ingredListToScale){
            ingred.Measurement__c = ingred.Measurement__c * scaledIngred;
        } 
        
    //return list of scaled ingredients
    return ingredListToScale;    
    }
    
    
    @AuraEnabled(Cacheable=true)
    public static Recipe__c[] getAllRecipes() {
        return [
            SELECT
                Id,
                Name,
                Draft__c,
                Active_Time__c,
                Active_Time_Units__c,
                Complexity__c,
                Needs_Review__c,
                Possible_Duplicate__c,
                Season__c
            FROM Recipe__c
            ORDER BY Name
            LIMIT 50
        ];
    }

    @AuraEnabled(Cacheable=true)
    public static Recipe__c[] searchRecipes(String searchTerm) {
        // Return all recipes when no search term
        searchTerm = searchTerm.trim();
        if (searchTerm == '') {
            System.debug('returning: '+getAllRecipes());
            return getAllRecipes();
        }
        // Prepare query paramters
        searchTerm = '%' + searchTerm + '%';
        // Execute search query
        return [
            SELECT
                Id,
                Name,
                Draft__c,
                Active_Time__c,
                Active_Time_Units__c,
                Complexity__c,
                Needs_Review__c,
                Possible_Duplicate__c,
                Season__c
            FROM Recipe__c
            WHERE Name LIKE :searchTerm
            ORDER BY Name
            LIMIT 50
        ];
    }
}