import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../view_models/notification_view_model.dart';
import '../theme/app_theme.dart';

class NotificationSettingsView extends StatefulWidget {
  const NotificationSettingsView({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsView> createState() =>
      _NotificationSettingsViewState();
}

class _NotificationSettingsViewState extends State<NotificationSettingsView> {
  final TextEditingController _customController =
      TextEditingController(text: '60');

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Consumer<NotificationViewModel>(
            builder: (ctx, vm, _) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: AppTheme.textPrimaryColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                    title: Text(
                      'Напоминания',
                      style: GoogleFonts.outfit(
                        color: AppTheme.textPrimaryColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    centerTitle: true,
                    pinned: true,
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Header card
                          _buildHeaderCard(),
                          const SizedBox(height: 32),

                          // Options label
                          Text(
                            'Напомнить через:',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Preset options
                          ...ReminderOption.values
                              .where((o) => o != ReminderOption.custom)
                              .map((option) => _buildOptionTile(vm, option)),

                          // Custom option
                          _buildCustomTile(vm),
                          const SizedBox(height: 32),

                          // Schedule button
                          _buildScheduleButton(vm),
                          const SizedBox(height: 16),

                          // Status message
                          if (vm.statusMessage != null) ...[
                            _buildStatusCard(vm.statusMessage!,
                                isSuccess: vm.isScheduled),
                            const SizedBox(height: 16),
                          ],

                          // Cancel button (only if scheduled)
                          if (vm.isScheduled)
                            OutlinedButton.icon(
                              onPressed: vm.cancelReminder,
                              icon: const Icon(Icons.cancel_outlined,
                                  color: AppTheme.wrongColor),
                              label: Text(
                                'Отменить напоминание',
                                style: GoogleFonts.outfit(
                                    color: AppTheme.wrongColor),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: AppTheme.wrongColor),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.notifications_active_rounded,
                color: AppTheme.primaryColor, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Поставьте таймер',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Выберите через сколько получить напоминание о прохождении теста',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColor,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(NotificationViewModel vm, ReminderOption option) {
    final isSelected = vm.selectedOption == option;
    return GestureDetector(
      onTap: () => vm.selectOption(option),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.15)
              : AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryColor
                : Colors.white.withOpacity(0.08),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? AppTheme.primaryColor
                  : AppTheme.textSecondaryColor,
            ),
            const SizedBox(width: 16),
            Text(
              option.label,
              style: GoogleFonts.outfit(
                fontSize: 17,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? AppTheme.textPrimaryColor
                    : AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTile(NotificationViewModel vm) {
    final isSelected = vm.selectedOption == ReminderOption.custom;
    return GestureDetector(
      onTap: () => vm.selectOption(ReminderOption.custom),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.15)
              : AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryColor
                : Colors.white.withOpacity(0.08),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? AppTheme.primaryColor
                  : AppTheme.textSecondaryColor,
            ),
            const SizedBox(width: 16),
            Text(
              'Своё время: ',
              style: GoogleFonts.outfit(
                fontSize: 17,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? AppTheme.textPrimaryColor
                    : AppTheme.textSecondaryColor,
              ),
            ),
            // Input field (always visible but editable only when selected)
            Expanded(
              child: TextField(
                controller: _customController,
                enabled: isSelected,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (val) {
                  final mins = int.tryParse(val) ?? 1;
                  vm.setCustomMinutes(mins);
                },
                style: GoogleFonts.outfit(
                  fontSize: 17,
                  color: AppTheme.textPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  suffixText: 'мин.',
                  suffixStyle: GoogleFonts.inter(
                      color: AppTheme.textSecondaryColor, fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: AppTheme.primaryColor.withOpacity(0.4)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: AppTheme.primaryColor),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.08)),
                  ),
                  fillColor: AppTheme.backgroundColor.withOpacity(0.5),
                  filled: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleButton(NotificationViewModel vm) {
    return ElevatedButton.icon(
      onPressed: vm.scheduleReminder,
      icon: const Icon(Icons.alarm_add_rounded),
      label: const Text('Поставить напоминание'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: GoogleFonts.outfit(
            fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildStatusCard(String message, {required bool isSuccess}) {
    final color = isSuccess ? AppTheme.correctColor : AppTheme.wrongColor;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(fontSize: 15, color: color),
      ),
    );
  }
}
