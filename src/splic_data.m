function [trainset_hmm, trainset_gmm_hmm, test_data, test_observation_hard, test_observation_soft] = splic_data(dataset, config)

data = dataset.data;
desig = dataset.desig;
softprobably = dataset.softprobably;

K = config.K;
P = config.P;
train_packnum = config.train_packnum;
test_packnum = config.test_packnum;

block_len = size(data,2);
snr_num = size(desig,1);

train_data = data(1:train_packnum, :);
test_data = data(end-test_packnum+1:end,:);

train_state=zeros(train_packnum,block_len);
s=zeros(block_len,K);


if strcmp(config.method, 'CONV')
    for p=1:train_packnum
        s(1,1)=train_data(p,1);
        for i=2:block_len
            s(i,2:K) = s(i-1,1:K-1);
            s(i,1) = train_data(p,i);
        end
        for i=1:K
            train_state(p,:) = train_state(p,:) + s(:,i)'*2^(K-i);
        end
        train_state(p,:)=train_state(p,:)+1;
    end
elseif strcmp(config.method, 'RSC')
    for p=1:train_packnum
        s(1,1)=train_data(p,1);
        for i=2:block_len
            s(i,K) = s(i-1,K-1);
            s(i,2) = mod(sum(s(i-1,:)),2);
            s(i,1) = data(p,i);
        end
        for i=1:K
            train_state(p,:) = train_state(p,:) + s(:,i)'*2^(K-i);
        end
        train_state(p,:)=train_state(p,:)+1;
    end  
else
    error('config.method must be CONV or RSC.')
end


seen_HARD = zeros(snr_num, size(desig,2), block_len);
for snr=1:snr_num
seen_ = permute(reshape(desig(snr,:,:),size(desig,2),P,[]),[1 3 2]);
temp = 0;
for i=1:P
    temp = temp + seen_(:,:,i)*2^(P-i);
end
seen_ = temp+1;
seen_HARD(snr,:,:) = seen_;
end
train_observation_hard = seen_HARD(:,1:train_packnum, :);
test_observation_hard = seen_HARD(:, end-test_packnum+1:end,:);

seen_SOFT=zeros(snr_num,size(softprobably,2),block_len,2^P);
for snr=1:snr_num
for i=1:size(softprobably,2)
    seen_=reshape(softprobably(snr,i,:),P,[])';
    for j=1:2^P
        tmp = dec2bin(2^P+j-1)-'0';
        tmp(1) = [];
        
        temp = 1;
        for n=1:P
            if (tmp(n)==1)
                temp = temp .* seen_(:,n);
            else
                temp = temp .* (1-seen_(:,n));
            end
        end
        seen_S(i,:,j) = temp;
    end
end
seen_SOFT(snr,:,:,:)=seen_S;
end

train_observation_soft = seen_SOFT(:,1:train_packnum, :,:);
test_observation_soft = seen_SOFT(:, end-test_packnum+1:end,:,:);

trainset_hmm.train_state = train_state;
trainset_hmm.train_observation = train_observation_hard;
trainset_gmm_hmm.train_Hard = train_observation_hard;
trainset_gmm_hmm.train_Soft = train_observation_soft;
end