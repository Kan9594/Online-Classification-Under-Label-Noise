function draw_cm(mat,tick,num_class)
%%
%  Matlab code for visualization of confusion matrix;
%  Parameters£ºmat: confusion matrix;
%              tick: name of each class, e.g. 'class_1' 'class_2'...
%              num_class: number of class
%
%  Author£º Page( Ø§×Ó)  
%           Blog: www.shamoxia.com;  
%           QQ:379115886;  
%           Email: peegeelee@gmail.com
%%
%imagesc(1:num_class,1:num_class,mat);             %# in color
%heatmap(mat)
figure
imagesc(mat),colorbar
set(gca, 'XTick', 1:num_class, 'YTick', 1:num_class);
% colormap(flipud(gray));  %# for gray; black for large value.
% 
% textStrings = num2str(mat(:),'%0.2f');  
% textStrings = strtrim(cellstr(textStrings)); 
% %%
%  idx = strcmp(textStrings(:), '0.00');
%  textStrings(idx) = {'   '}; %²»ÏÔÊ¾0
% %%
% [x,y] = meshgrid(1:num_class); 
% hStrings = text(x(:),y(:),textStrings(:), 'HorizontalAlignment','center');
% midValue = mean(get(gca,'CLim')); 
% textColors = repmat(mat(:) > midValue,1,3); 
% set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors
% 
% set(gca,'xticklabel',tick,'XAxisLocation','top');
% set(gca, 'XTick', 1:num_class, 'YTick', 1:num_class);
% rotateXLabels(gca, 315 );% rotate the x tick
% set(gca,'yticklabel',tick);
% 
% %%
% box off
% ax2 = axes('Position',get(gca,'Position'),...
%             'XAxisLocation','bottom',...
%            'YAxisLocation','left',...
%            'Color','none',...
%            'XColor','k','YColor','k');
% set(ax2,'YTick', []);
% set(ax2,'XTick', []);
% box on


