close all; 
clear all;
set(gca, 'fontsize', 14)

load BER_Bit_based_Message_Passing.log;
load BER_Bit_based_Message_Passing_no.log;
semilogy(BER_Bit_based_Message_Passing(1:6,1), BER_Bit_based_Message_Passing(1:6,2), '-go',  'LineWidth', 2.0, 'MarkerSIze', 10);
hold on;
grid on;
semilogy(BER_Bit_based_Message_Passing(1:6,1), BER_Bit_based_Message_Passing(1:6,3), '-bd',  'LineWidth', 2.0, 'MarkerSIze', 10);
% semilogy(BER_Bit_based_Message_Passing(1:6,1), BER_Bit_based_Message_Passing(1:6,4), '-bd',  'LineWidth', 2.0, 'MarkerSIze', 12);
% semilogy(BER_Bit_based_Message_Passing(1:6,1), BER_Bit_based_Message_Passing(1:6,5), '-cs',  'LineWidth', 2.0, 'MarkerSIze', 10);
% semilogy(BER_Bit_based_Message_Passing(1:6,1), BER_Bit_based_Message_Passing(1:6,6), '-k^',  'LineWidth', 2.0, 'MarkerSIze', 10);
semilogy(BER_Bit_based_Message_Passing(1:6,1), BER_Bit_based_Message_Passing(1:6,7), '-rs',  'LineWidth', 2.0, 'MarkerSIze', 10);

semilogy(BER_Bit_based_Message_Passing_no(1:6,1), BER_Bit_based_Message_Passing_no(1:6,2), '-.g*',  'LineWidth', 2.0, 'MarkerSIze', 12);
semilogy(BER_Bit_based_Message_Passing_no(1:6,1), BER_Bit_based_Message_Passing_no(1:6,3), '-.bx',  'LineWidth', 2.0, 'MarkerSIze', 12);
% semilogy(BER_Bit_based_Message_Passing_no(1:6,1), BER_Bit_based_Message_Passing_no(1:6,4), '-.bd',  'LineWidth', 2.0, 'MarkerSIze', 12);
% semilogy(BER_Bit_based_Message_Passing_no(1:6,1), BER_Bit_based_Message_Passing_no(1:6,5), '-.cs',  'LineWidth', 2.0, 'MarkerSIze', 10);
% semilogy(BER_Bit_based_Message_Passing_no(1:6,1), BER_Bit_based_Message_Passing_no(1:6,6), '-.k^',  'LineWidth', 2.0, 'MarkerSIze', 10);
semilogy(BER_Bit_based_Message_Passing_no(1:6,1), BER_Bit_based_Message_Passing_no(1:6,7), '-.r+',  'LineWidth', 2.0, 'MarkerSIze', 12);
plot(0, 1, 'w');


%title('BER Performance of the Proposed Algorithm in MIMO (2x2) ITU-VA Channel');
xlabel('E_b/N_0 (dB)');
ylabel('Probability of Bit Error');
axis([0 25 1e-4 1]);

legend('1_s_t ite.', '2_n_d ite.', '6_t_h ite.', '1_s_t ite. w/o PPIC', '2_n_d ite. w/o PPIC', '6_t_h ite. w/o PPIC', 'QPSK, VA500', 3);
%legend('1_s_t Iteration', '2_n_d Iteration', '3_r_d Iteration', '6_t_h Iteration', 'QPSK, f_DxT_s = 0.1', 3);
%print -djpeg100 Bit_Message_Passing_MIMO_500.jpg;
