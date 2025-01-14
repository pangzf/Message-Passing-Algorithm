close all; 
clear all;
set(gca, 'fontsize', 12)

load BER_with_inter.log;
load BER_no_inter.log;

semilogy(BER_with_inter(:,1), BER_with_inter(:,2), '-ro',  'LineWidth', 2.0, 'MarkerSIze', 10);
grid on;
hold on;
semilogy(BER_with_inter(:,1), BER_with_inter(:,3), '-b^',  'LineWidth', 2.0, 'MarkerSIze', 10);
semilogy(BER_with_inter(:,1), BER_with_inter(:,4), '-c+',  'LineWidth', 2.0, 'MarkerSIze', 12);
semilogy(BER_with_inter(:,1), BER_with_inter(:,5), '-ms',  'LineWidth', 2.0, 'MarkerSIze', 10);
semilogy(BER_with_inter(:,1), BER_with_inter(:,6), '-g*',  'LineWidth', 2.0, 'MarkerSIze', 12);
%semilogy(BER_with_inter(:,1), BER_with_inter(:,7), '-rs',  'LineWidth', 2.0, 'MarkerSIze', 10);
% semilogy(BER_with_inter(:,1), BER_with_inter(:,8), '-mx',  'LineWidth', 2.0, 'MarkerSIze', 10);
% semilogy(BER_with_inter(:,1), BER_with_inter(:,9), '-rs',  'LineWidth', 2.0, 'MarkerSIze', 10);
% semilogy(BER_with_inter(:,1), BER_with_inter(:,10), '-rs',  'LineWidth', 2.0, 'MarkerSIze', 10);
% semilogy(BER_with_inter(:,1), BER_with_inter(:,11), '-ms',  'LineWidth', 2.0, 'MarkerSIze', 10);

semilogy(BER_no_inter(:,1), BER_no_inter(:,2), '-.ro',  'LineWidth', 2.0, 'MarkerSIze', 10);
semilogy(BER_no_inter(:,1), BER_no_inter(:,3), '-.b^',  'LineWidth', 2.0, 'MarkerSIze', 10);
semilogy(BER_no_inter(:,1), BER_no_inter(:,4), '-.c+',  'LineWidth', 2.0, 'MarkerSIze', 12);
semilogy(BER_no_inter(:,1), BER_no_inter(:,5), '-.ms',  'LineWidth', 2.0, 'MarkerSIze', 10);
semilogy(BER_no_inter(:,1), BER_no_inter(:,6), '-.g*',  'LineWidth', 2.0, 'MarkerSIze', 12);
%semilogy(BER_no_inter(:,1), BER_no_inter(:,7), '-.rs',  'LineWidth', 2.0, 'MarkerSIze', 10);
% semilogy(BER_no_inter(:,1), BER_no_inter(:,8), '-mx',  'LineWidth', 2.0, 'MarkerSIze', 10);
% semilogy(BER_no_inter(:,1), BER_no_inter(:,9), '-rs',  'LineWidth', 2.0, 'MarkerSIze', 10);
% semilogy(BER_no_inter(:,1), BER_no_inter(:,10), '-rs',  'LineWidth', 2.0, 'MarkerSIze', 10);
% semilogy(BER_no_inter(:,1), BER_no_inter(:,11), '-.mv',  'LineWidth',
% 2.0, 'MarkerSIze', 10);

%title('BER Performance of MPA with Gallager (20,4,3) in MIMO (4x4) VA Channel');
xlabel('E_b/N_0 (dB)');
ylabel('Probability of Bit Error');
axis([0 16 1e-6 1]);

legend('Interleaved: 1_s_t ite.', 'Interleaved: 2_n_d ite.', 'Interleaved: 3_r_d ite.', 'Interleaved: 4_t_h ite.', 'Interleaved: 5_t_h ite.', 'w/o Interleaving: 1_s_t ite.', 'w/o Interleaving: 2_n_d ite.', 'w/o Interleaving: 3_r_d ite.', 'w/o Interleaving: 4_t_h ite.', 'w/o Interleaving: 5_t_h ite.', 3);
%print -djpeg100 BER_with_inter_120.jpg;
