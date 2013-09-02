
function aliceMaxAlpha(prefix)
%sf={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};
cd /home/yuval/Copy/MEGdata/alice
sf={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};

!echo > ~/alice2tlrc 
for subi=1:8
    cd([sf{subi},'/MRI'])
    if ~exist([prefix,'Max+orig.BRIK'],'file')
        [~, V, Info, ~] = BrikLoad ([prefix,'+orig']);
        [maxAlpha,~]=max(V(:,:,:,8:10),[],4); % 9 to 11Hz
        %     [maxAlpha,maxI]=max(V(:,:,:,8:10),[],4); % 9 to 11Hz
        %     maxFreq=maxI+8;
        %     [~,maxI]=max(V(:,:,:,7:11),[],4); % 8 to 12Hz
        %     peakTest=(maxI==2)+(maxI==3)+(maxI==4);
        %     maxAlphaP=maxAlpha.*peakTest;
        InfoNewTSOut = Info;
        InfoNewTSOut.RootName = '';
        InfoNewTSOut.BRICK_STATS = [];
        InfoNewTSOut.BRICK_FLOAT_FACS = [];
        InfoNewTSOut.IDCODE_STRING = '';
        InfoNewTSOut.BRICK_TYPES=3*ones(1,1); % 1 short, 3 float.
        InfoNewTSOut.DATASET_RANK(2)=1;
        % 4D to 3D
        InfoNewTSOut.BRICK_LABS='alpha';
        InfoNewTSOut.DATASET_RANK(2)=1;
        InfoNewTSOut.BRICK_TYPES=Info.BRICK_TYPES(1);
        InfoNewTSOut.BRICK_FLOAT_FACS=Info.BRICK_FLOAT_FACS(1);
        InfoNewTSOut.TAXIS_NUMS(1)=1;
        
        OptTSOut.Scale = 1;
        OptTSOut.verbose = 1;
        OptTSOut.View = '+orig'
        OptTSOut.Prefix = [prefix,'Max'];
        WriteBrik (maxAlpha, InfoNewTSOut, OptTSOut);
        %     OptTSOut.Prefix = 'alphaMaxP';
        %     WriteBrik (maxAlphaP, InfoNewTSOut, OptTSOut);
        %     OptTSOut.Prefix = 'alphaMaxF';
        %     WriteBrik (maxFreq, InfoNewTSOut, OptTSOut);
        
        
    end
%     eval(['!echo "cd ',pwd,'" >> ~/alice2tlrc'])
%     eval(['!echo "@auto_tlrc -apar ortho+tlrc -input alphaMax+orig -dxyz 5" >> ~/alice2tlrc'])
%     eval(['!echo "mv alphaMax+tlrc.HEAD /home/yuval/Copy/MEGdata/alice/func/alphaMax_',num2str(subi),'+tlrc.HEAD" >> ~/alice2tlrc']);
%     eval(['!echo "mv alphaMax+tlrc.BRIK /home/yuval/Copy/MEGdata/alice/func/alphaMax_',num2str(subi),'+tlrc.BRIK" >> ~/alice2tlrc']);
    eval(['!echo "cd ',pwd,'" >> ~/alice2tlrc'])
    eval(['!echo "@auto_tlrc -apar ortho+tlrc -input ',prefix,'Max+orig -dxyz 5" >> ~/alice2tlrc'])
    eval(['!echo "mv ',prefix,'Max+tlrc.HEAD /home/yuval/Copy/MEGdata/alice/func/',prefix,'Max_',num2str(subi),'+tlrc.HEAD" >> ~/alice2tlrc']);
    eval(['!echo "mv ',prefix,'Max+tlrc.BRIK /home/yuval/Copy/MEGdata/alice/func/',prefix,'Max_',num2str(subi),'+tlrc.BRIK" >> ~/alice2tlrc']);
    cd ../..
end