-- ============================================================================
-- DEMO FIELDS SCRIPT - Complete Reset and Populate
-- ============================================================================
-- This script:
-- 1. Deletes all existing fields
-- 2. Creates 12 demo fields (2-3 per sport category)
-- 3. Distributes across 4 cities (Minya, Mallawi, New Minya, Assiut)
-- 4. Assigns to 2 existing admins
-- ============================================================================

DO $$
DECLARE
    admin1_id UUID;
    admin2_id UUID;
    football_category_id UUID;
    basketball_category_id UUID;
    tennis_category_id UUID;
    volleyball_category_id UUID;
    padel_category_id UUID;
    minya_city_id UUID;
    mallawi_city_id UUID;
    new_minya_city_id UUID;
    assiut_city_id UUID;
BEGIN
    -- ========================================================================
    -- STEP 1: DELETE EXISTING FIELDS
    -- ========================================================================
    DELETE FROM fields;
    RAISE NOTICE '✅ Deleted all existing fields';

    -- ========================================================================
    -- STEP 2: FETCH ADMIN IDs
    -- ========================================================================
    SELECT id INTO admin1_id FROM profiles WHERE role = 'admin' LIMIT 1;
    SELECT id INTO admin2_id FROM profiles WHERE role = 'admin' AND id != admin1_id LIMIT 1;

    -- Fallback to any users if no admins found
    IF admin1_id IS NULL THEN 
        SELECT id INTO admin1_id FROM profiles LIMIT 1; 
    END IF;
    IF admin2_id IS NULL THEN 
        SELECT id INTO admin2_id FROM profiles WHERE id != admin1_id LIMIT 1; 
    END IF;

    IF admin1_id IS NULL OR admin2_id IS NULL THEN
        RAISE EXCEPTION 'Could not find 2 distinct users to assign fields to.';
    END IF;

    RAISE NOTICE '✅ Found Admin 1: %', admin1_id;
    RAISE NOTICE '✅ Found Admin 2: %', admin2_id;

    -- ========================================================================
    -- STEP 3: FETCH SPORT CATEGORY IDs
    -- ========================================================================
    SELECT id INTO football_category_id FROM sport_categories WHERE name ILIKE '%Football%' LIMIT 1;
    SELECT id INTO basketball_category_id FROM sport_categories WHERE name ILIKE '%Basketball%' LIMIT 1;
    SELECT id INTO tennis_category_id FROM sport_categories WHERE name ILIKE '%Tennis%' LIMIT 1;
    SELECT id INTO volleyball_category_id FROM sport_categories WHERE name ILIKE '%Volleyball%' LIMIT 1;
    SELECT id INTO padel_category_id FROM sport_categories WHERE name ILIKE '%Padel%' LIMIT 1;

    -- Fallback
    IF football_category_id IS NULL THEN 
        SELECT id INTO football_category_id FROM sport_categories LIMIT 1; 
    END IF;

    RAISE NOTICE '✅ Football Category: %', football_category_id;
    RAISE NOTICE '✅ Basketball Category: %', basketball_category_id;
    RAISE NOTICE '✅ Tennis Category: %', tennis_category_id;
    RAISE NOTICE '✅ Volleyball Category: %', volleyball_category_id;
    RAISE NOTICE '✅ Padel Category: %', padel_category_id;

    -- ========================================================================
    -- STEP 4: FETCH CITY IDs
    -- ========================================================================
    SELECT id INTO minya_city_id FROM cities WHERE name ILIKE '%Minya%' AND name NOT ILIKE '%New%' LIMIT 1;
    SELECT id INTO mallawi_city_id FROM cities WHERE name ILIKE '%Mallawi%' LIMIT 1;
    SELECT id INTO new_minya_city_id FROM cities WHERE name ILIKE '%New Minya%' LIMIT 1;
    SELECT id INTO assiut_city_id FROM cities WHERE name ILIKE '%Assiut%' LIMIT 1;

    -- Fallback
    IF minya_city_id IS NULL THEN 
        SELECT id INTO minya_city_id FROM cities LIMIT 1; 
    END IF;
    IF mallawi_city_id IS NULL THEN 
        SELECT id INTO mallawi_city_id FROM cities WHERE id != minya_city_id LIMIT 1; 
    END IF;
    IF new_minya_city_id IS NULL THEN 
        SELECT id INTO new_minya_city_id FROM cities WHERE id NOT IN (minya_city_id, mallawi_city_id) LIMIT 1; 
    END IF;
    IF assiut_city_id IS NULL THEN 
        SELECT id INTO assiut_city_id FROM cities WHERE id NOT IN (minya_city_id, mallawi_city_id, new_minya_city_id) LIMIT 1; 
    END IF;

    RAISE NOTICE '✅ Minya City: %', minya_city_id;
    RAISE NOTICE '✅ Mallawi City: %', mallawi_city_id;
    RAISE NOTICE '✅ New Minya City: %', new_minya_city_id;
    RAISE NOTICE '✅ Assiut City: %', assiut_city_id;

    -- ========================================================================
    -- STEP 5: INSERT DEMO FIELDS
    -- ========================================================================

    -- FOOTBALL FIELDS (3 fields)
    -- Field 1: Football - Admin 1 - Minya
    INSERT INTO fields (
        owner_id, sport_category_id, name, description, address, city_id,
        latitude, longitude, price_per_hour, currency, surface_type,
        size, images, amenities, is_active, rating, created_at, updated_at
    ) VALUES (
        admin1_id, football_category_id,
        'Minya Stadium Football Field',
        'Professional 11-a-side football pitch with natural grass and floodlights.',
        'Downtown Minya, Minya Governorate',
        minya_city_id,
        28.0871, 30.7618,
        400.00, 'EGP', 'Natural Grass',
        '11-a-side',
        ARRAY['https://images.unsplash.com/photo-1529900748604-07564a03e7a6?q=80&w=1470'],
        ARRAY['Parking', 'Showers', 'Lockers', 'Floodlights'],
        true, 4.8, NOW(), NOW()
    );

    -- Field 2: Football - Admin 2 - Mallawi
    INSERT INTO fields (
        owner_id, sport_category_id, name, description, address, city_id,
        latitude, longitude, price_per_hour, currency, surface_type,
        size, images, amenities, is_active, rating, created_at, updated_at
    ) VALUES (
        admin2_id, football_category_id,
        'Mallawi Sports Complex',
        'Indoor 5-a-side futsal court with air conditioning.',
        'Central Mallawi, Minya Governorate',
        mallawi_city_id,
        28.1167, 30.8333,
        250.00, 'EGP', 'Rubber',
        '5-a-side',
        ARRAY['https://images.unsplash.com/photo-1575361204480-aadea25e6e68?q=80&w=1471'],
        ARRAY['AC', 'Changing Rooms', 'Water Dispenser', 'WiFi'],
        true, 4.6, NOW(), NOW()
    );

    -- Field 3: Football - Admin 1 - New Minya
    INSERT INTO fields (
        owner_id, sport_category_id, name, description, address, city_id,
        latitude, longitude, price_per_hour, currency, surface_type,
        size, images, amenities, is_active, rating, created_at, updated_at
    ) VALUES (
        admin1_id, football_category_id,
        'New Minya Football Arena',
        'Modern 7-a-side pitch with artificial turf.',
        'New Minya City Center',
        new_minya_city_id,
        28.0500, 30.7200,
        300.00, 'EGP', 'Artificial Turf',
        '7-a-side',
        ARRAY['https://images.unsplash.com/photo-1524012431247-53c456965637?q=80&w=1470'],
        ARRAY['Night Lighting', 'Parking', 'Cafe'],
        true, 4.7, NOW(), NOW()
    );

    -- BASKETBALL COURTS (2 fields)
    -- Field 4: Basketball - Admin 2 - Assiut
    INSERT INTO fields (
        owner_id, sport_category_id, name, description, address, city_id,
        latitude, longitude, price_per_hour, currency, surface_type,
        size, images, amenities, is_active, rating, created_at, updated_at
    ) VALUES (
        admin2_id, basketball_category_id,
        'Assiut Basketball Arena',
        'Indoor basketball court with professional flooring.',
        'Assiut Sports City',
        assiut_city_id,
        27.1809, 31.1837,
        350.00, 'EGP', 'Hardwood',
        'Full Court',
        ARRAY['https://images.unsplash.com/photo-1546519638-68e109498ffc?q=80&w=1470'],
        ARRAY['AC', 'Scoreboard', 'Seating', 'Lockers'],
        true, 4.9, NOW(), NOW()
    );

    -- Field 5: Basketball - Admin 1 - Minya
    INSERT INTO fields (
        owner_id, sport_category_id, name, description, address, city_id,
        latitude, longitude, price_per_hour, currency, surface_type,
        size, images, amenities, is_active, rating, created_at, updated_at
    ) VALUES (
        admin1_id, basketball_category_id,
        'Minya Youth Basketball Court',
        'Outdoor basketball court with lighting.',
        'Youth Center, Minya',
        minya_city_id,
        28.0900, 30.7650,
        200.00, 'EGP', 'Concrete',
        'Half Court',
        ARRAY['https://images.unsplash.com/photo-1608245449230-4ac19066d2d0?q=80&w=1470'],
        ARRAY['Night Lighting', 'Water Fountain'],
        true, 4.3, NOW(), NOW()
    );

    -- TENNIS COURTS (2 fields)
    -- Field 6: Tennis - Admin 1 - Mallawi
    INSERT INTO fields (
        owner_id, sport_category_id, name, description, address, city_id,
        latitude, longitude, price_per_hour, currency, surface_type,
        size, images, amenities, is_active, rating, created_at, updated_at
    ) VALUES (
        admin1_id, tennis_category_id,
        'Mallawi Tennis Club',
        'Clay tennis courts maintained to high standards.',
        'Mallawi Sports District',
        mallawi_city_id,
        28.1200, 30.8400,
        220.00, 'EGP', 'Clay',
        'Standard',
        ARRAY['https://images.unsplash.com/photo-1622279457486-62dcc4a431d6?q=80&w=1470'],
        ARRAY['Coach Available', 'Equipment Rental', 'Showers'],
        true, 4.5, NOW(), NOW()
    );

    -- Field 7: Tennis - Admin 2 - New Minya
    INSERT INTO fields (
        owner_id, sport_category_id, name, description, address, city_id,
        latitude, longitude, price_per_hour, currency, surface_type,
        size, images, amenities, is_active, rating, created_at, updated_at
    ) VALUES (
        admin2_id, tennis_category_id,
        'New Minya Tennis Academy',
        'Hard court tennis facility with professional coaching.',
        'New Minya Sports Complex',
        new_minya_city_id,
        28.0550, 30.7250,
        280.00, 'EGP', 'Hard Court',
        'Standard',
        ARRAY['https://images.unsplash.com/photo-1554068865-24cecd4e34b8?q=80&w=800'],
        ARRAY['Pro Shop', 'Ball Machine', 'Parking'],
        true, 4.7, NOW(), NOW()
    );

    -- VOLLEYBALL COURTS (3 fields)
    -- Field 8: Volleyball - Admin 2 - Assiut
    INSERT INTO fields (
        owner_id, sport_category_id, name, description, address, city_id,
        latitude, longitude, price_per_hour, currency, surface_type,
        size, images, amenities, is_active, rating, created_at, updated_at
    ) VALUES (
        admin2_id, volleyball_category_id,
        'Assiut Beach Volleyball',
        'Sand volleyball court with beach vibes.',
        'Assiut Recreation Area',
        assiut_city_id,
        27.1850, 31.1900,
        180.00, 'EGP', 'Sand',
        'Standard',
        ARRAY['https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?q=80&w=1470'],
        ARRAY['Outdoor', 'Showers', 'Cafe'],
        true, 4.4, NOW(), NOW()
    );

    -- Field 9: Volleyball - Admin 1 - Minya
    INSERT INTO fields (
        owner_id, sport_category_id, name, description, address, city_id,
        latitude, longitude, price_per_hour, currency, surface_type,
        size, images, amenities, is_active, rating, created_at, updated_at
    ) VALUES (
        admin1_id, volleyball_category_id,
        'Minya Indoor Volleyball',
        'Indoor volleyball court with professional net.',
        'Minya Sports Hall',
        minya_city_id,
        28.0920, 30.7680,
        240.00, 'EGP', 'Hardwood',
        'Standard',
        ARRAY['https://images.unsplash.com/photo-1593786481097-0d22e4c93a88?q=80&w=1470'],
        ARRAY['AC', 'Seating', 'Lockers'],
        true, 4.6, NOW(), NOW()
    );

    -- Field 10: Volleyball - Admin 2 - Mallawi
    INSERT INTO fields (
        owner_id, sport_category_id, name, description, address, city_id,
        latitude, longitude, price_per_hour, currency, surface_type,
        size, images, amenities, is_active, rating, created_at, updated_at
    ) VALUES (
        admin2_id, volleyball_category_id,
        'Mallawi Community Volleyball',
        'Outdoor volleyball court for community use.',
        'Mallawi Community Center',
        mallawi_city_id,
        28.1180, 30.8350,
        150.00, 'EGP', 'Grass',
        'Standard',
        ARRAY['https://images.unsplash.com/photo-1547347298-4074fc3086f0?q=80&w=1470'],
        ARRAY['Outdoor', 'Free Parking'],
        true, 4.2, NOW(), NOW()
    );

    -- PADEL COURTS (2 fields)
    -- Field 11: Padel - Admin 1 - Assiut
    INSERT INTO fields (
        owner_id, sport_category_id, name, description, address, city_id,
        latitude, longitude, price_per_hour, currency, surface_type,
        size, images, amenities, is_active, rating, created_at, updated_at
    ) VALUES (
        admin1_id, padel_category_id,
        'Assiut Padel Club',
        'Premium padel courts with modern facilities.',
        'Assiut Downtown',
        assiut_city_id,
        27.1820, 31.1860,
        320.00, 'EGP', 'Artificial Turf',
        'Standard',
        ARRAY['https://images.unsplash.com/photo-1624638764471-1493636b2362?q=80&w=1470'],
        ARRAY['Equipment Rental', 'Cafe', 'WiFi', 'Parking'],
        true, 4.8, NOW(), NOW()
    );

    -- Field 12: Padel - Admin 2 - New Minya
    INSERT INTO fields (
        owner_id, sport_category_id, name, description, address, city_id,
        latitude, longitude, price_per_hour, currency, surface_type,
        size, images, amenities, is_active, rating, created_at, updated_at
    ) VALUES (
        admin2_id, padel_category_id,
        'New Minya Padel Arena',
        'State-of-the-art padel facility with glass walls.',
        'New Minya Sports Zone',
        new_minya_city_id,
        28.0520, 30.7230,
        350.00, 'EGP', 'Artificial Turf',
        'Standard',
        ARRAY['https://images.unsplash.com/photo-1622163642998-1ea32b0bbc67?q=80&w=800'],
        ARRAY['Pro Shop', 'Lounge', 'AC', 'Showers'],
        true, 4.9, NOW(), NOW()
    );

    -- ========================================================================
    -- SUCCESS MESSAGE
    -- ========================================================================
    RAISE NOTICE '========================================';
    RAISE NOTICE '✅ DEMO FIELDS CREATED SUCCESSFULLY!';
    RAISE NOTICE '========================================';
    RAISE NOTICE 'Total Fields: 12';
    RAISE NOTICE '';
    RAISE NOTICE 'Distribution by Category:';
    RAISE NOTICE '  ⚽ Football: 3 fields';
    RAISE NOTICE '  🏀 Basketball: 2 fields';
    RAISE NOTICE '  🎾 Tennis: 2 fields';
    RAISE NOTICE '  🏐 Volleyball: 3 fields';
    RAISE NOTICE '  🎾 Padel: 2 fields';
    RAISE NOTICE '';
    RAISE NOTICE 'Distribution by City:';
    RAISE NOTICE '  📍 Minya: 4 fields';
    RAISE NOTICE '  📍 Mallawi: 3 fields';
    RAISE NOTICE '  📍 New Minya: 3 fields';
    RAISE NOTICE '  📍 Assiut: 2 fields';
    RAISE NOTICE '';
    RAISE NOTICE 'Assigned to:';
    RAISE NOTICE '  👤 Admin 1 (%): 6 fields', admin1_id;
    RAISE NOTICE '  👤 Admin 2 (%): 6 fields', admin2_id;
    RAISE NOTICE '========================================';

END $$;
