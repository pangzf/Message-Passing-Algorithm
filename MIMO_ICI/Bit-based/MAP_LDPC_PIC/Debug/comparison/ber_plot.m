close all; 
clear all;
set(gca, 'fontsize', 12)

load BER_MPA_LDPC.log;
load BER_ML_PIC_LDPC.log;

semilogy(BER_MPA_LDPC(:,1), BER_MPA_LDPC(:,2), '-ro',  'LineWidth', 2.0, 'MarkerSIze', 10);
hold on;
grid on;
semilogy(BER_MPA_LDPC(:,1), BER_MPA_LDPC(:,3), '-bd',  'LineWidth', 2.0, 'MarkerSIze', 10);
semilogy(BER_MPA_LDPC(:,1), BER_MPA_LDPC(:,4), '-c*',  'LineWidth', 2.0, 'MarkerSIze', 12);
% semilogy(BER_MPA_LDPC(:,1), BER_MPA_LDPC(:,5), '-cs',  'LineWidth', 2.0, 'MarkerSIze', 10);
% semilogy(BER_MPA_LDPC(:,1), BER_MPA_LDPC(:,6), '-g^',  'LineWidth', 2.0, 'MarkerSIze', 10);
% semilogy(BER_MPA_LDPC(:,1), BER_MPA_LDPC(:,7), '-rs',  'LineWidth', 2.0, 'MarkerSIze', 10);
% semilogy(BER_MPA_LDPC(:,1), BER_MPA_LDPC(:,8), '-mx',  'LineWidth', 2.0, 'MarkerSIze', 10);
% semilogy(BER_MPA_LDPC(:,1), BER_MPA_LDPC(:,9), '-rs',  'LineWidth', 2.0, 'MarkerSIze', 10);
% semilogy(BER_MPA_LDPC(:,1), BER_MPA_LDPC(:,10), '-rs',  'LineWidth', 2.0, 'MarkerSIze', 10);
semilogy(BER_MPA_LDPC(:,1), BER_MPA_LDPC(:,11), '-ms',  'LineWidth', 2.0, 'MarkerSIze', 10);

semilogy(BER_ML_PIC_LDPC(:,1), BER_ML_PIC_LDPC(:,2), '-.rx',  'LineWidth', 2.0, 'MarkerSIze', 10);
semilogy(BER_ML_PIC_LDPC(:,1), BER_ML_PIC_LDPC(:,3), '-.bp',  'LineWidth', 2.0, 'MarkerSIze', 10);
semilogy(BER_ML_PIC_LDPC(:,1), BER_ML_PIC_LDPC(:,4), '-.c^',  'LineWidth', 2.0, 'MarkerSIze', 12);
% semilogy(BER_ML_PIC_LDPC(:,1), BER_ML_PIC_LDPC(:,5), '-.cs',  'LineWidth', 2.0, 'MarkerSIze', 10);
% semilogy(BER_ML_PIC_LDPC(:,1), BER_ML_PIC_LDPC(:,6), '-.g^',  'LineWidth', 2.0, 'MarkerSIze', 10);
% semilogy(BER_ML_PIC_LDPC(:,1), BER_ML_PIC_LDPC(:,7), '-.rs',  'LineWidth', 2.0, 'MarkerSIze', 10);
% semilogy(BER_ML_PIC_LDPC(:,1), BER_ML_PIC_LDPC(:,8), '-.mx',  'LineWidth', 2.0, 'MarkerSIze', 10);
% semilogy(BER_ML_PIC_LDPC(:,1), BER_ML_PIC_LDPC(:,9), '-.rs',  'LineWidth', 2.0, 'MarkerSIze', 10);
% semilogy(BER_ML_PIC_LDPC(:,1), BER_ML_PIC_LDPC(:,10), '-.rs',  'LineWidth', 2.0, 'MarkerSIze', 10);
semilogy(BER_ML_PIC_LDPC(:,1), BER_ML_PIC_LDPC(:,11), '-.m+',  'LineWidth', 2.0, 'MarkerSIze', 10);
plot(0, 1, 'w');

%title('BER Performance of the Proposed Algorithm in MIMO (2x2) ITU VA Channel');
xlabel('E_b/N_0 (dB)');
ylabel('Probability of Bit Error');
axis([0 16 1e-6 1]);

legend('PPIC+MPD+LDPC: 1_s_t ite.', 'PPIC+MPD+LDPC: 2_n_d ite.', 'PPIC+MPD+LDPC: 3_r_d ite.', 'PPIC+MPD+LDPC: 10_t_h ite.', 'PIC+MLD+LDPC: 1_s_t ite.', 'PIC+MLD+LDPC: 2_n_d ite.', 'PIC+MLD+LDPC: 3_r_d ite.', 'PIC+MLD+LDPC: 10_t_h ite.', 'QPSK VA350', 3);
print -djpeg100 BER_MPA_LDPC_350.jpg;