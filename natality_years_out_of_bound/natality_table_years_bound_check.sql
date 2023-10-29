BEGIN

    DECLARE row_count INT64;

    SET row_count = (
        SELECT
          count(*)
        FROM
          `bigquery-public-data.samples.natality`
        WHERE
          year > extract(year from @run_date)
          OR year < 1969
    );

    IF row_count > 0 THEN
        RAISE USING MESSAGE = '${found_bad_records}';
    END IF;

END;