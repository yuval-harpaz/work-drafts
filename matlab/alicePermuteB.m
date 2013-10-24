function [critT,critClustSize]=alicePermuteB(prefix,subbriks)
% run ttest++ on a set of data, comparing the results of LR dif to zero.
% example: alicePermuteB('BaliceLRdif',161:408);
cd /home/yuval/Copy/MEGdata/alice/func/B
sf={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};
tThresh=3;%2.044;
if exist('tMinMax.txt','file')
    !rm tMinMax.txt
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
M=M+1;
clustSize=zeros(length(M),2);
conds={'','_neg'};
%% prepare for subbrik by subbrik processing
% brikload BaliceLRdif_8+tlrc
[~, V, Info, ~] = BrikLoad ([prefix,'_',num2str(subi),'+tlrc']);
Vsize=size(V);
clear V
OptTSOut.Scale = 1;
OptTSOut.verbose = 1;
OptTSOut.View = '+tlrc';
%    WriteBrik (Vout, Info, OptTSOut);
tcount=1;ccount=1;
%% main loop
if ~exist('subbriks','var')
    subbriks=[];
end
if isempty(subbriks)
    subbriks=0:Vsize(4)-1;
end

for subbriki=subbriks
    clustSize=[];
    if exist([prefix,'ttest+tlrc.BRIK'],'file')
        eval(['!rm ',prefix,'ttest+tlrc*'])
    end
    for permi=1:length(M)
        if exist('./TTnew+tlrc.BRIK','file')
            !rm TTnew+tlrc*
        end
        setA='-setA r1 ';
        for subi=1:8
            setA=[setA,sf{subi},'r1 ',prefix,'_',num2str(subi),conds{M(permi,subi)},'+tlrc''','[',num2str(subbriki),']''',' ']; %#ok<AGROW>
        end
        command = ['~/abin/3dttest++ -mask ~/SAM_BIU/docs/MASKctx+tlrc ',setA];
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
        setA=[setA,sf{subi},'r1 ',prefix,'_',num2str(subi),'+tlrc''','[',num2str(subbriki),']''',' '];
    end
    command = ['~/abin/3dttest++ -prefix ',prefix,'ttest -mask ~/SAM_BIU/docs/MASKctx+tlrc ',setA];
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
    
    % messages
    sig={' ',' ',' ',' '};
    nothing=true;
    if -tReal(1)>critT
%         sig{1}='*';
%         nothing=false;
        eval(['!~/abin/3dclust -prefix negTsub -quiet -1clip ',num2str(critT),' 5 125 neg+tlrc'])
        [~, VL, Infosub, ~] = BrikLoad ('negTsub+tlrc');
        VL=-1*flipdim(VL,1);
    else
        VL=zeros(Vsize(1:3));
    end
    if tReal(2)>critT
%         sig{1}='*';
%         nothing=false;
        eval(['!~/abin/3dclust -prefix posTsub -quiet -1clip ',num2str(critT),' 5 125 pos+tlrc'])
        [~, VR, Infosub, ~] = BrikLoad ('posTsub+tlrc');
    else
        VR=zeros(Vsize(1:3));
    end
    VtSub=VL+VR;
    if ~isempty(find(VtSub, 1))
        OptTSOut.Prefix = [prefix,'_t',num2str(subbriki)];
        WriteBrik (VtSub, Infosub, OptTSOut);
        tInd(tcount)=subbriki; %#ok<AGROW>
        tcount=tcount+1;
    end
    if clustSizeReal(1)>critClustSize
        eval(['!~/abin/3dclust -prefix negCsub -quiet -1clip ',num2str(tThresh),' 5 ',num2str(critClustSize*125),' neg+tlrc'])
        [~, VL, Infosub, ~] = BrikLoad ('negCsub+tlrc');
        VL=-1*flipdim(VL,1);
    else
        VL=zeros(Vsize(1:3));
    end
    if clustSizeReal(2)>critClustSize
        eval(['!~/abin/3dclust -prefix posCsub -quiet -1clip ',num2str(tThresh),' 5 ',num2str(critClustSize*125),' pos+tlrc'])
        [~, VR, Infosub, ~] = BrikLoad ('posCsub+tlrc');
        else
        VR=zeros(Vsize(1:3));
    end
    VcSub=VL+VR;
    if ~isempty(find(VcSub, 1))
        OptTSOut.Prefix = [prefix,'_c',num2str(subbriki)];
        WriteBrik (VcSub, Infosub, OptTSOut);
        cInd(ccount)=subbriki; %#ok<AGROW>
        ccount=ccount+1;
    end
    
    
    % now open AFNI and view Post_Pre+tlrc.
    % to see if you have sig voxels check the range of the overlay (see arrow0). Note, there
    % are two images there, means difference (brik[0]) and t values (brik[1]).
    % choose [1] in Define Overlay (Arrow1).
    % to see if you have large clusters set the threshold to tThresh (arrow with no number), click on
    % clusterize (arrow2), set (arrow3), Rpt (arrow4). Look at the list for
    % cluster size (arrow6).
    !rm neg*+tlrc*
    !rm pos*+tlrc*
    !rm *Clust.txt
%    !~/abin/afni -dset ~/SAM_BIU/docs/temp+tlrc &
    !rm TTnew+tlrc*
end
% V=zeros(Vsize);
% for ti=tInd
%     [~, Vt, Infot, ~] = BrikLoad ([prefix,'_t',num2str(ti),'+tlrc']);
%     V(:,:,:,ti+1)=Vt;
% end
% OptTSOut.Prefix = [prefix,'_T'];
% WriteBrik (V, Info, OptTSOut);
%
VT=zeros(Vsize);
VC=VT;
!echo > clusters.log
talready=false;
for ti=1:size(VT,4)-1
    if exist([prefix,'_t',num2str(ti),'+tlrc.BRIK'],'file')
        if exist([prefix,'_t',num2str(ti-1),'+tlrc.BRIK'],'file') || exist([prefix,'_t',num2str(ti+1),'+tlrc.BRIK'],'file')
            [~, Vt, ~, ~] = BrikLoad ([prefix,'_t',num2str(ti),'+tlrc']);
            VT(:,:,:,ti+1)=Vt;
            talready=true;
            eval(['!echo subbrik ',num2str(ti),' >> clusters.log'])
            eval(['!~/abin/3dclust -quiet -1clip ',num2str(tThresh),' 5 ',num2str(125),' ',prefix,'_t',num2str(ti),'+tlrc >> clusters.log'])
        end
    end
    if exist([prefix,'_c',num2str(ti),'+tlrc.BRIK'],'file')
        if exist([prefix,'_c',num2str(ti-1),'+tlrc.BRIK'],'file') || exist([prefix,'_c',num2str(ti+1),'+tlrc.BRIK'],'file')
            [~, Vc, ~, ~] = BrikLoad ([prefix,'_c',num2str(ti),'+tlrc']);
            VC(:,:,:,ti+1)=Vc;
            if ~talready
                eval(['!echo subbrik ',num2str(ti),' >> clusters.log'])
            end
            eval(['!~/abin/3dclust -quiet -1clip ',num2str(tThresh),' 5 ',num2str(125),' ',prefix,'_c',num2str(ti),'+tlrc >> clusters.log'])
        end
    end
end
OptTSOut.Prefix = [prefix,'_T'];
WriteBrik (VT, Info, OptTSOut);
OptTSOut.Prefix = [prefix,'_C'];
WriteBrik (VC, Info, OptTSOut);
OptTSOut.Prefix = [prefix,'_CT'];
WriteBrik (VC+VT, Info, OptTSOut);

!rm *_neg*