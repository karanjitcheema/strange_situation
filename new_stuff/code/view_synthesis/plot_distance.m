% function plot_distance(pos3d,pos2d)
for i=1:2:size(pos3d,2)
    dist(ceil(i/2)) = norm(pos2d(1:2,i)-pos2d(1:2,i+1));
end
for i=1:2:size(pos3d,2)
    dist3d(ceil(i/2)) = norm(pos2d(1:3,i)-pos2d(1:3,i+1));
end
for i=1:2:size(pos3d,2)
    hdiff(ceil(i/2)) = norm(pos2d(3,i)-pos2d(3,i+1));
end

figure;
hold on;
axis([0 1650 0 400])
% plot(1:1146,dist(1:1146),'b+');
for i=1:length(dist)
    if i>1
        plot(i-1,dist(i-1),'b+');
    end
    plot(i,dist(i),'r+');
    drawnow;
    saveas(gcf,fullfile('/Users/karanjitcheema/Desktop/reunion_dist1',[num2str(i),'.png']));
end

figure;hold on;
axis([0 1650 0 300])
plot(1:length(dist),dist,'b+');
plot(1:length(dist),hdiff,'r+');
plot(1:length(dist),dist3d,'g+');
xlabel('t','fontsize',32,'fontweight','b');
ylabel('distance','fontsize',32,'fontweight','b');
legend('2d distance','height difference','3d distance','NorthEast')