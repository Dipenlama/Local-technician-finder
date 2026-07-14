import 'package:flutter/material.dart';
import 'package:mistrix/features/admin/domain/entities/admin_client.dart';
import 'package:mistrix/features/admin/domain/entities/admin_service.dart';
import 'package:mistrix/features/technicians/domain/entities/technician.dart';

Future<bool> confirmAdminDelete(BuildContext context, String name) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          icon: Icon(Icons.delete_outline_rounded,
              color: Theme.of(context).colorScheme.error),
          title: const Text('Delete item?'),
          content: Text(
              'This will permanently remove “$name” from the local admin data.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Delete'),
            ),
          ],
        ),
      ) ??
      false;
}

Future<AdminService?> showServiceEditor(
  BuildContext context, {
  AdminService? service,
}) {
  return showDialog<AdminService>(
    context: context,
    builder: (context) => _ServiceEditor(service: service),
  );
}

Future<Technician?> showTechnicianEditor(
  BuildContext context, {
  Technician? technician,
}) {
  return showDialog<Technician>(
    context: context,
    builder: (context) => _TechnicianEditor(technician: technician),
  );
}

Future<AdminClient?> showClientEditor(
  BuildContext context, {
  AdminClient? client,
}) {
  return showDialog<AdminClient>(
    context: context,
    builder: (context) => _ClientEditor(client: client),
  );
}

class _ServiceEditor extends StatefulWidget {
  const _ServiceEditor({this.service});

  final AdminService? service;

  @override
  State<_ServiceEditor> createState() => _ServiceEditorState();
}

class _ServiceEditorState extends State<_ServiceEditor> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _description;
  late final TextEditingController _price;
  late bool _active;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.service?.name ?? '');
    _description =
        TextEditingController(text: widget.service?.description ?? '');
    _price = TextEditingController(
      text: widget.service == null
          ? ''
          : widget.service!.basePrice.toStringAsFixed(0),
    );
    _active = widget.service?.isActive ?? true;
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.service == null ? 'Add service' : 'Edit service'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Service name'),
                validator: _required,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _description,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: _required,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _price,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Starting price',
                  prefixText: 'Rs. ',
                ),
                validator: (value) {
                  if (double.tryParse(value ?? '') == null) {
                    return 'Enter a valid price';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Active service'),
                value: _active,
                onChanged: (value) => setState(() => _active = value),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: Navigator.of(context).pop, child: const Text('Cancel')),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      AdminService(
        id: widget.service?.id ??
            'service-${DateTime.now().microsecondsSinceEpoch}',
        name: _name.text.trim(),
        description: _description.text.trim(),
        basePrice: double.parse(_price.text),
        isActive: _active,
      ),
    );
  }
}

class _TechnicianEditor extends StatefulWidget {
  const _TechnicianEditor({this.technician});

  final Technician? technician;

  @override
  State<_TechnicianEditor> createState() => _TechnicianEditorState();
}

class _TechnicianEditorState extends State<_TechnicianEditor> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _profession;
  late final TextEditingController _location;
  late final TextEditingController _rating;
  late bool _available;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.technician?.name ?? '');
    _profession =
        TextEditingController(text: widget.technician?.profession ?? '');
    _location = TextEditingController(text: widget.technician?.location ?? '');
    _rating = TextEditingController(
        text: widget.technician?.rating.toString() ?? '5.0');
    _available = widget.technician?.isAvailable ?? true;
  }

  @override
  void dispose() {
    _name.dispose();
    _profession.dispose();
    _location.dispose();
    _rating.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          widget.technician == null ? 'Add technician' : 'Edit technician'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Full name'),
                validator: _required,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _profession,
                decoration: const InputDecoration(labelText: 'Profession'),
                validator: _required,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _location,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: _required,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _rating,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Rating (0-5)'),
                validator: (value) {
                  final rating = double.tryParse(value ?? '');
                  if (rating == null || rating < 0 || rating > 5) {
                    return 'Enter a rating from 0 to 5';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Available for bookings'),
                value: _available,
                onChanged: (value) => setState(() => _available = value),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: Navigator.of(context).pop, child: const Text('Cancel')),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      Technician(
        id: widget.technician?.id ??
            'tech-${DateTime.now().microsecondsSinceEpoch}',
        name: _name.text.trim(),
        profession: _profession.text.trim(),
        location: _location.text.trim(),
        rating: double.parse(_rating.text),
        reviewCount: widget.technician?.reviewCount ?? 0,
        isAvailable: _available,
      ),
    );
  }
}

class _ClientEditor extends StatefulWidget {
  const _ClientEditor({this.client});

  final AdminClient? client;

  @override
  State<_ClientEditor> createState() => _ClientEditorState();
}

class _ClientEditorState extends State<_ClientEditor> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late bool _active;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.client?.name ?? '');
    _email = TextEditingController(text: widget.client?.email ?? '');
    _phone = TextEditingController(text: widget.client?.phone ?? '');
    _active = widget.client?.isActive ?? true;
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.client == null ? 'Add client' : 'Edit client'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Full name'),
                validator: _required,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email address'),
                validator: (value) => value == null || !value.contains('@')
                    ? 'Enter a valid email'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone number'),
                validator: (value) => value == null || value.trim().length < 8
                    ? 'Enter a valid phone number'
                    : null,
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Active client'),
                value: _active,
                onChanged: (value) => setState(() => _active = value),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: Navigator.of(context).pop, child: const Text('Cancel')),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      AdminClient(
        id: widget.client?.id ??
            'client-${DateTime.now().microsecondsSinceEpoch}',
        name: _name.text.trim(),
        email: _email.text.trim().toLowerCase(),
        phone: _phone.text.trim(),
        isActive: _active,
        joinedAt: widget.client?.joinedAt ?? DateTime.now(),
      ),
    );
  }
}

String? _required(String? value) {
  if (value == null || value.trim().isEmpty) return 'This field is required';
  return null;
}
