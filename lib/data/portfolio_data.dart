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
  static const cvAsset = "images/cv.pdf";

  static const roles = [
    "cross-platform Flutter apps.",
    "pixel-perfect interfaces.",
    "scalable app architecture.",
    "products people love.",
  ];

  static const bio =
      "Senior Flutter Developer with 5+ years of experience building cross-platform mobile "
      "applications. I translate Figma designs into polished, high-fidelity interfaces and "
      "collaborate closely with designers and cross-functional teams to ship scalable, "
      "high-quality experiences.";

  static const about =
      "I'm a mobile and web developer with a strong focus on UI/UX, top-notch performance and "
      "clean architecture. I care about the details — smooth motion, accessible layouts and "
      "code that stays easy to change. I learn fast and love new challenges.";
}

class Social {
  final String label;
  final FaIconData icon;
  final String url;
  const Social(this.label, this.icon, this.url);
}

const socials = [
  Social("GitHub", FontAwesomeIcons.github, "https://github.com/${Profile.githubUser}"),
  Social("LinkedIn", FontAwesomeIcons.linkedinIn, "https://linkedin.com/in/canaan-ozah-909399211"),
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

const techStack = [
  "Flutter", "Dart", "Provider", "Clean Architecture", "REST APIs", "Figma",
  "Android", "iOS", "Flutter Web", "Desktop", "Git", "Testing", "CI/CD", "WordPress",
];

Future<void> openLink(String url) async {
  if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
    debugPrint("Could not launch $url");
  }
}
