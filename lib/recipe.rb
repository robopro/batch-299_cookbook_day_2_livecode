class Recipe
  def initialize(attributes = {})
    @name = attributes[:name]
    @description = attributes[:description]
    @prep_time = attributes[:prep_time]
    @done = attributes[:done] || false
  end

  def mark_as_done!
    @done = true
  end

  def to_s
    x = @done ? "x" : " "
    return "[#{x}] #{@name} - #{@description} (#{@prep_time})"
  end

  def to_csv
    return [@name, @description, @prep_time, @done]
  end

  def self.headers
    %w[name description prep_time done]
  end
end
