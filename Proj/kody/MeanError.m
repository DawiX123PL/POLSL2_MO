function mean_e = MeanError(E_ts)

    E_ts = getsampleusingtime(E_ts, 20, 100); % okres 20-100 sekund

    E = E_ts.Data(1:end-1);
    T = E_ts.Time;

    Delta_t = T(2:end) - T(1:end-1);
    
    mean_e = sum( E .* Delta_t ) / sum(Delta_t);
    mean_e = abs(mean_e);

end