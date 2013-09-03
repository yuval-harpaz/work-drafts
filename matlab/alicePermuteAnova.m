function [critF,critClustSize]=alicePermuteAnova(prefix1,prefix2,prefix3,fThresh)
% setA-setB
cd /home/yuval/Copy/MEGdata/alice/func
sf={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};
if ~exist('fThresh','var')
    fThresh=[];
end
if isempty(fThresh)
    fThresh=3;%2.044;
end


%if exist('fMax.txt','file')
    !rm fMax*.txt
%end
%if exist('fMaxReal.txt','file')
    !rm fMaxReal*.txt
%end
if exist([prefix1,'_',prefix2,'_',prefix3,'+tlrc.BRIK'],'file')
    eval(['!rm ',prefix1,'_',prefix2,'_',prefix3,'+tlrc*'])
end
if exist('pos+tlrc.BRIK','file')
    !rm pos+tlrc*
end


% making 1000 permutations list
n = 8 ;
if strcmp(prefix2,'seg10M210')
    n=7; % bad Mark!
end

combs=[1 2 3;1 3 2;2 1 3;2 3 1;3 1 2; 3 2 1];
M=randi(6,1000,n);
eqcond=(M(:,1)==M(:,2)) + (M(:,1)==M(:,3)) + (M(:,1)==M(:,4)) + (M(:,1)==M(:,5)) + (M(:,1)==M(:,6));
if ~isempty(find(eqcond==6))
    M(eqcond==6,:)=[]; % remove perutation, equal to real comparison
end
M(end+1,:)=1;

clustSize=zeros(length(M)-1,1);
conds={prefix1,prefix2,prefix3};
for permi=1:length(M)
    if exist('./FTnew+tlrc.BRIK','file')
        !rm FTnew+tlrc*
    end
    str='~/abin/3dANOVA -levels 3';
    for condi=1:3
        for subi=1:n
            str=[str,' -dset ',num2str(condi),' ',conds{combs(M(permi,subi),condi)},'_',num2str(subi),'+tlrc'];
        end
    end
    
    str = [str, ' -ftr FTnew'];
    %     eval(['!',str])
    [~, ~] = unix(str);
    for thri=1:length(fThresh)
        eval(['!~/abin/3dcalc -a FTnew+tlrc''','[1]''',' -exp ''','ispositive(a-',num2str(fThresh(thri)),')*a''',' -prefix pos'])
        eval(['!~/abin/3dclust -quiet -1clip ',num2str(fThresh(thri)),' 5 125 pos+tlrc > posClust.txt'])
        posClust=importdata('posClust.txt');
        if iscell(posClust)
            posClustSize=0;
        else
            posClustSize=posClust(1)/125;
        end
        !rm pos+tlrc*
        !rm *Clust.txt
        % read max f value
        if permi==length(M)
            if thri==1
                !~/abin/3dBrickStat -max FTnew+tlrc''','[1]''',' >> fMaxReal.txt
            end
            clustSizeReal(thri)=posClustSize;
        else
            if thri==1
                !~/abin/3dBrickStat -max FTnew+tlrc''','[1]''',' >> fMax.txt
            end
            % compute volume of largest positive and negative clusters
            clustSize(permi,thri)=posClustSize;
        end
    end
end
clustSize=sort(clustSize,'descend');
% take the 5% greatest volumes (in voxels) as critical cluster size
critClustSize=clustSize(ceil(0.05*(permi-1)),:);
% take the 5% extreme f values as criticat f
fList=importdata('fMax.txt');
for fi=1:length(fList)
    flist(fi)=str2num(fList{fi}(1:8));
end

fList=sort(flist,'descend');
critF=fList(ceil(0.05*(permi-1)));
!rm fMax.txt

% real ttest data
fReal=importdata('fMaxReal.txt');
fReal=str2num(fReal{end,1}(1:8));
sig={' ',' '};
nothing=true;
if fReal>critF
    sig{1}='*';
    nothing=false;
end
if sum(clustSizeReal>critClustSize)>0
    sig{2}='*';
    nothing=false;
end
threshDisp='';
for thri=1:length(fThresh)
    threshDisp=[threshDisp,num2str(fThresh(thri)),'  '];
end
disp('===========================================')
disp(['critical F value      : ',num2str(critF)]);
disp(['the largets F value   : ',num2str(fReal),' ',sig{1}])
disp('===========================================')
disp(['F threshold             :    ', threshDisp])
disp(['critical cluster size   :    ', num2str(critClustSize)]);
disp(['largest cluster         :    ', num2str(clustSizeReal),' ',sig{2}])
disp('===========================================')
disp('')
if nothing
    disp('NOTHING!!!')
end
eval(['!mv FTnew+tlrc.BRIK ',prefix1,'_',prefix2,'_',prefix3,'+tlrc.BRIK'])
eval(['!mv FTnew+tlrc.HEAD ',prefix1,'_',prefix2,'_',prefix3,'+tlrc.HEAD'])
!~/abin/afni -dset ~/SAM_BIU/docs/temp+tlrc &
%% FIXME set the contrasts
