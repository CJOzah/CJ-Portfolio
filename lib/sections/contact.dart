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
    return Section(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionHeader(
          eyebrow: "Contact",
          title: "Get in touch",
          subtitle: "Open to full-time roles and freelance projects. Your message previews live as you type.",
        ),
        const _ContactForm(),
      ]),
    );
  }
}

class _ContactInfo extends StatelessWidget {
  const _ContactInfo();

  @override
  Widget build(BuildContext context) {
    return Reveal(
      child: Panel(
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

class _InfoTile extends StatefulWidget {
  final Contact contact;
  const _InfoTile(this.contact);

  @override
  State<_InfoTile> createState() => _InfoTileState();
}

class _InfoTileState extends State<_InfoTile> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.contact.value));
    if (!mounted) return;
    setState(() => _copied = true);
    await Future.delayed(const Duration(milliseconds: 1600));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    final contact = widget.contact;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(children: [
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: contact.url == null ? null : () => openLink(contact.url!),
            child: Row(children: [
              IconBadge(contact.icon, size: 48),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(contact.label,
                      style: context.text.labelMedium!
                          .copyWith(color: context.colors.onSurface.withValues(alpha: 0.6))),
                  const SizedBox(height: 2),
                  Text(contact.value, style: context.text.titleSmall!.copyWith(fontWeight: FontWeight.w600)),
                ]),
              ),
            ]),
          ),
        ),
        if (contact.url != null)
          IconButton(
            tooltip: _copied ? "Copied" : "Copy",
            onPressed: _copy,
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, a) => ScaleTransition(scale: a, child: child),
              child: Icon(
                _copied ? Icons.check_rounded : Icons.copy_rounded,
                key: ValueKey(_copied),
                size: 18,
                color: _copied ? const Color(0xFF22A06B) : null,
              ),
            ),
          ),
      ]),
    );
  }
}

/// The exact text sent; fields left empty are omitted.
String contactMessage(String name, String email, String phone, String message) => [
      if (name.trim().isNotEmpty) "Hello, I am ${name.trim()}.",
      if (email.trim().isNotEmpty) "Email: ${email.trim()}",
      if (phone.trim().isNotEmpty) "Phone: ${phone.trim()}",
      if (message.trim().isNotEmpty) message.trim(),
    ].join("\n");

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

  String get _body => contactMessage(_name.text, _email.text, _phone.text, _message.text);

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

    final form = Reveal(
      child: Panel(
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
                PrimaryButton(
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
    final preview = ListenableBuilder(
      listenable: Listenable.merge([_name, _email, _phone, _message]),
      builder: (_, __) => _MessagePreview(_body),
    );
    const info = _ContactInfo();
    if (!context.isDesktop) {
      return Column(children: [form, const SizedBox(height: 24), Reveal(child: preview), const SizedBox(height: 24), info]);
    }
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(flex: 6, child: form),
      const SizedBox(width: 32),
      Expanded(flex: 5, child: Column(children: [Reveal(child: preview), const SizedBox(height: 24), info])),
    ]);
  }
}

/// WhatsApp-style preview showing exactly what will be sent.
class _MessagePreview extends StatelessWidget {
  final String body;
  const _MessagePreview(this.body);

  static const _chat = Color(0xFF0B141A), _bar = Color(0xFF1F2C34), _outgoing = Color(0xFF005C4B);

  @override
  Widget build(BuildContext context) {
    final empty = body.isEmpty;
    return Semantics(
      label: empty ? "Message preview, empty" : "Message preview: $body",
      child: ExcludeSemantics(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: ColoredBox(
            color: _chat,
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Container(
                color: _bar,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(children: [
                  ClipOval(child: Image.asset("images/portrait.jpg", width: 36, height: 36, fit: BoxFit.cover)),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(Profile.name, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                      Text("Preview of your message", style: TextStyle(color: Color(0x99FFFFFF), fontSize: 11.5)),
                    ]),
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 18, 14, 18),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 96),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 180),
                      alignment: Alignment.topRight,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 340),
                        padding: const EdgeInsets.fromLTRB(12, 9, 12, 8),
                        decoration: const BoxDecoration(
                          color: _outgoing,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisSize: MainAxisSize.min, children: [
                          Text(
                            empty ? "Start typing and your message appears here" : body,
                            style: TextStyle(color: empty ? const Color(0x99FFFFFF) : Colors.white, fontSize: 14, height: 1.4),
                          ),
                          const SizedBox(height: 4),
                          const Icon(Icons.done_all_rounded, size: 15, color: Color(0xFF53BDEB)),
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
