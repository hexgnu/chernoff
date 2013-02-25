class FaceVector
  attr_reader :points
  def initialize
    # Makes an 11 point vector
    @points = []
    (1..11).each do |i|
      @points[i] = rand
    end
  end
  
  def distance(face_vector)
    sum = 0.0
    @points.each_with_index do |point, i|
      diff = point - face_vector.points[i]
      sum += diff * diff
    end
    Math::sqrt(sum)
  end
end