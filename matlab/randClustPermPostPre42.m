function [critClustSize,critT]=randClustPermPostPre42(n)
cd /home/yuval/Data/perm
clustSize=zeros(n,1);
if exist('tMinMax.txt','file')
    !rm tMinMax.txt
end
if exist('Post_Pre+tlrc.BRIK','file')
    !rm Post_Pre+tlrc*
end
!ls quad*01 -d > ls.txt
LSA=importdata('ls.txt');
!ls quad*02 -d > ls.txt
LSB=importdata('ls.txt');
for permi=1:n
    if exist('TTnew+tlrc.BRIK','file')
        !rm TTnew+tlrc*
    end
    rnd1=round(rand(1,length(LSA))+1);
    rnd2=rnd1*-1+3;
    setA='-setA r1 ';
    setB='-setB r2 ';
    for subi=1:33
        setA=[setA,LSA{subi},'r1 ',LSA{subi},'/alpha',num2str(rnd1(subi)),'+tlrc '];
        setB=[setB,LSB{subi},'r1 ',LSB{subi},'/alpha',num2str(rnd2(subi)),'+tlrc '];
    end

    command = ['~/abin/3dttest++ -paired -no1sam -mask ~/SAM_BIU/docs/MASKbrain+tlrc ',setA,setB];
    [~, ~] = unix(command);
    
    % !~/abin/3dExtrema -volume -closure -data_thr 3 TTnew+tlrc[1]
    % !~/abin/3dExtrema -volume -closure -data_thr 3 -minima TTnew+tlrc[1]
    % !~/abin/3dExtrema -volume -closure -data_thr 3 -minima -output min TTnew+tlrc[1]
    !~/abin/3dBrickStat -min -max TTnew+tlrc'[1]' >> tMinMax.txt
    !~/abin/3dcalc -a TTnew+tlrc'[1]' -exp 'ispositive(a-3)*a' -prefix pos
    !~/abin/3dcalc -a TTnew+tlrc'[1]' -exp '-1*isnegative(a+3)*a' -prefix neg
    
    !~/abin/3dclust -quiet -1clip 3 5 125 neg+tlrc > negClust.txt
    !~/abin/3dclust -quiet -1clip 3 5 125 pos+tlrc > posClust.txt
    negClust=importdata('negClust.txt');
    posClust=importdata('posClust.txt');
    if iscell(negClust)
        negClustSize=0;
    else
        negClustSize=negClust(1)/125;
    end
    if iscell(posClust)
        posClustSize=0;
    else
        posClustSize=posClust(1)/125;
    end
    
    clustSize(permi,1)=max([negClustSize,posClustSize]);
    !rm neg+tlrc*
    !rm pos+tlrc*
end

clustSize=sort(clustSize,'descend');
% take the 5% greatest volumes (in voxels) as critical cluster size
critClustSize=clustSize(ceil(0.05*n));
% take the 5% extreme (max and -1*min) t values as criticat t
tList=importdata('tMinMax.txt');
tList=[-tList(:,1);tList(:,2)];
tList=sort(tList,'descend');
critT=tList(ceil(0.05*n*2));


rnd1=ones(1,length(LSA));
rnd2=rnd1+1;

setA='-setA r1 ';
setB='-setB r2 ';
for subi=1:33
    setA=[setA,LSA{subi},'r1 ',LSA{subi},'/alpha',num2str(rnd1(subi)),'+tlrc '];
    setB=[setB,LSB{subi},'r1 ',LSB{subi},'/alpha',num2str(rnd2(subi)),'+tlrc '];
end
% making the real ttest
command = ['~/abin/3dttest++ -paired -no1sam -prefix Post_Pre -mask ~/SAM_BIU/docs/MASKbrain+tlrc ',setA,setB];
[~, ~] = unix(command);
end


% if exist('tV1V2+tlrc.BRIK')
%     !rm tV1V2+tlrc.*
% end
% unix(['~/abin/3dttest++ -paired -prefix tV1V2 -no1sam -mask ~/SAM_BIU/docs/MASKbrain+tlrc ',...
%     '-setA V1 ',...
%     'sub05v1 quad0501/alpha2+tlrc ',...
%     'sub06v1 quad0601/alpha2+tlrc ',...
%     'sub07v1 quad0701/alpha2+tlrc ',...
%     'sub09v1 quad0901/alpha2+tlrc ',...
%     'sub10v1 quad1001/alpha2+tlrc ',...
%     'sub14v1 quad1401/alpha2+tlrc ',...
%     'sub15v1 quad1501/alpha2+tlrc ',...
%     'sub16v1 quad1601/alpha2+tlrc ',...
%     'sub18v1 quad1801/alpha2+tlrc ',...
%     '-setB V2 ',...
%     'sub05v2 quad0502/alpha2+tlrc ',...
%     'sub06v2 quad0602/alpha2+tlrc ',...
%     'sub07v2 quad0702/alpha2+tlrc ',...
%     'sub09v2 quad0902/alpha2+tlrc ',...
%     'sub10v2 quad1002/alpha2+tlrc ',...
%     'sub14v2 quad1402/alpha2+tlrc ',...
%     'sub15v2 quad1502/alpha2+tlrc ',...
%     'sub16v2 quad1602/alpha2+tlrc ',...
%     'sub18v2 quad1802/alpha2+tlrc']);
