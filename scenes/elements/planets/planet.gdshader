shader_type canvas_item;

void vertex() {
}

uniform float rotation_speed : hint_range(0.0, 1.0) = 0.1;

uniform sampler2D planet_texture : filter_linear_mipmap, repeat_enable; 

void fragment() {
   
    vec2 centered_uv = UV * 2.0 - 1.0;
    
   
    float radius = length(centered_uv);
    
    if (radius > 1.0) {
        COLOR.a = 0.0; 
    } else {
      
        float z = sqrt(1.0 - radius * radius);
        
       
        float longitude = atan(centered_uv.x, z);
        float latitude = asin(centered_uv.y);
        
       
        vec2 sphere_uv = vec2(longitude / (2.0 * PI) + 0.5, latitude / PI + 0.5);
        
        
        sphere_uv.x -= TIME * rotation_speed;
        
  
        vec4 tex_color = texture(planet_texture, sphere_uv);
        float lighting = smoothstep(0.0, 1.0, z); 
        
        COLOR = tex_color * vec4(vec3(lighting), 1.0);
    }
}