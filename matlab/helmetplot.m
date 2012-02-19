function g = helmetplot(cfg,data)

% needs helmetpatch.mat

% plots averaged time_freq or single trial data on 4D helmet
% cfg options:
% xlim = [begin, end]; time-window to plot (default all)
% trialnum = trial; if unaveraged data, single trial can be plotted


% To do: decide what kind of data (maybe use checkdata function)
%        make a series of plots at specified times


%use only MEG channels

fcs=plothelmetpatch(data.grad);
meglabs=ft_channelselection('MEG',data.label);
chans2use=match_str(data.label,meglabs);


if isfield(data,'avg')
    if strcmp(data.dimord, 'chan_time')||strcmp(data.dimord, 'rpt_chan_time')
        if ~isfield(cfg, 'xlim'),  cfg.xlim=[min(data.time), max(data.time)];         end
        startpnt=cfg.xlim(1); endpnt=cfg.xlim(2);
        tpts=[min(find(data.time>startpnt)), max(find(data.time<endpnt))];
        avls=mean(data.avg(chans2use,tpts),2);
    elseif strcmp(data.dimord, 'chan_freq')
        if ~isfield(cfg, 'xlim'),      cfg.xlim=data.cfg.foilim;         end
        startpnt=cfg.xlim(1); endpnt=cfg.xlim(2);
        tpts=[min(find(data.freq>=startpnt)), max(find(data.freq<=endpnt))];
        avls=sum(log(data.powspctrm(chans2use,tpts)),2);
    end
else
    if  ~isfield(cfg,'trialnum')
        printf('No trial number specified for unaveraged data');
        return;
    end;
    if ~isfield(cfg, 'xlim'),  cfg.xlim=[min(data.time{1,cfg.trialnum}), max(data.time{1,cfg.trialnum})];         end
    startpnt=cfg.xlim(1); endpnt=cfg.xlim(2);
    tpts=[min(find(data.time{1,cfg.trialnum}>startpnt)), max(find(data.time{1,cfg.trialnum}<endpnt))];
    avls=mean(data.trial{1,cfg.trialnum}(chans2use,tpts),2);
end;

% load helmetpatch;
%  use pnt of specified data, change right-left
meglabs=ft_channelselection('MEG',data.grad.label);
chans2use=match_str(data.grad.label,meglabs);
grad=ft_convert_units(data.grad,'mm');
if isfield(grad,'pnt')
vertc=grad.pnt(chans2use,:);
else
    vertc=grad.chanpos(chans2use,:);
end
vertc(:,2)=vertc(:,2);
%plot helmet
figure;
g=patch('Vertices',vertc,'Faces',fcs,'FaceVertexCData',avls,'FaceColor','interp','FaceAlpha',0.9,'EdgeColor','none','Marker','o','MarkerFaceColor','k');
    function fcs=plothelmetpatch(sns)
        % plothelmetpatch(grad)
        % choose edges to exclude
        % plot3(sns.pnt(1:248,1),-sns.pnt(1:248,2),sns.pnt(1:248,3),'ko','markerfacecolor','k')
        % C=convhulln(sns.pnt(1:248,:));
        % hold on;
        % for i = 1:size(C,1),  j = C(i,[1 2 3 1]); patch(sns.pnt(j,1),sns.pnt(j,2),sns.pnt(j,3),rand,'FaceAlpha',0.6); end;
        % view(3), axis equal off tight vis3d; camzoom(1.2)
        % colormap(spring)
        % rotate3d on
        
        if isfield(sns,'pnt')
            X=sns.pnt;
        else
            X=sns.chanpos;
        end
        X(:,2)=X(:,2);
%        figure;
%         plot3(sns.pnt(1:248,1),sns.pnt(1:248,2),sns.pnt(1:248,3),'o')
%         hold on;
        C=convhulln(X(1:248,:));
%         for i = 1:size(C,1)
%             j = C(i,[1 2 3 1]);
%             % patch(sns.pnt(j,1),-sns.pnt(j,2),sns.pnt(j,3),rand,'FaceAlpha',0.6);
%         end;
% %        view(3), axis equal tight vis3d; camzoom(1.2)
% %        colormap(spring);
        
        for i=1:248, text(X(i,1), -X(i,2), X(i,3), num2str(i)); end
        edgelabels=[121:124,150:152,177,195,229:248];
        for seni=1:length(edgelabels)
            edgesn(seni,1)=find(strcmp(['A',num2str(edgelabels(seni))],sns.label));
        end
        %edgesn=[226;156;93;229;147;117;183;181;11;47;121;82;175;37;67;
        todel=[];
        for i=1:length(C); if (~isempty(find(edgesn==C(i,1))) & ~isempty(find(edgesn==C(i,2))) & ~isempty(find(edgesn==C(i,3)))) todel=[todel i]; end
        end;
        for i=1:numel(todel), C(todel(i),:)=[0 0 0]; end
        
        
        cf=find(C(:,1));fa=C(cf,:);
        fcs=fa;
    end
end