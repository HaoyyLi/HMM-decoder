function lambda = train_hmm(trainset, config)

K = config.K;
P = config.P;
method = config.method;

train_state = trainset.train_state;
train_observation = trainset.train_observation;
train_packnum = size(train_state, 1);
block_len = size(train_state, 2);

B = zeros(size(train_observation,1),2^P,2^K);
for snr=1:size(B,1)
    for p=1:train_packnum
        for i=1:2^P
            for j=1:2^K
                for n=1:size(train_state,2)
                    if (train_state(p,n)==j && train_observation(snr,p,n)==i)
                        B(snr,i,j)=B(snr,i,j)+1;
                    end
                end
            end
        end
    end
    B(snr,:,:) = B(snr,:,:)/block_len/train_packnum;
    B(snr,:,:) = B(snr,:,:)./sum(B(snr,:,:),2);
end
B = squeeze(mean(B,1));

if strcmp(config.method, 'CONV')
A = state_trans(K);
elseif strcmp(config.method, 'RSC')
A = zeros(2^K, 2^K);
for p=1:train_packnum
    s = train_state(p,:);
    for i=1:2^K
        for j=1:2^K
            for n=1:block_len-1
                if (s(n+1)==j && s(n)==i)
                    A(i,j)=A(i,j)+1;
                end
            end
        end
    end
end
A = A./sum(A,2);
A(find(A~=0))=0.5;
else
    error('config.method must be CONV or RSC.')
end

lambda.A = A;
lambda.B = B;
phi = zeros(1, 2^K);
phi(1,1) = 0.5;
phi(1, 2^(K-1)+1) = 0.5;
lambda.phi = phi;
end