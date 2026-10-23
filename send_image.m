
clc;
clear;
close all;

% Receiver settings
receiverIP = "127.0.0.1";  % Same computer
port = 55001;

% Select image
[file, path] = uigetfile( ...
    {'*.png;*.jpg;*.jpeg;*.bmp', 'Image Files'}, ...
    'Select Image to Send');

if isequal(file, 0)
    disp('Image selection cancelled.');
    return;
end

filename = fullfile(path, file);

% Read image as exact file bytes
fid = fopen(filename, 'rb');

if fid < 0
    error('Could not open selected image.');
end

imageBytes = fread(fid, Inf, '*uint8');
fclose(fid);

if isempty(imageBytes)
    error('Selected image file is empty.');
end

% Connect to receiver
fprintf('Connecting to %s:%d...\n', receiverIP, port);

client = tcpclient(receiverIP, port, 'Timeout', 30);

% Ensure connection is released when script exits
cleanupObj = onCleanup(@() delete(client));

% Send file size as a 16-character hexadecimal header
header = uint8(sprintf('%016X', numel(imageBytes)));
write(client, header, 'uint8');

% Send file data in chunks
chunkSize = 32768;
totalBytes = numel(imageBytes);

fprintf('Sending %d bytes...\n', totalBytes);

for k = 1:chunkSize:totalBytes
    lastIndex = min(k + chunkSize - 1, totalBytes);
    write(client, imageBytes(k:lastIndex), 'uint8');
end

fprintf('SUCCESS: Image data sent.\n');
fprintf('Total bytes sent: %d\n', totalBytes);

clear cleanupObj;
