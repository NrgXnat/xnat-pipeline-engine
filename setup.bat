@echo off
rem ---------------------------------------------------------------------------
rem Setup processing for
rem
rem Environment Variable Prequisites
rem
rem   JAVA_HOME       Directory of Java Version
rem
rem
rem $Id: setup.bat,v 1.1 2008/11/13 16:23:07 mohanar Exp $
rem ---------------------------------------------------------------------------

setlocal

rem This looks weird but something causes value of %~dp0 to change later on.
set ORIGIN=%~dp0

if "%1"=="" goto :usage
if "%2"=="" goto :usage
if "%3"=="" goto :usage

:continue

echo SETIING UP PIPELINE UTILITIES

echo Using JAVA_HOME:           %JAVA_HOME%
echo .
echo Verify java version (with 'java -version')
call java -version

set ADMIN_EMAIL=%1
shift
set SMTP_SERVER=%1
shift
set XNAT_URL=%1
shift
set XNAT_SITE_NAME=XNAT

if "%1"=="" goto :setDefaultSiteName

set XNAT_SITE_NAME=%1
shift

if "%1"=="" goto :EXECUTE
set DESTINATION=-Pdestination="%1"
shift

if "%1"=="" goto :EXECUTE

:DoWhileModulePaths

if not "%PATHS%"=="" set PATHS=%PATHS%,
set PATHS=%PATHS%%1
shift
if "%1"=="" goto :BreakOnModulePaths
goto :DoWhileModulePaths

:BreakOnModulePaths
set MODULE_PATHS="-PmodulePaths=%PATHS%"
goto :EXECUTE

:setDefaultSiteName
set XNAT_SITE_NAME=XNAT

:EXECUTE

rem Execute Gradle build

cd %ORIGIN%
gradlew -PadminEmail="%ADMIN_EMAIL%" -PsmtpServer="%SMTP_SERVER%" -PxnatUrl="%XNAT_URL%" -PsiteName="%XNAT_SITE_NAME%" %DESTINATION% %MODULE_PATHS%

goto :END

:USAGE

echo Missing required command line arguments
echo USAGE: setup.bat ^<admin email^> ^<SMTP server^> ^<XNAT url^> [XNAT site name] [destination] [modulePath1 modulePath2 modulePath3... modulePathn]

:END

endlocal

