function [] = draw_maps_nuclei_cells_DT_and_PT(visualization,opt,type,b)
%DRAW_MAPS Draws 3D maps from grid features
%

for f = 2:12,
    
    if type == 1
        res_saved = load([opt.path_PT{b},'nuclei_grid.mat']);
        features = res_saved.nuclei_grid;
        grid = res_saved.grid;
    elseif type == 2
        res_saved = load([opt.path_PT{b},'cells_grid.mat']);
        features = res_saved.cells_grid;
        grid = res_saved.grid;
    end
    names = fieldnames(features);
    
    min_val = visualization.(names{f}).min;
    max_val = visualization.(names{f}).max;
    range = round(min_val*features.(names{f}).scaling_factor):round(max_val*features.(names{f}).scaling_factor);
    cmap = jet(length(range));
    
    h1 = figure(1),
    
    for i = 1:grid.nb_x,
        for j = 1:grid.nb_y,
            for k = 1:grid.nb_z,
                if features.(names{2}).vals(i,j,k) >= 10,
                    r = (opt.delta_x/2)*(0.8*((features.(names{f}).vals(i,j,k) - min_val)/...
                        (max_val - min_val))-0.2*((features.(names{f}).vals(i,j,k) - max_val)/(max_val - min_val)));
                    
                    [xs,ys,zs] = sphere(50);
                    
                    x0 = features.centers(i,j,k,1);
                    y0 = features.centers(i,j,k,2);
                    z0 = features.centers(i,j,k,3);
                    
                    x = xs*r + x0;
                    y = ys*r + y0;
                    z = zs*r + z0;
                    
                    idx_tmp = find(range == round(features.(names{f}).scaling_factor*features.(names{f}).vals(i,j,k)));
                    
                    surface(x,y,z,'FaceColor',  cmap(idx_tmp,:),'EdgeColor',cmap(idx_tmp,:))
                    hold on
                end
            end
        end
    end
    
    if type == 1
        res_saved = load([opt.path_DT{b},'nuclei_grid.mat']);
        features = res_saved.nuclei_grid;
        grid = res_saved.grid;
    elseif type == 2
        res_saved = load([opt.path_DT{b},'cells_grid.mat']);
        features = res_saved.cells_grid;
        grid = res_saved.grid;
    end
    
    names = fieldnames(features);
    
    hold on
    for i = 1:grid.nb_x,
        for j = 1:grid.nb_y,
            for k = 1:grid.nb_z,
                if features.(names{2}).vals(i,j,k) >= 10,
                    r = (opt.delta_x/2)*(0.8*((features.(names{f}).vals(i,j,k) - min_val)/...
                        (max_val - min_val))-0.2*((features.(names{f}).vals(i,j,k) - max_val)/(max_val - min_val)));
                    
                    [xs,ys,zs] = sphere(50);
                    
                    x0 = features.centers(i,j,k,1)+opt.DT_shift_x;
                    y0 = features.centers(i,j,k,2)+opt.DT_shift_y;
                    z0 = features.centers(i,j,k,3);
                    
                    x = xs*r + x0;
                    y = ys*r + y0;
                    z = zs*r + z0;
                    
                    idx_tmp = find(range == round(features.(names{f}).scaling_factor*features.(names{f}).vals(i,j,k)));
                    
                    surface(x,y,z,'FaceColor',  cmap(idx_tmp,:),'EdgeColor',cmap(idx_tmp,:))
                    hold on
                end
            end
        end
    end
    
    xlabel('x');
    ylabel('y');
    zlabel('z');
    axis image
    title(features.(names{f}).title,'Interpreter','None');
    view([visualization.az visualization.el]);
    
    if opt.save_figs,
        mkdir([opt.save_folder]);
        saveas(h1,[opt.save_folder,names{f}]);
        saveas(h1,[opt.save_folder,names{f},'.png']);
    end
    close all
    
    
    
    h2 = figure(2)
    axis off;
    for i = 1:7,
        
        val_temp = (max_val - min_val)*(i-1)/6 + min_val;
        r = (opt.delta_x/2)*(0.8*((val_temp - min_val)/(max_val - min_val))-0.2*((val_temp - max_val)/(max_val - min_val)));
        
        [xs,ys,zs] = sphere(50);
        
        x0 = (i-1)*opt.delta_x;
        y0 = 0;
        z0 = 0;
        
        x = xs*r + x0;
        y = ys*r + y0;
        z = zs*r + z0;
        
        idx_tmp = find(range == round(features.(names{f}).scaling_factor*val_temp));
        
        surface(x,y,z,'FaceColor',  cmap(idx_tmp,:),'EdgeColor',cmap(idx_tmp,:));
        hold on
        text(x0-opt.delta_x/3, -opt.delta_y, num2str(val_temp,3),'FontSize',14);
        hold on,
        
    end
    title([features.(names{f}).title,' Range'],'Interpreter','None')
    axis image
    
    if opt.save_figs,
        mkdir([opt.save_folder]);
        saveas(h2,[opt.save_folder,names{f},'_range']);
        saveas(h2,[opt.save_folder,names{f},'_range','.png']);
    end
    close all
end

% Log Volume and Surface Area

for f = 3:4
    
    if type == 1
        res_saved = load([opt.path_PT{b},'nuclei_grid.mat']);
        features = res_saved.nuclei_grid;
        grid = res_saved.grid;
    elseif type == 2
        res_saved = load([opt.path_PT{b},'cells_grid.mat']);
        features = res_saved.cells_grid;
        grid = res_saved.grid;
    end
    
    min_val = features.(names{f}).scaling_factor_log*log(visualization.(names{f}).min);
    max_val = features.(names{f}).scaling_factor_log*log(visualization.(names{f}).max);
    range = round(min_val):round(max_val);
    cmap = jet(length(range));
    
    h1 = figure(1),
    
    for i = 1:grid.nb_x,
        for j = 1:grid.nb_y,
            for k = 1:grid.nb_z,
                if features.(names{2}).vals(i,j,k) >=10,
                    
                    r = (opt.delta_x/2)*(0.8*((features.(names{f}).scaling_factor_log*log(features.(names{f}).vals(i,j,k)) - min_val)/(max_val - min_val))-0.2*((features.(names{f}).scaling_factor_log*log(features.(names{f}).vals(i,j,k)) - max_val)/(max_val - min_val)));
                    [xs,ys,zs] = sphere(50);
                    
                    x0 = features.centers(i,j,k,1);
                    y0 = features.centers(i,j,k,2);
                    z0 = features.centers(i,j,k,3);
                    
                    x = xs*r + x0;
                    y = ys*r + y0;
                    z = zs*r + z0;
                    
                    idx_tmp = find(range == round(features.(names{f}).scaling_factor_log*log(features.(names{f}).vals(i,j,k))));
                    
                    surface(x,y,z,'FaceColor',  cmap(idx_tmp,:),'EdgeColor',cmap(idx_tmp,:))
                    hold on
                end
                
            end
        end
    end
    
    if type == 1
        res_saved = load([opt.path_DT{b},'nuclei_grid.mat']);
        features = res_saved.nuclei_grid;
        grid = res_saved.grid;
    elseif type == 2
        res_saved = load([opt.path_DT{b},'cells_grid.mat']);
        features = res_saved.cells_grid;
        grid = res_saved.grid;
    end
    
    hold on
    
    for i = 1:grid.nb_x,
        for j = 1:grid.nb_y,
            for k = 1:grid.nb_z,
                if features.(names{2}).vals(i,j,k) >=10,
                    
                    r = (opt.delta_x/2)*(0.8*((features.(names{f}).scaling_factor_log*log(features.(names{f}).vals(i,j,k)) - min_val)/(max_val - min_val))-0.2*((features.(names{f}).scaling_factor_log*log(features.(names{f}).vals(i,j,k)) - max_val)/(max_val - min_val)));
                    [xs,ys,zs] = sphere(50);
                    
                    x0 = features.centers(i,j,k,1)+opt.DT_shift_x;
                    y0 = features.centers(i,j,k,2)+opt.DT_shift_y;
                    z0 = features.centers(i,j,k,3);
                    
                    x = xs*r + x0;
                    y = ys*r + y0;
                    z = zs*r + z0;
                    
                    idx_tmp = find(range == round(features.(names{f}).scaling_factor_log*log(features.(names{f}).vals(i,j,k))));
                    
                    surface(x,y,z,'FaceColor',  cmap(idx_tmp,:),'EdgeColor',cmap(idx_tmp,:))
                    hold on
                end
                
            end
        end
    end
    
    xlabel('x');
    ylabel('y');
    zlabel('z');
    xlim([7000 9000])
    axis image
    title(['Log ',features.(names{f}).title])
    view([visualization.az visualization.el]);
    
    if opt.save_figs,
        mkdir([opt.save_folder]);
        saveas(h1,[opt.save_folder,names{f},'_log']);
        saveas(h1,[opt.save_folder,names{f},'_log','.png']);
    end

    close all
    
    
    h2 = figure(2)
    axis off;
    for i = 1:7,
        
        val_temp = (max_val - min_val)*(i-1)/6 + min_val;
        r = (opt.delta_x/2)*(0.8*((val_temp - min_val)/(max_val - min_val))-0.2*((val_temp - max_val)/(max_val - min_val)));
        
        [xs,ys,zs] = sphere(50);
        
        x0 = (i-1)*opt.delta_x;
        y0 = 0;
        z0 = 0;
        
        x = xs*r + x0;
        y = ys*r + y0;
        z = zs*r + z0;
        
        idx_tmp = find(range == round(val_temp));
        
        surface(x,y,z,'FaceColor',  cmap(idx_tmp,:),'EdgeColor',cmap(idx_tmp,:));
        hold on
        text(x0-opt.delta_x/3, -opt.delta_y, num2str(exp(val_temp/features.(names{f}).scaling_factor_log),3),'FontSize',14);
        hold on,
        
    end
    title([features.(names{f}).title,' Range'])
    axis image
    
    if opt.save_figs,
        mkdir([opt.save_folder]);
        saveas(h2,[opt.save_folder,names{f},'_log_range']);
        saveas(h2,[opt.save_folder,names{f},'_log_range','.png']);
    end

    close all
end

% Orientations
for f = (length(names)-3):(length(names)-1)
    
    if type == 1
        res_saved = load([opt.path_PT{b},'nuclei_grid.mat']);
        features = res_saved.nuclei_grid;
        grid = res_saved.grid;
    elseif type == 2
        res_saved = load([opt.path_PT{b},'cells_grid.mat']);
        features = res_saved.cells_grid;
        grid = res_saved.grid;
    end
    
    names = fieldnames(features);
    
    amp = 60;
    h1 = figure(1),

    THmin = 1;
    THmax = 1;
    PHImin = 1;
    PHImax = 1;

    for i = 1:grid.nb_x,
        for j = 1:grid.nb_y,
            for k = 1:grid.nb_z,
                if features.(names{2}).vals(i,j,k) >=10,

                    hold on,


                    TH = acos(features.(names{f}).orientations(i,j,k,3));
                    PHI = atan2(features.(names{f}).orientations(i,j,k,2),features.(names{f}).orientations(i,j,k,1));
                    THmin  = min(THmin, TH);
                    PHImin  = min(THmin, TH);
                    THmax  = max(THmax, TH);
                    PHImax  = max(THmax, TH);
                    line([features.centers(i,j,k,1);features.centers(i,j,k,1)+amp*features.(names{f}).orientations(i,j,k,1)],...
                        [features.centers(i,j,k,2);features.centers(i,j,k,2)+amp*features.(names{f}).orientations(i,j,k,2)],...
                        [features.centers(i,j,k,3);features.centers(i,j,k,3)+amp*features.(names{f}).orientations(i,j,k,3)],...
                        'LineWidth',15*features.(names{f}).sph_var(i,j,k),'Color',[(1/2*sin(TH*2) + 1/2),(1/2*cos(PHI) + 1/2),(1/2*sin(PHI) + 1/2)])
                    hold off,


                end
            end
        end
    end
    
    if type == 1
        res_saved = load([opt.path_DT{b},'nuclei_grid.mat']);
        features = res_saved.nuclei_grid;
        grid = res_saved.grid;
    elseif type == 2
        res_saved = load([opt.path_DT{b},'cells_grid.mat']);
        features = res_saved.cells_grid;
        grid = res_saved.grid;
    end
    
    names = fieldnames(features);
    
    hold on
    
    for i = 1:grid.nb_x,
        for j = 1:grid.nb_y,
            for k = 1:grid.nb_z,
                if features.(names{2}).vals(i,j,k) >=10,

                    hold on,


                    TH = acos(features.(names{f}).orientations(i,j,k,3));
                    PHI = atan2(features.(names{f}).orientations(i,j,k,2),features.(names{f}).orientations(i,j,k,1));
                    THmin  = min(THmin, TH);
                    PHImin  = min(THmin, TH);
                    THmax  = max(THmax, TH);
                    PHImax  = max(THmax, TH);
                    line([features.centers(i,j,k,1)+opt.DT_shift_x;features.centers(i,j,k,1)+opt.DT_shift_x+amp*features.(names{f}).orientations(i,j,k,1)],...
                        [features.centers(i,j,k,2)+opt.DT_shift_y;features.centers(i,j,k,2)+opt.DT_shift_y+amp*features.(names{f}).orientations(i,j,k,2)],...
                        [features.centers(i,j,k,3);features.centers(i,j,k,3)+amp*features.(names{f}).orientations(i,j,k,3)],...
                        'LineWidth',15*features.(names{f}).sph_var(i,j,k),'Color',[(1/2*sin(TH*2) + 1/2),(1/2*cos(PHI) + 1/2),(1/2*sin(PHI) + 1/2)])
                    hold off,

                end
            end
        end
    end

    xlabel('x');
    ylabel('y');
    zlabel('z');

    axis image
    title(names{f})

    view([visualization.az visualization.el]);

    if opt.save_figs,
        mkdir([opt.save_folder]);
        saveas(h1,[opt.save_folder,names{f},'_orientation']);
        saveas(h1,[opt.save_folder,names{f},'_orientation','.png']);
    end
    close all
end

end

