mom_file = fopen('/Users/karanjitcheema/Desktop/RA_Work/reunion_2/centres_mother.txt', 'r');
baby_file = fopen('/Users/karanjitcheema/Desktop/RA_Work/reunion_2/centres_baby.txt', 'r');
mother = struct([]);
baby = struct([]);

i=1;
while(~feof(mom_file))
    A = fscanf(mom_file,'%f %f %f %f %f %f %f %f', 8);
    mother(i).cam  = A(1);
    mother(i).frame  = A(2);
    mother(i).valid  = A(3);
    mother(i).offset  = A(4);
    mother(i).x  = A(5);
    mother(i).y  = A(6);
    mother(i).height  = A(7);
    mother(i).width  = A(8);
    i = i+1;
end
i=1;
while(~feof(baby_file))
    A = fscanf(baby_file,'%f %f %f %f %f %f %f %f', 8);
    baby(i).cam  = A(1);
    baby(i).frame  = A(2);
    baby(i).valid  = A(3);
    baby(i).offset  = A(4);
    baby(i).x  = A(5);
    baby(i).y  = A(6);
    baby(i).height  = A(7);
    baby(i).width  = A(8);
    i = i+1;
end

directory = '/Users/karanjitcheema/Desktop/RA_Work/Data/';
filename_1_prefix = strcat(directory,'USB-VID_045E&PID_02AE-A00364A04906127A_');
filename_2_prefix = strcat(directory,'USB-VID_045E&PID_02AE-A00367A14179123A_');
filename_3_prefix = strcat(directory,'USB-VID_045E&PID_02AE-A00365A09389104A_');
filename_4_prefix = strcat(directory,'USB-VID_045E&PID_02AE-B00362214481051B_');

cam1_depth_mapping = load(fullfile([filename_1_prefix,'DepthFrameToColorFrameMapping.mat']));
cam2_depth_mapping = load(fullfile([filename_2_prefix,'DepthFrameToColorFrameMapping.mat']));
cam3_depth_mapping = load(fullfile([filename_3_prefix,'DepthFrameToColorFrameMapping.mat']));
cam4_depth_mapping = load(fullfile([filename_4_prefix,'DepthFrameToColorFrameMapping.mat']));

three_d_coordinates  = struct([]);
j=1;
valid = 0;
prob =0;
for i = 1:length(mother)
    if(mother(i).valid ==0)
        continue;
    end
    valid = valid +1;
    three_d_coordinates(j).line_num = i;
    
    if(mother(i).cam == 1)
        load(fullfile([filename_1_prefix,num2str(mother(i).frame),'.mat']),'ColorFrame','DepthFrame');
        d_img = map_depthframe_to_colorframe(DepthFrame.DepthData.Depth,cam1_depth_mapping.DepthFrameToColorFrameMapping);
    elseif(mother(i).cam ==2)
        load(fullfile([filename_2_prefix,num2str(mother(i).frame),'.mat']),'ColorFrame','DepthFrame');
        d_img = map_depthframe_to_colorframe(DepthFrame.DepthData.Depth,cam2_depth_mapping.DepthFrameToColorFrameMapping);
    elseif(mother(i).cam ==3)
        load(fullfile([filename_3_prefix,num2str(mother(i).frame),'.mat']),'ColorFrame','DepthFrame');
        d_img = map_depthframe_to_colorframe(DepthFrame.DepthData.Depth,cam3_depth_mapping.DepthFrameToColorFrameMapping);
    elseif(mother(i).cam ==4)
        load(fullfile([filename_4_prefix,num2str(mother(i).frame),'.mat']),'ColorFrame','DepthFrame');
        d_img = map_depthframe_to_colorframe(DepthFrame.DepthData.Depth,cam4_depth_mapping.DepthFrameToColorFrameMapping);
    end
    
%     depth_values = zeros(mother(i).height,mother(i).width);
    center_x = mother(i).x;
    center_y = mother(i).y;
    width = mother(i).width;
    height = mother(i).height;
    min_x = floor(center_x - width/2);
    max_x = floor(center_x + width/2);
    min_y = floor(center_y - height/2);
    max_y = floor(center_y + height/2);
    if(i==15)
    end
    
    depth_values = d_img(min_y:max_y,min_x:max_x);

% %     now find the X and Y values in the depth mapping...
%     count_row =0;
%     count_col =0;
    
%         for k = min_y:max_y
%             [found_row,found_col] = find(cam1_depth_mapping.DepthFrameToColorFrameMapping.Y(:,1) == k);
%             count_row = count_row +1;
%             if(numel(found_row) ==0)
%                 new_y_value(count_row) = -1;
%                 continue;
%             end
%             new_y_value(count_row) = found_row(1);
%         end
%         for m = min_x:max_x
%             [found_row,found_col] = find(cam1_depth_mapping.DepthFrameToColorFrameMapping.X(1,:) == m);
%             count_col = count_col +1;
%             if(numel(found_col) ==0)
%                 new_x_value(count_col) = -1;
%                 continue;
%             end
%             new_x_value(count_col) = found_col(1);
%         end
%         
%         for row = 1:count_row
%             if(new_y_value(row) == -1)
%                 continue;
%             end
%             for col = 1:count_col
%                 if(new_x_value(col) == -1)
%                     continue;
%                 end
%                 three_d_coordinates_bounding_box(1,count) = DepthFrame.DepthData.X(new_y_value(row),new_x_value(col));
%                 three_d_coordinates_bounding_box(2,count) = DepthFrame.DepthData.Y(new_y_value(row),new_x_value(col));
%                 three_d_coordinates_bounding_box(3,count) = DepthFrame.DepthData.Depth(new_y_value(row),new_x_value(col));
%                 if(three_d_coordinates_bounding_box(3,count) == -1)
%                     continue;
%                 end
%                 count = count +1;
%             end
%         end
    count =1;
    if(mother(i).cam == 1)
        for k = min_y:max_y
            for l = min_x:max_x
                [found_row,found_col] = find(cam1_depth_mapping.DepthFrameToColorFrameMapping.X(1,:) == l);
                if(numel(found_col) ==0 ||numel(found_col) ==0)
                    continue;
                end
                new_x_value = found_col(1);
                [found_row,found_col] = find(cam1_depth_mapping.DepthFrameToColorFrameMapping.Y(:,1) == k);
                if(numel(found_col) ==0 ||numel(found_col) ==0)
                    continue;
                end
                new_y_value = found_row(1);
                three_d_coordinates_bounding_box(1,count) = DepthFrame.DepthData.X(new_y_value ,new_x_value ) ;
                three_d_coordinates_bounding_box(2,count) = DepthFrame.DepthData.Y(new_y_value ,new_x_value );
                three_d_coordinates_bounding_box(3,count) = DepthFrame.DepthData.Depth(new_y_value ,new_x_value );
                if(three_d_coordinates_bounding_box(3,count) == -1)
                    continue;
                end
                count = count +1;
                
            end
        end
    elseif(mother(i).cam == 2)
        for k = min_y:max_y
             for l = min_x:max_x
                [found_row,found_col] = find(cam2_depth_mapping.DepthFrameToColorFrameMapping.X(1,:) == l);
                if(numel(found_col) ==0 ||numel(found_col) ==0)
                    continue;
                end
                new_x_value = found_col(1);
                [found_row,found_col] = find(cam2_depth_mapping.DepthFrameToColorFrameMapping.Y(:,1) == k);
                if(numel(found_col) ==0 ||numel(found_col) ==0)
                    continue;
                end
                new_y_value = found_row(1);
                
                three_d_coordinates_bounding_box(1,count) = DepthFrame.DepthData.X(new_y_value ,new_x_value );
                three_d_coordinates_bounding_box(2,count) = DepthFrame.DepthData.Y(new_y_value ,new_x_value );
                three_d_coordinates_bounding_box(3,count) = DepthFrame.DepthData.Depth(new_y_value ,new_x_value );
                if(three_d_coordinates_bounding_box(3,count) == -1)
                    continue;
                end
                count = count +1;
            end
        end
    elseif(mother(i).cam == 3)        
        for k = min_y:max_y
            for l = min_x:max_x
                [found_row,found_col] = find(cam3_depth_mapping.DepthFrameToColorFrameMapping.X(1,:) == l);
                if(numel(found_col) ==0 ||numel(found_col) ==0)
                    continue;
                end
                new_x_value = found_col(1);
                [found_row,found_col] = find(cam3_depth_mapping.DepthFrameToColorFrameMapping.Y(:,1) == k);
                if(numel(found_col) ==0 ||numel(found_col) ==0)
                    continue;
                end
                new_y_value = found_row(1);
                
                three_d_coordinates_bounding_box(1,count) = DepthFrame.DepthData.X(new_y_value ,new_x_value );
                three_d_coordinates_bounding_box(2,count) = DepthFrame.DepthData.Y(new_y_value ,new_x_value );
                three_d_coordinates_bounding_box(3,count) = DepthFrame.DepthData.Depth(new_y_value ,new_x_value );
                if(three_d_coordinates_bounding_box(3,count) == -1)
                    continue;
                end
                count = count +1;
            end
        end
    elseif(mother(i).cam == 4)        
        for k = min_y:max_y
            for l = min_x:max_x
                [found_row,found_col] = find(cam4_depth_mapping.DepthFrameToColorFrameMapping.X(1,:) == l);
                if(numel(found_col) ==0 ||numel(found_col) ==0)
                    continue;
                end
                new_x_value = found_col(1);
                [found_row,found_col] = find(cam4_depth_mapping.DepthFrameToColorFrameMapping.Y(:,1) == k);
                if(numel(found_col) ==0 ||numel(found_col) ==0)
                    continue;
                end
                new_y_value = found_row(1);
                
                three_d_coordinates_bounding_box(1,count) = DepthFrame.DepthData.X(new_y_value ,new_x_value );
                three_d_coordinates_bounding_box(2,count) = DepthFrame.DepthData.Y(new_y_value ,new_x_value );
                three_d_coordinates_bounding_box(3,count) = DepthFrame.DepthData.Depth(new_y_value ,new_x_value );
                if(three_d_coordinates_bounding_box(3,count) == -1)
                    continue;
                end
                count = count +1;
            end
        end
    end

    bandwidth = 25;
    [clustCent,point2cluster,clustMembsCell] = MeanShiftCluster(three_d_coordinates_bounding_box,bandwidth);
    three_d_coordinates(j).x =  clustCent(1,mode(point2cluster));
    three_d_coordinates(j).y =  clustCent(2,mode(point2cluster));
    three_d_coordinates(j).z =  clustCent(3,mode(point2cluster));
    three_d_coordinates(j).cam = mother(i).cam;
    three_d_coordinates(j).frame = mother(i).frame;
    three_d_coordinates(j).valid = mother(i).valid;
    three_d_coordinates(j).offset = mother(i).offset;
    three_d_coordinates(j).bounding_box_x = mother(i).x;
    three_d_coordinates(j).bounding_box_y = mother(i).y;
    three_d_coordinates(j).bounding_box_width = mother(i).width;
    three_d_coordinates(j).bounding_box_height = mother(i).height;
%     plot3(three_d_coordinates(j).x,three_d_coordinates(j).y,three_d_coordinates(j).z,'LineWidth',5);
%     hold on;
%     pause(0.1);
    j=j+1;
end



three_d_coordinates_baby  = struct([]);
j=1;
valid_baby = 0;
prob_baby =0;
cases =0;
for i = 1:length(baby)
    if(baby(i).valid ==0)
        continue;
    end
    valid_baby = valid_baby +1;
    three_d_coordinates_baby(j).line_num = i;
    clear DepthFrame;
    if(baby(i).cam == 1)
        load(fullfile([filename_1_prefix,num2str(baby(i).frame),'.mat']),'ColorFrame','DepthFrame');
        d_img = map_depthframe_to_colorframe(DepthFrame.DepthData.Depth,cam1_depth_mapping.DepthFrameToColorFrameMapping);
    elseif(baby(i).cam ==2)
        load(fullfile([filename_2_prefix,num2str(baby(i).frame),'.mat']),'ColorFrame','DepthFrame');
        d_img = map_depthframe_to_colorframe(DepthFrame.DepthData.Depth,cam2_depth_mapping.DepthFrameToColorFrameMapping);
    elseif(baby(i).cam ==3)
        load(fullfile([filename_3_prefix,num2str(baby(i).frame),'.mat']),'ColorFrame','DepthFrame');
        d_img = map_depthframe_to_colorframe(DepthFrame.DepthData.Depth,cam3_depth_mapping.DepthFrameToColorFrameMapping);
    elseif(baby(i).cam ==4)
        load(fullfile([filename_4_prefix,num2str(baby(i).frame),'.mat']),'ColorFrame','DepthFrame');
        d_img = map_depthframe_to_colorframe(DepthFrame.DepthData.Depth,cam4_depth_mapping.DepthFrameToColorFrameMapping);
    end
    
%     depth_values = zeros(baby(i).height,baby(i).width);
    center_x = baby(i).x;
    center_y = baby(i).y;
    width = baby(i).width;
    height = baby(i).height;
    min_x = floor(center_x - width/2);
    max_x = floor(center_x + width/2);
    min_y = floor(center_y - height/2);
    max_y = floor(center_y + height/2);
    if(max_y>480)
        max_y = 480;
    end
    depth_values = d_img(min_y:max_y,min_x:max_x);

% %     now find the X and Y values in the depth mapping...
    count =1;
    if(baby(i).cam == 1)
        for k = min_y:max_y
            for l = min_x:max_x
                [found_row,found_col] = find(cam1_depth_mapping.DepthFrameToColorFrameMapping.X(1,:) == l);
                if(numel(found_col) ==0 ||numel(found_col) ==0)
                    continue;
                end
                new_x_value = found_col(1);
                [found_row,found_col] = find(cam1_depth_mapping.DepthFrameToColorFrameMapping.Y(:,1) == k);
                if(numel(found_col) ==0 ||numel(found_col) ==0)
                    continue;
                end
                new_y_value = found_row(1);
                if(DepthFrame.DepthData.Depth(new_y_value ,new_x_value) == -1)
                    continue;
                end
                
                three_d_coordinates_baby_bounding_box(1,count) = DepthFrame.DepthData.X(new_y_value ,new_x_value ) ;
                three_d_coordinates_baby_bounding_box(2,count) = DepthFrame.DepthData.Y(new_y_value ,new_x_value );
                three_d_coordinates_baby_bounding_box(3,count) = DepthFrame.DepthData.Depth(new_y_value ,new_x_value );
                count = count +1;
                
            end
        end
    elseif(baby(i).cam == 2)        
        for k = min_y:max_y
            for l = min_x:max_x
                [found_row,found_col] = find(cam2_depth_mapping.DepthFrameToColorFrameMapping.X(1,:) == l);
                if(numel(found_col) ==0 ||numel(found_col) ==0)
                    continue;
                end
                new_x_value = found_col(1);
                [found_row,found_col] = find(cam2_depth_mapping.DepthFrameToColorFrameMapping.Y(:,1) == k);
                if(numel(found_col) ==0 ||numel(found_col) ==0)
                    continue;
                end
                new_y_value = found_row(1);
                
                three_d_coordinates_baby_bounding_box(1,count) = DepthFrame.DepthData.X(new_y_value ,new_x_value );
                three_d_coordinates_baby_bounding_box(2,count) = DepthFrame.DepthData.Y(new_y_value ,new_x_value );
                three_d_coordinates_baby_bounding_box(3,count) = DepthFrame.DepthData.Depth(new_y_value ,new_x_value );
                if(three_d_coordinates_baby_bounding_box(3,count) == -1)
                    continue;
                end
                count = count +1;
            end
        end
    elseif(baby(i).cam == 3)
        for k = min_y:max_y
            for l = min_x:max_x
                [found_row,found_col] = find(cam3_depth_mapping.DepthFrameToColorFrameMapping.X(1,:) == l);
                if(numel(found_col) ==0 ||numel(found_col) ==0)
                    continue;
                end
                new_x_value = found_col(1);
                [found_row,found_col] = find(cam3_depth_mapping.DepthFrameToColorFrameMapping.Y(:,1) == k);
                if(numel(found_col) ==0 ||numel(found_col) ==0)
                    continue;
                end
                new_y_value = found_row(1);
                
                if(DepthFrame.DepthData.Depth(new_y_value ,new_x_value ) == -1)
                    continue;
                end
                three_d_coordinates_baby_bounding_box(1,count) = DepthFrame.DepthData.X(new_y_value ,new_x_value );
                three_d_coordinates_baby_bounding_box(2,count) = DepthFrame.DepthData.Y(new_y_value ,new_x_value );
                three_d_coordinates_baby_bounding_box(3,count) = DepthFrame.DepthData.Depth(new_y_value ,new_x_value );
                count = count +1;
            end
        end
    elseif(baby(i).cam == 4)
        for k = min_y:max_y
            for l = min_x:max_x
                [found_row,found_col] = find(cam4_depth_mapping.DepthFrameToColorFrameMapping.X(1,:) == l);
                if(numel(found_col) ==0 ||numel(found_col) ==0)
                    continue;
                end
                new_x_value = found_col(1);
                [found_row,found_col] = find(cam4_depth_mapping.DepthFrameToColorFrameMapping.Y(:,1) == k);
                if(numel(found_col) ==0 ||numel(found_col) ==0)
                    continue;
                end
                new_y_value = found_row(1);
                
                three_d_coordinates_baby_bounding_box(1,count) = DepthFrame.DepthData.X(new_y_value ,new_x_value );
                three_d_coordinates_baby_bounding_box(2,count) = DepthFrame.DepthData.Y(new_y_value ,new_x_value );
                three_d_coordinates_baby_bounding_box(3,count) = DepthFrame.DepthData.Depth(new_y_value ,new_x_value );
                if(three_d_coordinates_baby_bounding_box(3,count) == -1)
                    continue;
                end
                count = count +1;
            end
        end
    end
    if(count ==1)
        continue;
    end
    bandwidth = 25;
    [clustCent,point2cluster,clustMembsCell] = MeanShiftCluster(three_d_coordinates_baby_bounding_box,bandwidth);
    three_d_coordinates_baby(j).x =  clustCent(1,mode(point2cluster));
    three_d_coordinates_baby(j).y =  clustCent(2,mode(point2cluster));
    three_d_coordinates_baby(j).z =  clustCent(3,mode(point2cluster));
    three_d_coordinates_baby(j).cam = baby(i).cam;
    three_d_coordinates_baby(j).frame = baby(i).frame;
    three_d_coordinates_baby(j).valid = baby(i).valid;
    three_d_coordinates_baby(j).offset = baby(i).offset;
    three_d_coordinates_baby(j).bounding_box_x = baby(i).x;
    three_d_coordinates_baby(j).bounding_box_y = baby(i).y;
    three_d_coordinates_baby(j).bounding_box_width = baby(i).width;
    three_d_coordinates_baby(j).bounding_box_height = baby(i).height;
%     plot3(three_d_coordinates_baby(j).x,three_d_coordinates_baby(j).y,three_d_coordinates_baby(j).z,'LineWidth',5);
%     hold on;
%     pause(0.01);
    j=j+1;
end

fclose(mom_file);
fclose(baby_file);
