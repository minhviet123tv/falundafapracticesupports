@echo off
echo Fixing Flutter build errors on Windows...
echo.

echo Step 1: Cleaning existing symlinks...
if exist "windows\flutter\ephemeral\.plugin_symlinks" (
    echo Removing existing .plugin_symlinks directory...
    rmdir /s /q "windows\flutter\ephemeral\.plugin_symlinks"
    echo Symlinks directory removed.
) else (
    echo No existing symlinks directory found.
)

echo.
echo Step 2: Cleaning Flutter build cache...
flutter clean

echo.
echo Step 3: Cleaning Gradle cache...
cd android
if exist "build" (
    rmdir /s /q "build"
    echo Android build directory removed.
)
if exist "app\build" (
    rmdir /s /q "app\build"
    echo App build directory removed.
)
cd ..

echo.
echo Step 4: Getting dependencies...
flutter pub get

echo.
echo Step 5: Running flutter doctor to check setup...
flutter doctor

echo.
echo Step 6: Testing build...
flutter build apk --debug

echo.
echo Build fix completed! 
echo If you still encounter issues, try running:
echo   flutter clean
echo   flutter pub get
echo   flutter build apk --debug
pause
