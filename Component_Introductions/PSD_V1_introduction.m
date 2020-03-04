%{
Author: Andy Schreier
E-Mail: andy.schreier@eng.ox.ac.uk
Copyright: optical wireless communication group
Status: alpha-testing
Version: 0.1
Versionupdate: 20/02/2020

The given script represents an adaptation of the provided documentation
from ThorLabs. This script is intended to be used to inititalise the
position sensor controlled by the KCube. Furthermore, a figure window is
generated displaying the current beam postion.

The declaration of the global variable h0998 has been made to call this
variable from outside this script and any main functions.

Please, adopt this script by adding the serial number of your KCube (see
comment 'set the serial number') prior to any operation of this script.

This script uses an ActiveX controller. Since the use of it might be 
affected in future (new Oracle license scheme), MatLab implemented 
functions in R2019b to replace Java and ActiveX applications (see
https://uk.mathworks.com/products/matlab/app-designer/java-swing-alternatives.html?s_tid=pi_app_designer_R2019b_activex).
Please, develop an alternative way to initialise and read out the KCube.

The use of the function ReadSumDiffSignals() is given as well as a line of
code determining the current beam position on the lateral effect sensor. 
The manual of the KCube provides further information about these two lines.
%}

%% PSD Control Initialisation
global h0998; % make h0998 a global variable

% Create Matlab Figure Container
fpos    = get(0,'DefaultFigurePosition'); % figure default position
fpos(3) = 650; % figure window width
fpos(4) = 450; % height

f = figure('Position', fpos,...
           'Menu','None',...
           'Name','APT GUI');
% create ActiveX controller
h0998 = actxcontrol('APTQUAD.APTQuadCtrl.1',[20 20 600 400 ], f);
%h0998.StartCtrl;
% set the serial number
%SN = 89856017; % put in the serial number of the hardware
%SN = 69250998; % put in the serial number of the hardware
SN = 69251072 % serial number of coarse tracking in setup
set(h0998,'HWSerialNum', SN);
h0998.StartCtrl;
h0998.Identify; 

%How to get the position on the PSD:
%[A0998 PSUM0998 XDIFF0998 YDIFF0998]=h0998.ReadSumDiffSignals(0,0,0); % get the result from PSD
%Position_Now = [XDIFF0998 YDIFF0998]/PSUM0998; %calculate the x and y value