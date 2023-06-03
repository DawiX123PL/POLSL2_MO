clear all
close all
clc



%Delta = {0.001, 0.01, 0.1, 1}
%Alfa = {0.05, 1}





DeltaAlfa = {
    [0.001, 0.05]
    [0.001, 1   ]
    [0.01,  0.05]
    [0.01,  1   ]
    [0.1,   0.05]
    [0.1,   1   ]
    [1,     0.05]
    [1,     1   ]
}'

% wskaźnik jakości
%QI = @(e) ISE_100(e)
%QI = @(e) ISE_20_100(e)
%QI = @(e) MeanError(e)
%QI = @(e) ISE_ISC(e)

%% wskaznik jakosci ISE_100(e)
QI = @(e) ISE_100(e)
WYNIKI_FOLDER = "../continuous/wyniki/ISE_100"
% Model_file = "object_with_Discrete.slx"
Model_file = "object_with_PID.slx"

for i = 1:length(DeltaAlfa)
    clearvars -except DeltaAlfa i WYNIKI_FOLDER QI Model_file
    delta = DeltaAlfa{i}(1);
    alfa = DeltaAlfa{i}(2);
    DESTINATION_FOLDER = WYNIKI_FOLDER + "\a_" + string(alfa) + "_d_" + string(delta) + "\";
    mkdir(DESTINATION_FOLDER)
    step2_tune_PID
end

%% wskaznik jakosci ISE_20_100(e)
QI = @(e) ISE_20_100(e)
WYNIKI_FOLDER = "../wyniki/ISE_20_100"
Model_file = "object_with_PID.slx"

for i = 1:length(DeltaAlfa)
    clearvars -except DeltaAlfa i WYNIKI_FOLDER QI
    delta = DeltaAlfa{i}(1);
    alfa = DeltaAlfa{i}(2);
    DESTINATION_FOLDER = WYNIKI_FOLDER + "\a_" + string(alfa) + "_d_" + string(delta) + "\";
    mkdir(DESTINATION_FOLDER)
    step2_tune_PID
end

%% wskaznik jakosci MeanError(e)
QI = @(e) MeanError(e)
WYNIKI_FOLDER = "../wyniki/MeanError"
Model_file = "object_with_PID.slx"

for i = 1:length(DeltaAlfa)
    clearvars -except DeltaAlfa i WYNIKI_FOLDER QI
    delta = DeltaAlfa{i}(1);
    alfa = DeltaAlfa{i}(2);
    DESTINATION_FOLDER = WYNIKI_FOLDER + "\a_" + string(alfa) + "_d_" + string(delta) + "\";
    mkdir(DESTINATION_FOLDER)
    step2_tune_PID
end

%% wskaznik jakosci ISE_ISC(e)

error("!!!!!!!!!!!!!!!!!!!!!!!!!!!! " + newline + "ISE_ISC NIE ZAIMPLEMENTOWANE")

QI = @(e) ISE_ISC(e)
WYNIKI_FOLDER = "../wyniki/ISE_ISC"
Model_file = "object_with_PID.slx"

for i = 1:length(DeltaAlfa)
    clearvars -except DeltaAlfa i WYNIKI_FOLDER QI
    delta = DeltaAlfa{i}(1);
    alfa = DeltaAlfa{i}(2);
    DESTINATION_FOLDER = WYNIKI_FOLDER + "\a_" + string(alfa) + "_d_" + string(delta) + "\";
    mkdir(DESTINATION_FOLDER)
    step2_tune_PID
end
