function aliceAvgTlrc(prefix,mask)
% prefix='alice179';
% mask=0
cd /home/yuval/Copy/MEGdata/alice/func
str='!~/abin/3dcalc ';
letters={'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h'};

for subi=1:8
    str=[str,'-',letters{subi},' ',prefix,'_',num2str(subi),'+tlrc '];
end
str=[str,' -prefix ',prefix,' -exp ''','(1e-8)*(a+b+c+d+e+f+g+h)/8'''];
eval(str)
if ~exist('mask','var')
    mask=[];
end
if isempty(mask)
    mask=1;
end
if mask>0
    masktlrc([prefix,'+tlrc'],'~/SAM_BIU/docs/MASKctx+tlrc')
end