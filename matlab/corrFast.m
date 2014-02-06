function R=corrFast(data1,data2)
% thanks to rob welsh who tipped the world here http://www.mathworks.com/matlabcentral/fileexchange/34982-a-faster-way-to-computer-a-correlation-matrix-than-corr-m
if exist('data2','var')
    C=cov([data1,data2]);
    R=RfromC(C);
    % siz=length(data
    s1=size(data1,2);s2=size(data2,2);
    R=R(1:s1,s1+1:s1+s2);
else
    C=cov(data1);
    R=RfromC(C);
    R=R+R'+eye(size(R));
end
function R=RfromC(C)
n_dim=length(C);
R=zeros(n_dim,n_dim);
sd=sqrt(diag(C));
for a=1:n_dim,
    %for b=1:n_dim,
    for b=a+1:n_dim,
        R(a,b)=C(a,b)/(sd(a)*sd(b));
    end
end