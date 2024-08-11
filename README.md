# Maa 游戏资源更新 pwsh脚本


# 使用

下载脚本`update.ps1`

![alt text](.asset\image.png)

或者
```pwsh
set-executionpolicy remotesigned
pwsh update.ps1
```

可以通过windows任务计划添加每天执行，也可以通过命令插入maa快捷方式来实现每次启动maa前自动更新资源。

此脚本在运行过程中会关闭运行中的maa以避免无法完成资源文件覆盖。

没有配置git与github的远程连接的可以替换脚本代码中 git clone 的部分

maa，伟大无需多言
