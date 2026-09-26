# Lumb

App móvil en Flutter para gestionar **terapias de calor en la zona lumbar**. El nombre viene de *lumbar*.

El usuario indica su nivel de dolor y con qué frecuencia lo siente. Con eso, la app genera un plan de sesiones (temperatura, duración y días de descanso) y controla el dispositivo de terapia por **Bluetooth**. El historial y el progreso quedan guardados en Firebase.

## Funcionalidades

- **Autenticación:** email y contraseña, Google y Facebook, con recuperación de contraseña.
- **Plan de terapia:** se genera según el nivel de dolor (0–4). La temperatura va de 28 °C a 40 °C.
- **Panel de control:** temperatura, temporizador y encendido/apagado del dispositivo.
- **Conexión Bluetooth serial:** con el dispositivo emparejado (por ejemplo, un módulo HC-05).
- **Sesiones:** calendario, estados (pendiente, completada, perdida) y feedback después de cada sesión.
- **Gráficos de progreso** y gestión de dispositivos y perfil.

## Stack

| Área | Tecnología |
|---|---|
| Framework | Flutter (Dart `^3.5.3`) |
| Estado | `flutter_bloc` (BLoC + Cubit) |
| Inyección de dependencias | `get_it` |
| Navegación | `go_router` |
| Backend | Firebase Auth, Cloud Firestore, Storage |
| Hardware | `flutter_bluetooth_serial` + `permission_handler` |
| UI | `fl_chart`, `table_calendar`, `syncfusion_flutter_gauges`, `reactive_forms` |

## Arquitectura

Clean Architecture organizada en capas dentro de `lib/`:

```
lib/
├── config/        # tema, colores, rutas, estilos, animaciones
├── core/          # errores, utilidades, validadores, contrato UseCase
├── domain/        # entidades, interfaces de repositorio, casos de uso
├── data/          # modelos, servicios Firebase, implementaciones de repositorio
├── presentation/  # blocs/cubits, pantallas y widgets
├── inject_dependecies.dart  # registro en get_it
└── main.dart
```

Los datos en Firestore se guardan bajo `Users/{uid}`: el perfil, las sesiones y los dispositivos.

## Cómo arrancar el proyecto

### Requisitos

- Flutter SDK (stable) con Dart `>= 3.5.3`. Compruébalo con `flutter doctor`.
- Android Studio o Xcode, según la plataforma.
- Un proyecto de Firebase y la [FlutterFire CLI](https://firebase.google.com/docs/flutter/setup).
- **Android real** para probar el Bluetooth. `flutter_bluetooth_serial` solo funciona en Android, y el mínimo es SDK 23.

### 1. Clonar e instalar dependencias

```bash
git clone https://github.com/cesarcunyarache/lumb.git
cd lumb
flutter pub get
```

### 2. Configurar Firebase

Los archivos de configuración de Firebase **no están en el repo**, porque el `.gitignore` los excluye. Genéralos con tu propio proyecto:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Eso crea estos archivos:

- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `macos/Runner/GoogleService-Info.plist`
- `lib/firebase_options.dart`

En la consola de Firebase:

1. Activa **Authentication** con los proveedores Email/Password, Google y Facebook.
2. Crea una base de datos de **Cloud Firestore** y un bucket de **Storage**.
3. Para Google Sign-In en Android, registra el SHA-1 de tu keystore de debug:
   ```bash
   cd android && ./gradlew signingReport
   ```
4. Para Facebook Login, configura el App ID y el Client Token de tu app de Meta en Android e iOS. Sigue la guía de [`flutter_facebook_auth`](https://facebook.meedu.app/).

### 3. Ejecutar

```bash
flutter devices   # lista los dispositivos disponibles
flutter run       # arranca la app en el dispositivo conectado
```

En iOS, instala primero los pods:

```bash
cd ios && pod install && cd ..
```

### Comandos útiles

```bash
flutter analyze            # linter (flutter_lints)
flutter build apk --release
```

## Dispositivo Bluetooth

1. Empareja el dispositivo desde los ajustes de Bluetooth de Android.
2. Abre la sección Bluetooth de la app y selecciónalo.

La app pide los permisos de Bluetooth y ubicación al iniciar. La comunicación es por **Bluetooth clásico (SPP)** y los comandos se envían como texto ASCII.

## Notas

- La app usa el idioma y los formatos de fecha en español (`es_PE`).
- Nunca subas al repo los archivos de Firebase ni los keystores (`*.jks`, `key.properties`).
