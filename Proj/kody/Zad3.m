clear all; close all; clc;
%%

Alpha = [0.001, 0.01, 0.1, 1];
Delta = [0.05, 1];

QI = @(e) ISE_ISC(e);

WYNIKI_FOLDER = "../wyniki/Zad3";
model_file = "object_with_PID.slx";


%%

for alpha = Alpha
    for delta = Delta
        DESTINATION_FOLDER = WYNIKI_FOLDER + "\a_" + string(alpha) + "_d_" + string(delta) + "\";
        mkdir(DESTINATION_FOLDER)
        TunePID(alpha, delta, QI, model_file, DESTINATION_FOLDER)
    end
end