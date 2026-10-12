# FixLens — Flutter Web

Premium smart home repair and diagnosis UI built with Flutter.

## Run locally in VS Code

1. Install Flutter and the Flutter extension in VS Code.
2. Extract the ZIP and open the `fixlens` folder in VS Code.
3. In the VS Code terminal, run these commands once to add Flutter Web support and fetch packages:

   ```powershell
   flutter create --platforms=web .
   flutter pub get
   flutter run -d chrome
   ```

4. To create a production web build:

   ```powershell
   flutter build web --release
   ```

   The website output is in `build/web`.

## GitHub

Create an empty GitHub repository, then run these commands from this project folder:

```powershell
git init
git add .
git commit -m "Build FixLens Flutter web app"
git branch -M main
git remote add origin https://github.com/YOUR-USERNAME/YOUR-REPOSITORY.git
git push -u origin main
```

Replace the URL with your repository URL. If Git says a remote already exists, use `git remote set-url origin YOUR-REPOSITORY-URL`.

## Vercel

1. Sign in to Vercel with GitHub.
2. Click **Add New → Project**, and import the FixLens repository.
3. Keep the Root Directory as `./`.
4. The repository's `vercel.json` sets the build command to `bash ./vercel-build.sh` and output directory to `build/web`.
5. Deploy.

The Vercel build script downloads the stable Flutter SDK and builds Flutter Web. The first build may take several minutes.

## Important project status

- The dashboard, diagnosis suggestion, repair request list, and profile are frontend demo functionality.
- Requests are stored in app memory only and disappear on refresh.
- The diagnosis is a rule-free demo safety suggestion, not an AI model or professional diagnosis.
- Oracle / Java Servlet integration, real authentication, and persistent database storage are not included in this frontend starter. Never connect Flutter directly to Oracle or put database credentials in frontend code. Connect through a backend API.
- Vercel deploys the web build, not an Android APK. Use `flutter build apk --release` separately for Android.
