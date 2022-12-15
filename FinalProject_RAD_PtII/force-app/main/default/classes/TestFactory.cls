//Test Factory example from Trailhead: https://trailhead.salesforce.com/en/content/learn/modules/unit-testing-on-the-lightning-platform/generate-data-for-tests

@isTest
public class TestFactory {

    public static Account getAccount(String name, Boolean doInsert){
        Account a = new Account(name = name);
        if(doInsert){
            insert a;
        }
        return a;
    }

    public static Contact getContact(Id accountId, String fname, String lname, Boolean doInsert){
        Contact c = new Contact(firstName = fname, lastName = lname, accountId = accountId);
        if(doInsert){
            insert c;
        }
        return c;
    }

    public static void generateAccountWithContacts(Integer numContacts){
        Account a = getAccount('default account ltd', true);
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 0; i < numContacts; i++){
            String contactName = 'contact' + i;
            contacts.add(getContact(a.id, contactName, contactName, false));
        }
        insert contacts;
    }

    public static Opportunity[] generateOppsForAccount(id accountId, Decimal amount, Integer numOpps){
        List<Opportunity> opps = new List<Opportunity>();
        for(Integer i = 0; i < numOpps; i++){
            Opportunity o = new Opportunity();
            o.name = 'Account ' + i;
            o.accountId = accountid;
            o.amount = amount;
            o.closeDate = Date.today().addDays(5);
            o.stageName = 'Prospecting';
            opps.add(o);
        }
        return opps;
    }
    
    public static User generateUser(String profileName){
        UserRole userRole = new UserRole(DeveloperName = 'TestingTeam', Name = 'Testing Team');
        insert userRole;
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = :profileName].Id,
            LastName = 'last',
            Email = 'Cpt.Awesome@awesomesauce.com',
            Username = 'Cpt.Awesome@awesomesauce.com',
            CompanyName = 'Testing Co',
            Title = 'Captian',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = userRole.Id
        );
        insert u;
        return u;
    }

    //---------------Final Project TestFactory Methods------------------------------------------------
    //---------------------------METHOD 1-------------------------------------------------------------
    @TestVisible
    public static Ingredient__c[] generateIngredients(Integer numberOfIngredients = 1) { //It should take a parameter that dictates the number of Ingredient objects to be created
       // Pull this out into separate method
       // Recipe__c testRecipe = new Recipe__c(Name = 'Test Recipe');      // Create a new test Recipe object
       //insert testRecipe;                                               // Comit test Recipe object

        List<Ingredient__c> ingredientList = new List<Ingredient__c>(); // Create a list of Ingredient sObject records

        for (Integer i = 0; i < numberOfIngredients; i++) {
                i = i++;
                Ingredient__c newIngredient = new Ingredient__c();
                newIngredient.Name = 'Ingredient ' + i;
                newIngredient.Recipe__c = testRecipe.Id;
                newIngredient.Measurement__c = (Math.Random() * 10);       
                newIngredient.Measurement_Type__c = 'Tsp';
                ingredientList.add(newIngredient);
                
        }

        // Return the list of Ingredients generated, DO NOT insert into org
        return ingredientList;
    }

    //---------------------------METHOD 2-------------------------------------------------------------
    public static Ingredient__c[] insertIngredients(Integer numberOfIngredients) { //It should take a parameter that dictates the number of Ingredient objects to be created
        // Call generateIngredients method passing in # of Ingredients argument and set it equal to a new List of Ingredients varaible
        List<Ingredient__c> ingredientsToInsert = new List<Ingredient__c>(generateIngredients(numberOfIngredients)); 
        
        insert ingredientsToInsert;     // Insert list of Ingredients into org
                 
        return ingredientsToInsert;     // Return the list of Ingredients inserted into org
    }

    //---------------------------METHOD 3-------------------------------------------------------------
    public static Recipe__c[] generateRecipes(Integer numberOfRecipes,List<Ingredient__c> childIngredients) { //It should take a parameter that dictates the number of Recipes to be created and a list of ingredients to add as child records
         List<Recipe__c> recipeList = new List<Recipe__c>(); // Create a list of Recipe sObject records
 
         for (Integer i = 0; i < numberOfRecipes; i++) {
                 i = i++;
                 Recipe__c newRecipe = new Recipe__c();
                 newRecipe.Name = 'Recipe ' + i;
                 newRecipe.Description__c = 'Test Description for Recipe ' +i;
                
                 recipeList.add(newRecipe);
                 
         }
         insert recipeList;     // Insert list of Recipes into org
                 
         return recipeList;     // Return the list of Recipes inserted into org

     } 
}
