# 定义 Git 仓库 URL 和目标文件夹
$gitUrl = "git@github.com:MaaAssistantArknights/MaaResource.git"
$httpUrl = "https://github.com/MaaAssistantArknights/MaaResource.git"
$MaaResourceDir = "MaaResource"  # 克隆到的临时目录

$drives = Get-PSDrive -PSProvider FileSystem | Select-Object -ExpandProperty Root

foreach ($drive in $drives) {
    Write-Output "在本地查找MAA目录...`n"
    $MaaPath = Get-ChildItem -Recurse -Filter "MAA.exe" -ErrorAction SilentlyContinue -Path $drive |
               Select-Object -First 1 -ExpandProperty DirectoryName

    if ($MaaPath) {
        break
    }
}

if ($MaaPath) {
    # 克隆 Git 仓库到临时目录
    Write-Output "`n加载最新资源... "
    Remove-Item -Path $MaaResourceDir -Recurse -Force -ErrorAction SilentlyContinue
    git clone $gitUrl $MaaResourceDir

    Stop-Process -Name "MAA" -ErrorAction SilentlyContinue
    robocopy $MaaResourceDir $MaaPath /XF .gitignore LICENSE README.md /XD .git /S /NFL /NDL /NJH
    
    $commitInfo = & git -C .\MaaResource\ log origin/main -1 --format="%h %s"
    Write-Output "完成资源更新 $commitInfo"

} else {
    Write-Output "`n没有在本地发现MAA"
    exit
}





