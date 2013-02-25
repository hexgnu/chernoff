require 'matrix'
require './point.rb'
class FacePainter
  def initialize(app, face_vector, x, y, width, height)
    @head_radius = 30
    @eye_radius = 5
    @eye_left_x = 40
    @eye_right_x = 60
    @eye_y = 40
    @pupil_radius = 0.2
    @eyebrow_l_l_x = 35
    @eyebrow_r_l_x = 55
    @eyebrow_l_r_x = 45
    @eyebrow_r_r_x = 65
    @eyebrow_y = 30
    @nose_apex_x = 50
    @nose_apex_y = 45
    @nose_height = 16
    @nose_width = 8
    @mouth_y = 65
    @x_factor = width / 100.0
    @y_factor = height / 100.0
    @x_origin = x
    @y_origin = y
		
    @app = app
    @face_vector = face_vector
    @width = width
    @height = height
  end
  
  def draw!
    draw_head!
    draw_eyes!
    draw_pupils!
    draw_eyebrow!
    draw_nose!
    draw_mouth!
  end
  
  def draw_eyes!
    eye_spacing = ((@face_vector.eye_width - 0.5) * 10).to_i
    eye_size = (((@face_vector.eye_area - 0.5) / 2.0) * 10).to_i
    e = eccentricities(@face_vector.eye_height)

    oval(@eye_left_x - eye_spacing, @eye_y, @eye_radius + eye_size + e[0], @eye_radius + eye_size + e[1])
    oval(@eye_right_x + eye_spacing, @eye_y, @eye_radius + eye_size + e[0], @eye_radius + eye_size + e[1])
  end
  
  def draw_pupils!
    pupil_size = ([1, @face_vector.pupil_size * 2].max * 2).to_i
    oval(@eye_left_x - ((@face_vector.crosseyedness - 0.5) * 10).to_i, @eye_y, pupil_size, pupil_size, true)
    oval(@eye_right_x + ((@face_vector.crosseyedness - 0.5) * 10).to_i, @eye_y, pupil_size, pupil_size, true)
  end
  
  def draw_head!
    e = eccentricities(@face_vector.head_size)
    oval(50, 50, @head_radius + e[0], @head_radius + e[1])
  end
  
  def draw_nose!
    y = 55 + (((@face_vector.nose_size - 0.5) / 2.0) * 10).to_i

    line(@nose_apex_x, @nose_apex_y, @nose_apex_x - (@nose_width / 2.0), y)
    line(@nose_apex_x - (@nose_width / 2.0), y, @nose_apex_x + (@nose_width / 2.0), y)
    line(@nose_apex_x + (@nose_width / 2.0), y, @nose_apex_x, @nose_apex_y)
  end
  
  def draw_lip(p1, p2, p3)
    left = Matrix[[p1.x**2, p1.x, 1], [p2.x ** 2, p2.x, 1], [p3.x ** 2, p3.x, 1]]
    right = Matrix[[p1.y],[p2.y],[p3.y]]
    
    a, b, c = (left.inv * right).to_a.flatten
    
    # Function a x^2 + b x + c
    
    
    # find parabola for bottom and top
    
    current_x = scale_x(p1.x.to_i + @x_origin)
    current_y = scale_y(p1.y + @y_origin)
    @app.stroke @app.black
    ((p1.x.to_i + 1)..p2.x.to_i).each do |x|
      next_x = scale_x(x + @x_origin)
      next_y = scale_y((a * x ** 2 + b * x + c).to_i + @y_origin)
      @app.line(current_x, current_y, next_x, next_y)
      current_x = next_x
      current_y = next_y
    end
  end
  

  def draw_mouth!       
    mouth_size = (@face_vector.mouth_width - 0.5) * 10
    p1 = Point.new(40 - mouth_size, @mouth_y)
    p2 = Point.new(60 + mouth_size, @mouth_y)
    p3 = Point.new(((p2.x - p1.x)) / 2 + p1.x, ((@face_vector.smile - 0.5) * 10) + @mouth_y)
    p3_prime = Point.new(p3.x, p3.y + ((@face_vector.mouth_depth / 2.0) * 10))
    
    draw_lip(p1, p2, p3)
    draw_lip(p1, p2, p3_prime)
	end
  
  def draw_eyebrow!
    y1 = @eyebrow_y + ((@face_vector.eyebrow_slant - 0.5) * 10).to_i
    y2 = @eyebrow_y - ((@face_vector.eyebrow_slant - 0.5) * 10).to_i

    line @eyebrow_l_l_x, y1, @eyebrow_l_r_x, y2
    line @eyebrow_r_l_x, y2, @eyebrow_r_r_x, y1
  end
  
  def eccentricities(p)
    a = [0, ((p - 0.5) * 20.0).abs.to_i]
    a.reverse! if p > 0.5
    a
  end
  
  def oval(x, y, height_r, width_r, fill = false)
    
    if fill
      @app.nostroke 
      @app.fill @app.black
    else
      @app.fill @app.white
    end
    
    @app.oval scale_x(x - width_r) + @x_origin, 
             scale_y(y - height_r) + @y_origin,
    				 scale_x(width_r * 2), 
    				 scale_y(height_r * 2)
  end
  
  def line(x1, y1, x2, y2)
    @app.stroke @app.black
    @app.line  scale_x(x1 + @x_origin), 
              scale_y(y1 + @y_origin),
    					scale_x(x2 + @x_origin), 
    					scale_y(y2 + @y_origin)
    
  end
  
  def scale_x(x)
    (x * @x_factor).to_i
  end
  
  def scale_y(y)
    (y * @y_factor).to_i
  end
end