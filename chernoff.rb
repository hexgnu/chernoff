require './face_vector'
require './face_painter'

Shoes.app(:title => "Chernoff Faces!", :width => 600, :height => 400) do    
  app = self
  f = FaceVector.new
  
  
  
  x = 0
  y = 0
  per_row = 4
  
  4.times do |rn|
      y = rn * 100
      6.times do |j|
        x = j * 100
        
        fp = FacePainter.new(app, FaceVector.new, x,y, 100, 100)
        fp.draw!
      end
    end
end