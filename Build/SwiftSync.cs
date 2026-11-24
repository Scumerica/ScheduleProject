// SWIFT Sync launcher.
// The app itself (scheduler.html and its banner) is packed inside this program. Each start writes the
// packed files to %LOCALAPPDATA%\SWIFT Sync\app, so the copy that runs is always the one this program
// was built with, then opens it in Microsoft Edge as an app window with a browser profile of its own.
// That profile keeps the app's saved schedule and settings apart from everything else in Edge.
using System;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Windows.Forms;

[assembly: AssemblyTitle("SWIFT Sync")]
[assembly: AssemblyProduct("SWIFT Sync")]
[assembly: AssemblyDescription("Staff scheduling for driver license offices")]
[assembly: AssemblyVersion("1.0.0.0")]
[assembly: AssemblyFileVersion("1.0.0.0")]

static class SwiftSync
{
    static readonly string[] PackedFiles = { "scheduler.html", "swift-banner.jpg" };

    [STAThread]
    static void Main()
    {
        try
        {
            string home = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "SWIFT Sync");
            string appDir = Path.Combine(home, "app");
            string profileDir = Path.Combine(home, "browser-profile");
            Directory.CreateDirectory(appDir);
            Directory.CreateDirectory(profileDir);

            // A ready-made place for saved schedules, to pick under Settings > Storage folder
            Directory.CreateDirectory(Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments), "SWIFT Sync", "Storage"));

            Assembly self = Assembly.GetExecutingAssembly();
            foreach (string name in PackedFiles)
            {
                using (Stream packed = self.GetManifestResourceStream(name))
                using (FileStream file = File.Create(Path.Combine(appDir, name)))
                {
                    packed.CopyTo(file);
                }
            }

            string page = new Uri(Path.Combine(appDir, "scheduler.html")).AbsoluteUri;
            string edge = FindEdge();
            if (edge == null)
            {
                // Without Edge the page opens in the default browser instead
                Process.Start(page);
                return;
            }

            var start = new ProcessStartInfo(edge,
                "--app=\"" + page + "\" --user-data-dir=\"" + profileDir + "\" --no-first-run --no-default-browser-check --start-maximized");
            start.UseShellExecute = false;
            Process.Start(start);
        }
        catch (Exception error)
        {
            MessageBox.Show("SWIFT Sync could not start:\n\n" + error.Message, "SWIFT Sync", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
    }

    static string FindEdge()
    {
        string[] places =
        {
            Environment.GetFolderPath(Environment.SpecialFolder.ProgramFilesX86),
            Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles),
            Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData)
        };
        foreach (string root in places)
        {
            if (string.IsNullOrEmpty(root)) continue;
            string path = Path.Combine(root, "Microsoft", "Edge", "Application", "msedge.exe");
            if (File.Exists(path)) return path;
        }
        return null;
    }
}
