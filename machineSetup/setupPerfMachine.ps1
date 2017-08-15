#Set power scheme to high performance
powercfg /S 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg /SETACVALUEINDEX SCHEME_MIN SUB_SLEEP STANDBYIDLE 0
powercfg /SETACVALUEINDEX SCHEME_MIN SUB_VIDEO VIDEOIDLE 0
powercfg /SETACVALUEINDEX SCHEME_MIN SUB_PROCESSOR PERFBOOSTMODE 0
powercfg /SETACVALUEINDEX SCHEME_MIN SUB_PROCESSOR PROCTHROTTLEMAX 100
powercfg /SETACVALUEINDEX SCHEME_MIN SUB_PROCESSOR PROCTHROTTLEMIN 100
powercfg /SETACVALUEINDEX SCHEME_MIN SUB_PROCESSOR SYSCOOLPOL 1  
powercfg /SETACVALUEINDEX SCHEME_MIN SUB_PROCESSOR THROTTLING 0  
#region GIT Install Config
$gitInstallLog = @"
[Setup]
Lang=default
Dir=C:\Program Files\Git
Group=Git
NoIcons=0
SetupType=default
Components=ext,ext\shellhere,ext\guihere,assoc,assoc_sh
Tasks=
PathOption=Cmd
SSHOption=OpenSSH
CRLFOption=CRLFAlways
BashTerminalOption=ConHost
PerformanceTweaksFSCache=Enabled
UseCredentialManager=Enabled
EnableSymlinks=Disabled
"@
#endregion
$gitInstallLog > gitInstallInfo.log
wget https://github.com/git-for-windows/git/releases/download/v2.14.1.windows.1/Git-2.14.1-64-bit.exe -OutFile git-2.14.1.exe
$gitArgList = "/LOADINF=gitInstallInfo.log", "/VERYSILENT"
echo Start-Process -FilePath .\git-2.14.1.exe -ArgumentList $gitArgList -Wait
Start-Process -FilePath .\git-2.14.1.exe -ArgumentList $gitArgList -Wait

wget https://cmake.org/files/v3.7/cmake-3.7.2-win64-x64.msi -OutFile cmake-3.7.2.msi
$cmakeArgList = "/i", "cmake-3.7.2.msi", "/quiet", "/norestart", "ADD_CMAKE_TO_PATH=System"
echo Start-Process -FilePath msiexec -ArgumentList $cmakeArgList -Wait
Start-Process -FilePath msiexec -ArgumentList $cmakeArgList -Wait

wget http://javadl.oracle.com/webapps/download/AutoDL?BundleId=218831_e9e7ea248e2c4826b92b3f075a80e441 -OutFile java.exe
$javaArgList = ,"/s"
echo Start-Process -FilePath java.exe -ArgumentList $javaArgList -Wait
Start-Process -FilePath java.exe -ArgumentList $javaArgList -Wait

wget https://www.python.org/ftp/python/2.7.13/python-2.7.13.msi -OutFile python27.msi
$python27ArgList = "/i", "python27.msi", "/quiet", "/norestart", "ADDLOCAL=DefaultFeature,SharedCRT,Extensions,TclTk,Documentation,Tools,pip_feature,Testsuite,PrependPath"
echo Start-Process -FilePath msiexec -ArgumentList $python27ArgList -Wait
Start-Process -FilePath msiexec -ArgumentList $python27ArgList -Wait

wget https://www.python.org/ftp/python/3.5.3/python-3.5.3.exe -OutFile python35.exe
$python35ArgList = "/quiet", "PrependPath=1", "TargetDir=C:\Python35"
echo Start-Process -FilePath python35.exe -ArgumentList $python35ArgList -Wait
Start-Process -FilePath python35.exe -ArgumentList $python35ArgList -Wait

wget https://benchviewstorage.blob.core.windows.net/public/vs_community.exe -OutFile vs_community.exe
#region VS Admin File
$vsAdminFile = @"
<?xml version="1.0" encoding="utf-8"?>
<AdminDeploymentCustomizations xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="http://schemas.microsoft.com/wix/2011/AdminDeployment">
  <BundleCustomizations TargetDir="C:\Program Files (x86)\Microsoft Visual Studio 14.0" NoCacheOnlyMode="default" NoWeb="default" NoRefresh="default" SuppressRefreshPrompt="default" Feed="default" />
  <SelectableItemCustomizations>
    <SelectableItemCustomization Id="MicroUpdateV3.5" Selected="yes" FriendlyName="Update for Microsoft Visual Studio 2015 (KB3165756)" />
    <SelectableItemCustomization Id="WebToolsV1" Hidden="no" Selected="yes" FriendlyName="Microsoft Web Developer Tools" />
    <SelectableItemCustomization Id="GitForWindowsx64V7" Hidden="no" Selected="yes" FriendlyName="Git for Windows" />
    <SelectableItemCustomization Id="GitForWindowsx86V7" Hidden="no" Selected="yes" FriendlyName="Git for Windows" />
    <SelectableItemCustomization Id="JavaScript_HiddenV12" Selected="yes" FriendlyName="JavaScript Project System for Visual Studio" />
    <SelectableItemCustomization Id="MDDJSDependencyHiddenV1" Selected="yes" FriendlyName="MDDJSDependencyHidden" />
    <SelectableItemCustomization Id="AppInsightsToolsVisualStudioHiddenVSU3RTMV1" Selected="yes" FriendlyName="Developer Analytics Tools v7.0.2" />
    <SelectableItemCustomization Id="Silverlight5_DRTHidden" Selected="yes" FriendlyName="Silverlight5_DRTHidden" />
    <SelectableItemCustomization Id="BlissHidden" Selected="yes" FriendlyName="BlissHidden" />
    <SelectableItemCustomization Id="HelpHidden" Selected="yes" FriendlyName="HelpHidden" />
    <SelectableItemCustomization Id="JavaScript" Selected="yes" FriendlyName="JavascriptHidden" />
    <SelectableItemCustomization Id="NetFX4Hidden" Selected="yes" FriendlyName="NetFX4Hidden" />
    <SelectableItemCustomization Id="NetFX45Hidden" Selected="yes" FriendlyName="NetFX45Hidden" />
    <SelectableItemCustomization Id="NetFX451MTPackHidden" Selected="yes" FriendlyName="NetFX451MTPackHidden" />
    <SelectableItemCustomization Id="NetFX451MTPackCoreHidden" Selected="yes" FriendlyName="NetFX451MTPackCoreHidden" />
    <SelectableItemCustomization Id="NetFX452MTPackHidden" Selected="yes" FriendlyName="NetFX452MTPackHidden" />
    <SelectableItemCustomization Id="NetFX46MTPackHidden" Selected="yes" FriendlyName="NetFX46MTPackHidden" />
    <SelectableItemCustomization Id="PortableDTPHidden" Selected="yes" FriendlyName="PortableDTPHidden" />
    <SelectableItemCustomization Id="PreEmptiveDotfuscatorHidden" Selected="yes" FriendlyName="PreEmptiveDotfuscatorHidden" />
    <SelectableItemCustomization Id="PreEmptiveAnalyticsHidden" Selected="yes" FriendlyName="PreEmptiveAnalyticsHidden" />
    <SelectableItemCustomization Id="ProfilerHidden" Selected="yes" FriendlyName="ProfilerHidden" />
    <SelectableItemCustomization Id="RoslynLanguageServicesHidden" Selected="yes" FriendlyName="RoslynLanguageServicesHidden" />
    <SelectableItemCustomization Id="SDKTools3Hidden" Selected="yes" FriendlyName="SDKTools3Hidden" />
    <SelectableItemCustomization Id="SDKTools4Hidden" Selected="yes" FriendlyName="SDKTools4Hidden" />
    <SelectableItemCustomization Id="WCFDataServicesHidden" Selected="yes" FriendlyName="WCFDataServicesHidden" />
    <SelectableItemCustomization Id="VSUV1PreReqV1" Selected="no" FriendlyName="Visual Studio 2015 Update 1 Prerequisite" />
    <SelectableItemCustomization Id="VSUV3RTMV1" Selected="yes" FriendlyName="Visual Studio 2015 Update 3" />
    <SelectableItemCustomization Id="NativeLanguageSupport_VCV1" Hidden="no" Selected="yes" FriendlyName="Common Tools for Visual C++ 2015" />
    <SelectableItemCustomization Id="NativeLanguageSupport_MFCV1" Hidden="no" Selected="no" FriendlyName="Microsoft Foundation Classes for C++" />
    <SelectableItemCustomization Id="NativeLanguageSupport_XPV1" Hidden="no" Selected="no" FriendlyName="Windows XP Support for C++" />
    <SelectableItemCustomization Id="Win81SDK_HiddenV1" Hidden="no" Selected="no" FriendlyName="Windows 8.1 SDK and Universal CRT SDK" />
    <SelectableItemCustomization Id="FSharpV1" Hidden="no" Selected="no" FriendlyName="Visual F#" />
    <SelectableItemCustomization Id="PythonToolsForVisualStudioV8" Hidden="no" Selected="no" FriendlyName="Python Tools for Visual Studio (January 2017)" />
    <SelectableItemCustomization Id="ClickOnceV1" Hidden="no" Selected="no" FriendlyName="ClickOnce Publishing Tools" />
    <SelectableItemCustomization Id="SQLV1" Hidden="no" Selected="no" FriendlyName="Microsoft SQL Server Data Tools" />
    <SelectableItemCustomization Id="PowerShellToolsV1" Hidden="no" Selected="no" FriendlyName="PowerShell Tools for Visual Studio" />
    <SelectableItemCustomization Id="SilverLight_Developer_KitV1" Hidden="no" Selected="no" FriendlyName="Silverlight Development Kit" />
    <SelectableItemCustomization Id="Windows10_ToolsAndSDKV13" Hidden="no" Selected="no" FriendlyName="Tools (1.4.1) and Windows 10 SDK (10.0.14393)" />
    <SelectableItemCustomization Id="Win10_EmulatorV1" Selected="no" FriendlyName="Emulators for Windows 10 Mobile (10.0.10240)" />
    <SelectableItemCustomization Id="Win10_EmulatorV2" Selected="no" FriendlyName="Emulators for Windows 10 Mobile (10.0.10586)" />
    <SelectableItemCustomization Id="Win10_EmulatorV3" Hidden="no" Selected="no" FriendlyName="Emulators for Windows 10 Mobile (10.0.14393)" />
    <SelectableItemCustomization Id="XamarinVSCoreV7" Hidden="no" Selected="no" FriendlyName="C#/.NET (Xamarin v4.2.1)" />
    <SelectableItemCustomization Id="XamarinPT_V1" Selected="no" FriendlyName="Xamarin Preparation Tool" />
    <SelectableItemCustomization Id="MDDJSCoreV11" Hidden="no" Selected="no" FriendlyName="HTML/JavaScript (Apache Cordova) Update 10" />
    <SelectableItemCustomization Id="AndroidNDK11C_V1" Hidden="no" Selected="no" FriendlyName="Android Native Development Kit (R11C, 32 bits)" />
    <SelectableItemCustomization Id="AndroidNDK11C_32_V1" Hidden="no" Selected="no" FriendlyName="Android Native Development Kit (R11C, 32 bits)" />
    <SelectableItemCustomization Id="AndroidNDK11C_64_V1" Hidden="no" Selected="no" FriendlyName="Android Native Development Kit (R11C, 64 bits)" />
    <SelectableItemCustomization Id="AndroidNDKV1" Hidden="no" Selected="no" FriendlyName="Android Native Development Kit (R10E, 32 bits)" />
    <SelectableItemCustomization Id="AndroidNDK_32_V1" Hidden="no" Selected="no" FriendlyName="Android Native Development Kit (R10E, 32 bits)" />
    <SelectableItemCustomization Id="AndroidNDK_64_V1" Hidden="no" Selected="no" FriendlyName="Android Native Development Kit (R10E, 64 bits)" />
    <SelectableItemCustomization Id="AndroidSDKV1" Hidden="no" Selected="no" FriendlyName="Android SDK" />
    <SelectableItemCustomization Id="AndroidSDK_API1921V1" Hidden="no" Selected="no" FriendlyName="Android SDK Setup (API Level 19 and 21)" />
    <SelectableItemCustomization Id="AndroidSDK_API22V1" Hidden="no" Selected="no" FriendlyName="Android SDK Setup (API Level 22)" />
    <SelectableItemCustomization Id="AndroidSDK_API23V1" Hidden="no" Selected="no" FriendlyName="Android SDK Setup (API Level 23)" />
    <SelectableItemCustomization Id="AntV1" Hidden="no" Selected="no" FriendlyName="Apache Ant (1.9.3)" />
    <SelectableItemCustomization Id="L_MDDCPlusPlus_iOS_V7" Hidden="no" Selected="no" FriendlyName="Visual C++ iOS Development (Update 3)" />
    <SelectableItemCustomization Id="L_MDDCPlusPlus_Android_V7" Hidden="no" Selected="no" FriendlyName="Visual C++ Android Development (Update 3)" />
    <SelectableItemCustomization Id="L_MDDCPlusPlus_ClangC2_V6" Hidden="no" Selected="no" FriendlyName="Clang with Microsoft CodeGen (July 2016)" />
    <SelectableItemCustomization Id="L_IncrediBuild_V1" Selected="no" FriendlyName="IncrediBuild" />
    <SelectableItemCustomization Id="JavaJDKV1" Hidden="no" Selected="no" FriendlyName="Java SE Development Kit (7.0.550.13)" />
    <SelectableItemCustomization Id="Node.jsV1" Hidden="no" Selected="no" FriendlyName="Joyent Node.js" />
    <SelectableItemCustomization Id="VSEmu_AndroidV1.1.622.2" Hidden="no" Selected="no" FriendlyName="Microsoft Visual Studio Emulator for Android (July 2016)" />
    <SelectableItemCustomization Id="WebSocket4NetV1" Hidden="no" Selected="no" FriendlyName="WebSocket4Net" />
    <SelectableItemCustomization Id="ToolsForWin81_WP80_WP81V1" Hidden="no" Selected="no" FriendlyName="Tools and Windows SDKs" />
    <SelectableItemCustomization Id="WindowsPhone81EmulatorsV1" Hidden="no" Selected="no" FriendlyName="Emulators for Windows Phone 8.1" />
    <SelectableItemCustomization Id="GitHubVSV1" Hidden="no" Selected="no" FriendlyName="GitHub Extension for Visual Studio" />
    <SelectableItemCustomization Id="VS_SDK_GroupV5" Hidden="no" Selected="no" FriendlyName="Visual Studio Extensibility Tools Update 3" />
    <SelectableItemCustomization Id="VS_SDK_Breadcrumb_GroupV5" Selected="no" FriendlyName="Visual Studio Extensibility Tools Update 3" />
    <SelectableItemCustomization Id="Win10_VSToolsV13" Hidden="no" Selected="no" FriendlyName="Tools for Universal Windows Apps (1.4.1) and Windows 10 SDK (10.0.14393)" />
    <SelectableItemCustomization Id="Win10SDK_HiddenV1" Hidden="no" Selected="no" FriendlyName="Windows 10 SDK (10.0.10240)" />
    <SelectableItemCustomization Id="Win10SDK_HiddenV2" Selected="no" FriendlyName="Windows 10 SDK (10.0.10586)" />
    <SelectableItemCustomization Id="Win10SDK_HiddenV3" Hidden="no" Selected="no" FriendlyName="Windows 10 SDK (10.0.10586)" />
    <SelectableItemCustomization Id="Win10SDK_HiddenV4" Selected="no" FriendlyName="Windows 10 SDK (10.0.14393)" />
    <SelectableItemCustomization Id="Win10SDK_VisibleV1" Hidden="no" Selected="no" FriendlyName="Windows 10 SDK 10.0.10240" />
    <SelectableItemCustomization Id="UWPPatch_KB3073097_HiddenV3" Selected="no" FriendlyName="KB3073097" />
    <SelectableItemCustomization Id="AppInsightsToolsVSWinExpressHiddenVSU3RTMV1" Selected="no" FriendlyName="Developer Analytics Tools v7.0.2" />
    <SelectableItemCustomization Id="AppInsightsToolsVWDExpressHiddenVSU3RTMV1" Selected="no" FriendlyName="Developer Analytics Tools v7.0.2" />
    <SelectableItemCustomization Id="UWPStartPageV1" Selected="no" FriendlyName="Tools for Universal Windows Apps Getting Started Experience" />
  </SelectableItemCustomizations>
</AdminDeploymentCustomizations>
"@
#endregion
$vsAdminFile | Out-File adminFile.xml -encoding Utf8
$adminFileLoc = (Get-Item -Path ".\" -Verbose).FullName + "\adminFile.xml"
$vsArgList = "/AdminFile", $adminFileLoc , "/Passive", "/NoRestart"
echo Start-Process -FilePath vs_community.exe -ArgumentList $vsArgList -Wait
Start-Process -FilePath vs_community.exe -ArgumentList $vsArgList -Wait
#Add nuget.exe
mkdir C:\Tools
wget https://dist.nuget.org/win-x86-commandline/latest/nuget.exe -OutFile C:\Tools\nuget.exe
#Copy down scripts used for starting up the Jenkins service
$bootStrapCmd = "powershell.exe C:\jenkinsStart\bootstrap-windows.ps1"
$Utf8NoBom = New-Object System.Text.UTF8Encoding $False
[System.IO.File]::WriteAllLines("C:\bootstrap-windows.cmd", $bootStrapCmd, $Utf8NoBom)
$bootStrapPs1 = @"
Set-ExecutionPolicy Unrestricted -force
# Download the main script
`$scriptSrc = "https://ci2.dot.net/userContent/jenkins-windows-startup.ps1"
`$scriptDest = "`$pwd\jenkins-windows-startup.ps1"
Write-Output "Downloading primary script from `$scriptSrc to `$scriptDest"
`$wc = New-Object System.Net.WebClient
`$wc.DownloadFile(`$scriptSrc, `$scriptDest)
Write-Output "Executing script"
# One of the following
& `$scriptDest -secret <machine_token_here>
"@
$secret = Read-Host -Prompt 'Please enter the Jenkins secret of the machine'
$bootStrapPs1 = $bootStrapPs1.Replace("<machine_token_here>",$secret)
mkdir C:\jenkinsStart
$bootStrapPs1 | Out-File C:\jenkinsStart\bootstrap-windows.ps1
mkdir C:\Jenkins
#Setup the scheduled task to start the Jenkins service
$action = New-ScheduledTaskAction -Execute 'C:\bootstrap-windows.cmd'
$trigger = New-ScheduledTaskTrigger -AtLogOn
$settings = New-ScheduledTaskSettingsSet -Priority 4
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Jenkins Startup" -Description "Startup the Jenkins Task" -Settings $settings -Force