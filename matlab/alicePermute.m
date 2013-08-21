function [critT,critClustSize]=alicePermute(prefix,four)
% four is to take 4 subjects real and 4 subjects negative dif., 0 or 1
if ~exist('four','var')
    four=[];
end
if isempty(four)
    four=false;
end
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
if four
    M=M(find(sum(M')==4),:);
end
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
%[~, ~] = unix(command);

% dig in results
eval(['!~/abin/3dBrickStat -min -max ',prefix,'ttest+tlrc[1] > tMinMaxReal.txt'])
tReal=importdata('tMinMaxReal.txt');

% compute volume of largest positive and negative clusters
eval(['!~/abin/3dcalc -a ',prefix,'ttest+tlrc''','[1]''',' -exp ''','ispositive(a-',num2str(tThresh),')*a''',' -prefix pos'])
eval(['!~/abin/3dcalc -a ',prefix,'ttest+tlrc''','[1]''',' -exp ''','isnegative(a+',num2str(tThresh),')*a''',' -prefix neg'])
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
clustSizeReal=[negClustSize,posClustSize];
!rm neg+tlrc*
!rm pos+tlrc*
!rm *Clust.txt
% messages
sig={' ',' ',' ',' '};
nothing=true;
if -tReal(1)>critT
    sig{1}='*';
    nothing=false;
end
if tReal(2)>critT
    sig{2}='*';
    nothing=false;
end
if clustSizeReal(1)>critClustSize
    sig{3}='*';
    nothing=false;
end
if clustSizeReal(2)>critClustSize
    sig{4}='*';
    nothing=false;
end
disp(['critical T value = ',num2str(critT)]);
disp(['extreme t values are: ',num2str(tReal(1)),' ',sig{1},'     ',num2str(tReal(2)),sig{2}])
disp(['critical cluster size is = ',num2str(critClustSize)]);
disp(['neg and pos clusters: ',num2str(clustSizeReal(1)),' ',sig{3},'     ',num2str(clustSizeReal(2)),sig{4}])
disp('')
if nothing
    disp('NOTHING!!!')
end

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