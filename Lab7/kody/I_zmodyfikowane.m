function I = I_zmodyfikowane(x, u, p, Ln, fn)
    x_n = x(2:end-1);
    u_n = u(2:end);
    p_n = p(2:end-1);
    p_n_plus = p(3:end);

    I = p(1)*x(1) ...
        + sum( Ln(x_n, u_n) + p_n_plus.*fn(x_n, u_n) - p_n.*x_n) ...
        - p(end)*x(end);
end
