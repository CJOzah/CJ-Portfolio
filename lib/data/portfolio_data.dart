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
  static const location = "Port Harcourt, Rivers State, Nigeria";
  static const cvAsset = "images/Canaan-Ozah-CV.pdf";

  static const bio =
      "Five years shipping Flutter apps for live events, last-mile delivery and US healthcare, "
      "used by more than 50,000 people. I lead mobile teams from first spec to store release.";

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
  final String title;
  final String body;
  const Service(this.title, this.body);
}

const services = [
  Service("Mobile Development",
      "Beautiful, responsive Android and iOS apps tailored to your spec and built to convert visitors into users."),
  Service("Cross-Platform Apps",
      "Production-ready Flutter apps for Android, iOS, web and desktop with shared logic and platform-specific polish."),
  Service("Mobile-First Product Design",
      "Intuitive flows, scalable design systems and clean, high-converting interfaces from product goals."),
];

const process = [
  Service("Discovery",
      "User stories, key flows and technical constraints shaped into a clear roadmap."),
  Service("Architecture",
      "Clean layers, state management and reusable components for long-term maintainability."),
  Service("UI/UX Build",
      "Adaptive layouts, polished interactions and accessibility from day one."),
  Service("API & Data",
      "Secure APIs, caching, offline handling and reliable data models."),
  Service("Test & Release",
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

  /// Set both to feature the role in Selected work.
  final String? field, impact;

  /// Start and end as fractional years for the career timeline; no [to] means current.
  final double from;
  final double? to;
  const Role(this.company, this.title, this.period, this.location, this.highlights,
      {required this.from, this.to, this.tags = const [], this.link, this.field, this.impact});
}

/// Most recent first (from CV 2026).
const experience = [
  Role("EventPadi", "Lead Mobile Developer", "2023 – Present", "Lagos, Nigeria", [
    "Led a dual-sided event marketplace and an ecosystem of event apps: ASIS, Conference360, Omniverse Summit, Ofala Onitsha.",
    "Built QR ticketing and accreditation with MVVM, synced over REST and shipped via CI/CD.",
    "Launched on Android and iOS with analytics-driven conversion tracking.",
  ], from: 2023, tags: ["Flutter", "Kotlin", "Swift", "MVVM", "QR", "REST APIs", "Figma", "Adobe XD", "CI/CD"], field: "Event marketplace", impact: "5 apps shipped", link: StoreLink("EventPadi apps", "https://play.google.com/store/apps/developer?id=Membscribe")),
  Role("Dreacot Delivery", "Mobile Developer", "Aug 2024 – Jan 2026", "Lagos, Nigeria", [
    "Architected an on-demand delivery system connecting vendors, riders and customers in real time.",
    "Live GPS tracking, dynamic rider assignment and route optimization.",
    "Secure wallet and payment integration; push workflows built for rapid order growth.",
  ], from: 2024.6, to: 2026.05, tags: ["Flutter", "Maps", "Payments", "FCM"], field: "On-demand logistics", impact: "Live GPS dispatch", link: StoreLink("Dreacot apps", "https://play.google.com/store/apps/developer?id=Dreacot+Digital+Limited")),
  Role("The Omniverse Summit", "Senior Mobile Developer", "Jan – Oct 2025", "Lagos, Nigeria", [
    "QR entry, real-time WebSocket Q&A and live polling for thousands of concurrent attendees.",
    "Ran a 100+ user closed beta: zero live-event downtime.",
    "On-site technical lead shipping real-time hotfixes during the summit.",
  ], from: 2025, to: 2025.8, tags: ["Swift", "MVVM", "WebSockets"], field: "Live events", impact: "Zero live downtime"),
  Role("Conference360", "Lead Mobile Developer", "2023 – 2025", "Lagos, Nigeria", [
    "B2B networking: sponsor discovery and 1-on-1 meeting scheduling.",
    "Secure post-event replays and certificates via WordPress auth + Flutter.",
    "Load-tested interactive exhibition maps on mid-range devices.",
  ], from: 2023, to: 2025, tags: ["Flutter", "MVC", "WordPress"]),
  Role("The Ofala Onitsha App", "Lead Mobile Developer", "2023", "Onitsha, Nigeria", [
    "Custom ticketing and real-time scheduling for 5,000 concurrent festival-goers.",
    "Cut ticket-processing time by 40%; live parade and performance updates.",
  ], from: 2023, to: 2024, tags: ["Dart", "WebSockets"], field: "Festival ticketing", impact: "5,000 concurrent users"),
  Role("Autofixr", "Senior Mobile Developer", "2023", "Lagos, Nigeria", [
    "Location-based nearby repair services with the Google Maps API.",
    "Provider directory and bookings with automated push reminders.",
    "Optimized APIs to cut data usage 30% for low-connectivity users.",
  ], from: 2023, to: 2024, tags: ["Flutter", "Google Maps", "FCM"], field: "Auto services", impact: "30% less data used"),
  Role("RTech Diagnostics", "Mobile Developer", "2022", "Texas, USA (remote)", [
    "Architected and shipped 4 Flutter healthcare apps.",
    "35% fewer bug reports after a Provider/Riverpod refactor; 50% faster rollouts.",
    "Android + iOS releases through GitHub Actions CI/CD.",
  ], from: 2022, to: 2023, tags: ["Flutter", "Provider", "Riverpod", "intl", "GitHub Actions"], field: "US healthcare", impact: "4 apps, 35% fewer bugs"),
  Role("Mothership Africa", "Mobile Developer", "2022", "Lagos, Nigeria", [
    "Built the Mothership Africa app with MVVM and multi-language localization.",
    "Light/dark themes, UX improvements and the Google Play launch.",
  ], from: 2022, to: 2023, tags: ["Flutter", "MVVM", "i18n"]),
  Role("Da-Manager Megadrive Solutions", "Web Designer & Mobile Developer", "2021 – Present", "Warri, Nigeria", [
    "Designed and run the company site on Firebase Hosting (99.9% uptime).",
    "Flutter apps with Firebase Auth, Firestore and WebSockets: +20% retention.",
  ], from: 2021, tags: ["Flutter", "Firebase", "Figma"]),
];

/// An app shown in the first-page showcase. Assets live in images/apps/.
class AppPreview {
  final String slug, name, category, blurb;

  /// Group shown as a filter in the Recent apps section.
  final String family;

  /// Background colour of the mock-up cover, as 0xAARRGGBB.
  final int tint;
  final List<String> tags;

  /// Google Play package id; null while the app is unreleased.
  final String? playId;

  /// How many store screenshots exist as images/apps/<slug>-<n>.jpg.
  final int shots;
  const AppPreview(this.slug, this.name, this.category, this.blurb,
      {required this.family, required this.tint, this.tags = const [], this.playId, required this.shots});

  String get icon => "images/apps/$slug.png";
  String shot(int i) => "images/apps/$slug-$i.jpg";
  String? get storeUrl => playId == null ? null : "https://play.google.com/store/apps/details?id=$playId";
}

const apps = [
  AppPreview("eventpadi", "EventPadi", "Event companion",
      "Attendee app for agendas, speakers, networking, live polls, a shop and QR badges, with on-site check-in for staff.",
      family: "EventPadi apps", tint: 0xFF7A18E8, tags: ["Flutter", "WebSockets", "QR"], playId: "com.membscribe.eventspadi", shots: 3),
  AppPreview("studio", "EventPadi Studio", "Event organizer tools",
      "Create events, sell tickets and check in guests, all from your phone.",
      family: "EventPadi apps", tint: 0xFF5B21B6, tags: ["Flutter", "Bloc"], playId: "com.eventpadi.studio", shots: 3),
  AppPreview("omniverse", "Omniverse Summit", "Live events",
      "The official summit app, with QR entry, real-time Q&A and polling for attendees in person or online.",
      family: "EventPadi apps", tint: 0xFF2A2F8F, tags: ["Swift", "MVVM", "WebSockets"], playId: "com.membscribe.omniverse", shots: 3),
  AppPreview("ofala", "The Ofala Onitsha App", "Culture festival",
      "The official digital companion to the Ofala Festival, with ticketing and a real-time schedule.",
      family: "EventPadi apps", tint: 0xFFC9A227, tags: ["Dart", "WebSockets"], playId: "com.eventpadi.ofala", shots: 3),
  AppPreview("nafest", "NAFEST", "National festival",
      "The official app of Nigeria's National Festival of Arts and Culture.",
      family: "EventPadi apps", tint: 0xFF2E7D32, tags: ["Flutter", "White-label"], playId: "com.eventpadi.nafests", shots: 3),
  AppPreview("asis", "Africa Social Impact Summit", "Impact events",
      "Summit app for the Sterling One Foundation's work on sustainable social impact across Africa.",
      family: "EventPadi apps", tint: 0xFFB4532A, tags: ["Flutter", "QR"], playId: "com.eventpadi.asis", shots: 3),
  AppPreview("dreacot_user", "Dreacot", "On-demand delivery",
      "Order food, groceries and deliveries from stores nearby, pay by wallet and follow your rider live.",
      family: "Dreacot apps", tint: 0xFFE8890C, tags: ["Flutter", "Maps", "Payments"], playId: "com.dreacotdigital.dreacotdelivery.user", shots: 3),
  AppPreview("dreacot_rider", "Dreacot: Rider", "Delivery riders",
      "Riders get orders assigned automatically and follow optimized routes with live GPS.",
      family: "Dreacot apps", tint: 0xFFC96F00, tags: ["Flutter", "Maps", "FCM"], playId: "com.dreacotdigital.dreacotdelivery.rider", shots: 3),
  AppPreview("dreacot_partner", "Dreacot: Partner", "Vendors",
      "Vendors receive and manage delivery orders from customers in real time.",
      family: "Dreacot apps", tint: 0xFFA85A00, tags: ["Flutter", "FCM"], playId: "com.dreacotdigital.dreacotdelivery.partner", shots: 3),
  AppPreview("trimmers", "Trimmers", "Salon and membership",
      "Book salon services, shop the Mini Mart, buy memberships and top up a wallet, with card payments through Paystack.",
      family: "Trimmers apps", tint: 0xFFB08D57, tags: ["Flutter", "Payments", "Firebase"], playId: "com.dreacotdigital.trimmers", shots: 3),
  AppPreview("trimmers_staff", "Trimmers: Staff", "Salon operations",
      "The companion app for salon specialists working alongside Trimmers.",
      family: "Trimmers apps", tint: 0xFF3A2F25, tags: ["Flutter", "Firebase"], playId: "com.dreacotdigital.trimmers.staff", shots: 3),
  AppPreview("autofixr", "Autofixr", "Auto services",
      "Find vetted mechanics and workshops near you for repairs, quick servicing and routine car maintenance.",
      family: "Other apps", tint: 0xFF0F6E66, tags: ["Flutter", "Google Maps", "FCM"], playId: "com.autofixrapp.app", shots: 3),
  AppPreview("tec", "TEC Community", "Church community",
      "Community app with forms and surveys, built on the shared white-label shell behind several of these apps.",
      family: "Other apps", tint: 0xFF1F5FA8, tags: ["Flutter", "White-label"], playId: "com.membscribes.tec", shots: 3),
  AppPreview("garm", "Garm Island", "Fashion e-commerce",
      "Menswear store with product discovery, cart, secure checkout, wallet payments and delivery tracking.",
      family: "Other apps", tint: 0xFF1A1A1A, tags: ["Flutter", "Payments", "Firebase"], playId: "com.dreacotdigital.garmisland", shots: 2),
  AppPreview("opms", "Periscope", "Construction projects",
      "OysterBuild's project app, bringing dashboards, project updates and payments together for clients.",
      family: "Other apps", tint: 0xFF4F9EC4, tags: ["Flutter", "Firebase"], playId: "com.membscribe.opms", shots: 3),
  AppPreview("trackpadi", "Trackpadi", "Personal finance",
      "A shared household income and expense tracker for partners, synced in real time.",
      family: "Other apps", tint: 0xFF1E6B4E, tags: ["Flutter", "Bloc", "Supabase"], playId: "com.eventpadi.trackpadi", shots: 3),
  AppPreview("estatepadi", "EstatePadi", "Property management",
      "A private resident portal for estate management: bills, announcements and your leaders in one place.",
      family: "Other apps", tint: 0xFF1F5C46, tags: ["Flutter"], shots: 2),
  AppPreview("applypadi", "ApplyPadi", "Job search",
      "A job-hunting assistant: upload your resume, find jobs that fit and approve each prepared application.",
      family: "Other apps", tint: 0xFF2A7F8E, tags: ["Flutter", "Firebase AI"], shots: 1),
];

List<Role> rolesUsing(String tech) => experience.where((r) => r.tags.contains(tech)).toList();

Future<void> openLink(String url) async {
  if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
    debugPrint("Could not launch $url");
  }
}
