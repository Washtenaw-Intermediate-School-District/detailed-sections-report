SELECT
	teachers.ID AS teacher,
    s.external_expression || '-' || c.course_name || '-(' || s.id || ')' "Class",
    t.abbreviation,
    sch.name
    
FROM SECTIONS s
    LEFT JOIN(
        SELECT
            st.SECTIONID,
            LISTAGG(u.LASTFIRST,'; ') WITHIN GROUP (ORDER BY st.SECTIONID) "ID"
        FROM SECTIONTEACHER st
            INNER JOIN SECTIONS s ON s.ID = st.SECTIONID
            INNER JOIN TERMS t ON t.ID = s.TERMID AND t.SCHOOLID = s.SCHOOLID
            INNER JOIN SCHOOLSTAFF ss ON st.TEACHERID = ss.ID AND s.SCHOOLID = ss.SCHOOLID
            INNER JOIN USERS u ON ss.USERS_DCID = u.DCID
        WHERE t.YEARID = EXTRACT(YEAR FROM SYSDATE) + CASE WHEN EXTRACT(MONTH FROM SYSDATE) >= 8 THEN 1 ELSE 0 END - 1991
        GROUP BY st.SECTIONID
        ) TEACHERS ON TEACHERS.SECTIONID = s.ID
    INNER JOIN TERMS t ON t.ID = s.TERMID AND t.SCHOOLID = s.SCHOOLID
    INNER JOIN SCHOOLSTAFF ss ON s.TEACHER = ss.ID AND s.SCHOOLID = ss.SCHOOLID
    INNER JOIN COURSES c ON s.course_number = c.course_number
    INNER JOIN SCHOOLS sch ON s.schoolid = sch.school_number

WHERE t.YEARID = EXTRACT(YEAR FROM SYSDATE) + CASE WHEN EXTRACT(MONTH FROM SYSDATE) >= 8 THEN 1 ELSE 0 END - 1991

    
ORDER BY t.abbreviation,teachers.ID, s.external_expression || '-' || c.course_name || '-(' || s.id || ')'
