SELECT COUNT(job_id) AS total,
    EXTRACT(
        MONTH
        from job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York'
    ) AS mois
FROM job_postings_fact
GROUP BY mois
ORDER BY mois DESC;