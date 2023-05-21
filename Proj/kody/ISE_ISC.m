function ise_isc = ISE_ISC(E_ts)

    E_ts = getsampleusingtime(E_ts, 0, 100); % okres 0-100 sekund

    ise_isc = ISE(E_ts) + ISC();

end


function ise = ISE(E_ts)
    E = E_ts.Data(1:end-1);
    T = E_ts.Time;

    Delta_t = T(2:end) - T(1:end-1);
    
    ise = sum( (E.^2) .* Delta_t );
end


function isc = ISC()
    
    error("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"+ newline + ...
        "Wskaźnik ISC nie został zaimplementowany");

end