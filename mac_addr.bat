@echo off
title 显示你的IP
color F9
@echo -
for /f "tokens=2 delims=:" %%i in ('ipconfig^|findstr "Address"') do set ip=%%i
@echo ==================[你的IP地址是:%ip%]===============
@echo -
@echo -
@echo ==================[你的mac地址是:]===============
ipconfig /all |findstr "Physical Address"
@echo -
Echo 请按任意键关闭窗口！ &pause>NUL 
do echo