function ntrl=createUNITtrl2(cfg)
% needed:
% cfg.dataset : file name
% trl columns: 
% 1: begin sample; 2: end sample; 3: offset; 4: trigger; 5: response time
% 6: response; 7: response accuracy coded as 0\1; 8: outlier responses
% (marked with 1)

%% basic defenitions and characteristics:
% read the header information and the events from the data
hdr   = ft_read_header(cfg.dataset);
event = ft_read_event(cfg.dataset);

% search for "trigger" events
trigger = [event(strcmp('STATUS', {event.type})).value]';
sample  = [event(strcmp('STATUS', {event.type})).sample]';

% determine the number of samples before and after the trigger
pretrig  = -round(cfg.trialdef.pre  * hdr.Fs);
posttrig =  round(cfg.trialdef.post * hdr.Fs);
offset = round(cfg.trialdef.offset * hdr.Fs);

%% basic TRL matrix
% ERP of the second stimuli presentation at retrieval
index=find(trigger>=30 & trigger<=39); %stimulus trigger
jindex=find(trigger>=11 & trigger<=16); %response trigger 
DIR=pwd;
DIR=str2num(DIR(end-2:end));
if DIR./2==round(DIR./2)
    Up=false;
else
    Up=true;
end
num_trials=length(index);
ntrl(1:num_trials,1)=sample(index)+pretrig; 
ntrl(1:num_trials,2)=sample(index)+posttrig;
ntrl(1:num_trials,3)=offset;   
ntrl(1:num_trials,4)=trigger(index); 
ntrl(1:num_trials,5)=(sample(jindex)-sample(index))./hdr.Fs;
ntrl(1:num_trials,6)=trigger(jindex);
if Up
    ntrl(logical(ismember(ntrl(:,4),[30:33,36,37]).*ismember(ntrl(:,6),14:16)),7)=1;
    ntrl(logical(ismember(ntrl(:,4),[34,35,38,39]).*ismember(ntrl(:,6),11:13)),7)=1;
else
    ntrl(logical(ismember(ntrl(:,4),30:35).*ismember(ntrl(:,6),14:16)),7)=1;
    ntrl(logical(ismember(ntrl(:,4),36:39).*ismember(ntrl(:,6),11:13)),7)=1;
end

% complete all conditions according to trigger

% % determine fast and slow responses, and change column 8 to 1 for outliars
for i=11:16
    x=(ntrl(:,6)==i&ntrl(:,7)==1); 
    hv=3*std(ntrl(x,5))+mean(ntrl(x,5)); lv=mean(ntrl(x,5))-3*std(ntrl(x,5)); 
    if lv<0
        lv=0;
    end
    ntrl(find((ntrl(:,5)>hv|ntrl(:,5)<lv)&x),8)=1;
end;
