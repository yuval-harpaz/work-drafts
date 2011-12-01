%% source - full path of meg data file
%% begTime - the first sample to show (default 1)
%% endTime - the last sample to show (default last sample)
%% myTitle - title for the graph (default: filepath)
function myTracePlot(source, begTime, endTime, myTitle)

if ~exist('source','var')
    error('Usage: tracePlot_BIU(sourcefile, begTimeSec, endTimeSec\n');
end
hdr=ft_read_header(source);

if ~exist('begTime','var')
    begTime=1;
end
if ~exist('endTime','var')
    endTime=hdr.nSamples;
end
if ~exist('myTitle','var')
    myTitle=sprintf('%s:[%d-%d]seconds', source, begTime, endTime);
end

path = fileparts(source);
fid = fopen(sprintf('%s/click.log', path), 'w');

DeltaXSec = 30;  %DeltaXSec is the width of the axis 'window' in samples

cfg.dataset=source;
cfg.trialdef.beginning=begTime/hdr.Fs;
cfg.trialdef.end=endTime/hdr.Fs;
cfg.trialfun='trialfun_raw';
cfg1=ft_definetrial(cfg);

chans = hdr.label(strmatch('A', hdr.label));
cfg1.channel=chans;
cfg1.hpfilter='yes';
cfg1.hpfreq=3;
display('reading and filtering')
data=ft_preprocessing(cfg1);

%% this is a try to break the data into 1 seconds trial
% tlen=fix(hdr.Fs); 
% chans = hdr.label(strmatch('A', hdr.label));
% cfg=[];
% cfg.dataset=source;
% begsample=fix(begTime:tlen:(endTime - tlen + 1));
% endsample=fix(begsample + tlen - 1);
% offset=zeros(size(begsample));
% cfg.trl=[begsample(:) endsample(:) offset(:)];
% sel=(endsample>hdr.nSamples);
% cfg.trl(sel, :)=[];
% cfg.channel=chans; %{'MEG' '-A204' '-A74'};

%cfg.trl = [begsample(1), endsample(end), 0; cfg.trl];
% cfg1.hpfilter='yes';
% cfg1.hpfreq=3;
% data1 = ft_preprocessing(cfg);


data_trial = data.trial{1,1};
% data1_trial = data1.trial{1,1};

trial=zeros(size(data_trial));
% trial1=zeros(size(data1_trial));
display('sorting channels')


for i=1:248
    for j=1:248
        if strcmp(['A',num2str(i)],data.label{j,1})
            trial(i,:)=data.trial{1,1}(j,:);
%             trial1(i,:)=data1.trial{1,1}(j,:);
        end
    end
end
trial=trial.*10^12;
% sd=median(std(trial'));
sd=0.3;
YFactor = 2;

firstChan=1;lastChan=248;
chans=firstChan:4:lastChan;
Ydata=zeros(62,size(data_trial,2));
for chan=1:62
    Ydata(chan,:)=trial(chans(chan),:)*YFactor-chan*sd*10;
end
ch=firstChan:28:lastChan;
for chTick=1:9
    ticks{1,(10-chTick)}=['A',num2str(ch(chTick))];
end


%% get the trigger channel
% trigger_data = read_meg_file_pdf(source, begTime*hdr.Fs, endTime*hdr.Fs, 'TRIGGER', []);
% trigger_data = clearBits(trigger_data, 2048);
% trigger_data = clearBits(trigger_data, 1024);
% trigger_data = clearBits(trigger_data, 512);
% trigger_data = clearBits(trigger_data, 256);


screen_size = get(0, 'ScreenSize');
figure1 = figure('XVisual','0x23 (TrueColor, depth 32, RGB mask 0xff0000 0xff00 0x00ff)',...
                 'Position', [0 0 0.9*screen_size(3) 0.9*screen_size(4) ],...
                 'CloseRequestFcn',{@my_closereq, fid},...
                 'WindowButtonUpFcn',{@on_click});
axes1 = axes('Parent',figure1,...
             'YTickLabel',ticks,...
             'YTick',[-171 -150 -129 -108 -87 -66 -45 -24 -3]);
box('on');
hold('all');
set(gca(), 'FontSize', 14);
title(myTitle);
ylabel('Channel');
xlabel('Time [Sec]');

a = gca;
plot(data.time{1,1}, Ydata, 'Parent',axes1);
current_data_pos_t = [];

%% preparing slider
set(gcf,'doublebuffer','on');
%set(a,'xlim',[begTime begTime+DeltaXSec]);
set(a,'xlim',[begTime/hdr.Fs begTime/hdr.Fs+DeltaXSec]);
pos = get(a,'position');
Newpos = [pos(1) pos(2)-0.1 pos(3) 0.05];
uicontrol('Style','slider',...
    'units','normalized',...
    'position',Newpos,...
    'callback',{@surfzlim,begTime, endTime, DeltaXSec},...
    'min',0,...
    'max',100);
datacursormode on
dcm_obj = datacursormode(figure1);
set(dcm_obj,'UpdateFcn',{@DCMupdatefcn, fid})
button1 = uicontrol('Style','pushbutton',...
                    'string', 'Show topoplot',...
                    'position',[screen_size(4)*0.1 800 200 40],...
                    'callback',{@on_button_click});

%    'position',[0.1*screen_size(4) 0.9*screen_size(4) 120 40],...

function surfzlim(hObj, event, begTime, endTime, DeltaXSec) %#ok<INUSL>
    % Called to set zlim of surface in figure axes
    % when user moves the slider control
    slider_range = endTime/hdr.Fs - begTime/hdr.Fs - DeltaXSec;
    val = get(hObj,'value');
    xmin = round(begTime/hdr.Fs + (val/100)*(slider_range));
    xmax = xmin + DeltaXSec;
    xlim([xmin, xmax]);   
end


function on_click(hObject,eventdata)
    display('In on_click');
end        

function on_button_click(hObject,eventdata)
    if isempty(current_data_pos_t)
        return;
    end
    cfg=[];
    cfg.layout='4D248.lay';
    sec_arround = 1;
    cfg.xlim = [current_data_pos_t(1)-sec_arround current_data_pos_t(1)+sec_arround]; %time window in ms
    cfg.trials=[6];
    figure;
    ft_topoplotER(cfg, data);
end        

function txt = DCMupdatefcn(empt,event_obj, fid)
     current_data_pos_t = get(event_obj,'Position');
     txt = ['Sample: ',num2str(current_data_pos_t(1))];
     set(button1, 'string', sprintf('Show topoplot: %g',current_data_pos_t(1)));   
end


function my_closereq(src,evnt, fid)
% User-defined close request function 
% to display a question dialog box 
   selection = questdlg('Close This Figure?',...
      'Close Request Function',...
      'Yes','No','Yes'); 
   switch selection, 
      case 'Yes',
         fclose(fid);
         delete(gcf)
      case 'No'
      return 
   end
end

end
