%---�������� 
%---by Jim 2018.10.19
%--- file_id �ļ�ID
function feature_analyse(file_id)
    %�ļ�·��
    features_path = ['E:\GraduationProject\Practice1\code\feature\slp', num2str(file_id), '\slp', num2str(file_id), '_features.xlsx'];
    %���ڴ洢��������
    feature_name = {'��', '��', '��', '��', 'SaEn', 'emg'};
    samples = xlsread(features_path);%���ݼ�
    [m, n] = size(samples);
    time = samples(:, 1);%����ʱ�̵�
    stage = samples(:, n);%ר�ҷ���
    features = samples(:, 2:n-1);%�����ռ�
    
    %��һ��
%     features_T = mapminmax(features', 0, 1);
%     features = features_T';
    %��һ��
    
    for i = 1 : n - 2
        feature = features(:, i);
        num_of_zero = size(find(feature == 0), 1);
        if num_of_zero == m
            continue;%����δ��ȡ������
        end
        for j = 1 : m
            switch stage(j)
                case 0%---��ɫ Wake
                    WAKE = plot(time(j), feature(j), 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'MarkerSize', 4);
                case 1%---�Ϻ�ɫ REM
                    REM = plot(time(j), feature(j), 'o', 'MarkerEdgeColor', 'm', 'MarkerFaceColor', 'm', 'MarkerSize', 4);
                case 2%---��ɫ������ɫ S1
                    N1 = plot(time(j), feature(j), 'o', 'MarkerEdgeColor', 'c', 'MarkerFaceColor', 'c', 'MarkerSize', 4);
                case 3%---��ɫ S2
                    N2 = plot(time(j), feature(j), 'o', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b', 'MarkerSize', 4);
                case 4%---��ɫ S3
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
        xlabel('��¼ʱ�� ����/min');
        title([num2str(file_id), '�ű���', '��ͬ˯��״̬�� ', feature_name{i}, ' �ı仯���']);
        pause;
%         print(1, '-dpng', ['E:\sleepStage\1.5\data\ucddb', num2str(file_id), '\feature_picture\', feature_name{i}], '-r100');
    end
end