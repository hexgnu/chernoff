require './face_vector'
require './face_painter'

Shoes.app(:title => "Chernoff Faces!") do    
  app = self
  f = FaceVector.new
  fp = FacePainter.new
  fp.draw(app, f, 20, 20, 100, 100)
end


__END__
class Face
  SCALE = 100
  
  def self.random_face(app)
    Face.new(*([app, 0.9] + 17.times.map { rand }))
  end
  
  def initialize(app, x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18)
    # x1 = height  of upper face
    # x2 = overlap of lower face
    # x3 = half of vertical size of face
    # x4 = width of upper face
    # x5 = width of lower face
    # x6 = length of nose
    # x7 = vertical position of mouth
    # x8 = curvature of mouth
    # x9 = width of mouth
    # x10 = vertical position of eyes
    # x11 = separation of eyes
    # x12 = slant of eyes
    # x13 = eccentricity of eyes
    # x14 = size of eyes
    # x15 = position of pupils
    # x16 = vertical position of eyebrows
    # x17 = slant of eyebrows
    # x18 = size of eyebrows
    
    @app = app
    @x1 = x1
    @x2 = x2
    @x3 = 1.9 * (x3 - 0.5)
    @x4 = (x4 + 0.25)
    @x5 = (x5 + 0.2)
    @x6 = 0.3 * (x6 + 0.01)
    @x7 = x7
    @x8 = 5 * (x8 + 0.001)
    @x9 = x9
    @x10 = x10
    @x11 = x11 / 5.0
    @x12 = 2 * (x12 - 0.5)
    @x13 = x13 + 0.05
    @x14 = x14 + 0.1
    @x15 = 0.5 * (x15 - 0.5)
    @x16 = 0.25 * x16
    @x17 = 0.5 * (x17 - 0.5)
    @x18 = 0.5 * (x18 + 0.1)
    
    18.times do |i|
      instance_variable_set("@x#{i + 1}", instance_variable_get("@x#{i + 1}") * SCALE)
    end 
      
    @app.stroke @app.red
    @app.nofill
    draw_top_of_face!
    draw_bottom_of_face!
    cover_overlaps!
    draw_nose!
    draw_mouth!
  end
  
  def draw_top_of_face!
    @app.fill @app.white
    @app.stroke @app.black
    @app.strokewidth 2
    @app.oval(0, (@x1 + @x3) / 2.0, 2 * @x4)
  end
  
  def draw_bottom_of_face!
    @app.stroke @app.black
    @app.fill @app.white
    @app.strokewidth 2
    @app.oval(0, (-@x1 + @x2 + @x3) / 2.0, 2 * @x5, (@x1 + @x2 + @x3))
    # bottom of face, in box with l=-x5, r=x5, b=-x1, t=x2+x3
    # e = mpl.patches.Ellipse( (0,(-x1+x2+x3)/2), 2*x5, (x1+x2+x3), fc='white', linewidth=2)
    #     ax.add_artist(e)
  end
  
  def cover_overlaps!
    @app.nostroke
    @app.fill @app.white
    @app.oval(0, (@x1 + @x3) / 2.0, 2 * @x4, (@x1 - @x3))
    @app.oval(0, (-@x1 + @x2 + @x3) / 2.0, 2 * @x5, (@x1 + @x2 + @x3))
    # e = mpl.patches.Ellipse( (0,(x1+x3)/2), 2*x4, (x1-x3), fc='white', ec='none')
    #    ax.add_artist(e)
    #    e = mpl.patches.Ellipse( (0,(-x1+x2+x3)/2), 2*x5, (x1+x2+x3), fc='white', ec='none')
    #    ax.add_artist(e)
  end
  
  def draw_nose!
    @app.stroke @app.black
    @app.line(0,0 -@x6 / 2.0, @x6 / 2.0)
    # plot([0,0], [-x6/2, x6/2], 'k')
  end
  
  def draw_mouth!
    @app.arc(0, (-@x7 + 0.5 / @x8), 1 / @x8, 1/ @x8, 270 - 180 / Math::PI * Math::atan(@x8 * @x9), 270 + 180 / Math::PI * Math::atan(@x8 * @x9))
    # p = mpl.patches.Arc( (0,-x7+.5/x8), 1/x8, 1/x8, theta1=270-180/pi*arctan(x8*x9), theta2=270+180/pi*arctan(x8*x9))
    # ax.add_artist(p)
  end
  
  def draw_eyes!
    @app.rotate -180 / Math::PI * @x12
    @app.fill @app.white
    @app.oval -@x11 - @x14 / 2, @x10, @x14, @x13 * @x14
    
    @app.oval @x11 + @x14 / 2, @x10, @x14, @x13 * @x14
    
    # p = mpl.patches.Ellipse( (-x11-x14/2,x10), x14, x13*x14, angle=-180/pi*x12, facecolor='white')
    #     ax.add_artist(p)
    #     
    #     p = mpl.patches.Ellipse( (x11+x14/2,x10), x14, x13*x14, angle=180/pi*x12, facecolor='white')
    #     ax.add_artist(p)
  end
  
  def draw_pupils!
    # p = mpl.patches.Ellipse( (-x11-x14/2-x15*x14/2, x10), .05, .05, facecolor='black')
    #     ax.add_artist(p)
    #     p = mpl.patches.Ellipse( (x11+x14/2-x15*x14/2, x10), .05, .05, facecolor='black')
    #     ax.add_artist(p)
  end
  
  def draw_eyebrows!
    # plot([-x11-x14/2-x14*x18/2,-x11-x14/2+x14*x18/2],[x10+x13*x14*(x16+x17),x10+x13*x14*(x16-x17)],'k')
    #     plot([x11+x14/2+x14*x18/2,x11+x14/2-x14*x18/2],[x10+x13*x14*(x16+x17),x10+x13*x14*(x16-x17)],'k')
  end
end


class Messenger
  def initialize(app)
    @app = app
    @app.para 'zomg'
  end
end



