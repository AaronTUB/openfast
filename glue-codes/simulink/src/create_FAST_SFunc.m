%% INSTRUCTIONS
% Before running this script, you must have compiled OpenFAST for Simulink to create a DLL (i.e., a shared library like .so, .dylib, .lib, etc.).
% - If cmake was used, make sure the install directory is specified properly in the `installDir` variable below,
%   and if using Windows, set `built_with_visualStudio` to false.
% - If the Visual Studio Solution file contained in the vs-build directory was used to create the DLL on Windows,
%   make sure `built_with_visualStudio` is set to true.
% - The name of the library that was generated must match the `libname` variable below
%   and should be located in the directory specified by `libDir`.
% - The `includeDir` variable must specify the directory that contains the following header files:
%   "FAST_Library.h", "OpenFOAM_Types.h", and "SuperController_Types.h"
% - The `outDir` variable indicates where the resulting mex file will reside.
%
% Run `mex -setup` in Matlab to configure a C compiler if you have not already done so.


mexname = 'FAST_SFunc'; % base name of the resulting mex file


if ( ismac )  % Apple MacOS
    installDir = '../../../install';
    outDir = fullfile(installDir, 'lib');
elseif ( ispc ) % Windows PC
    installDir = '../../../install';
    outDir = fullfile(installDir, 'lib');
    % If there are shared libraries does it work for outDir to be the local directory?
else
    installDir = '../../../install';
    outDir = '.';
end

libDir = fullfile(installDir, 'lib');
includeDir = fullfile(installDir, 'include');
libName = 'openfastlib';

%% BUILD COMMAND
fprintf( '\n----------------------------\n' );
fprintf( 'Creating %s\n\n', [outDir filesep mexname '.' mexext] );

mex('-largeArrayDims', ...
    '-v', ... %add this line for "verbose" output (for debugging)
    ['-L', libDir], ...
    ['-l', libName], ...
    '-lgfortran', ...
    '-lquadmath', ...
    '-llapack', ...
    '-lblas', ...
    '-ldl', ...
    ['-I', includeDir], ...
    '-outdir', outDir, ...
    ['CFLAGS=$CFLAGS -DS_FUNCTION_NAME=' mexname], ...
    ... ['CXXFLAGS=$CXXFLAGS -DS_FUNCTION_NAME=' mexname], ...
    '-output', mexname, ...
    'FAST_SFunc.c');

