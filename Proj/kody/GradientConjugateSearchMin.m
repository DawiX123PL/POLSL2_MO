% todo 

function [x_min, trajectory, iter] =  GradientConjugateSearchMin(f, x0, epsilon, n, delta, alfa)

   
    trajectory = {};

    x_current = x0;

    waitbar_h = waitbar(0, 'Obliczenia metodą najszybszego spadku', 'Name', 'Obliczenia metodą najszybszego spadku');
 
    f_value = inf;


    [grad, f_value] = Gradient(f,x_current, delta);
    dir = -grad;

    for iter = 1:n

        waitbar(iter/n, waitbar_h, sprintf( ...
            "iteracja: %d/%d wartość funkcji: %f alfa: %f ", ...
            iter, n, f_value, alfa))

        F = @(alfaf) f(x_current + dir * alfaf);
        [alfa, f_value] = fminsearch(F, 0, optimset("TolFun", 1e-8));

        trajectory{iter} = x_current;

        x_current =  x_current + dir * alfa;

        % kryterium stopu 1 
        if norm(grad) < epsilon
            break
        end

        grad_old = grad;
        [grad, f_value] = Gradient(f,x_current, delta);
        %dir = - grad + norm(grad)/norm(grad_old) * dir;
        beta = (grad * (grad' - grad_old')) / (grad_old * grad_old');
        dir = - grad + beta * dir;

    end


    close(waitbar_h);


    x_min = x_current;

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
    grad = y_i - y * ones(size(x));
    
end