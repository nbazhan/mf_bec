function rc = get_rc(obj, t)
rc.x = obj.c.x + obj.c.rx*cos(obj.c.w*t + obj.c.phi); 
rc.y = obj.c.y + obj.c.ry*sin(obj.c.w*t + obj.c.phi); 
if obj.model.D == 3
    rc.z = obj.c.z;
end
end