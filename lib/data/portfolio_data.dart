import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// All editable portfolio content lives here.
class Profile {
  static const name = "Canaan Ozah";
  static const shortName = "CJ Ozah";
  static const tagline = "Senior Flutter Developer";
  static const githubUser = "CJOzah";
  static const email = "bdiamondozah@gmail.com";
  static const phone = "+234-705-652-4189";
  static const whatsapp = "2347056524189";
  static const location = "Warri, Delta State, Nigeria";
  static const cvAsset = "images/Canaan-Ozah-CV.pdf";

  static const roles = [
    "apps used by 50K+ people.",
    "real-time event platforms.",
    "live-tracking delivery systems.",
    "pixel-perfect Flutter UIs.",
  ];

  static const bio =
      "Senior Flutter Developer with 5+ years building scalable, high-performance mobile apps. "
      "I've led cross-functional teams shipping apps to 50K+ users, with deep expertise in "
      "Flutter, Firebase, REST APIs, WebSockets and CI/CD.";

  static const about =
      "From event platforms handling thousands of concurrent attendees to live GPS delivery "
      "systems and US healthcare apps, I architect and ship production apps end to end: "
      "MVVM/clean architecture, real-time features, payments and store releases. I care about "
      "smooth motion, accessible layouts and code that stays easy to change.";
}

class Social {
  final String label;
  final FaIconData icon;
  final String url;
  const Social(this.label, this.icon, this.url);
}

const socials = [
  Social("GitHub", FontAwesomeIcons.github, "https://github.com/${Profile.githubUser}"),
  Social("LinkedIn", FontAwesomeIcons.linkedinIn, "https://www.linkedin.com/in/oghenenyerhovwo-ozah-909399211/"),
  Social("X", FontAwesomeIcons.xTwitter, "https://twitter.com/cjozah"),
  Social("Facebook", FontAwesomeIcons.facebookF, "https://facebook.com/canaan.ozah"),
];

/// Contact channels. `url` null = not clickable.
/// Note: keep Font Awesome icons in const data like this; icons referenced inline in
/// widgets were dropped by the web icon tree-shaker (font_awesome_flutter 11).
class Contact {
  final FaIconData icon;
  final String label, value;
  final String? url;
  const Contact(this.icon, this.label, this.value, [this.url]);
}

const contacts = [
  Contact(FontAwesomeIcons.envelope, "Email", Profile.email, "mailto:${Profile.email}"),
  Contact(FontAwesomeIcons.whatsapp, "Phone / WhatsApp", Profile.phone, "https://wa.me/${Profile.whatsapp}"),
  Contact(FontAwesomeIcons.locationDot, "Based in", Profile.location),
];

class Stat {
  final int value;
  final String suffix;
  final String label;
  const Stat(this.value, this.suffix, this.label);
}

class Service {
  final FaIconData icon;
  final String title;
  final String body;
  const Service(this.icon, this.title, this.body);
}

const services = [
  Service(FontAwesomeIcons.mobileScreen, "Mobile Development",
      "Beautiful, responsive Android and iOS apps tailored to your spec and built to convert visitors into users."),
  Service(FontAwesomeIcons.layerGroup, "Cross-Platform Apps",
      "Production-ready Flutter apps for Android, iOS, web and desktop with shared logic and platform-specific polish."),
  Service(FontAwesomeIcons.penRuler, "Mobile-First Product Design",
      "Intuitive flows, scalable design systems and clean, high-converting interfaces from product goals."),
];

const process = [
  Service(FontAwesomeIcons.compass, "Discovery",
      "User stories, key flows and technical constraints shaped into a clear roadmap."),
  Service(FontAwesomeIcons.sitemap, "Architecture",
      "Clean layers, state management and reusable components for long-term maintainability."),
  Service(FontAwesomeIcons.wandMagicSparkles, "UI/UX Build",
      "Adaptive layouts, polished interactions and accessibility from day one."),
  Service(FontAwesomeIcons.plug, "API & Data",
      "Secure APIs, caching, offline handling and reliable data models."),
  Service(FontAwesomeIcons.rocket, "Test & Release",
      "Tests on core flows, optimized builds and monitored, iterative releases."),
];

const stats = [
  Stat(5, "+", "Years shipping apps"),
  Stat(50, "K+", "Users reached"),
  Stat(10, "+", "Production apps"),
  Stat(4, "", "Platforms"),
];

const techStack = [
  "Flutter", "Dart", "Firebase", "Riverpod", "Bloc", "Provider", "Kotlin", "Swift",
  "WebSockets", "REST APIs", "Google Maps", "Payments", "MVVM", "GitHub Actions",
  "Figma", "Adobe XD", "WordPress", "Python",
];

/// Play Store developer pages for shipped client apps.
const storePages = [
  StoreLink("EventPadi apps", "https://play.google.com/store/apps/developer?id=Membscribe"),
  StoreLink("Dreacot apps", "https://play.google.com/store/apps/developer?id=Dreacot+Digital+Limited"),
];

class StoreLink {
  final String label, url;
  const StoreLink(this.label, this.url);
}

class Role {
  final String company, title, period, location;
  final List<String> highlights;
  final List<String> tags;
  final StoreLink? link;
  const Role(this.company, this.title, this.period, this.location, this.highlights,
      {this.tags = const [], this.link});
}

/// Most recent first (from CV 2026).
const experience = [
  Role("EventPadi", "Lead Mobile Developer", "2023 – Present", "Lagos, Nigeria", [
    "Led a dual-sided event marketplace and an ecosystem of event apps: ASIS, Conference360, Omniverse Summit, Ofala Onitsha.",
    "Built QR ticketing and accreditation with MVVM, synced over REST and shipped via CI/CD.",
    "Launched on Android and iOS with analytics-driven conversion tracking.",
  ], tags: ["Flutter", "Kotlin", "Swift", "QR", "CI/CD"], link: StoreLink("EventPadi apps", "https://play.google.com/store/apps/developer?id=Membscribe")),
  Role("Dreacot Delivery", "Mobile Developer", "Aug 2024 – Jan 2026", "Lagos, Nigeria", [
    "Architected an on-demand delivery system connecting vendors, riders and customers in real time.",
    "Live GPS tracking, dynamic rider assignment and route optimization.",
    "Secure wallet and payment integration; push workflows built for rapid order growth.",
  ], tags: ["Flutter", "Maps", "Payments", "FCM"], link: StoreLink("Dreacot apps", "https://play.google.com/store/apps/developer?id=Dreacot+Digital+Limited")),
  Role("The Omniverse Summit", "Senior Mobile Developer", "Jan – Oct 2025", "Lagos, Nigeria", [
    "QR entry, real-time WebSocket Q&A and live polling for thousands of concurrent attendees.",
    "Ran a 100+ user closed beta: zero live-event downtime.",
    "On-site technical lead shipping real-time hotfixes during the summit.",
  ], tags: ["Swift", "MVVM", "WebSockets"]),
  Role("Conference360", "Lead Mobile Developer", "2023 – 2025", "Lagos, Nigeria", [
    "B2B networking: sponsor discovery and 1-on-1 meeting scheduling.",
    "Secure post-event replays and certificates via WordPress auth + Flutter.",
    "Load-tested interactive exhibition maps on mid-range devices.",
  ], tags: ["Flutter", "MVC", "WordPress"]),
  Role("The Ofala Onitsha App", "Lead Mobile Developer", "2023", "Onitsha, Nigeria", [
    "Custom ticketing and real-time scheduling for 5,000 concurrent festival-goers.",
    "Cut ticket-processing time by 40%; live parade and performance updates.",
  ], tags: ["Dart", "WebSockets"]),
  Role("Autofixr", "Senior Mobile Developer", "2023", "Lagos, Nigeria", [
    "Location-based nearby repair services with the Google Maps API.",
    "Provider directory and bookings with automated push reminders.",
    "Optimized APIs to cut data usage 30% for low-connectivity users.",
  ], tags: ["Flutter", "Google Maps", "FCM"]),
  Role("RTech Diagnostics", "Mobile Developer", "2022", "Texas, USA (remote)", [
    "Architected and shipped 4 Flutter healthcare apps.",
    "35% fewer bug reports after a Provider/Riverpod refactor; 50% faster rollouts.",
    "Android + iOS releases through GitHub Actions CI/CD.",
  ], tags: ["Flutter", "Riverpod", "intl", "CI/CD"]),
  Role("Mothership Africa", "Mobile Developer", "2022", "Lagos, Nigeria", [
    "Built the Mothership Africa app with MVVM and multi-language localization.",
    "Light/dark themes, UX improvements and the Google Play launch.",
  ], tags: ["Flutter", "MVVM", "i18n"]),
  Role("Da-Manager Megadrive Solutions", "Web Designer & Mobile Developer", "2021 – Present", "Warri, Nigeria", [
    "Designed and run the company site on Firebase Hosting (99.9% uptime).",
    "Flutter apps with Firebase Auth, Firestore and WebSockets: +20% retention.",
  ], tags: ["Flutter", "Firebase", "Figma"]),
];

Future<void> openLink(String url) async {
  if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
    debugPrint("Could not launch $url");
  }
}
