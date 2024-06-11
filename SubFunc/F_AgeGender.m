function F_AgeGender(OPT)
R_STR = {['Results1',OPT.PATH.S],['Results2',OPT.PATH.S]};
AGE   = nan(2,100);
GEN   = strings(2,100);

for fR = 1:length(R_STR) 
    FILES = dir(R_STR{fR});
    FILES = {FILES(contains({FILES.name},'.mat')).name};
    cSubj = 0;
    for fSubj = 1:length(FILES)
        clear resp_2;
        load([R_STR{fR},FILES{fSubj}])
        if isfield(PAR,'QUEST')
            if (PAR.QUEST.PERS_A{1})
                if (PAR.QUEST.PERS_A{1} < 90)
                    AGE(fR,fSubj)=PAR.QUEST.PERS_A{1};
                    GEN(fR,fSubj)=PAR.QUEST.PERS_A{2};
                end
            end
        end
    end
end
%& AGE PLOT
figure(9);clf(9)
for fR = 1:length(R_STR) 
    dAGE = AGE(fR,:);
    dAGE = dAGE(~isnan(dAGE));
    subplot(2,1,fR)
    XTL = string([15:1:40]); XTLD = strings(1,length(15:1:40)); XTLD(1:5:end) = XTL(1:5:end);
    h   = histogram(dAGE,BinEdges=[15:1:40]); 
    xlim([18,38]); xlabel('age in years');  xticks([15:40]);xticklabels(XTLD);
    ylim([0,9]);ylabel('# Participants');yticks([0:1:20]);title(['Experiment ',num2str(fR)]);grid on;
    line([mean(dAGE),mean(dAGE)],[0,max(h.Values)],'color',[0.7,0,0,0.9],'linewidth',3)
    text([mean(dAGE)],[max(h.Values)+0.5],['Mean = ', num2str(mean(dAGE)),' | ', 'std = ', num2str(std(dAGE))],'HorizontalAlignment','center');
    line([mean(dAGE)-std(dAGE),mean(dAGE)+std(dAGE)],[mean([min(h.Values),max(h.Values)]),mean([min(h.Values),max(h.Values)])],'color',[0.7,0,0,0.4],'linewidth',3)
    line([mean(dAGE)-std(dAGE),mean(dAGE)-std(dAGE)],[0.5,max(h.Values)-0.5],'color',[0.7,0,0,0.4],'linewidth',3)
    line([mean(dAGE)+std(dAGE),mean(dAGE)+std(dAGE)],[0.5,max(h.Values)-0.5],'color',[0.7,0,0,0.4],'linewidth',3)
    set(gca,'FontSize',16);set(gca,'FontWeight','bold')
end
set(gcf,'Position', [100,100, 800, 800]);set(gcf,'color','w');
saveas(gcf,'Plot\Age.png')
%% GENDER PLOT
figure(10);clf(10)
for fR = 1:length(R_STR) 
    dGEN = GEN(fR,:);
    dGEN = dGEN(strcmp(dGEN,"") == 0);
    subplot(2,1,fR)
    hold on
    bar([sum(strcmpi(dGEN,'X')),0,0]);
    bar([0,sum(strcmpi(dGEN,'F')),0]);
    bar([0,0,sum(strcmpi(dGEN,'M'))]);
    hold off
    xticks([1,2,3]);xticklabels({'Diverse','Female','Male'})
    YTL = string([0:1:20]); YTLD = strings(1,length(0:1:20)); YTLD(1:5:end) = YTL(1:5:end);
    ylim([0,20]); yticks([0:1:20]); yticklabels(YTLD)
    title(['Experiment ',num2str(fR)]);
    set(gca,'FontSize',16);set(gca,'FontWeight','bold')
    box on; grid on;
end
set(gcf,'Position', [100,100, 800, 800]);set(gcf,'color','w');
saveas(gcf,'Plot\Gender.png')