-- 3.2a: Reproduce 'The rows that vanished'
    -- Get number of rows without 'Spam detected' removal reason
    SELECT COUNT(*) AS returned_rows
    FROM likes
    WHERE removal_reason != 'Spam detected';
    -- Returns 22

    -- Get number of rows with null removal reason
    SELECT COUNT(*) AS omitted_null_rows
    FROM likes
    WHERE removal_reason IS NULL;
    -- Returns 166

    -- Get total row count of likes
    SELECT COUNT(*) AS total_row_count
    FROM likes;
    -- Returns 200. 166 + 22 = 188 != 200, which shows some rows are missing.

    -- Repair to get full count
    SELECT COUNT(*) AS repaired_rows
    FROM likes
    WHERE COALESCE(removal_reason, 'No reason provided') != 'Spam detected'
       OR removal_reason = 'Spam detected';
    -- Returns 200.

-- 3.2b: The alias that doesn't exist yet
    -- Displaying the error by calling alias where I can't
    SELECT
        like_id,
        dwell_ms / 1000.0 AS dwell_seconds
    FROM likes
    WHERE dwell_seconds >= 10;
    -- Error Message: [42703] ERROR: column "dwell_seconds" does not exist

    -- Rewrite using expression repeat
    SELECT
        like_id,
        dwell_ms / 1000.0 AS dwell_seconds
    FROM likes
    WHERE dwell_ms / 1000.0 >= 10;
    -- Returns 137 rows

    -- Rewrite using CTE
    WITH dwell_sec AS (
        SELECT
            like_id,
            dwell_ms / 1000.0 AS dwell_seconds
        FROM likes
    ) SELECT
          like_id,
          dwell_seconds
    FROM dwell_sec
    WHERE dwell_seconds >= 10;
    -- Returns 137 rows