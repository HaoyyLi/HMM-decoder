function HMM_Decoder
global config
addpath('./matlab-hmm')
addpath('./matlab-hmm/matlab-gmm')
%%
dataset = load(config.filename);
data = dataset.data;
%% 
[trainset_hmm, trainset_gmm_hmm, test_data, test_observation_hard, test_observation_soft] = splic_data(dataset, config);
block_len = size(data,2);
snr_num = size(dataset.desig, 1);
%% training hmm
lambda = train_hmm(trainset_hmm, config);
%% Decoding--hard decision
berhard_HMM = ones(snr_num,config.test_packnum);
for snr = 1:snr_num
parfor n=1:config.test_packnum
% Calculate p(X) & vertibi decode
logp_xn_given_zn = Discrete_logp_xn_given_zn(squeeze(test_observation_hard(snr,n,:)), lambda);
[~,~, loglik] = LogForwardBackward(logp_xn_given_zn, lambda.phi, lambda.A);
path = LogViterbiDecode(logp_xn_given_zn, lambda.phi, lambda.A);
dedata = dec2bin(path-1);
dedata = str2num(dedata(:,1));
berhard_HMM(snr,n) = biterr(dedata,test_data(n,:)')/block_len;
end
end
%% training gmm
lambda = train_gmm_hmm(trainset_gmm_hmm, lambda);
%% Decoding--soft decision
bersoft_HMM = ones(snr_num,config.test_packnum);
for snr = 1:snr_num
parfor n=1:config.test_packnum
% Calculate p(X) & vertibi decode
logp_xn_given_zn = Gmm_logp_xn_given_zn(squeeze(test_observation_soft(snr,n,:,:)), lambda);
[~,~, loglik] = LogForwardBackward(logp_xn_given_zn, lambda.phi, lambda.A);
path = LogViterbiDecode(logp_xn_given_zn, lambda.phi, lambda.A);

dedata = dec2bin(path-1);
dedata = str2num(dedata(:,1));
bersoft_HMM(snr,n) = biterr(dedata,test_data(n,:)')/block_len;
end
end
%%
ber_test = dataset.ber(:,end-config.test_packnum+1:end);
berhard_test = dataset.berhard(:,end-config.test_packnum+1:end);
bersoft_test = dataset.bersoft(:,end-config.test_packnum+1:end);
%%
figure1 = figure;
set(gcf,'unit','centimeters','position',[6 6 14 10]);
set(gcf,'ToolBar','none','ReSize','off'); 
set(gcf,'color','w');

EbN0 = 0:1:12;
semilogy(EbN0,mean(ber_test(1:13,:),2),'k--')
hold on
semilogy(EbN0,mean(berhard_test(1:13,:),2),'k*--')
semilogy(EbN0,mean(berhard_HMM(1:13,:),2),'b*-')
semilogy(EbN0,mean(bersoft_test(1:13,:),2),'k^--')
semilogy(EbN0,mean(bersoft_HMM(1:13,:),2),'r^-')

grid on
set(gca, 'XTicklabel',0:2:12,'FontSize',12)
set(gca, 'YTick',[1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1],'FontSize',12)
xlabel('Eb/N0(dB)', 'FontSize',14)
ylabel('Bit Error Rate(BER)', 'FontSize',14)
legend('Unencode','Viterbi Decoder Hard','HMM Decoder Hard','Viterbi Decoder Soft','HMM Decoder Soft','Location','best', 'FontSize',8)
