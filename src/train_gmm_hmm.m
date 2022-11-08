function lambda = train_gmm_hmm(trainset_gmm_hmm, lambda)
train_Hard = trainset_gmm_hmm.train_Hard;
train_Soft = trainset_gmm_hmm.train_Soft;
[p, Q]= size(lambda.B);

Data_HARD = reshape(permute(train_Hard, [3,2,1]),[],1);
Data_SOFT = reshape(permute(train_Soft,[3,2,1,4]), [], p);

parfor i=1:p
    id = find(Data_HARD==i);
    tmp = Data_SOFT(id,:);
    [pi, mu_tmp, Sigma_tmp, loglik] = Gmm(tmp, Q, 'cov_type', 'full', 'cov_thresh', 1e-1, 'restart_num', 1, 'iter_num', 100);
    mu(:,:,i) = mu_tmp;
    Sigma(:,:,:,i) = Sigma_tmp;
end

lambda.mu = permute(mu,[1 3 2]);
lambda.Sigma = permute(Sigma,[1 2 4 3]);
end