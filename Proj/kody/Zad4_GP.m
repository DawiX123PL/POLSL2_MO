clear all; close all; clc;
%%

Alpha = [1];
Delta = [0.001];
epsilon = {0.0001, 0.0001};

QI = @(e, u) MeanError(e);

WYNIKI_FOLDER = "../wyniki/Zad4/GP";
model_file = "object_with_Discrete";


metoda_optymalizacji = "GradProsty";

%%
Zad1234_Com