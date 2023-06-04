function TunePID(alfa, delta, QI, model_file, destination_folder)
        
    % parametry optymalizacji
    
    % PID_kr = 1
    % PID_Ti = 1000
    % PID_Td = 0
    
    PID_kr = 0.41568
    PID_Ti = 1.74
    PID_Td = 0.435
    PID_h = 0.1
    
    filter_coeficient = 100;
    w_target = 0.5;
    u_limit = [0 1];
    
    %model_file = "object_with_PID.slx"
    
    x0 = [PID_kr, PID_Ti, PID_Td] % punkt poczatkowy optymalizacji
    
    n = 200;
    epsilon = {0.0000001, 0.0000001, 0.0000001};
    %delta = 0.001; % delta = {0.001, 0.01, 0.1, 1}
    %alfa = 1; % alfa = {0.05, 1}
    
    
    %% optymalizacja metoda sprzezonego gradientu i wyswietlenie wyniku
    
    % wskaźnik jakości
    %QI = @(e) ISE_100(e)
    %QI = @(e) ISE_20_100(e)
    %QI = @(e) ISE_ISC(e)
    %QI = @(e) MeanError(e)
    
    % przeksztalcenie minimalizowanej funkcji do postaci y = F(x)
    F = @(x) PID_to_QI1(x(1), x(2), x(3), filter_coeficient, w_target, u_limit, PID_h, delta, QI, model_file)
    %F = @(x) PID_to_QI1(x(1), x(2), x(3), filter_coeficient, w_target, u_limit, PID_h, QI, model_file)
   
    
    % minimalizacja
    tic
    [x_min, trajectory, iter, Q_trajectory] = GradientSearchMin(F, x0, epsilon, n, delta, alfa);
    % [x_min, trajectory, iter] = GradientConjugateSearchMin(F, x0, epsilon, n, delta, alfa);
    toc
    
    PID_kr_opt = x_min(1)
    PID_Ti_opt = x_min(2)
    PID_Td_opt = x_min(3)
    
    
    % wyświetlenie trajektorii
    trajectory_kr = zeros(size(trajectory));
    trajectory_Ti = zeros(size(trajectory));
    trajectory_Td = zeros(size(trajectory));
    
    for i = 1:length(trajectory)
        trajectory_kr(i) = trajectory{i}(1);
        trajectory_Ti(i) = trajectory{i}(2);
        trajectory_Td(i) = trajectory{i}(3);
    end
    
    figure
    tiledlayout(2,2);
    nexttile;
    plot([0: length(trajectory_kr)-1], trajectory_kr);
    ylabel("kr");
    xlabel("iteration");
    grid on
    
    nexttile;
    plot([0: length(trajectory_Ti)-1], trajectory_Ti);
    ylabel("Ti");
    xlabel("iteration");
    grid on
    
    nexttile;
    plot([0: length(trajectory_Td)-1], trajectory_Td);
    ylabel("Td");
    xlabel("iteration");
    grid on
    
    nexttile;
    plot([0: length(Q_trajectory)-1], Q_trajectory);
    ylabel("QI");
    xlabel("iteration");
    grid on
    
    saveas(gcf, destination_folder + 'trajectory.png')
    saveas(gcf, destination_folder + 'trajectory.svg')
    
    % wyświetlenie plotów dla danego regulatora PID
    quality_indicator = Plot_PID(PID_kr_opt, PID_Ti_opt, PID_Td_opt, filter_coeficient, w_target, u_limit, PID_h, QI, model_file);
    saveas(gcf, destination_folder + 'output.png')
    saveas(gcf, destination_folder + 'output.svg')
     
    % zapisanie macierzy do plikow
    save(destination_folder + 'trajectory.mat', 'trajectory');
    save(destination_folder + 'Q_trajectory.mat', 'Q_trajectory');
    save(destination_folder + 'PID_min.mat', 'x_min');
    save(destination_folder + 'quality_indicator.mat', 'quality_indicator');

end

%% wskaznik jakosci i ploty
function quality_indicator = Plot_PID(PID_kr, PID_Ti, PID_Td, filter_coeficient, w_target, u_limit, PID_h, QI, model_file)
    w=warning('off','all');
    sim_out = sim(model_file, "SrcWorkspace", "current", 'FastRestart', 'on');
    warning(w);
    
    figure
    hold on
    plot(sim_out.Y);
    plot(sim_out.E);
    xlabel("time");
    yline(0);
    yline(w_target);
    
    legend("y(t)","e(t)", '', '', "Location","east");

    quality_indicator = QI(sim_out.E);
end

%% funkcja uruchamiająca symulacje i zwracająca wskażnik jakości
function [qi, grad] = PID_to_QI(PID_kr1, PID_Ti1, PID_Td1, filter_coeficient, w_target, u_limit, PID_h, QI, model_file)

    filter_coeficient = 100;
    w_target = 0.5;
    u_limit = [0 1];
    
    w=warning('off','all');
    PID_kr = PID_kr1;
    PID_Ti = PID_Ti1;
    PID_Td = PID_Td1;
    sim_out = sim(model_file, "SrcWorkspace", "current", 'FastRestart', 'on');
    warning(w);

    %sim_out.SimulationMetadata.TimingInfo

    Y = sim_out.Y;
    E = sim_out.E;
    
    qi = QI(E);

    % obliczanie gradientu 
    DELTALAAAAAAA = 0.001;

    if nargout > 1 % gradient required
        grad = [0 0 0]
        return
    end

    w=warning('off','all');
    PID_kr = PID_kr1 + DELTALAAAAAAA;
    PID_Ti = PID_Ti1;
    PID_Td = PID_Td1;
    sim_out_KR = sim(model_file, "SrcWorkspace", "current", 'FastRestart', 'on');
    warning(w);

    w=warning('off','all');
    PID_kr = PID_kr1;
    PID_Ti = PID_Ti1 + DELTALAAAAAAA;
    PID_Td = PID_Td1;
    sim_out_TI = sim(model_file, "SrcWorkspace", "current", 'FastRestart', 'on');
    warning(w);

    w=warning('off','all');
    PID_kr = PID_kr1;
    PID_Ti = PID_Ti1;
    PID_Td = PID_Td1 + DELTALAAAAAAA;
    sim_out_TD = sim(model_file, "SrcWorkspace", "current", 'FastRestart', 'on');
    warning(w);

    qi_kr = QI(sim_out_KR.E);
    qi_ti = QI(sim_out_TI.E);
    qi_td = QI(sim_out_TD.E);

    grad = [qi_kr - qi, qi_ti - qi, qi_td - qi];

end








%% funkcja uruchamiająca symulacje i zwracająca wskażnik jakości
function [qi, grad] = PID_to_QI1(PID_kr1, PID_Ti1, PID_Td1, filter_coeficient, w_target, u_limit, PID_h, delta, QI, model_file)

    sim_in = [
        Simulink.SimulationInput(model_file);
        Simulink.SimulationInput(model_file);
        Simulink.SimulationInput(model_file);
        Simulink.SimulationInput(model_file);
    ];

    delta = 1;
    sim_in(1) = sim_in(1).setVariable('PID_kr', PID_kr1);
    sim_in(1) = sim_in(1).setVariable('PID_Ti', PID_Ti1);
    sim_in(1) = sim_in(1).setVariable('PID_Td', PID_Td1);

    sim_in(2) = sim_in(2).setVariable('PID_kr', PID_kr1 + delta);
    sim_in(2) = sim_in(2).setVariable('PID_Ti', PID_Ti1);
    sim_in(2) = sim_in(2).setVariable('PID_Td', PID_Td1);

    sim_in(3) = sim_in(3).setVariable('PID_kr', PID_kr1);
    sim_in(3) = sim_in(3).setVariable('PID_Ti', PID_Ti1 + delta);
    sim_in(3) = sim_in(3).setVariable('PID_Td', PID_Td1);

    sim_in(4) = sim_in(4).setVariable('PID_kr', PID_kr1);
    sim_in(4) = sim_in(4).setVariable('PID_Ti', PID_Ti1);
    sim_in(4) = sim_in(4).setVariable('PID_Td', PID_Td1 + delta);

    for i = 1:4
        sim_in(i) = sim_in(i).setVariable('filter_coeficient', filter_coeficient);
        sim_in(i) = sim_in(i).setVariable('w_target', w_target);
        sim_in(i) = sim_in(i).setVariable('u_limit', u_limit);
        sim_in(i) = sim_in(i).setVariable('PID_h', PID_h);
    end

    if nargout <= 1 % gradient required
        
        w=warning('off','all');
        sim_out = sim(sim_in(1), "UseFastRestart","on");
        warning(w);
        
        qi    = QI(sim_out(1).E);
        grad = [0 0 0];
        return
    end
    
    w=warning('off','all');
    %sim_out = sim(sim_in, "UseFastRestart","on", "ShowProgress", "off");
    sim_out = sim(sim_in, "UseFastRestart","on");
    warning(w);

    qi    = QI(sim_out(1).E);
    qi_kr = QI(sim_out(2).E);
    qi_ti = QI(sim_out(3).E);
    qi_td = QI(sim_out(4).E);

    grad = [qi_kr - qi, qi_ti - qi, qi_td - qi];

end





