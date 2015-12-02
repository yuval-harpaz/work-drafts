function [g2sum,g2max,rep,g2byWin]=g2loop(X,Nsamp,overlap)
% computes g2 with a sliding window
% x is a data matrix (or a vector), raws for channels, columns for time samples.
% Nsamp is how many samples to include in a window
% overlap should  0.5 or 0
if ~exist('overlap','var')
    overlap=0;
end
g2sum=zeros(size(X,1),1);
g2max=g2sum;
samp0=round(1:(Nsamp-overlap*Nsamp):size(X,2));
samp1=samp0+round(Nsamp)-1;
out=find(samp1>size(X,2),1);
if ~ isempty(out)
    samp0=samp0(1:out-1);
    samp1=samp1(1:out-1);
end
rep=length(samp0);
g2byWin=[];
for wini=1:rep
    g2win=g2(X(:,samp0(wini):samp1(wini)));
    g2win(g2win<0)=0;
    g2sum=g2sum+g2win;
    g2max=max([g2max,g2win],[],2);
    if nargout==4
        g2byWin=[g2byWin,g2win];
    end
        
end


