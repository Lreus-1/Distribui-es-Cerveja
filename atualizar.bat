@echo off
chcp 65001 >nul
title Atualizar painel - Distribuicao Cerveja
cd /d "%~dp0"

echo.
echo ===============================================
echo   ATUALIZAR PAINEL - DISTRIBUICAO CERVEJA
echo ===============================================
echo.

rem 1) Se houver um index.html novo em Downloads, traz para esta pasta
set "BAIXADO=%USERPROFILE%\Downloads\index.html"
if exist "%BAIXADO%" (
    echo Encontrei um index.html em Downloads. Movendo para esta pasta...
    move /Y "%BAIXADO%" "%~dp0index.html" >nul
    echo OK.
) else (
    echo Nenhum index.html novo em Downloads. Usando o que ja esta na pasta.
)
echo.

rem 2) Confere se ha algo para enviar
git add -A
git diff --cached --quiet
if %errorlevel%==0 (
    echo Nada mudou desde o ultimo envio. Nada para publicar.
    goto fim
)

rem 3) Commit com data e hora
for /f "tokens=1-3 delims=/" %%a in ("%date%") do set "HOJE=%%a/%%b/%%c"
set "HORA=%time:~0,5%"
git commit -m "Atualiza dados %HOJE% %HORA%"
echo.

rem 4) Envia para o GitHub (o Vercel republica sozinho)
git push
if errorlevel 1 (
    echo.
    echo *** ERRO no envio. Confira a internet ou o login do GitHub. ***
    goto fim
)

echo.
echo Pronto! Painel enviado. Em 1 ou 2 minutos o Vercel ja mostra a versao nova.

:fim
echo.
pause
