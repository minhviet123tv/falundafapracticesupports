# Hướng dẫn sửa lỗi cài đặt ứng dụng Android

## Lỗi: ERROR_INSTALL_NOT_ALLOWED (-6)

Lỗi này xảy ra khi thiết bị Android không cho phép cài đặt ứng dụng do các nguyên nhân sau:

### 1. Kiểm tra thiết bị

#### A. Pin thiết bị
- Đảm bảo pin thiết bị > 20%
- Kết nối sạc nếu cần thiết

#### B. Dung lượng ổ đĩa
- Kiểm tra dung lượng trống: Cần ít nhất 500MB
- Xóa cache và file không cần thiết
- Gỡ cài đặt ứng dụng không sử dụng

#### C. Cài đặt bảo mật
1. Vào **Settings > Security**
2. Bật **Unknown sources** hoặc **Install unknown apps**
3. Cho phép cài đặt từ **ADB** hoặc **File Manager**

### 2. Sửa lỗi trong code

#### A. Cập nhật AndroidManifest.xml
```xml
<application
    android:label="Falun Dafa Practice Supports"
    android:name="${applicationName}"
    android:enableOnBackInvokedCallback="true"
    android:usesCleartextTraffic="true"
    android:requestLegacyExternalStorage="true"
    android:icon="@mipmap/ic_launcher">
```

#### B. Cập nhật build.gradle
```gradle
android {
    namespace = "com.example.new_audio"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    defaultConfig {
        applicationId = "com.mvdragon.falundafapracticesupports"
        minSdk = 21  // Tăng minSdk lên 21
        targetSdk = flutter.targetSdkVersion
        versionCode = flutterVersionCode.toInteger()
        versionName = flutterVersionName
    }
}
```

### 3. Lệnh sửa lỗi

#### A. Clean và rebuild
```bash
flutter clean
flutter pub get
flutter build apk --debug
```

#### B. Uninstall và reinstall
```bash
adb uninstall com.mvdragon.falundafapracticesupports
flutter run
```

#### C. Reset ADB
```bash
adb kill-server
adb start-server
```

### 4. Kiểm tra thiết bị

#### A. Liệt kê thiết bị
```bash
flutter devices
adb devices
```

#### B. Kiểm tra thông tin thiết bị
```bash
adb shell getprop ro.product.model
adb shell df
```

### 5. Giải pháp khác

#### A. Sử dụng USB Debugging
1. Bật **Developer options**
2. Bật **USB debugging**
3. Kết nối qua USB

#### B. Sử dụng Wireless Debugging
1. Bật **Wireless debugging**
2. Kết nối qua IP

#### C. Sử dụng Android Studio
1. Mở project trong Android Studio
2. Chọn thiết bị
3. Run app

### 6. Lỗi thường gặp

#### A. Permission denied
- Kiểm tra quyền truy cập
- Chạy với quyền admin

#### B. Device not found
- Kiểm tra kết nối USB
- Cài đặt driver

#### C. Build failed
- Kiểm tra dependencies
- Update Flutter SDK
