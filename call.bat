@echo off
chcp 65001
setlocal enabledelayedexpansion

:: スクリプトのあるフォルダを基準に設定
set "basedir=%~dp0"
set "inputdir=%basedir%input"
set "outputdir=%basedir%output"

:: ffmpeg.exe のパスを1つ上の階層から設定
set "ffmpegexe=%basedir%..\ffmpeg.exe"

:: input/output フォルダ存在チェック
if not exist "%inputdir%" (
    echo エラー: input フォルダが存在しません。
    goto end
)

if not exist "%outputdir%" (
    echo エラー: output フォルダが存在しません。
    goto end
)

if not exist "%ffmpegexe%" (
    echo エラー: ffmpeg.exe が見つかりません。%ffmpegexe% を確認してください。
    goto end
)

:: output フォルダの中身を全削除
echo output フォルダの削除されたファイル:
for %%F in ("%outputdir%\*") do (
    echo 削除: %%~nxF
)
del /q "%outputdir%\*" >nul 2>&1

:: input フォルダ内のすべてのファイルを処理
set "filefound=false"
for %%F in ("%inputdir%\*.*") do (
    set "filefound=true"
    set "inputfile=%%F"
    set "filename=%%~nF"

    echo.
    echo 処理中: !filename!

    "%ffmpegexe%" -i "!inputfile!" ^
      -map 0:0? -c:v copy "%outputdir%\!filename!_video001.mp4" ^
      -map 0:1? -c:a copy "%outputdir%\!filename!_audio001.m4a" ^
      -map 0:2? -c:a copy "%outputdir%\!filename!_audio002.m4a" ^
      -map 0:3? -c:a copy "%outputdir%\!filename!_audio003.m4a" ^
      -map 0:4? -c:a copy "%outputdir%\!filename!_audio004.m4a"

    echo 完了: !filename! を分離し、output フォルダに保存しました。
)

if /i "%filefound%"=="false" (
    echo エラー: input フォルダにファイルが存在しません。
    goto end
)

echo.
echo すべての処理が完了しました。

:end
pause
endlocal
