class View
  def display(recipes)
    print `clear`
    recipes.each_with_index do |recipe, index|
      puts "#{index + 1}. #{recipe.to_s}"
    end
  end

  def ask_for(attribute)
    puts "What is the #{attribute} of the recipe?"
    return gets.chomp
  end

  def ask_for_index
    puts "Give me a number!"
    return gets.chomp.to_i - 1
  end
end
