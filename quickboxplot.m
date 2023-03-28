clear all
 signal= readmatrix([uigetfile('*.csv')],'NumHeaderLines',1);
 
 signal2= readmatrix([uigetfile('*.csv')],'NumHeaderLines',1);
 signal3= readmatrix([uigetfile('*.csv')],'NumHeaderLines',1);
 signal4= readmatrix([uigetfile('*.csv')],'NumHeaderLines',1);
 figure;
 
step = 0.05; %en mm!
strainstep = step./75; %en strain!
 strain = strainstep*(1:length(signal));

 signal_norm = normalize(signal,'scale',[mean(signal(:,1))]);
 signal2_norm = normalize(signal2,'scale',[mean(signal2(:,1))]);
 signal3_norm = normalize(signal3,'scale',[mean(signal3(:,1))]);
 signal4_norm = normalize(signal4,'scale',[mean(signal4(:,1))]);
coeffs = {'Fit slope'};
meansig = mean(signal_norm);
meansig2 = mean(signal2_norm);
meansig3 = mean(signal3_norm);
meansig4 = mean(signal4_norm);




subplot(2,2,1);
figure;

%set(txt,'VerticalAlignment', 'Middle','FontSize',7);
%set(gca,'box','off');
%h = copyobj(gca,gcf);
%delete(allchild(h))
%set(h,'YAxisLoc','right','next','add','Ylim',[0.98,1.01])

boxplot(signal_norm,'PlotStyle','compact','OutlierSize',0.001,'Labels',strain);
%tiledlayout;
title('n=1.3')
%ylim([0.98 1.01]);
%xlim([0 0.0673]);
txt = findobj(gca,'Type','text');
hold on
%plot(fittedmodel1,signal,meansig);
coeffvals= coeffvalues(fittedmodel1);
line=coeffvals(signal,meansig);
ci = confint(fittedmodel1,0.95);
str1 = sprintf('\n %s = %0.3f   (%0.3f   %0.3f)',coeffs{1},coeffvals(2),ci(:,1));
annotation('textbox',[.16 .66 .1 .05],'String',[str1],'FontSize',8,'VerticalAlignment','Top');
xlim([0 0.0673]);
ylim([0.98 1.01]);
plot(line);
ylabel('Normalized optical signal');
xlabel('Longitudinal strain');
hold off;

subplot(2,2,2);
boxplot(signal2_norm,'PlotStyle','compact','OutlierSize',0.001,'Labels',strain);
txt = findobj(gca,'Type','text');
set(txt,'VerticalAlignment', 'Middle','FontSize',7);
title('n=1.36')
ylabel('Normalized optical signal');
xlabel('Longitudinal strain');
txt = findobj(gca,'Type','text');
set(txt,'VerticalAlignment', 'Middle','FontSize',7);



subplot(2,2,3);
boxplot(signal3_norm,'PlotStyle','compact','OutlierSize',0.001,'Labels',strain);
txt = findobj(gca,'Type','text');
set(txt,'VerticalAlignment', 'Middle','FontSize',7);
title('n=1.39')
ylabel('Normalized optical signal');
xlabel('Longitudinal strain');
txt = findobj(gca,'Type','text');
set(txt,'VerticalAlignment', 'Middle','FontSize',7);



subplot(2,2,4);
boxplot(signal4_norm,'PlotStyle','compact','OutlierSize',0.001,'Labels',strain);
txt = findobj(gca,'Type','text');
set(txt,'VerticalAlignment', 'Middle','FontSize',7);
title('n=1.42')
ylabel('Normalized optical signal');
xlabel('Longitudinal strain');
txt = findobj(gca,'Type','text');
set(txt,'VerticalAlignment', 'Middle','FontSize',7);



subplot(2,2,2);
plot(fittedmodel2,strain,meansig2);
coeffvals= coeffvalues(fittedmodel2);
ci = confint(fittedmodel,0.95);
str1 = sprintf('\n %s = %0.3f   (%0.3f   %0.3f)',coeffs{1},coeffvals(2),ci(:,1));
annotation('textbox',[.62 .66 .1 .05],'String',[str1],'FontSize',8,'VerticalAlignment','Top')
ylabel('Normalized optical signal');
xlabel('Longitudinal strain');  
ylim([0.98 1.01]);
xlim([0 0.0673]);

subplot(2,2,3);
plot(fittedmodel3,strain,meansig3);
coeffvals= coeffvalues(fittedmodel3);
ci = confint(fittedmodel3,0.95);
str1 = sprintf('\n %s = %0.3f   (%0.3f   %0.3f)',coeffs{1},coeffvals(2),ci(:,1));
annotation('textbox',[.16 .16 .1 .05],'String',[str1],'FontSize',8,'VerticalAlignment','Top')
ylabel('Normalized optical signal');
xlabel('Longitudinal strain');  
ylim([0.98 1.01]);
xlim([0 0.0673]);

subplot(2,2,4);

plot(fittedmodel4,strain,meansig4);
coeffvals= coeffvalues(fittedmodel4);
ci = confint(fittedmodel4,0.95);
str1 = sprintf('\n %s = %0.3f   (%0.3f   %0.3f)',coeffs{1},coeffvals(2),ci(:,1));
annotation('textbox',[.64 .16 .1 .05],'String',[str1],'FontSize',8,'VerticalAlignment','Top')
ylabel('Normalized optical signal');
xlabel('Longitudinal strain');  
ylim([0.98 1.01]);
xlim([0 0.0673]);
figure;


% 
% subplot(2,2,1);
% boxplot(signal_norm,'PlotStyle','compact','OutlierSize',0.001,'Labels',strain);
% title('n=1.3')
% %ylim([0.98 1.01]);
% %xlim([0 0.0673]);
% ylabel('Normalized optical signal');
% xlabel('Longitudinal strain');
% txt = findobj(gca,'Type','text');
% set(txt,'VerticalAlignment', 'Middle','FontSize',7);
% 
% subplot(2,2,2);
% boxplot(signal2_norm,'PlotStyle','compact','OutlierSize',0.001,'Labels',strain);
% txt = findobj(gca,'Type','text');
% set(txt,'VerticalAlignment', 'Middle','FontSize',7);
% title('n=1.36')
% ylabel('Normalized optical signal');
% xlabel('Longitudinal strain');
% txt = findobj(gca,'Type','text');
% set(txt,'VerticalAlignment', 'Middle','FontSize',7);
% 
% 
% 
% subplot(2,2,3);
% boxplot(signal3_norm,'PlotStyle','compact','OutlierSize',0.001,'Labels',strain);
% txt = findobj(gca,'Type','text');
% set(txt,'VerticalAlignment', 'Middle','FontSize',7);
% title('n=1.39')
% ylabel('Normalized optical signal');
% xlabel('Longitudinal strain');
% txt = findobj(gca,'Type','text');
% set(txt,'VerticalAlignment', 'Middle','FontSize',7);
% 
% 
% 
% subplot(2,2,4);
% boxplot(signal4_norm,'PlotStyle','compact','OutlierSize',0.001,'Labels',strain);
% txt = findobj(gca,'Type','text');
% set(txt,'VerticalAlignment', 'Middle','FontSize',7);
% title('n=1.42')
% ylabel('Normalized optical signal');
% xlabel('Longitudinal strain');
% txt = findobj(gca,'Type','text');
% set(txt,'VerticalAlignment', 'Middle','FontSize',7);