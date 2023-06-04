clear all; close all; clc;
%%

%Alpha = [0.001, 0.01, 0.1, 1];
Alpha = [0.05]
Delta = [0.001];

QI = @(e) ISE_100(e);

WYNIKI_FOLDER = "../wyniki/Zad4c";
model_file = "object_with_Discrete";


%%

for alpha = Alpha
    for delta = Delta
        DESTINATION_FOLDER = WYNIKI_FOLDER + "\a_" + string(alpha) + "_d_" + string(delta) + "\";
        mkdir(DESTINATION_FOLDER)
        TunePID(alpha, delta, QI, model_file, DESTINATION_FOLDER)
    end
end