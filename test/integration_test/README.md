# Integration Test Configuration

## Supabase Test Environment

To run integration tests with a real Supabase instance, create a `.env.test` file in the project root with the following variables:

```env
SUPABASE_TEST_URL=your_test_supabase_url
SUPABASE_TEST_ANON_KEY=your_test_anon_key
SUPABASE_TEST_SERVICE_ROLE_KEY=your_test_service_role_key
```

## Test Database Setup

### 1. Create a Test Supabase Project
- Go to https://supabase.com
- Create a new project specifically for testing
- Note the project URL and API keys

### 2. Run Database Migrations
Ensure your test database has the same schema as production:
- Run all migration scripts
- Seed with test data if needed

### 3. Test User Credentials
Create test users with different roles:
- Super Admin: `superadmin@test.com`
- Admin: `admin@test.com`
- Regular User: `user@test.com`

## Running Integration Tests

```bash
# Run all integration tests
flutter test integration_test/

# Run specific integration test
flutter test integration_test/super_admin_flow_test.dart

# Run with coverage
flutter test --coverage integration_test/
```

## Important Notes

⚠️ **Warning**: Integration tests will:
- Create real data in your test database
- Modify existing records
- Delete test data after completion

✅ **Best Practices**:
- Always use a separate test Supabase project
- Never run integration tests against production
- Clean up test data after each test run
- Use unique identifiers for test data

## Test Data Cleanup

Integration tests automatically clean up after themselves, but you can manually clean test data:

```sql
-- Delete all test users (emails ending with @test.com)
DELETE FROM users WHERE email LIKE '%@test.com';

-- Delete all test fields
DELETE FROM fields WHERE name LIKE 'Test Field%';

-- Delete all test bookings
DELETE FROM bookings WHERE created_at > NOW() - INTERVAL '1 hour';
```
