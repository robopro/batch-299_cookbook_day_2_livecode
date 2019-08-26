require 'open-uri'
require 'nokogiri'
require_relative 'view'
require_relative 'scrape_service'

class Controller
  def initialize(cookbook)
    @cookbook = cookbook
    @view = View.new
  end

  def list
    recipes = @cookbook.all
    @view.display(recipes)
  end

  def create
    name = @view.ask_for("name")
    description = @view.ask_for("description")
    # We added @prep time to our model, so we also need to add it here.
    prep_time = @view.ask_for("prepping time")
    # We added @done to our model, but we set a default value for that and won't
    # ask the user to set it when he creates a new recipe.
      # ie. we assume he hasn't made the recipe yet when he adds it.

    # We're passing the arguments as a hash
    attributes = { name: name, description: description, prep_time: prep_time}
    recipe = Recipe.new(attributes)
    @cookbook.add_recipe(recipe)
  end

  def destroy
    list
    index = @view.ask_for_index
    @cookbook.remove_recipe(index)
  end

  def mark
    # 1. List all the recipes
    list
    # 2. Ask the user for which recipe (index)
    index = @view.ask_for_index
    # 3. Get the recipe at index from the cookbook
      # We made the method in the cookbook because we didn't want to
      # expose the #save_to_csv method
    recipe = @cookbook.mark_recipe(index)
    # 4. List all recipes again
    list
  end

  def import
    # 1. Ask the user through the view for an ingredient(keyword)
    keyword = @view.ask_for("ingredient")
    # 2. Call the ScrapeService to scrape marmiton for recipes with
      # our keyword (ingredient) in them.
    results = ScrapeService.new(keyword).call
    # 3. show a list of recipes to the user
    @view.display(results)
    # 4. Ask user to pick recipe they want to save (index)
    index = @view.ask_for_index
    # 5. Add recipe user picks to cookbook
    @cookbook.add_recipe(results[index])
    # 6. List all recipes *in the cookbook*
    list
  end
end
