function [critT,critClustSize]=alicePermuteFour(prefix)

sf={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};
tThresh=3;%2.044;


if exist('tMinMax.txt','file')
    !rm tMinMax.txt
end
if exist([prefix,'ttest+tlrc.BRIK'],'file')
    eval(['!rm ',prefix,'ttest+tlrc*'])
end
if exist('neg+tlrc.BRIK','file')
    !rm neg+tlrc*
    !rm pos+tlrc*
end

for subi=1:8
    eval(['!~/abin/3dcalc -prefix ',prefix,'_',num2str(subi),'_neg -a ',prefix,'_',num2str(subi),'+tlrc -exp ''','-a'''])
end
% making all possible permutations list
n = 8 ;
M = (dec2bin(0:(2^n)-1)=='1');
M=M(2:2^(n-1),:);
M=M(find(sum(M')==4),:);
M=M+1;
clustSize=zeros(length(M),2);
conds={'','_neg'};
for permi=1:length(M)
    if exist('./TTnew+tlrc.BRIK','file')
        !rm TTnew+tlrc*
    end
    setA='-setA r1 ';
    for subi=1:8
        setA=[setA,sf{subi},'r1 ',prefix,'_',num2str(subi),conds{M(permi,subi)},'+tlrc '];
    end
    command = ['~/abin/3dttest++ -no1sam -mask ~/SAM_BIU/docs/MASKctx+tlrc ',setA];
    %     eval(['!',command])
    [~, ~] = unix(command);
    % read min and max t value
    !~/abin/3dBrickStat -min -max TTnew+tlrc'[1]' >> tMinMax.txt
    % compute volume of largest positive and negative clusters
    eval(['!~/abin/3dcalc -a TTnew+tlrc''','[1]''',' -exp ''','ispositive(a-',num2str(tThresh),')*a''',' -prefix pos'])
    eval(['!~/abin/3dcalc -a TTnew+tlrc''','[1]''',' -exp ''','isnegative(a+',num2str(tThresh),')*a''',' -prefix neg'])
    eval(['!~/abin/3dclust -quiet -1clip ',num2str(tThresh),' 5 125 neg+tlrc > negClust.txt'])
    eval(['!~/abin/3dclust -quiet -1clip ',num2str(tThresh),' 5 125 pos+tlrc > posClust.txt'])
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
    clustSize(permi,1:2)=[negClustSize,posClustSize];
    !rm neg+tlrc*
    !rm pos+tlrc*
    !rm *Clust.txt
end
clustSize=[clustSize(:,1);clustSize(:,2)];
clustSize=sort(clustSize,'descend');
% take the 5% greatest volumes (in voxels) as critical cluster size
critClustSize=clustSize(ceil(0.05*permi*2));
% take the 5% extreme (max and -1*min) t values as criticat t
tList=importdata('tMinMax.txt');
tList=[-tList(:,1);tList(:,2)];
tList=sort(tList,'descend');
critT=tList(ceil(0.05*permi*2));
!rm tMinMax.txt

% real ttest now
setA='-setA r1 ';
for subi=1:8
    setA=[setA,sf{subi},'r1 ',prefix,'_',num2str(subi),'+tlrc '];
end
command = ['~/abin/3dttest++ -prefix ',prefix,'ttest -no1sam -mask ~/SAM_BIU/docs/MASKctx+tlrc ',setA];
eval(['!',command])
[~, ~] = unix(command);
% now open AFNI and view Post_Pre+tlrc.
% to see if you have sig voxels check the range of the overlay (see arrow0). Note, there
% are two images there, means difference (brik[0]) and t values (brik[1]).
% choose [1] in Define Overlay (Arrow1).
% to see if you have large clusters set the threshold to tThresh (arrow with no number), click on
% clusterize (arrow2), set (arrow3), Rpt (arrow4). Look at the list for
% cluster size (arrow6).

!~/abin/afni -dset ~/SAM_BIU/docs/temp+tlrc &
!rm *_neg*
!rm TTnew+tlrc*