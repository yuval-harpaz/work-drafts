function marikLegAdapChans(cond,t,z,hp)
% example: marikLegAdapChans(1,0.05112,-0.1);
% t=0.05112; % time
% cond=1; % 1 = in, 2 = a little out, 3 = more out.
% z=-0.1; % how many chans to include, above z along the z axis. default,
% all chans included
% hp=20; % highpass filter
if ~exist('z','var')
    z=[];
end
if isempty(z)
    z=-1; % 1m below the ears, takes all chans.
end
suf=num2str(-z*100);
load /home/yuval/Data/emptyRoom/empty
grad=meg.grad;
clear meg
labels=grad.label(grad.chanpos(:,3)>z); % choose central channels

fn={'lToeIn','lToeOut2','lToeOut3'};
cd /home/yuval/Data/marik/4fingers
for condi=cond% 1:3
    %if ~exist(['adapChan',suf,'.mat'],'file')
        load (fn{condi})
        eval(['raw=',fn{condi}])
        
        [~,chi]=ismember(labels,raw.label);
        chi=chi(chi>0);
        raw.avg=raw.avg(chi,:);
        raw.label=raw.label(chi);
        cfg=[];
        if exist('hp','var')
            if ~isempty(hp)
                cfg.hpfilter='yes';
                cfg.hpfreq=hp;
            end
        end
        cfg.demean='yes';
        cfg.blcwindow=[-0.2 0];
        raw=ft_preprocessing(cfg,raw);
        data=raw.avg;
        new=raw;
        new.avg=zeros(size(raw.avg));
        new_data=DATA_adaptive_pca_denoiser4(data,100,250,2);
        new.avg(:,1:size(new_data,2))=new_data;
        eval([fn{condi},'DN=new;'])
        eval([fn{condi},'=raw;'])
%     else
%         if condi==1
%             load (['adapChan',suf,'.mat'])
%         end
%     end
end


fold=num2str(cond);
fn={'lToeIn','lToeOut2','lToeOut3'};
fn=fn{cond};
% if ~exist('adapChan.mat','file')
%     save (['adapChan',suf], 'lT*')
% end

%% dipole fit
cd /home/yuval/Data/marik/4fingers
eval(['raw=',fn,';'])
eval(['dn=',fn,'DN;'])
cd (fold)
cfg                        = [];
cfg.feedback               = 'no';
cfg.grad = raw.grad;
cfg.headshape='hs_file';
cfg.singlesphere='yes';
vol  = ft_prepare_localspheres_BIU(cfg);
showHeadInGrad([],'m');
hold on;
ft_plot_vol(vol);
title(['origin = ',num2str(vol.o)]);

hs=ft_read_headshape('hs_file');

cd ..

%dn.avg=zeros(size(raw.avg));
%eval(['matSize=size(',fn,'DN);'])
%nRow=num2str(matSize(1));
%nCol=num2str(matSize(2));
%eval(['dn.avg(1:',nRow,',1:',nCol,')=',fn,'DN.avg;']);
cfg=[];
cfg.lpfilter='yes';
cfg.lpfreq=40;
rawLp=ft_preprocessing(cfg,raw);
dnLp=ft_preprocessing(cfg,dn);
dnLp=correctBL(dnLp,[-0.2 0]);
rawLp=correctBL(rawLp,[-0.2 0]);
cfg=[];
cfg.layout='4D248.lay';

cfg.xlim=[t t]; %0.06488 0.08454
cfg.zlim=[-5e-14 5e-14];
cfg.interactive='yes';
cfg.interpolation      = 'linear';
figure;


ft_topoplotER(cfg,raw,rawLp,dn,dnLp);



%li2Avg.grad=ft_convert_units(li2Avg.grad,'mm');

cfg = [];
cfg.latency = [t t];  % specify latency window around M50 peak
cfg.numdipoles = 1;
cfg.vol=vol;
cfg.feedback = 'textbar';
cfg.gridsearch='yes';
dip = ft_dipolefitting(cfg, raw);
hs=ft_read_headshape('1/hs_file');
figure;
plot3pnt(hs.pnt,'.k')
hold on
ft_plot_dipole(dip.dip.pos,dip.dip.mom,'units','m','color','green');
dipDN = ft_dipolefitting(cfg, dn);
ft_plot_dipole(dipDN.dip.pos,dipDN.dip.mom,'units','m','color','blue');
dipLp = ft_dipolefitting(cfg, rawLp);
ft_plot_dipole(dipLp.dip.pos,dipLp.dip.mom,'units','m','color','red');
dipDNLp = ft_dipolefitting(cfg, dnLp);
ft_plot_dipole(dipDNLp.dip.pos,dipDNLp.dip.mom,'units','m','color','w');
title('raw = green, dn = blue, filt = red, dn+filt = white')








