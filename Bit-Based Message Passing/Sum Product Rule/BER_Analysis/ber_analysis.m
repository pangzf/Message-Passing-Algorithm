close all;
clear all;

Pb = 1e-2;
Ia = 0.01:0.01:0.94;
A1 = 1.09542;
B1 = 0.214217;
C1 = 2.33727;
A2 = 0.706692;
B2 = 0.386013;
C2 = -1.75017;
if(Ia <= 0.3646)
    Sigma_a = A1 .* Ia.^2 + B1 .* Ia + C1 .* sqrt(Ia);
else
	Sigma_a = -A2 .* log(-B2 .* (Ia - 1.0)) - C2 .* Ia;
end
Var_a = Sigma_a.^2;
Mean_a = Var_a ./ 2.0;

Var_e = (2 * sqrt(2) * erfcinv(2 * Pb)) .^ 2 - Var_a;
Sigma_e = sqrt(Var_e);
a1 = -0.0421061;
b1 = 0.209252;
c1 = -0.00640081;
a2 = 0.00181491;
b2 = -0.142675;
c2 = -0.0822054;
d2 = 0.0549608;
if(Sigma_e <= 1.6363)
    Ie = a1 * Sigma_e.^3 + b1 * Sigma_e.^2 + c1 * Sigma_e;
elseif(Sigma_e > 1.6363 & Sigma_e < 10)
    Ie = 1 - exp(a2 * Sigma_e.^3 + b2 * Sigma_e.^2 + c2 * Sigma_e + d2);
else
    Ie = 1;
end

plot(Ie, Ia);
axis([0 1 0 1]);