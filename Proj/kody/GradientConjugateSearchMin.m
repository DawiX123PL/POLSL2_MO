% todo 

function [x_min, trajectory, iter] =  GradientConjugateSearchMin(f, x0, eps, n, delta)

   
    trajectory = {};

    x_current = x0;

    for iter = 1:n
        grad = Gradient(f,x_current, delta);

        F = @(alfa) f(grad * alfa + x_current);
        alfa_min = fminsearch(F, 0);
        trajectory{iter} = x_current;

        x_current = grad * alfa_min + x_current;
    end

    x_min = x_current;

end


function grad = Gradient(f, x, delta)

    % wartosc funkcji f(x) w punkcie X
    y = f(x);
    
    % wartosci funkcji f(x) dla punktow X przesunietych w roznych
    % kierunkach o wartosc delta
    y_i = zeros(size(x));

    for i = 1:numel(x)
        x_plus_delta_i = x;
        x_plus_delta_i(i) = x_plus_delta_i(i) + delta;
        y_i(i) = f(x_plus_delta_i);
    end

    % liczenie gradientu
    grad = y * ones(size(x)) - y_i;
    
end