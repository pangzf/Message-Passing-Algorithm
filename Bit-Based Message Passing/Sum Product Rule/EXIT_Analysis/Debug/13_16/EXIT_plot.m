close all; 
clear all;

load Func_exit.log;
load Bit_exit.log;

figure(1);
set(gca, 'fontsize', 14);
plot(Func_exit(1:11,2), Func_exit(1:11,3), '-r*',  'LineWidth', 2.0, 'MarkerSIze', 10);
hold on;
grid on;
plot(Bit_exit(1:11,2), Bit_exit(1:11,1), '-b^',  'LineWidth', 2.0, 'MarkerSIze', 10);
plot(Bit_exit(1:11,3), Bit_exit(1:11,1), '-ms',  'LineWidth', 2.0, 'MarkerSIze', 10);
plot(0, 1, 'w');

%=========================%
% 13 dB                   %
%=========================%
Ia(1) = Func_exit(1,3);
Ie(1) = Bit_exit(1,2);
Id(1) = Bit_exit(1,3);
Ia(2) = Func_exit(8,3) + (Func_exit(9,3) - Func_exit(8,3)) * ((Ie(1) - Func_exit(8,2)) / (Func_exit(9,2) - Func_exit(8,2)));
Ie(2) = Bit_exit(8,2) + (Bit_exit(9,2) - Bit_exit(8,2)) * ((Ia(2) - Bit_exit(8,1)) / (Bit_exit(9,1) - Bit_exit(8,1)));
Id(2) = Bit_exit(8,3) + (Bit_exit(9,3) - Bit_exit(8,3)) * ((Ia(2) - Bit_exit(8,1)) / (Bit_exit(9,1) - Bit_exit(8,1)));
Ia(3) = Func_exit(10,3) + (Func_exit(11,3) - Func_exit(10,3)) * ((Ie(2) - Func_exit(10,2)) / (Func_exit(11,2) - Func_exit(10,2)));
Ie(3) = Bit_exit(10,2) + (Bit_exit(11,2) - Bit_exit(10,2)) * ((Ia(3) - Bit_exit(10,1)) / (Bit_exit(11,1) - Bit_exit(10,1)));
Id(3) = Bit_exit(10,3) + (Bit_exit(11,3) - Bit_exit(10,3)) * ((Ia(3) - Bit_exit(10,1)) / (Bit_exit(11,1) - Bit_exit(10,1)));
Ia(4) = Func_exit(10,3) + (Func_exit(11,3) - Func_exit(10,3)) * ((Ie(3) - Func_exit(10,2)) / (Func_exit(11,2) - Func_exit(10,2)));
Ie(4) = Bit_exit(10,2) + (Bit_exit(11,2) - Bit_exit(10,2)) * ((Ia(4) - Bit_exit(10,1)) / (Bit_exit(11,1) - Bit_exit(10,1)));
Id(4) = Bit_exit(10,3) + (Bit_exit(11,3) - Bit_exit(10,3)) * ((Ia(4) - Bit_exit(10,1)) / (Bit_exit(11,1) - Bit_exit(10,1)));
Ia(5) = Func_exit(10,3) + (Func_exit(11,3) - Func_exit(10,3)) * ((Ie(4) - Func_exit(10,2)) / (Func_exit(11,2) - Func_exit(10,2)));
Ie(5) = Bit_exit(10,2) + (Bit_exit(11,2) - Bit_exit(10,2)) * ((Ia(5) - Bit_exit(10,1)) / (Bit_exit(11,1) - Bit_exit(10,1)));
Id(5) = Bit_exit(10,3) + (Bit_exit(11,3) - Bit_exit(10,3)) * ((Ia(5) - Bit_exit(10,1)) / (Bit_exit(11,1) - Bit_exit(10,1)));
Ia(6) = Func_exit(10,3) + (Func_exit(11,3) - Func_exit(10,3)) * ((Ie(5) - Func_exit(10,2)) / (Func_exit(11,2) - Func_exit(10,2)));
Ie(6) = Bit_exit(10,2) + (Bit_exit(11,2) - Bit_exit(10,2)) * ((Ia(6) - Bit_exit(10,1)) / (Bit_exit(11,1) - Bit_exit(10,1)));
Id(6) = Bit_exit(10,3) + (Bit_exit(11,3) - Bit_exit(10,3)) * ((Ia(6) - Bit_exit(10,1)) / (Bit_exit(11,1) - Bit_exit(10,1)));
line([0 0], [0 Ia(1)], 'LineWidth', 2.0, 'Color', [0 1 1]);
line([0 Ie(1)], [Ia(1) Ia(1)], 'LineWidth', 2.0, 'Color', [0 1 1]);
line([Ie(1) Ie(1)], [Ia(1) Ia(2)], 'LineWidth', 2.0, 'Color', [0 1 1]);
line([Ie(1) Ie(2)], [Ia(2) Ia(2)], 'LineWidth', 2.0, 'Color', [0 1 1]);
line([Ie(2) Ie(2)], [Ia(2) Ia(3)], 'LineWidth', 2.0, 'Color', [0 1 1]);
line([Ie(2) Ie(3)], [Ia(3) Ia(3)], 'LineWidth', 2.0, 'Color', [0 1 1]);
line([Ie(3) Ie(3)], [Ia(3) Ia(4)], 'LineWidth', 2.0, 'Color', [0 1 1]);
line([Ie(3) Ie(4)], [Ia(4) Ia(4)], 'LineWidth', 2.0, 'Color', [0 1 1]);
line([Ie(4) Ie(4)], [Ia(4) Ia(5)], 'LineWidth', 2.0, 'Color', [0 1 1]);
line([Ie(4) Ie(5)], [Ia(5) Ia(5)], 'LineWidth', 2.0, 'Color', [0 1 1]);
line([Ie(5) Ie(5)], [Ia(5) Ia(6)], 'LineWidth', 2.0, 'Color', [0 1 1]);
line([Ie(5) Ie(6)], [Ia(6) Ia(6)], 'LineWidth', 2.0, 'Color', [0 1 1]);

A1 = 1.09542;
B1 = 0.214217;
C1 = 2.33727;
A2 = 0.706692;
B2 = 0.386013;
C2 = -1.75017;

if(Id <= 0.3646)
    Sigma_d = A1 .* Id.^2 + B1 .* Id + C1 .* sqrt(Id);
else
	Sigma_d = -A2 .* log(-B2 .* (Id - 1.0)) - C2 .* Id;
end

Var_d = Sigma_d.^2;
Mean_d = Var_d ./ 2.0;

Pb = 0.5 .* erfc(sqrt(Var_d) ./ (2*sqrt(2)));
err_rate1(:,1) = Ia;
err_rate1(:,2) = Id;
err_rate1(:,3) = Pb;

title('EXIT Chart of Bit-based Message Passing Algorithm in MIMO Fading Channel');
xlabel('I_A_,_F_N_D,  I_E_,_B_N_D');
ylabel('I_E_,_F_N_D,  I_A_,_B_N_D');
axis([0 1 0 1]);

legend('Function Node', 'Bit Node', 'Decision Node', '13 dB', 2);
%print -djpeg100 EXIT_Bit_Message_Passing_MIMO_13.jpg;

figure(2);
set(gca, 'fontsize', 14);
plot(Func_exit(12:22,2), Func_exit(12:22,3), '-g+',  'LineWidth', 2.0, 'MarkerSIze', 10);
hold on;
grid on;
plot(Bit_exit(12:22,2), Bit_exit(12:22,1), '-bo',  'LineWidth', 2.0, 'MarkerSIze', 10);
plot(Bit_exit(12:22,3), Bit_exit(12:22,1), '-r*',  'LineWidth', 2.0, 'MarkerSIze', 10);
plot(0, 1, 'w');

%=========================%
% 16 dB                   %
%=========================%
Ia(1) = Func_exit(12,3);
Ie(1) = Bit_exit(12,2);
Id(1) = Bit_exit(12,3);
Ia(2) = Func_exit(20,3) + (Func_exit(21,3) - Func_exit(20,3)) * ((Ie(1) - Func_exit(20,2)) / (Func_exit(21,2) - Func_exit(20,2)));
Ie(2) = Bit_exit(20,2) + (Bit_exit(21,2) - Bit_exit(20,2)) * ((Ia(2) - Bit_exit(20,1)) / (Bit_exit(21,1) - Bit_exit(20,1)));
Id(2) = Bit_exit(20,2) + (Bit_exit(21,2) - Bit_exit(20,2)) * ((Ia(2) - Bit_exit(20,1)) / (Bit_exit(21,1) - Bit_exit(20,1)));
Ia(3) = Func_exit(21,3) + (Func_exit(22,3) - Func_exit(21,3)) * ((Ie(2) - Func_exit(21,2)) / (Func_exit(22,2) - Func_exit(21,2)));
Ie(3) = Bit_exit(21,2) + (Bit_exit(22,2) - Bit_exit(21,2)) * ((Ia(3) - Bit_exit(21,1)) / (Bit_exit(22,1) - Bit_exit(21,1)));
Id(3) = Bit_exit(21,2) + (Bit_exit(22,2) - Bit_exit(21,2)) * ((Ia(3) - Bit_exit(21,1)) / (Bit_exit(22,1) - Bit_exit(21,1)));
Ia(4) = Func_exit(21,3) + (Func_exit(22,3) - Func_exit(21,3)) * ((Ie(3) - Func_exit(21,2)) / (Func_exit(22,2) - Func_exit(21,2)));
Ie(4) = Bit_exit(21,2) + (Bit_exit(22,2) - Bit_exit(21,2)) * ((Ia(4) - Bit_exit(21,1)) / (Bit_exit(22,1) - Bit_exit(21,1)));
Id(4) = Bit_exit(21,2) + (Bit_exit(22,2) - Bit_exit(21,2)) * ((Ia(4) - Bit_exit(21,1)) / (Bit_exit(22,1) - Bit_exit(21,1)));
Ia(5) = Func_exit(21,3) + (Func_exit(22,3) - Func_exit(21,3)) * ((Ie(4) - Func_exit(21,2)) / (Func_exit(22,2) - Func_exit(21,2)));
Ie(5) = Bit_exit(21,2) + (Bit_exit(22,2) - Bit_exit(21,2)) * ((Ia(5) - Bit_exit(21,1)) / (Bit_exit(22,1) - Bit_exit(21,1)));
Id(5) = Bit_exit(21,2) + (Bit_exit(22,2) - Bit_exit(21,2)) * ((Ia(5) - Bit_exit(21,1)) / (Bit_exit(22,1) - Bit_exit(21,1)));
Ia(6) = Func_exit(21,3) + (Func_exit(22,3) - Func_exit(21,3)) * ((Ie(5) - Func_exit(21,2)) / (Func_exit(22,2) - Func_exit(21,2)));
Ie(6) = Bit_exit(21,2) + (Bit_exit(22,2) - Bit_exit(21,2)) * ((Ia(6) - Bit_exit(21,1)) / (Bit_exit(22,1) - Bit_exit(21,1)));
Id(6) = Bit_exit(21,2) + (Bit_exit(22,2) - Bit_exit(21,2)) * ((Ia(6) - Bit_exit(21,1)) / (Bit_exit(22,1) - Bit_exit(21,1)));
line([0 0], [0 Ia(1)], 'LineWidth', 2.0, 'Color', [1 0 1]);
line([0 Ie(1)], [Ia(1) Ia(1)], 'LineWidth', 2.0, 'Color', [1 0 1]);
line([Ie(1) Ie(1)], [Ia(1) Ia(2)], 'LineWidth', 2.0, 'Color', [1 0 1]);
line([Ie(1) Ie(2)], [Ia(2) Ia(2)], 'LineWidth', 2.0, 'Color', [1 0 1]);
line([Ie(2) Ie(2)], [Ia(2) Ia(3)], 'LineWidth', 2.0, 'Color', [1 0 1]);
line([Ie(2) Ie(3)], [Ia(3) Ia(3)], 'LineWidth', 2.0, 'Color', [1 0 1]);
line([Ie(3) Ie(3)], [Ia(3) Ia(4)], 'LineWidth', 2.0, 'Color', [1 0 1]);
line([Ie(3) Ie(4)], [Ia(4) Ia(4)], 'LineWidth', 2.0, 'Color', [1 0 1]);
line([Ie(4) Ie(4)], [Ia(4) Ia(5)], 'LineWidth', 2.0, 'Color', [1 0 1]);
line([Ie(4) Ie(5)], [Ia(5) Ia(5)], 'LineWidth', 2.0, 'Color', [1 0 1]);
line([Ie(5) Ie(5)], [Ia(5) Ia(6)], 'LineWidth', 2.0, 'Color', [1 0 1]);
line([Ie(5) Ie(6)], [Ia(6) Ia(6)], 'LineWidth', 2.0, 'Color', [1 0 1]);

A1 = 1.09542;
B1 = 0.214217;
C1 = 2.33727;
A2 = 0.706692;
B2 = 0.386013;
C2 = -1.75017;

if(Id <= 0.3646)
    Sigma_d = A1 .* Id.^2 + B1 .* Id + C1 .* sqrt(Id);
else
	Sigma_d = -A2 .* log(-B2 .* (Id - 1.0)) - C2 .* Id;
end

Var_d = Sigma_d.^2;
Mean_d = Var_d ./ 2.0;

Pb = 0.5 .* erfc(sqrt(Var_d) ./ (2*sqrt(2)));
err_rate2(:,1) = Ia;
err_rate2(:,2) = Id;
err_rate2(:,3) = Pb;

title('EXIT Chart of Bit-based Message Passing Algorithm in MIMO Fading Channel');
xlabel('I_A_,_F_N_D,  I_E_,_B_N_D');
ylabel('I_E_,_F_N_D,  I_A_,_B_N_D');
axis([0 1 0 1]);

legend('Function Node', 'Bit Node', 'Decision Node', '16dB', 2);
% %print -djpeg100 EXIT_Bit_Message_Passing_MIMO_16.jpg;
