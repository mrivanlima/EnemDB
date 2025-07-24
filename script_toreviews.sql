UPDATE imp.exam_gabaritos
SET exam_year = substring(file_name FROM '^(\d{4})')::int,
    exam_day = substring(file_name FROM '_(\d+)\.pdf$')::int;