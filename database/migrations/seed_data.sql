-- Seed 100 hotel bookings

INSERT INTO hotel_bookings (
    id,
    org_id,
    hotel_id,
    city,
    checkin_date,
    checkout_date,
    amount,
    status,
    created_at
)
SELECT
    gen_random_uuid(),

    -- Reuse 5 organizations
    CASE (gs % 5)
        WHEN 0 THEN '11111111-1111-1111-1111-111111111111'::uuid
        WHEN 1 THEN '22222222-2222-2222-2222-222222222222'::uuid
        WHEN 2 THEN '33333333-3333-3333-3333-333333333333'::uuid
        WHEN 3 THEN '44444444-4444-4444-4444-444444444444'::uuid
        ELSE      '55555555-5555-5555-5555-555555555555'::uuid
    END,

    'HOTEL-' || gs,

    (ARRAY[
        'delhi',
        'bangalore',
        'hyderabad',
        'chennai'
    ])[floor(random()*4 + 1)::int],

    CURRENT_DATE + floor(random()*10)::int,

    CURRENT_DATE + floor(random()*10)::int + 2,

    round((random()*10000)::numeric,2),

    (ARRAY[
        'BOOKED',
        'PENDING',
        'CANCELLED',
        'COMPLETED'
    ])[floor(random()*4 + 1)::int],

    NOW() - (floor(random()*30)::text || ' days')::interval

FROM generate_series(1,100) gs;


-- Seed booking events

INSERT INTO booking_events (
    booking_id,
    event_type,
    payload,
    created_at
)
SELECT
    id,
    'BOOKED',
    jsonb_build_object(
        'status', status,
        'city', city,
        'hotel', hotel_id
    ),
    created_at
FROM hotel_bookings
LIMIT 50;
