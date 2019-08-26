# We refactored our Controller#import method and created a ScrapeService
class ScrapeService
  def initialize(keyword)
    @keyword = keyword
    @url = "https://www.marmiton.org/recettes/recherche.aspx?aqt=" + @keyword
  end

  def call
    # 1. Open url
    html = open(@url).read
    # 2. parse html
    doc = Nokogiri::HTML(html, nil, 'utf-8')
    # 3. For the five first searches
    doc.search(".recipe-card").first(5).map do |element|
      # Get the name
      name = element.search(".recipe-card__title").text.strip
      # Get the description
      description = element.search(".recipe-card__description").text.strip
      prep_time = element.search(".recipe-card__duration__value").text.strip
      # Create recipe objects from name, description
      # And store in array (We use map.)
      Recipe.new(name: name, description: description, prep_time: prep_time)
    end
    # This method returns the array given by the map method on line 14.
  end
end
