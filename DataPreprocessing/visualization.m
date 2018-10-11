% PSG��ͼ���۲��źŲ���֤�����Ƿ���ȷ��
% by Jim 2018.10.11
function visualization(data_pkg)
    sample_rate = data_pkg.sample_rate;%������
    seg_time = 30;%�ֶγ���30s
    file_id = data_pkg.file_id;%�ļ�ID
    
    expert_stages = load('slp48stages.txt');  % ר�ҷ���

    %��ͨ���ź�
    ecg = data_pkg.ecg;
    resp_chest = data_pkg.resp_chest;
    eog = data_pkg.eog;
    chin_emg = data_pkg.chin_emg;
    EEG_C4A1 = data_pkg.EEG_C4A1;
    %��ͨ���ź�
    
    signal_len = length(chin_emg);%�ź��ܳ�
    total_seg = floor(signal_len / sample_rate / seg_time);%�ֶ�����(������������Ķ�)
    
    x = (1 : seg_time*sample_rate)/sample_rate;%���������
    interval_x = (1 : 0.5*sample_rate : seg_time*sample_rate)/sample_rate;%������0.5s�ļ��
    interval_y = (-100 : 100 : 500);
    vertical_line = meshgrid(interval_x, interval_y);
    horizental_line = meshgrid(interval_y, interval_x);
    
    for epoch = 1 : total_seg
        %30s�ֶ��ź�
        ecg_epoch = ecg((epoch-1)*seg_time*sample_rate+1 : epoch*seg_time*sample_rate);
        resp_chest_epoch = resp_chest((epoch-1)*seg_time*sample_rate+1 : epoch*seg_time*sample_rate);
        eog_epoch = eog((epoch-1)*seg_time*sample_rate+1 : epoch*seg_time*sample_rate);
        chin_emg_epoch = chin_emg((epoch-1)*seg_time*sample_rate+1 : epoch*seg_time*sample_rate);
        EEG_C4A1_epoch = EEG_C4A1((epoch-1)*seg_time*sample_rate+1 : epoch*seg_time*sample_rate);
        %30s�ֶ��ź�
        
        %���ӻ����ã�ԭʼ���ݲ�����ֵ̫С��
%         EEG_C4A1_epoch = EEG_C4A1_epoch ./ 1;
%         chin_emg_epoch = chin_emg_epoch ./ 2;
%         eog_epoch = eog_epoch .* 2;
        resp_chest_epoch = resp_chest_epoch .* 50;
        ecg_epoch = ecg_epoch .* 20;
        %���ӻ�����
        
        %���ӻ�ƫ����
        EEG_C4A1_epoch = EEG_C4A1_epoch + 0*100;
        chin_emg_epoch = chin_emg_epoch + 1*100;
        eog_epoch = eog_epoch + 2*100;
        resp_chest_epoch = resp_chest_epoch + 4*100;
        ecg_epoch = ecg_epoch + 3*100;
        %���ӻ�ƫ����
        
        plot(interval_x, horizental_line, '--');
        hold on
        plot(vertical_line, interval_y, '--');
        hold on
        plot(x, EEG_C4A1_epoch, 'k');
        hold on
        plot(x, chin_emg_epoch, 'k');
        hold on
        plot(x, eog_epoch, 'b');
        hold on
        plot(x, resp_chest_epoch, 'm');
        hold on
        plot(x, ecg_epoch, 'm');
        hold off
        xlabel('ʱ�� ��/s')
        set(gca, 'ytick', (-50 : 50 :450))
        set(gca, 'yticklabel', {'-------', 'EEG\_C4A1-100��V', '-------', 'EMG\_Chin-100��V', '-------', ...
            'EOG-100��V', '-------', 'ECG-1mV', '-------', 'RESP\_CHEST-1mV', '-------'});
        expert_stage_str = '';
        switch expert_stages(epoch)
            case 0
                expert_stage_str = 'WAKE';
            case 1
                expert_stage_str = 'REM';
            case 2
                expert_stage_str = 'N1';
            case 3
                expert_stage_str = 'N2';
            case 4
                expert_stage_str = 'N3';
        end
        title(['����--slp', num2str(file_id), '--����˯��Լ', num2str(roundn(signal_len/sample_rate/60/60, -1)), ...
               'Сʱ����', num2str((epoch-1)*30/60), '���ӵ���', num2str(epoch*30/60), '���Ӷർ˯��ͼ-', expert_stage_str]);
        pause;
    end
end