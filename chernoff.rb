require './face_vector'
require './face_painter'

Shoes.app(:title => "Chernoff Faces!", :width => 600, :height => 400) do    
  app = self
  f = FaceVector.new
  fp = FacePainter.new
  
  
  
  x = 0
  y = 0
  per_row = 4
  
  # fp.draw(app, f, 0, 0, 100, 100)
  4.times do |rn|
    y = rn * 100
    6.times do |j|
      x = j * 100
      
      fp.draw(app, FaceVector.new, x, y, 100, 100)
    end
  end
end