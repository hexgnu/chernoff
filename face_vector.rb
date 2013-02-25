class FaceVector
  FEATURES = %w[head_size]
  
  attr_reader :points
  attr_reader *FEATURES
  
  def initialize
    # Makes an 11 point vector
    @points = []
    (1..11).each do |i|
      @points[i] = rand
    end
    
    FEATURES.each do |feature|
      instance_variable_set("@#{feature}", rand)
    end
  end
  
end