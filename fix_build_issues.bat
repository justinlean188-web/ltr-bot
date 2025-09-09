@echo off
REM Fix Build Issues Script
echo 🔧 LTR Converter Bot - Build Issues Fixer
echo =========================================

echo.
echo 📋 This script will help fix common build issues
echo.

echo 🔍 Step 1: Check current buildozer.spec
echo    Looking for common issues...
echo.

REM Check for duplicate orientation
findstr /c:"orientation = portrait" buildozer.spec | find /c /v "" > temp_count.txt
set /p count=<temp_count.txt
del temp_count.txt

if %count% gtr 1 (
    echo ❌ Found duplicate orientation settings
    echo    Fixing by using simplified spec...
    copy buildozer.spec.simple buildozer.spec
    echo ✅ Fixed duplicate orientation issue
) else (
    echo ✅ No duplicate orientation found
)

echo.
echo 🔍 Step 2: Check requirements complexity
echo    Current requirements might be too complex...
echo.

REM Check if requirements line is too long
findstr "requirements = " buildozer.spec > temp_req.txt
for /f %%i in (temp_req.txt) do set req_line=%%i
del temp_req.txt

echo Current requirements: %req_line%
echo.

if "%req_line:~0,200%" neq "%req_line%" (
    echo ❌ Requirements line is very long (might cause issues)
    echo    Consider using simplified requirements
    echo.
    echo 📋 Simplified requirements:
    echo    requirements = python3,kivy,requests,pytelegrambotapi,flask
    echo.
    echo    Would you like to use simplified requirements? (y/n)
    set /p choice=
    if /i "%choice%"=="y" (
        copy buildozer.spec.simple buildozer.spec
        echo ✅ Applied simplified requirements
    )
) else (
    echo ✅ Requirements line looks reasonable
)

echo.
echo 🔍 Step 3: Validate buildozer.spec syntax
echo    Checking for syntax errors...
echo.

python -c "
import configparser
try:
    config = configparser.ConfigParser()
    config.read('buildozer.spec')
    print('✅ buildozer.spec syntax is valid')
except Exception as e:
    print(f'❌ buildozer.spec syntax error: {e}')
    print('   Using simplified spec...')
    import shutil
    shutil.copy('buildozer.spec.simple', 'buildozer.spec')
    print('✅ Applied simplified spec')
"

echo.
echo 🚀 Step 4: Next Steps
echo    Your buildozer.spec has been checked and fixed if needed.
echo.
echo 📋 To continue:
echo    1. Commit the updated buildozer.spec to GitHub
echo    2. Run the GitHub Actions workflow again
echo    3. Check the verbose output for any remaining issues
echo.

echo 📚 For more help, see:
echo    - TROUBLESHOOTING.md
echo    - setup_github_actions.md
echo.

pause
