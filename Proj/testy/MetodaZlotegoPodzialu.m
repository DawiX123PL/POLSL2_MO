function [x,a,b,i] = MetodaZlotegoPodzialu(a, b, func, eps, n)

goldenRatio = 0.618;

    for i = 1:n
        
        if(b-a) < eps
           break; 
        end
        
        d = b-a;
        x1 = b - d * goldenRatio;
        x2 = a + d * goldenRatio;
        y1 = func(x1);
        y2 = func(x2);
        
        if y1 >= y2
            a = x1;
        elseif y2 > y1
            b = x2;
        end

    end
    
    x = (a + b)/2;


end