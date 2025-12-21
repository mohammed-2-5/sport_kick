import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium customer selector with search.
///
/// Features:
/// - Search field
/// - Customer list with avatars
/// - Create new customer option
/// - Selected state with checkmark
class PremiumCustomerSelector extends StatefulWidget {
  final List<Customer> customers;
  final String? selectedCustomerId;
  final ValueChanged<String?> onCustomerSelected;
  final VoidCallback onCreateNew;

  const PremiumCustomerSelector({
    super.key,
    required this.customers,
    this.selectedCustomerId,
    required this.onCustomerSelected,
    required this.onCreateNew,
  });

  @override
  State<PremiumCustomerSelector> createState() =>
      _PremiumCustomerSelectorState();
}

class _PremiumCustomerSelectorState extends State<PremiumCustomerSelector> {
  final _searchController = TextEditingController();
  List<Customer> _filteredCustomers = [];

  @override
  void initState() {
    super.initState();
    _filteredCustomers = widget.customers;
    _searchController.addListener(_filterCustomers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCustomers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCustomers = widget.customers.where((customer) {
        return customer.name.toLowerCase().contains(query) ||
            (customer.phone?.toLowerCase().contains(query) ?? false);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search field
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: context.l10n.searchCustomers,
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary.withValues(alpha: 0.6),
              ),
              prefixIcon: const Icon(
                Icons.search,
                size: 20,
                color: AppColors.textSecondary,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Create new customer button
        _CreateNewButton(onTap: widget.onCreateNew),
        const SizedBox(height: 12),
        // Customer list
        Container(
          constraints: const BoxConstraints(maxHeight: 300),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: _filteredCustomers.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final customer = _filteredCustomers[index];
              return _CustomerCard(
                customer: customer,
                isSelected: customer.id == widget.selectedCustomerId,
                onTap: () => widget.onCustomerSelected(customer.id),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Customer data model.
class Customer {
  final String id;
  final String name;
  final String? phone;
  final String? imageUrl;

  const Customer({
    required this.id,
    required this.name,
    this.phone,
    this.imageUrl,
  });

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }
}

/// Create new customer button.
class _CreateNewButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CreateNewButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.accentCyan.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.accentCyan.withValues(alpha: 0.3),
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.add_circle_outline,
              color: AppColors.accentCyan,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              context.l10n.createNewCustomer,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.accentCyan,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual customer card.
class _CustomerCard extends StatelessWidget {
  final Customer customer;
  final bool isSelected;
  final VoidCallback onTap;

  const _CustomerCard({
    required this.customer,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.accentCyan : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.accentCyan.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.accentCyan, AppColors.accentCyanDark],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  customer.initials,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (customer.phone != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      customer.phone!,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textSecondary.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Selected checkmark
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.accentCyan, AppColors.accentCyanDark],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentCyan.withValues(alpha: 0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Icon(Icons.check, size: 14, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}
