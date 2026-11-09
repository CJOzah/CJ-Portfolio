<p align="center"><img src="images/brand/logo.png" width="96" alt="CJ logo"></p>

# CJ's Portfolio

Personal portfolio of **Canaan Ozah (CJ)**, Senior Flutter Developer. Built with Flutter web.

## Run

```bash
flutter pub get
flutter run -d chrome
```

## Add or update an app

Apps live in the `apps` list in `lib/data/portfolio_data.dart`. Put its icon at `images/apps/<slug>.png` and its
screenshots at `images/apps/<slug>-0.jpg`, `-1.jpg` and so on, then set `shots` to how many there are.
The mock-up cover in Recent apps and the gallery are built from those files.

## Deploy (GitHub Pages)

`.github/workflows/deploy.yml` tests, builds and deploys on every push and on demand.
One-time setup:

1. Settings → Pages → Source: **GitHub Actions**.

## Edit content

All text, links, stats, experience, services and the tech list live in `lib/data/portfolio_data.dart`.
The CV is `images/Canaan-Ozah-CV.pdf`.
Keep Font Awesome icons in const data there: icons referenced inline in widgets get dropped by the
web icon tree-shaker and render as empty boxes.

## Structure

```
lib/
  main.dart                 app + theme wiring
  home_page.dart            nav, scroll-spy, progress bar, intro, footer
  data/portfolio_data.dart  all content
  sections/                 hero, showcase, work, projects, about, experience, services, contact
  widgets/                  brand_logo, effects, dot_field, phone_showcase, code_window, command_palette (⌘K), common
  theme/app_theme.dart      brand palette, light/dark themes
.github/workflows/          build + deploy to GitHub Pages
images/brand/               logo.svg, logo-maskable.svg, logo.png
```
