function ise_isc = ISE_ISC(E_ts, U_ts)

    E_ts = getsampleusingtime(E_ts, 0, 100); % okres 0-100 sekund
    U_ts = getsampleusingtime(U_ts, 0, 100); % okres 0-100 sekund

    ise_isc = ISE(E_ts) + ISC(U_ts);
end


function ise = ISE(E_ts)
    E = E_ts.Data(1:end-1);
    T = E_ts.Time;

    Delta_t = T(2:end) - T(1:end-1);
    
    ise = sum( (E.^2) .* Delta_t );
end


function isc = ISC(U_ts)

    U = U_ts.Data(1:end-1);
    T = U_ts.Time;

    u_inf = U(end);
    Delta_t = T(2:end) - T(1:end-1);
    
    U_diff = U-u_inf;

    isc = sum(  (U_diff.^2) .* Delta_t );
end