import 'package:flutter/material.dart';
import '../../../clients/data/models/client_model.dart';

class AdvancedFiltersModal extends StatefulWidget {
  final ClientModel? initialClient;
  final DateTime? initialDateDebut;
  final DateTime? initialDateFin;
  final List<ClientModel> clients;
  final Function(ClientModel? client, DateTime? dateDeb, DateTime? dateFin) onApply;

  const AdvancedFiltersModal({
    super.key,
    required this.clients,
    required this.onApply,
    this.initialClient,
    this.initialDateDebut,
    this.initialDateFin,
  });

  @override
  State<AdvancedFiltersModal> createState() => _AdvancedFiltersModalState();
}

class _AdvancedFiltersModalState extends State<AdvancedFiltersModal> {
  ClientModel? _tempClient;
  DateTime? _tempDateDeb;
  DateTime? _tempDateFin;

  @override
  void initState() {
    super.initState();
    _tempClient = widget.initialClient;
    _tempDateDeb = widget.initialDateDebut;
    _tempDateFin = widget.initialDateFin;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filtres',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF1E293B),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _tempClient = null;
                    _tempDateDeb = null;
                    _tempDateFin = null;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Réinitialiser',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Affiner la liste des devis',
            style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 20),
          _buildFilterLabel('Client'),
          DropdownButtonFormField<ClientModel>(
            value: _tempClient,
            hint: const Text('Tous les clients',
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
            isExpanded: true,
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('Tous les clients'),
              ),
              ...widget.clients.map((c) => DropdownMenuItem(
                value: c,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: const Color(0xFF2563EB).withOpacity(0.1),
                      child: Text(
                        c.initials,
                        style: const TextStyle(
                          fontSize: 9,
                          color: Color(0xFF2563EB),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(c.displayName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13)),
                    ),
                  ],
                ),
              )),
            ],
            onChanged: (v) => setState(() => _tempClient = v),
            decoration: _getInputDecoration(),
          ),
          const SizedBox(height: 20),
          _buildFilterLabel('Période'),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _tempDateDeb ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => _tempDateDeb = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13), // Padding horizontal légèrement réduit
                    decoration: _getDateBoxDecoration(_tempDateDeb != null),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 15,
                          color: _tempDateDeb != null ? const Color(0xFF2563EB) : const Color(0xFF94A3B8),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _tempDateDeb != null
                                ? '${_tempDateDeb!.day.toString().padLeft(2, '0')}/${_tempDateDeb!.month.toString().padLeft(2, '0')}/${_tempDateDeb!.year}'
                                : 'Date début',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: _tempDateDeb != null ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                        if (_tempDateDeb != null) ...[
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => setState(() => _tempDateDeb = null),
                            child: const Icon(Icons.close, size: 14, color: Color(0xFF94A3B8)),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Text('→', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
              ),

              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _tempDateFin ?? (_tempDateDeb ?? DateTime.now()),
                      firstDate: _tempDateDeb ?? DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => _tempDateFin = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                    decoration: _getDateBoxDecoration(_tempDateFin != null),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 15,
                          color: _tempDateFin != null ? const Color(0xFF2563EB) : const Color(0xFF94A3B8),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _tempDateFin != null
                                ? '${_tempDateFin!.day.toString().padLeft(2, '0')}/${_tempDateFin!.month.toString().padLeft(2, '0')}/${_tempDateFin!.year}'
                                : 'Date fin',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: _tempDateFin != null ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                        if (_tempDateFin != null) ...[
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => setState(() => _tempDateFin = null),
                            child: const Icon(Icons.close, size: 14, color: Color(0xFF94A3B8)),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onApply(_tempClient, _tempDateDeb, _tempDateFin);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Appliquer les filtres',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8, top: 2),
    child: Text(
      text,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
    ),
  );

  InputDecoration _getInputDecoration() => InputDecoration(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
  );

  BoxDecoration _getDateBoxDecoration(bool isSelected) => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(
      color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
      width: isSelected ? 1.5 : 1,
    ),
  );
}