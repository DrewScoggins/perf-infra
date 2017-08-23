using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace SoD
{
    class Program
    {
        static void Main(string[] args)
        {
            var deployFile = new StreamWriter(File.Create(@"C:\work\8.18.17Perf\DeploymentSize.csv"));
            var acquireFile = new StreamWriter(File.Create(@"C:\work\8.18.17Perf\AcquireSize.csv"));
            getDeploymentSize(args[0], deployFile);
            getAcquisitionSize(args[0], acquireFile);
        }

        private static void getDeploymentSize(string pathToDotnet, StreamWriter sw)
        {
            string[] newTemplates = new string[] { "console",
                                                "classlib",
                                                "mstest",
                                                "xunit",
                                                "web",
                                                "mvc",
                                                "razor",
                                                "angular",
                                                "react ",
                                                "reactredux",
                                                "webapi",
                                                "nugetconfig",
                                                "webconfig",
                                                "sln",
                                                "page",
                                                "viewimports",
                                                "viewstart"};
            string[] operatingSystems = new string[] { "win10-x64", "win10-x86", "ubuntu.16.10-x64", "rhel.7-x64" };
            foreach (string template in newTemplates)
            {
                foreach (var os in operatingSystems)
                {
                    var sandbox = new DirectoryInfo(Path.Combine(Path.GetTempPath(), Path.GetRandomFileName()));
                    sandbox.Create();
                    ProcessStartInfo dotnetNew = new ProcessStartInfo(pathToDotnet, String.Format("new {0} --output {1}", template, sandbox.FullName));
                    dotnetNew.UseShellExecute = false;
                    ProcessStartInfo dotnetRestore = new ProcessStartInfo(pathToDotnet, String.Format("restore --runtime {0}", os));
                    dotnetRestore.UseShellExecute = false;
                    dotnetRestore.WorkingDirectory = sandbox.FullName;
                    ProcessStartInfo dotnetPublish = new ProcessStartInfo(pathToDotnet, String.Format("publish --runtime {0} --output {1}", os, Path.Combine(sandbox.FullName, "out")));
                    dotnetPublish.WorkingDirectory = sandbox.FullName;
                    dotnetPublish.UseShellExecute = false;
                    Process.Start(dotnetNew).WaitForExit();
                    Thread.Sleep(500);
                    Process.Start(dotnetRestore).WaitForExit();
                    Thread.Sleep(500);
                    Process.Start(dotnetPublish).WaitForExit();
                    Thread.Sleep(500);
                    var output = getFolderSize(new DirectoryInfo(Path.Combine(sandbox.FullName, "out")));
                    sw.WriteLine(String.Format("{0}-{1},{2}", template, os, output));
                    sw.Flush();
                    sandbox.Delete(true);
                }
            }
        }

        private static void getAcquisitionSize(string pathToDotnet, StreamWriter sw)
        {
            string userProfile = Environment.GetEnvironmentVariable("USERPROFILE");
            var fallbackFolder = new DirectoryInfo(Path.Combine(userProfile, ".dotnet", "packages"));
            if (fallbackFolder.Exists)
            {
                fallbackFolder.Delete(true);
                Thread.Sleep(1000);
            }
            ProcessStartInfo dotnet = new ProcessStartInfo(pathToDotnet, "new");
            Process.Start(dotnet).WaitForExit();
            long fallBackFolderSize = getFolderSize(fallbackFolder);
            sw.WriteLine("Fallback Folder," + fallBackFolderSize);
            Dictionary<string, long> dotnetCliFolderSize = new Dictionary<string, long>();
            var dotnetCliFolder = new DirectoryInfo(Path.GetDirectoryName(pathToDotnet));
            foreach (var dir in dotnetCliFolder.EnumerateDirectories())
            {
                dotnetCliFolderSize[dir.FullName.Substring(dir.FullName.LastIndexOf(Path.DirectorySeparatorChar) + 1)] = getFolderSize(dir);
            }
            foreach (var file in dotnetCliFolder.EnumerateFiles())
            {
                dotnetCliFolderSize[Path.GetFileNameWithoutExtension(file.FullName)] = file.Length;
            }
            foreach (var key in dotnetCliFolderSize.Keys)
            {
                sw.WriteLine(String.Join(",", key, dotnetCliFolderSize[key]));
                sw.Flush();
            }
        }

        private static long getFolderSize(DirectoryInfo fallbackFolder)
        {
            if(!fallbackFolder.Exists)
            {
                return 0;
            }
            long folderSize = 0;
            foreach(var dir in fallbackFolder.EnumerateDirectories())
            {
                folderSize += getFolderSize(dir);
            }
            foreach(var file in fallbackFolder.EnumerateFiles())
            {
                folderSize += file.Length;
            }
            return folderSize;
        }
    }
}
