# [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# 定义 Git 仓库 URL 和目标文件夹
$gitUrl = "git@github.com:MaaAssistantArknights/MaaResource.git"
$httpUrl = "https://github.com/MaaAssistantArknights/MaaResource.git"

$downloadUrl = $httpUrl

# 可以把maa的路径写在这里,这样就不需要自动寻找了
$MaaPath = ""
$MaaResourceDir = "MaaResource"  # 克隆到的临时目录

$drives = Get-PSDrive -PSProvider FileSystem | Select-Object -ExpandProperty Root

foreach ($drive in $drives) {
    if ($drive -eq "A:\" -or $drive -eq "B:\") {continue}
    if ($MaaPath) {
        Write-Output "找到Maa目录: $MaaPath"
        break
    } # 

    Write-Output "在 $drive 查找MAA目录..."
    $MaaPath = Get-ChildItem -Recurse -Filter "MAA.exe" -ErrorAction SilentlyContinue -Path $drive |
               Select-Object -First 1 -ExpandProperty DirectoryName
}

if ($MaaPath) {
    # 克隆 Git 仓库到临时目录
    Write-Output "加载最新资源... "
    Remove-Item -Path $MaaResourceDir -Recurse -Force -ErrorAction SilentlyContinue
    git clone $downloadUrl $MaaResourceDir

    Stop-Process -Name "MAA" -ErrorAction SilentlyContinue
    robocopy $MaaResourceDir $MaaPath /XF .gitignore LICENSE README.md /XD .git /S /NFL /NDL /NJH
    
    $commitInfo = & git -C .\MaaResource\ log origin/main -1 --format="%h %s"
    Write-Output "完成资源更新 哈希 $commitInfo"

} else {
    Write-Output "没有在本地发现MAA"
    exit
}

pause




