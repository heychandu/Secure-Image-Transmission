
clc;
clear;
close all;

port = 55001;

% Start TCP receiver
fprintf('Starting receiver on port %d...\n', port);

server = tcpserver("0.0.0.0", port);

cleanupObj = onCleanup(@() delete(server));

fprintf('READY: Waiting for sender...\n');

% Wait for sender to connect
while ~server.Connected
    pause(0.1);
end

fprintf('Sender connected!\n');

% Read 16-byte file-size header
headerBytes = readExact(server, 16, 120);

headerText = char(headerBytes(:).');
fileSize = hex2dec(headerText);

if ~isfinite(fileSize) || fileSize < 1 || ...
        fileSize ~= fix(fileSize) || fileSize > 1e9
    error('Invalid file-size header received.');
end

fprintf('Expected image size: %.0f bytes\n', fileSize);

% Receive exact image data
imageBytes = readExact(server, fileSize, 120);

fprintf('SUCCESS: Received all image bytes.\n');

% Save received image
[file, path] = uiputfile( ...
    {'*.png', 'PNG Image (*.png)'}, ...
    'Save Received Image', ...
    'received_image.png');

if isequal(file, 0)
    disp('Saving cancelled.');
    clear cleanupObj;
    return;
end

filename = fullfile(path, file);

fid = fopen(filename, 'wb');

if fid < 0
    error('Cannot create output image file.');
end

fwrite(fid, imageBytes, 'uint8');
fclose(fid);

fprintf('Saved: %s\n', filename);

% Verify that the received file is a valid image
try
    receivedImage = imread(filename);

    figure('Name', 'Received Image');
    imshow(receivedImage);
    title('Image Received Successfully');

catch ME
    error('Received file is not a valid image: %s', ME.message);
end

clear cleanupObj;

disp('Receiver finished.');

% Read exactly N bytes from the TCP connection
function data = readExact(server, N, timeoutSeconds)

    data = zeros(N, 1, 'uint8');
    received = 0;
    timer = tic;

    while received < N

        available = server.NumBytesAvailable;

        if available > 0
            count = min(available, N - received);

            chunk = read(server, count, 'uint8');

            data(received + 1:received + count) = chunk(:);
            received = received + count;

            % Reset inactivity timeout after receiving data
            timer = tic;
        else
            pause(0.01);
        end

        if toc(timer) > timeoutSeconds
            error('Timed out while receiving data. Received %d of %d bytes.', ...
                received, N);
        end
    end
end
