function ms = msSelectROIs(ms)
%MSSELECTROIS Summary of this function goes here
%   Detailed explanation goes here



    


    numROIs=0;
    userInput = 'Y';
    refFrameNumber = ceil(ms.numFrames/2);
    refFrame = msReadFrame(ms,refFrameNumber,true,false,false);
         
    
    lf = filter2(fspecial('average',[50 50]),refFrame,'same');
    hf = filter2(fspecial('average',[5 5]),refFrame,'same');
    
    edge = 75;
    d = abs(hf-lf);
    d(1:edge,:) = 0;
    d(end-edge:end,:) = 0;
    d(:,1:edge) = 0;
    d(:,end-edge:end) = 0;
    fcon = filter2(fspecial('average',[100 100]),d,'same');
    fcon = fcon./nanmax(fcon(:));
    [x y] = find(fcon>0.5);
    ms.alignmentROI(:,1) = [2.*floor((nanmin(y))./2) 2.*floor((nanmin(x))./2) ...
        2.*floor((nanmax(y)-nanmin(y))./2) ...
        2.*floor((nanmax(x)-nanmin(x))./2)];
    
    figure(1)
    imshow(uint8(refFrame),[nanmin(refFrame(:)) nanmax(refFrame(:))])
    rectangle('Position', ms.alignmentROI(:,1),'LineWidth',2,'LineStyle','--');
    drawnow
    
%     if (isfield(ms,'alignmentROI'))  %checks if alignmentROIs already exsist
%         imshow(uint8(refFrame),[nanmin(refFrame(:)) nanmax(refFrame(:))])
%         hold on
%         for ROINum = 1:size(ms.alignmentROI,2)
%             rectangle('Position', ms.alignmentROI(:,1),'LineWidth',2,'LineStyle','--');
%         end
%         userInput = upper(input('Session already has alignment ROIs. Reset ROIs? (Y/N)','s'));
%     end
% 
%     if strcmp(userInput,'Y')
%         ms.alignmentROI = [];
%         temp = {'hShift','wShift','alignedWidth','alignedHeight'};
%         idx = isfield(ms,temp);
%         ms = rmfield(ms,temp(idx));
% 
%         imshow(uint8(refFrame))
%         hold on
%         while (strcmp(userInput,'Y'))
%             numROIs = numROIs+1;
%             display(['Select ROI #' num2str(numROIs)])
%             rect = getrect(); 
%             rect(3) = rect(3) - mod(rect(3),2);
%             rect(4) = rect(4) - mod(rect(4),2);
% 
%             ms.alignmentROI(:,numROIs) = rect; %uint16([rect(1) rect(1)+rect(3) rect(2) rect(2)+rect(4)]);
%             rectangle('Position',rect,'LineWidth',2);
%             userInput = upper(input('Select another ROI? (Y/N)','s'));
%         end
%     end 
end
