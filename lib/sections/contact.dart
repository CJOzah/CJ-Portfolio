import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/effects.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final desktop = context.isDesktop;
    const info = _ContactInfo();
    const form = _ContactForm();
    return Section(
      child: Column(children: [
        const SectionHeader(
          eyebrow: "Contact",
          title: "Let's build something great",
          subtitle: "Open to full-time roles and freelance projects. Getting in touch is one click away.",
        ),
        desktop
            ? const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(flex: 4, child: info),
                SizedBox(width: 32),
                Expanded(flex: 6, child: form),
              ])
            : const Column(children: [form, SizedBox(height: 24), info]),
      ]),
    );
  }
}

class _ContactInfo extends StatelessWidget {
  const _ContactInfo();

  @override
  Widget build(BuildContext context) {
    return Reveal(
      from: const Offset(-40, 0),
      child: GlassCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          for (final c in contacts) _InfoTile(c),
          const SizedBox(height: 12),
          Text("FIND ME ON",
              style: context.text.labelMedium!.copyWith(
                letterSpacing: 2,
                color: context.colors.onSurface.withValues(alpha: 0.5),
              )),
          const SizedBox(height: 14),
          const SocialRow(),
        ]),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final Contact contact;
  const _InfoTile(this.contact);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: contact.url == null ? null : () => openLink(contact.url!),
          onLongPress: () {
            Clipboard.setData(ClipboardData(text: contact.value));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Copied ${contact.value}")));
          },
          child: Row(children: [
            IconBadge(contact.icon, size: 48),
            const SizedBox(width: 16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(contact.label,
                    style: context.text.labelMedium!
                        .copyWith(color: context.colors.onSurface.withValues(alpha: 0.55))),
                const SizedBox(height: 2),
                Text(contact.value, style: context.text.titleSmall!.copyWith(fontWeight: FontWeight.w600)),
              ]),
            ),
          ]),
        ),
      );
}

class _ContactForm extends StatefulWidget {
  const _ContactForm();
  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _message = TextEditingController();

  @override
  void dispose() {
    for (final c in [_name, _email, _phone, _message]) {
      c.dispose();
    }
    super.dispose();
  }

  String get _body => "Hello, I am ${_name.text.trim()}.\n"
      "Email: ${_email.text.trim()}\n"
      "Phone: ${_phone.text.trim()}\n"
      "Message: ${_message.text.trim()}";

  void _send({required bool whatsapp}) {
    if (!_formKey.currentState!.validate()) return;
    final text = Uri.encodeComponent(_body);
    openLink(whatsapp
        ? "https://wa.me/${Profile.whatsapp}?text=$text"
        : "mailto:${Profile.email}?subject=${Uri.encodeComponent("Portfolio enquiry from ${_name.text.trim()}")}&body=$text");
  }

  String? _required(String? v) => (v == null || v.trim().isEmpty) ? "Required" : null;

  @override
  Widget build(BuildContext context) {
    final twoCol = !context.isMobile;
    final email = TextFormField(
      controller: _email,
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      decoration: const InputDecoration(hintText: "Email address"),
      validator: (v) => EmailValidator.validate(v?.trim() ?? "") ? null : "Enter a valid email",
    );
    final phone = TextFormField(
      controller: _phone,
      keyboardType: TextInputType.phone,
      autofillHints: const [AutofillHints.telephoneNumber],
      decoration: const InputDecoration(hintText: "Phone (optional)"),
    );

    return Reveal(
      from: const Offset(40, 0),
      child: GlassCard(
        child: Form(
          key: _formKey,
          child: AutofillGroup(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Send a message", style: context.text.titleLarge!.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 24),
              TextFormField(
                controller: _name,
                autofillHints: const [AutofillHints.name],
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(hintText: "Full name"),
                validator: _required,
              ),
              const SizedBox(height: 16),
              twoCol
                  ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(child: email),
                      const SizedBox(width: 16),
                      Expanded(child: phone),
                    ])
                  : Column(children: [email, const SizedBox(height: 16), phone]),
              const SizedBox(height: 16),
              TextFormField(
                controller: _message,
                minLines: 5,
                maxLines: 8,
                decoration: const InputDecoration(hintText: "Tell me about your project…"),
                validator: _required,
              ),
              const SizedBox(height: 24),
              Wrap(spacing: 16, runSpacing: 16, children: [
                FireButton(
                  label: "Send via WhatsApp",
                  icon: FaIcon(contacts[1].icon),
                  onPressed: () => _send(whatsapp: true),
                ),
                GhostButton(
                  label: "Send via email",
                  icon: Icons.mail_outline_rounded,
                  onPressed: () => _send(whatsapp: false),
                ),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}
