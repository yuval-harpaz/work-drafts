function [Grid,ftLeadfield,ori]=fs2grid(cfg)
% finds freesurfer surface in MEG space from MNE *fwd.fif file
% if there is more than one such file in the current directory give it
% cfg.fileName. cfg.subset = true to select only the surface points used for the fwd solution
% cfg.subset can also be 20484 (first 10242 are LH) indices of LH and RH
% pair nodes, I get them using fsLRpairs.m
% if you want the ft leadfealds run the function from where the data is. it
% has to use the headshape and grad.

if ~exist('cfg','var')
    Dir=dir('*fwd.fif');
    if length(Dir)==1;
        cfg.fileName=Dir(1).name;
    else
        error('got to give *fwd.fif as cfg.fileName')
    end
end
if ~isfield(cfg,'subset')
    cfg.subset=true;
end
fwd=mne_read_forward_solution(cfg.fileName);
%lh_pial=mne_read_surface('lh.pial');
doLRpairs=false;
if cfg.subset %some 8000 points
    if length(cfg.subset)==20484
        doLRpairs=true;
        li=cfg.subset(1:10242);
        ri=cfg.subset(10243:20484);
    else
        li=fwd.src(1).vertno;
        ri=fwd.src(2).vertno;
    end
    lh=fwd.src(1).rr(li,:); % same as fwd.source_nn
    rh=fwd.src(2).rr(ri,:);
    lhori=fwd.src(1).nn(li,:); % same as fwd.source_nn
    rhori=fwd.src(2).nn(ri,:);
else
    lh=fwd.src(1).rr;
    rh=fwd.src(2).rr;
    lhori=fwd.src(1).nn; % same as fwd.source_nn
    rhori=fwd.src(2).nn;
end

Grid.pos=[lh;rh]; % from LPI to PRI
Grid.pos=Grid.pos(:,[2,1,3]);
Grid.pos(:,2)=-Grid.pos(:,2);
Grid.unit='m';
Grid.inside=true(length(Grid.pos),1);

if nargout>2
    ori=[lhori;rhori];
    ori=ori(:,[2,1,3]);
    ori(:,2)=-ori(:,2);
else
    ori=[];
end
clear lh* rh*
if ~doLRpairs && cfg.subset
    if size(fwd.sol.data,2)==fwd.nsource
        for posi=1:length(Grid.pos)
            Grid.leadfield{1,posi}=fwd.sol.data(:,posi);
        end
    elseif size(fwd.sol.data,2)==fwd.nsource*3
        colCount=0;
        for posi=1:length(Grid.pos)
            for axisi=1:3
                colCount=colCount+1;
                Grid.leadfield{1,posi}(1:fwd.nchan,axisi)=fwd.sol.data(:,colCount);
            end
            Grid.leadfield{1,posi}=Grid.leadfield{1,posi}(:,[2,1,3]);
            Grid.leadfield{1,posi}(:,2)=-Grid.leadfield{1,posi}(:,2);
        end
    else
        error('something didnt match with the size of the leadfield matrix fwd.sol.data')
    end
end
for chani=1:fwd.nchan;
    Grid.label{chani,1}=['A',num2str(chani)];
end
% ft order
chi=[22;2;104;241;138;214;71;26;93;39;125;20;65;9;8;95;114;175;16;228;35;191;37;170;207;112;224;82;238;202;220;28;239;13;165;204;233;98;25;70;72;11;47;160;64;3;177;63;155;10;127;67;115;247;174;194;5;242;176;78;168;31;223;245;219;12;186;105;222;76;50;188;231;45;180;99;234;215;235;181;38;230;91;212;24;66;42;96;57;86;56;116;151;141;120;189;80;210;143;113;27;137;135;167;75;240;206;107;130;100;43;200;102;132;183;199;122;19;62;21;229;84;213;55;32;85;146;58;60;88;79;169;54;203;145;103;163;139;49;166;156;128;68;159;236;161;121;4;61;6;126;14;94;15;193;150;227;59;36;225;195;30;109;172;108;81;171;218;173;201;74;29;164;205;232;69;157;97;217;101;124;40;123;153;178;1;179;33;147;117;148;87;89;243;119;52;142;211;190;53;192;73;226;136;184;51;237;77;129;131;198;197;182;46;92;41;90;7;23;83;154;34;17;18;248;149;118;208;152;140;144;209;110;111;244;185;246;162;106;187;48;221;196;133;158;44;134;216;];
Grid.label=Grid.label(chi);
%FIXME - arrange leadfield in ft order
if isfield(Grid,'leadfield')
    for posi=1:length(Grid.leadfield)
        Grid.leadfield{posi}=Grid.leadfield{posi}(chi,:);
    end
end
if exist(source,'file') && nargout>1
    hdr=ft_read_header(source);
    hs=ft_read_headshape('hs_file');
    [cfgLF.vol.o,cfgLF.vol.r]=fitsphere(hs.pnt);
    cfgLF.grad=hdr.grad;
    cfgLF.grid=Grid;
    cfgLF.channel='MEG';
    ftLeadfield=ft_prepare_leadfield(cfgLF);
    
else
    ftLeadfield=[];
end