function [x_min, trajectory, iter, Q_trajectory] =  GradientSearchMin(f, x0, epsilon, n, delta, alfa)

   
    trajectory = {};
    Q_trajectory = [];
    x_current = x0;
    f_value = inf;

    fprintf("i = %10d \t QI = %10f \t |grad| = %10f \t alfa = %10f \t delta = %10f \n", ...
        0, nan, nan, alfa, delta)
    
    for iter = 1:n

        %[grad, f_value] = Gradient(f,x_current, delta);
        [f_value, grad] = f(x_current);
        %dir = -grad;
        dir = -grad/norm(grad);

        F = @(alfaf) f_wrap(f, x_current, dir, alfaf, delta);
        %[alfa, f_value] = fminsearch(F, 0);
        %[alfa, f_value] = fminbnd(F, 0, 10);

        %options = optimoptions('fminunc','Algorithm','trust-region','SpecifyObjectiveGradient',true, 'TolX',epsilon{3}, 'TolFun', epsilon{3});
        %[alfa, f_value] = fminunc(F, 0, options);
        

        trajectory{end+1} = x_current;
        Q_trajectory(end+1) = f_value;

        x_old = x_current;
        x_current =  x_current + dir * alfa;
        
        fprintf("i = %10d \t QI = %10f \t |grad| = %10f \t alfa = %10f \t delta = %10f \n", ...
            iter, f_value, norm(grad), alfa, delta)

        if iter > 1
            if( Q_trajectory(iter) > Q_trajectory(iter-1) )
                alfa = alfa / 2;
            end
        end

        % kryterium stopu 1 
        if norm(grad) < epsilon{1}
            break
        end

        % kryterium stopu 1 
        if norm(x_current - x_old) < epsilon{2}
            break
        end
    end

    trajectory{end+1} = x_current;
    Q_trajectory(end+1) = f_value;
    x_min = x_current;

end


function [val, grad] = f_wrap(f, x_current, dir, alfa, delta)

    y = f(x_current + dir * alfa);
    y_delta = f(x_current + dir * (alfa + delta));

    val = y;
    grad = (y_delta - y) / delta;

end


function [grad, y] = Gradient(f, x, delta)

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
    grad = (y_i - y * ones(size(x))) / delta;
    
end