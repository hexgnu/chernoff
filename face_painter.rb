require 'matrix'
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
    draw_head(@face_vector.points[1])
    draw_eyes(@face_vector.points[2], @face_vector.points[7], @face_vector.points[8])
    draw_pupil(@face_vector.points[3], @face_vector.points[7])
    draw_eyebrow(@face_vector.points[4])
    draw_nose(@face_vector.points[5])
    draw_mouth(@face_vector.points[6], @face_vector.points[9], @face_vector.points[10])
  end
  
  def draw_eyes(p2, p7, p8)
    eye_spacing = ((p7 - 0.5) * 10).to_i
    eye_size = (((p8 - 0.5) / 2.0) * 10).to_i
    e = eccentricities(p2)

    xOval(@eye_left_x - eye_spacing, @eye_y, @eye_radius + eye_size + e[0], @eye_radius + eye_size + e[1])
    xOval(@eye_right_x + eye_spacing, @eye_y, @eye_radius + eye_size + e[0], @eye_radius + eye_size + e[1])
  end
  
  def draw_pupil(p3, p7)
    pupil_size = ([1, p3 * 0.2].max * 2).to_i

    xOval(@eye_left_x - ((p7 - 0.5) * 10).to_i, @eye_y, pupil_size, pupil_size, true)
    xOval(@eye_right_x + ((p7 - 0.5) * 10).to_i, @eye_y, pupil_size, pupil_size, true)
  end
  
  def draw_head(p1)
    e = eccentricities(p1)
    xOval(50, 50, @head_radius + e[0], @head_radius + e[1])
  end
  
  def draw_nose(p5)
    y = 55 + (((p5 - 0.5) / 2.0) * 10).to_i

    xLine(@nose_apex_x, @nose_apex_y, @nose_apex_x - (@nose_width / 2.0), y)
    xLine(@nose_apex_x - (@nose_width / 2.0), y, @nose_apex_x + (@nose_width / 2.0), y)
    xLine(@nose_apex_x + (@nose_width / 2.0), y, @nose_apex_x, @nose_apex_y)
  end
  
  def draw_lip(x1, y1, x2, y2, x3, y3)
    left = Matrix[[x1**2, x1, 1], [x2 ** 2, x2, 1], [x3 ** 2, x3, 1]]
    right = Matrix[[y1],[y2],[y3]]
    
    a, b, c = (left.inv * right).to_a.flatten
    
    # Function a x^2 + b x + c
    
    
    # find parabola for bottom and top
    
    current_x = scale_x(x1.to_i + @x_origin)
    current_y = scale_y(y1 + @y_origin)
    @app.stroke @app.black
    ((x1.to_i + 1)..x2.to_i).each do |x|
      next_x = scale_x(x + @x_origin)
      next_y = scale_y((a * x ** 2 + b * x + c).to_i + @y_origin)
      @app.line(current_x, current_y, next_x, next_y)
      current_x = next_x
      current_y = next_y
    end
  end
  

  def draw_mouth(p6, p9, p10)    
    mouth_size = ((p9 - 0.5) * 10)
    x1 = 40 - mouth_size
    y1 = @mouth_y
    x2 = 60 + mouth_size
    y2 = @mouth_y
    x3 = ((x2 - x1) / 2) + x1
    y3 = ((p6 - 0.5) * 10) + @mouth_y
    y3_prime = y3 + ((p10 / 2.0) * 10)
    
    draw_lip(x1, y1, x2, y2, x3, y3)
    draw_lip(x1, y1, x2, y2, x3, y3_prime)
	end
  
  def draw_eyebrow(p4)
    #screwed up
    y1 = @eyebrow_y + ((p4 - 0.5) * 10).to_i
    y2 = @eyebrow_y - ((p4 - 0.5) * 10).to_i
    @app.stroke @app.black
    xLine @eyebrow_l_l_x, y1, @eyebrow_l_r_x, y2
    xLine @eyebrow_r_l_x, y2, @eyebrow_r_r_x, y1
  end
  
  def eccentricities(p)
    a = []
    if (p > 0.5)
      a[0] = ((p - 0.5) * 20.0).to_i
      a[1] = 0
    else
      a[0] = 0
      a[1] = ((p - 0.5) * 20.0).abs.to_i
    end
    a
  end
  
  def xOval(x, y, height_r, width_r, fill = false)
    
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
  
  def xLine(x1, y1, x2, y2)
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