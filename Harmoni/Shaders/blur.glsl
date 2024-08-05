extern vec2 texture_size; 
    extern bool horizontal;
    uniform float weight[5] = float[] (0.227027, 0.1945946, 0.1216216, 0.054054, 0.016216);
    
    vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
    {
      vec4 pixel = Texel(texture, texture_coords) * colour ;
      vec2 tex_offset = 1.0 / texture_size;
      
      vec4 result = pixel*weight[0]; 
     
      if (horizontal) 
      {
        for(int i = 1; i < 5; ++i)
        {
          result += Texel(texture, texture_coords + vec2(tex_offset.x*i, 0), 0) * weight[i];
          result += Texel(texture, texture_coords - vec2(tex_offset.x*i, 0), 0) * weight[i];
        }
      }
      else
      {
        for(int i = 1; i < 5; ++i)
        {
          result += Texel(texture, texture_coords + vec2(0, tex_offset.y*i), 0) * weight[i];
          result += Texel(texture, texture_coords - vec2(0, tex_offset.y*i), 0) * weight[i];
        }
      }
      return result * colour;
    }