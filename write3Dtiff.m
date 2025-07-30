function write3Dtiff(array, filename)
    % make sure the vector returned by size() is of length 4
    dims = size(array,1:4);
    % Set data type specific fields
    if isa(array, 'single')
        bitsPerSample = 32;
        sampleFormat = Tiff.SampleFormat.IEEEFP;
    elseif isa(array, 'uint16')
        bitsPerSample = 16;
        sampleFormat = Tiff.SampleFormat.UInt;
    elseif isa(array, 'uint8')
        bitsPerSample = 8;
        sampleFormat = Tiff.SampleFormat.UInt;
		elseif isa(array, 'int16')
        bitsPerSample = 16;
        sampleFormat = Tiff.SampleFormat.Int;
    else
        % if you want to handle other numeric classes, add them yourself
        disp('Unsupported data type');
        return;
    end
    
    % Open TIFF file in write mode
    outtiff = Tiff(filename,'w');
    
    % Loop through frames
    for f = 1:dims(4)
        % Set tag structure for each frame
        tagstruct.ImageLength = dims(1);
        tagstruct.ImageWidth = dims(2);
        tagstruct.SamplesPerPixel = dims(3);
        tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
        tagstruct.BitsPerSample = bitsPerSample;
        tagstruct.SampleFormat = sampleFormat;
        
        if any(dims(3) == [3 4]) % assume these are RGB/RGBA
            tagstruct.Photometric = Tiff.Photometric.RGB;
        else % otherwise assume it's I/IA or volumetric
            tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
        end
        
        if any(dims(3) == [2 4]) % assume these are IA/RGBA
            tagstruct.ExtraSamples = Tiff.ExtraSamples.AssociatedAlpha;
        end
        
        % Set the tag for the current frame
        outtiff.setTag(tagstruct);
        
        % Write the frame
        outtiff.write(array(:,:,:,f));
        
        % Create a new directory for the next frame
        if f ~= dims(4)
            outtiff.writeDirectory();
        end
    end
    
    % Close the file
    outtiff.close();
end