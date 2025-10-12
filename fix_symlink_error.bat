@echo off
echo Fixing Flutter symlink error on Windows...
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
echo Step 2: Running flutter clean...
flutter clean

echo.
echo Step 3: Getting dependencies...
flutter pub get

echo.
echo Step 4: Running flutter pub deps to verify...
flutter pub deps

echo.
echo Fix completed! You can now run your Flutter app.
pause

