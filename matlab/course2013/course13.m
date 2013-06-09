%% Random permutations for multiple comparisons
% Here we perform dependent sample ttest for every voxel. we have two
% measurements per subject, one before and one after some task (alpha1 and
% alpha2. We run the ttest in the end but first we compote the ttest with
% random run order, so for subject 1 we take alpha1 - alpha2 and for
% subject 2 the other way around. then we see if we still have main effect,
% and what size of clusters we get if we mask with a fixed threshold. We
% run it n times and make a distribution of the maximum t value and maximum
% cluster size. In the end we see if the real ttest yielded an extreme t
% value anywhere or whether the clusters are extremely big.

%% Set N permutations and Threshold
n=100;
tThresh=2.044;

%% Run the permutations
clustSize=zeros(n,2);
if exist('tMinMax.txt','file')
    !rm tMinMax.txt
end
if exist('Post_Pre_Norm+tlrc.BRIK','file')
    !rm Post_Pre+tlrc*
end
if exist('neg+tlrc.BRIK','file')
    !rm neg+tlrc*
    !rm pos+tlrc*
end

!ls quad*01 -d > ls.txt
LSA=importdata('ls.txt');
!rm ls
for permi=1:n
    if exist('TTnew+tlrc.BRIK','file')
        !rm TTnew+tlrc*
    end
    rnd1=round(rand(1,length(LSA))+1);
    rnd2=rnd1*-1+3;
    setA='-setA r1 ';
    setB='-setB r2 ';
    for subi=1:length(LSA)
        setA=[setA,LSA{subi},'r1 ',LSA{subi},'/alpha',num2str(rnd1(subi)),'+tlrc '];
        setB=[setB,LSA{subi},'r1 ',LSA{subi},'/alpha',num2str(rnd2(subi)),'+tlrc '];
    end
    % next two lines run 3dttest++, one permutation
    command = ['~/abin/3dttest++ -paired -no1sam -mask ~/SAM_BIU/docs/MASKbrain+tlrc ',setA,setB];
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
critClustSize=clustSize(ceil(0.05*n*2));
% take the 5% extreme (max and -1*min) t values as criticat t
tList=importdata('tMinMax.txt');
tList=[-tList(:,1);tList(:,2)];
tList=sort(tList,'descend');
critT=tList(ceil(0.05*n*2));
!rm tMinMax.txt
%% Making the real ttest
rnd1=ones(1,length(LSA));
rnd2=rnd1+1;

setA='-setA r1 ';
setB='-setB r2 ';
for subi=1:length(LSA)
    setA=[setA,LSA{subi},'r1 ',LSA{subi},'/alpha',num2str(rnd1(subi)),'+tlrc '];
    setB=[setB,LSA{subi},'r1 ',LSA{subi},'/alpha',num2str(rnd2(subi)),'+tlrc '];
end
% making the real ttest
command = ['~/abin/3dttest++ -paired -no1sam -prefix Post_Pre -mask ~/SAM_BIU/docs/MASKbrain+tlrc ',setA,setB];
[~, ~] = unix(command);
% now open AFNI and view Post_Pre+tlrc.
% to see if you have sig voxels check the range of the overlay (see arrow0). Note, there
% are two images there, means difference (brik[0]) and t values (brik[1]).
% choose [1] in Define Overlay (Arrow1).
% to see if you have large clusters set the threshold to tThresh (arrow with no number), click on
% clusterize (arrow2), set (arrow3), Rpt (arrow4). Look at the list for
% cluster size (arrow6).
!~/abin/afni -dset ~/SAM_BIU/docs/temp+tlrc

