clear all; close all; clc;
%%

Alpha = [1];
Delta = [0.001];

QI = @(e) ISE_ISC(e);

WYNIKI_FOLDER = "../wyniki/Zad3/GPM";
model_file = "object_with_PID";


%%

for alpha = Alpha
    for delta = Delta
        DESTINATION_FOLDER = WYNIKI_FOLDER + "\a_" + string(alpha) + "_d_" + string(delta) + "\";
        mkdir(DESTINATION_FOLDER)
        TunePID(alpha, delta, QI, model_file, DESTINATION_FOLDER, "GradProstyMOD")
    end
end