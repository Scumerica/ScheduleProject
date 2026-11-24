# Cuts the circular logo out of the banner and writes it as a Windows icon (PNG-based .ico, 256 and 48 px)
param(
    [string]$Banner = (Join-Path $PSScriptRoot '..\Data\swift-banner.jpg'),
    [string]$Out = (Join-Path $PSScriptRoot 'swift-sync.ico'),
    [int]$X = 810, [int]$Y = 62, [int]$Size = 108
)
Add-Type -AssemblyName System.Drawing

$source = [System.Drawing.Image]::FromFile((Resolve-Path $Banner))
function Get-PngBytes([int]$px) {
    $bmp = New-Object System.Drawing.Bitmap $px, $px
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = 'HighQualityBicubic'
    $g.SmoothingMode = 'AntiAlias'
    $g.Clear([System.Drawing.Color]::Transparent)
    # Round icon: only the circle around the logo is kept
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddEllipse(0, 0, $px, $px)
    $g.SetClip($path)
    $g.DrawImage($source, (New-Object System.Drawing.Rectangle 0, 0, $px, $px), (New-Object System.Drawing.Rectangle $X, $Y, $Size, $Size), 'Pixel')
    $g.Dispose()
    $ms = New-Object System.IO.MemoryStream
    $bmp.Save($ms, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    return ,$ms.ToArray()
}

$images = @((Get-PngBytes 256), (Get-PngBytes 48), (Get-PngBytes 32), (Get-PngBytes 16))
$sizes = @(256, 48, 32, 16)
$fs = [System.IO.File]::Create($Out)
$w = New-Object System.IO.BinaryWriter $fs
$w.Write([UInt16]0); $w.Write([UInt16]1); $w.Write([UInt16]$images.Count)
$offset = 6 + 16 * $images.Count
for ($i = 0; $i -lt $images.Count; $i++) {
    $dim = if ($sizes[$i] -ge 256) { 0 } else { $sizes[$i] }
    $w.Write([byte]$dim); $w.Write([byte]$dim); $w.Write([byte]0); $w.Write([byte]0)
    $w.Write([UInt16]1); $w.Write([UInt16]32)
    $w.Write([UInt32]$images[$i].Length); $w.Write([UInt32]$offset)
    $offset += $images[$i].Length
}
foreach ($img in $images) { $w.Write($img) }
$w.Close()
$source.Dispose()

# A PNG preview of the largest size, to check the crop
[System.IO.File]::WriteAllBytes((Join-Path $PSScriptRoot 'icon-preview.png'), $images[0])
"wrote $Out"
