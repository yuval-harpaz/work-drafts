function vs2brik(cfg,vs)
% cfg should include func field with a name of functional data in BRIK
% format.
% cfg.TR (time of requisition) is the difference between two samples in S or ms.
% cfg.boxSize is [xmin xmax ymin ymax zmin zmax] in PRI order
% cfg.step is the spatial resolution in cm (0.5 ?)
% cfg.prefix for prefix
% vs has rows for voxels and columns for samples.
[err, Vfunc, Infofunc, ErrMessage] = BrikLoad (cfg.func);
if ~exist('~/bin/cat_matvec','file') % ~/bin but not ~/abin is recognized by matlab '!'
    !cp ~/abin/ccalc ~/bin/ 
    !cp ~/abin/Vecwarp ~/bin/
    !cp ~/abin/cat_matvec ~/bin/
    !cp ~/SAM_BIU/docs/coordstoijk.csh ~/bin/
    !echo 'echo $coords > coords.txt' >> ~/bin/coordstoijk.csh
end
xyzMin=num2str(10*cfg.boxSize([1 3 5]));
xyzMax=num2str(10*cfg.boxSize([2 4 6]));
eval(['!coordstoijk.csh /home/yuval/Dropbox/poster2012/KurMask001+orig ',xyzMin])
% P   A      R  L     I   S
%-120 120   -90 90   -20 150
%   7 43     40 6      49 1
%    49       35        37
ijkMin=importdata('coords.txt');
eval(['!coordstoijk.csh /home/yuval/Dropbox/poster2012/KurMask001+orig ',xyzMax])
ijkMax=importdata('coords.txt');
vsRs=reshape(vs(:,1),[35,37,49]);%figure;plot(squeeze(vsRs(20,20,:))==0,'k');hold on;plot(squeeze(vsRs(20,:,20))==0,'b');plot(squeeze(vsRs(:,20,20))==0,'c');

pmt=permute(vsRs,[3 1 2]);
pmt=flipdim(pmt,1);
pmt=flipdim(pmt,2);
pmt=flipdim(pmt,3);
ijkMax=ijkMax+1;ijkMin=ijkMin+1;
% ijk order in Vfunc is (small values for ) Ant Sup Left (ASL)
Vfunc(ijkMax(3):ijkMin(3),ijkMax(2):ijkMin(2),ijkMin(1):ijkMax(1))=pmt;
Vfunc(Vfunc~=0)=1;
%Vfunc(:,:,1)=100;
% BrikNameFunc=cfg.func;
% [err, Vfunc, Infofunc, ErrMessage] = BrikLoad (BrikNameFunc);	
InfoNewTSOut = Infofunc;
	InfoNewTSOut.RootName = '';
	InfoNewTSOut.BRICK_STATS = []; %automatically set
	InfoNewTSOut.BRICK_FLOAT_FACS = []; %automatically set
	InfoNewTSOut.IDCODE_STRING = '';%automatically set
	 			
	OptTSOut.Scale = 1;
	OptTSOut.Prefix = cfg.prefix;
	OptTSOut.verbose = 1;

	%write it
	[err, ErrMessage, InfoNewTSOut] = WriteBrik (Vfunc, InfoNewTSOut, OptTSOut);

% InfoNewTSOut = Infofunc;
% InfoNewTSOut.RootName = '';
% InfoNewTSOut.BRICK_STATS = []; %automatically set
% InfoNewTSOut.BRICK_FLOAT_FACS = []; %automatically set
% InfoNewTSOut.IDCODE_STRING = '';%automatically set
% OptTSOut.Scale = 1;
% OptTSOut.Prefix = cfg.prefix;
% OptTSOut.verbose = 1;
% %write it
% % dim APL
% [err, ErrMessage, InfoNewTSOut] = WriteBrik (vs, InfoNewTSOut, OptTSOut);
