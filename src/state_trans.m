function A = state_trans(K)

A = zeros(2^K, 2^K);
for i=1:2:2^K
    A(i,1+floor(i/2)) = 0.5;
    A(i+1,1+floor(i/2)) = 0.5;
    A(i,2^(K-1)+1+floor(i/2)) = 0.5;
    A(i+1,2^(K-1)+1+floor(i/2)) = 0.5;  
end
end