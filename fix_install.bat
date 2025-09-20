@echo off
echo ========================================
echo    Sửa lỗi cài đặt ứng dụng Android
echo ========================================

echo.
echo 1. Cleaning project...
flutter clean

echo.
echo 2. Getting dependencies...
flutter pub get

echo.
echo 3. Checking devices...
flutter devices

echo.
echo 4. Building debug APK...
flutter build apk --debug

echo.
echo 5. Installing app...
flutter install

echo.
echo ========================================
echo    Hoàn thành! Kiểm tra thiết bị.
echo ========================================
pause
