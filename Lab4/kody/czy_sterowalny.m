function result = czy_sterowalny(A,B)

    if size(A,1) ~= size(A,2)
        error("Macierz 'A' musi mieć wymiary n*n")
    end

    if size(A,1) ~= size(B,1)
        error("Macierz 'A' musi mieć wymiary n*n" + newline + ...
            "a macierz 'B' n*m" )
    end

    n = size(A,1);
    
    X = [];
    for i = 0:(n-1)
        X = [X, A^i * B];
    end
    
    if n == rank(X)
        result = 1; % sterowalny
    else
        result = 0; % niesterowalny
    end


end