function tests = test_viewer_entry_points
% Entry-point regressions; no image-data processing or toolbox calls.
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
repo = fileparts(fileparts(mfilename('fullpath')));
testCase.applyFixture(matlab.unittest.fixtures.PathFixture(repo));
testCase.applyFixture(matlab.unittest.fixtures.WorkingFolderFixture(repo));
testCase.TestData.originalVisibility = get(groot, 'DefaultFigureVisible');
set(groot, 'DefaultFigureVisible', 'off');
end

function teardownOnce(testCase)
set(groot, 'DefaultFigureVisible', testCase.TestData.originalVisibility);
end

function setup(testCase)
testCase.TestData.originalFigures = findall(groot, 'Type', 'figure');
clear window_builder_control_panel window_builder_prototype
end

function teardown(testCase)
figures = findall(groot, 'Type', 'figure');
for k = 1:numel(figures)
    if ~any(figures(k) == testCase.TestData.originalFigures)
        delete(figures(k));
    end
end
clear window_builder_control_panel window_builder_prototype
end

function testControlPanelCreatesReusesAndReopensFigure(testCase)
first = window_builder_control_panel();
testCase.assertTrue(isgraphics(first, 'figure'));
testCase.verifyEqual(window_builder_control_panel(), first);
delete(first);
reopened = window_builder_control_panel();
testCase.verifyTrue(isgraphics(reopened, 'figure'));
end

function testPrototypeCreatesReusesAndReopensFigure(testCase)
testCase.verifyEqual(nargin('window_builder_prototype'), 0);
first = window_builder_prototype();
testCase.assertTrue(isgraphics(first, 'figure'));
testCase.verifyEqual(window_builder_prototype(), first);
delete(first);
reopened = window_builder_prototype();
testCase.verifyTrue(isgraphics(reopened, 'figure'));
end

function testWrapperReturnsSeparateViewerAndPanel(testCase)
handles = sz_3d_image_viewer();
testCase.verifyTrue(isstruct(handles.Viewer));
testCase.verifyTrue(isgraphics(handles.Viewer.Objects.Figure, 'figure'));
testCase.verifyTrue(isgraphics(handles.ControlPanel, 'figure'));
testCase.verifyNotEqual(handles.Viewer.Objects.Figure, handles.ControlPanel);
testCase.verifyEqual(window_builder_control_panel(), handles.ControlPanel);
end
