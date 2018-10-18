%---特征分析 
%---by Jim 2018.10.19
%--- file_id 文件ID
function feature_analyse(file_id)
    %文件路径
    features_path = ['E:\GraduationProject\Practice1\code\feature\slp', num2str(file_id), '\slp', num2str(file_id), '_features.xlsx'];
    %用于存储特征名字
    feature_name = {'δ', 'θ', 'α', 'β', 'SaEn', 'emg'};
    samples = xlsread(features_path);%数据集
    [m, n] = size(samples);
    time = samples(:, 1);%分期时刻点
    stage = samples(:, n);%专家分期
    features = samples(:, 2:n-1);%特征空间
    
    %归一化
%     features_T = mapminmax(features', 0, 1);
%     features = features_T';
    %归一化
    
    for i = 1 : n - 2
        feature = features(:, i);
        num_of_zero = size(find(feature == 0), 1);
        if num_of_zero == m
            continue;%跳过未提取的特征
        end
        for j = 1 : m
            switch stage(j)
                case 0%---黑色 Wake
                    WAKE = plot(time(j), feature(j), 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'MarkerSize', 4);
                case 1%---紫红色 REM
                    REM = plot(time(j), feature(j), 'o', 'MarkerEdgeColor', 'm', 'MarkerFaceColor', 'm', 'MarkerSize', 4);
                case 2%---青色、蓝绿色 S1
                    N1 = plot(time(j), feature(j), 'o', 'MarkerEdgeColor', 'c', 'MarkerFaceColor', 'c', 'MarkerSize', 4);
                case 3%---蓝色 S2
                    N2 = plot(time(j), feature(j), 'o', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b', 'MarkerSize', 4);
                case 4%---绿色 S3
                    N3 = plot(time(j), feature(j), 'o', 'MarkerEdgeColor', 'g', 'MarkerFaceColor', 'g', 'MarkerSize', 4);
                otherwise
                    OTHER = plot(time(j), feature(j), 'o', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r', 'MarkerSize', 4);
            end
            hold on;
        end
        hold off;
        if ~exist('OTHER', 'var')
            l1 = legend([WAKE(1), REM(1), N1(1), N2(1), N3(1)], 'WAKE', 'REM', 'N1', 'N2', 'N3');
            l1.set('FontSize', 14)
        else
            l1 = legend([WAKE(1), REM(1), N1(1), N2(1), N3(1), OTHER(1)], 'WAKE', 'REM', 'N1', 'N2', 'N3', 'Other Label');
            l1.set('FontSize', 14)
        end
        xlabel('记录时长 分钟/min');
        title([num2str(file_id), '号被试', '不同睡眠状态下 ', feature_name{i}, ' 的变化情况']);
        pause;
%         print(1, '-dpng', ['E:\sleepStage\1.5\data\ucddb', num2str(file_id), '\feature_picture\', feature_name{i}], '-r100');
    end
end