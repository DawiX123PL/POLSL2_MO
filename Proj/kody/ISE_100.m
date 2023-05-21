function ise = ISE_100(E_ts)

    E_ts = getsampleusingtime(E_ts, 0, 100); % okres 0-100 sekund

    E = E_ts.Data(1:end-1);
    T = E_ts.Time;

    Delta_t = T(2:end) - T(1:end-1);
    
    ise = sum( (E.^2) .* Delta_t );

end