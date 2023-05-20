function [x,a,b,j] = MetodaGradientowa(func, x0,beta ,t, eps, n)

    funcPrim = diff(func);
    kierunek = -double(sign(funcPrim(x0)));
   
    x = 0;
    
    if (t) == 0
        return
    end
    
    
    for i = 1:n
        s = sign(funcPrim(t / beta^i * kierunek + x0)) * kierunek;
        if s >= 0
            break
        end   
    end
    
	a = t / beta^(i-1) * kierunek + x0;
    b = t / beta^i * kierunek + x0;
    
    if(a>b)
       tmp = a;
       a = b;
       b = tmp;
    end
    
    [x,a,b,n] = MetodaZlotegoPodzialu(a, b, func, eps, n - i);
    j = i + n;

end