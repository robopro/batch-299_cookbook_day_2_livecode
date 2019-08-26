require 'csv'
require_relative 'recipe'

class Cookbook
  def initialize(csv_file_path)
    @csv_file_path = csv_file_path
    @recipes = []
    load_from_csv
  end

  def all
    return @recipes
  end

  def add_recipe(recipe)
    @recipes << recipe
    save_to_csv
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)
    save_to_csv
  end

  def mark_recipe(index)
    @recipes[index].mark_as_done!
    save_to_csv
  end

  private

  def load_from_csv()
    # Because we now say that the first row of the csv are headers
    # We set the headers manually in our csv file.
    csv_options = { headers: :first_row, header_converters: :symbol }
    CSV.foreach(@csv_file_path, csv_options) do |row|
      # The data from the csv is read in as instances of String clas.
      # We need to transform the row[:done] to a boolean.
      row[:done] = row[:done] == "true"
      @recipes << Recipe.new(row)
    end
  end

  def save_to_csv
    CSV.open(@csv_file_path, 'wb') do |csv|
      # Instead of writing our headers manually we just call the headers
      # class method on the Recipe class.
      csv << Recipe.headers
      @recipes.each do |recipe|
        csv << recipe.to_csv
      end
    end
  end
end
