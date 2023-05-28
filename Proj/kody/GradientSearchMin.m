function [x_min, trajectory, iter, Q_trajectory] =  GradientSearchMin(f, x0, epsilon, n, delta, alfa)

   
    trajectory = {};
    Q_trajectory = [];

    x_current = x0;

    waitbar_h = waitbar(0, 'Obliczenia metodą najszybszego spadku', ...
        'Name', 'Obliczenia metodą najszybszego spadku', ...
        'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');

    setappdata(waitbar_h,'canceling',0);

    f_value = inf;

    for iter = 1:n

        if getappdata(waitbar_h,'canceling')
            break;
        end

        waitbar(iter/n, waitbar_h, sprintf( ...
            "iteracja: %d/%d wartość funkcji: %f alfa: %f ", ...
            iter, n, f_value, alfa))

        [grad, f_value] = Gradient(f,x_current, delta);
        dir = grad/norm(grad);


        %F = @(alfaf) f(x_current - grad * alfaf);
        %[alfa_min, f_value] = fminsearch(F, 0, optimset("TolFun", 1e-8));

        trajectory{end+1} = x_current;
        Q_trajectory(end+1) = f_value;

        x_old = x_current;
        x_current =  x_current - dir * alfa;
        
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

    delete(waitbar_h);
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
    grad = (y_i - y * ones(size(x))) / delta;
    
end