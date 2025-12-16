# Recurring Booking Feature Plan

## Feature Summary
Allow users to reserve a weekly time slot that auto-generates bookings (max 4 weeks ahead) until canceled.

## Final Decisions
| Decision | Value |
|----------|-------|
| Payment | Per-booking (pending until paid & approved) |
| Cancellation | 1 week notice required, full cancel only |
| Pause/Skip | ❌ Not allowed |
| Max Duration | 4 weeks ahead |
| Approval | Admin must approve recurring request |
| Conflict UI | Red "Reserved" badge on blocked slots |

---

## Database Schema

### `recurring_bookings` Table
```sql
CREATE TABLE recurring_bookings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  field_id UUID NOT NULL REFERENCES fields(id) ON DELETE CASCADE,
  
  -- Schedule
  day_of_week INTEGER NOT NULL CHECK (day_of_week BETWEEN 0 AND 6),
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  
  -- Status: pending_approval, active, canceled, rejected
  status TEXT DEFAULT 'pending_approval',
  
  -- Dates
  started_at DATE,
  last_generated_date DATE,
  
  -- Approval
  approved_by UUID REFERENCES profiles(id),
  approved_at TIMESTAMP,
  rejection_reason TEXT,
  
  -- Timestamps
  created_at TIMESTAMP DEFAULT NOW(),
  canceled_at TIMESTAMP,
  
  UNIQUE(field_id, day_of_week, start_time, status) 
    WHERE status IN ('pending_approval', 'active')
);
```

### Modify `bookings` Table
```sql
ALTER TABLE bookings 
ADD COLUMN recurring_booking_id UUID REFERENCES recurring_bookings(id);
```

---

## Booking Flow

```
1. User requests recurring → status: pending_approval
2. Owner approves → status: active, generates 4 pending bookings
3. Each week: booking status = pending (awaiting payment)
4. User pays → payment_status = pending_verification
5. Owner verifies → booking status = confirmed
6. Weekly cron → generates next week's pending booking
```

---

## Implementation Order

1. Database: Create `recurring_bookings` table
2. Database: Add `recurring_booking_id` to `bookings`
3. Backend: RPC functions (create, approve, reject, cancel)
4. Backend: Weekly cron job for booking generation
5. Flutter: Domain layer (entity, repo, use cases)
6. Flutter: Data layer (model, datasource, repo impl)
7. Flutter: User UI (booking toggle, my subscriptions)
8. Flutter: Owner UI (approval requests page)
9. Flutter: Time slot UI (red Reserved badge)
