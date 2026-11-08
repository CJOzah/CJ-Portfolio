<p align="center"><img src="images/brand/logo.png" width="96" alt="CJ logo"></p>

# CJ's Portfolio

Personal portfolio of **Canaan Ozah (CJ)**, Senior Flutter Developer. Built with Flutter web.

## Run

```bash
flutter pub get
flutter run -d chrome
```

Without a snapshot, local runs fetch your **public** repos live.

## Projects from GitHub (incl. organizations)

`tool/build_projects.dart` lists your own, org, collaborator and invited repos, keeps real apps
(README with a screenshot; no forks/archived/profile/portfolio), downloads screenshots and writes
`web/projects.json` + `web/projects/` (gitignored). The site reads that file, so no token ever ships.

```bash
export PORTFOLIO_GITHUB_TOKEN=ghp_xxx   # classic PAT: repo + read:org
dart run tool/build_projects.dart
flutter run -d chrome
```

README conventions the parser reads: `## Title`, `## Overview`, `## Images` (first URL), `## Link`
(Google Play URL). A repo named *eventpadi* with several `# App` sections becomes one card per app.

## Deploy (GitHub Pages)

`.github/workflows/deploy.yml` snapshots, tests, builds and deploys on every push, daily, and on demand.
One-time setup:

1. Settings → Pages → Source: **GitHub Actions**.
2. Settings → Secrets and variables → Actions → new secret `PORTFOLIO_GITHUB_TOKEN`.
3. If an org restricts classic tokens, approve it under that org's Settings → Personal access tokens.

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
  sections/                 hero, about, experience, services, projects, contact
  widgets/                  brand_logo, effects, backdrop, command_palette (⌘K), common
  theme/app_theme.dart      brand palette, light/dark themes
  github/                   fetcher (pure Dart), Project model, ProjectsStore
tool/build_projects.dart    GitHub → web/projects.json snapshot
.github/workflows/          build + deploy to GitHub Pages
images/brand/               logo.svg, logo-maskable.svg, logo.png
```
