@echo off
title ��ʾ���IP
color F9
@echo -
for /f "tokens=2 delims=:" %%i in ('ipconfig^|findstr "Address"') do set ip=%%i
@echo ==================[���IP��ַ��:%ip%]===============
@echo -
@echo -
@echo ==================[���mac��ַ��:]===============
ipconfig /all |findstr "Physical Address"
@echo -
Echo �밴������رմ��ڣ� &pause>NUL 
do echo