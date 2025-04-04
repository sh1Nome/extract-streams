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
    exit /b 1
)

if not exist "%outputdir%" (
    echo エラー: output フォルダが存在しません。
    exit /b 1
)

if not exist "%ffmpegexe%" (
    echo エラー: ffmpeg.exe が見つかりません。%ffmpegexe% を確認してください。
    exit /b 1
)

:: output フォルダの中身を全削除し、削除したファイル名を表示
echo output フォルダの削除されたファイル:
for %%F in ("%outputdir%\*") do (
    echo 削除: %%F
)
del /q "%outputdir%\*" >nul 2>&1

:: input フォルダ内の1件目のファイルを取得
for %%F in ("%inputdir%\*.*") do (
    set "inputfile=%%F"
    set "filename=%%~nF"
    goto :found
)

:found
if not defined inputfile (
    echo エラー: input フォルダにファイルが存在しません。
    exit /b 1
)

:: FFmpegで映像と音声を分離（音声最大4個まで）
"%ffmpegexe%" -i "!inputfile!" ^
  -map 0:0? -c:v copy "%outputdir%\!filename!_video001.mp4" ^
  -map 0:1? -c:a copy "%outputdir%\!filename!_audio001.m4a" ^
  -map 0:2? -c:a copy "%outputdir%\!filename!_audio002.m4a" ^
  -map 0:3? -c:a copy "%outputdir%\!filename!_audio003.m4a" ^
  -map 0:4? -c:a copy "%outputdir%\!filename!_audio004.m4a"

echo.
echo 完了: !filename! を分離し、output フォルダに保存しました。
pause
endlocal
