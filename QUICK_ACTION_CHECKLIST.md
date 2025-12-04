# ⚡ Quick Action Checklist - Sport Kick

**Use this checklist to track immediate actions needed**

---

## 🔴 BEFORE PRODUCTION LAUNCH (Must Complete)

### Day 1: Critical Fixes (7-8 hours)
- [ ] **Update Placeholder URLs** (30 min)
  - Open: `lib/features/settings/presentation/constants/settings_constants.dart`
  - Replace `https://example.com/privacy-policy` with real URL
  - Replace `https://example.com/terms-of-service` with real URL
  - Replace `https://example.com/help` with real URL or `mailto:support@sportkick.com`
  - Test all links work from app

- [ ] **Remove Unused API Client** (30 min)
  - Delete: `lib/core/network/api_client.dart`
  - Remove from DI: `lib/core/di/injection_container.dart`

- [ ] **Hide Coming Soon Features** (2 hours)
  - Comment out reviews section in `lib/features/fields/presentation/pages/field_details_page.dart`
  - Hide business hours button in `lib/features/owner/presentation/pages/owner_settings_page.dart`
  - Remove map view button in `lib/features/home/presentation/widgets/nearby_fields_preview.dart`

- [ ] **Fix Critical Lint Issues** (3-4 hours)
  - Fix unused import: `lib/features/auth/presentation/cubit/auth_cubit.dart:2`
  - Update deprecated Share in: `lib/core/services/csv_export_service.dart`
  - Update deprecated Share in: `lib/core/services/pdf_export_service.dart`
  - Run: `dart fix --apply`

### Day 2: Testing (4-6 hours)
- [ ] **Test Critical User Flows**
  - [ ] User registration and login
  - [ ] Password reset (now working)
  - [ ] Profile editing (now working)
  - [ ] Search fields (verify working)
  - [ ] Apply filters (verify working)
  - [ ] Create booking
  - [ ] View bookings
  - [ ] Cancel booking
  - [ ] All settings links work (privacy, terms, help)

- [ ] **Test Owner Flows**
  - [ ] Owner login
  - [ ] View fields
  - [ ] Manage bookings
  - [ ] Approve/reject bookings
  - [ ] View analytics

- [ ] **Test Super Admin Flows**
  - [ ] Create admin account
  - [ ] Manage users
  - [ ] View statistics
  - [ ] Assign fields to admins

---

## 🟡 WEEK 1 POST-LAUNCH (Optional Improvements)

### High-Value Quick Wins (15-20 hours)

- [ ] **Implement Error Logging** (4-6 hours)
  - Add Firebase Crashlytics
  - Monitor production errors
  - Get notified of crashes

- [ ] **Add Dark Theme** (8-10 hours)
  - Define dark colors
  - Update `app_theme.dart`
  - Test all screens

- [ ] **Basic Unit Tests** (5-8 hours)
  - Test critical use cases
  - Auth use cases
  - Booking use cases

---

## 🟢 MONTH 1-2 (Major Features)

### Reviews & Ratings (20-25 hours)
- [ ] Create database schema
- [ ] Implement domain layer
- [ ] Implement data layer
- [ ] Create UI pages
- [ ] Test functionality

### Business Hours (15-20 hours)
- [ ] Create database schema
- [ ] Implement domain layer
- [ ] Create configuration page
- [ ] Update booking validation

---

## 📊 Progress Tracker

| Phase | Tasks | Estimated Hours | Status |
|-------|-------|----------------|--------|
| **Phase 1: Critical** | 5 | 12-18 | ⬜ Not Started |
| **Phase 2: High Priority** | 5 | 97-130 | ⬜ Not Started |
| **Phase 3: Medium Priority** | 6 | 75-92 | ⬜ Not Started |
| **Phase 4: Low Priority** | 7 | 56-74 | ⬜ Not Started |
| **Phase 5: Future** | 8 | 260-330 | ⬜ Not Started |

**Legend:**
- ⬜ Not Started
- 🟨 In Progress
- ✅ Complete

---

## 🎯 Today's Action Items

**If you have 2 hours:**
1. Update placeholder URLs (30 min)
2. Remove unused API client (30 min)
3. Hide coming soon features (1 hour)

**If you have 4 hours:**
Do above + Fix lint issues (3-4 hours)

**If you have 8 hours:**
Do above + Complete all Phase 1 tasks

---

## 📱 Quick Commands

```bash
# Format code
dart format .

# Fix lint issues
dart fix --apply

# Run analyzer
flutter analyze

# Run tests
flutter test

# Build release
flutter build apk --release
```

---

## 📞 Get Help

For detailed implementation guides, see:
- `IMPLEMENTATION_PHASES_PLAN.md` - Complete phased plan
- `CODE_QUALITY_STANDARDS.md` - Coding standards
- `PROJECT_STATUS.md` - Current status

For questions about Claude Code:
- Run `/help` in Claude Code
- Visit: https://github.com/anthropics/claude-code

---

**Last Updated:** December 1, 2025
