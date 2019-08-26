# This is the import method before we refactored it.
def import
  # 1. Ask the user through the view for an ingredient(keyword)
  keyword = @view.ask_for("ingredient")
  # 2. open url (with keyword)
  url = "https://www.marmiton.org/recettes/recherche.aspx?aqt=" + keyword
  html = open(url).read
  # 3. parse html
  doc = Nokogiri::HTML(html, nil, 'utf-8')
  # 4. For the five first searches
  # results = []
  results = doc.search(".recipe-card").first(5).map do |element|
    # Get the name
    name = element.search(".recipe-card__title").text.strip
    # Get the description
    description = element.search(".recipe-card__description").text.strip
    # Create recipe objects from name, description
    # And store in array
    Recipe.new(name, description)
  end
  # 5. show a list of recipes to the user
  @view.display(results)
  # 6. Ask user to pick recipe they want to save (index)
  index = @view.ask_for_index
  # 7. Add recipe user picks to cookbook
  @cookbook.add_recipe(results[index])
  # 8. List all recipes *in the cookbook*
  list
end
