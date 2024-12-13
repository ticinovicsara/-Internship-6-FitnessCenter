
--1.
SELECT 
    c.name, 
    c.Surname, 
    CASE 
        WHEN c.Sex = 'Male' THEN 'Male'
        ElSE 'Female'
    END AS Sex, 
    c.Name AS Country, 
    co.AveragePay 
FROM Coaches c
JOIN Countries co ON c.CountryID = co.CountryID;


--2.
SELECT 
    a.Title AS Activity, 
    s.Appointment, 
    c.Name AS Name, 
    c.Surname AS Surname
FROM ActivitySchedules s
JOIN Activities a ON s.ActivityID = a.ActivityID
JOIN CoachActivities ca ON s.ScheduleID = ca.ScheduleID AND ca.CoachType = 'head'
JOIN Coaches c ON ca.CoachID = c.CoachID
ORDER BY s.Appointment, a.Title;


--3.
SELECT 
    fc.Name AS FitnessCenter, 
    COUNT(s.ScheduleID) AS ActivityCount
FROM FitnessCenters fc
JOIN ActivitySchedules s ON fc.fitnesscenterid = s.fitnesscenterid
GROUP BY fc.Name
ORDER BY ActivityCount DESC
LIMIT 3;


--4.
SELECT 
    c.Name, 
    c.Surname, 
    COUNT(ca.ScheduleID) AS ActivityCount,
    CASE 
        WHEN COUNT(ca.scheduleid) = 0 THEN 'AVAILABLE'
        WHEN COUNT(ca.scheduleid) BETWEEN 1 AND 3 THEN 'ACTIVE'
        ELSE 'FULLY BOOKED'
    END AS Status
FROM Coaches c
JOIN CoachActivities ca ON c.coachid = ca.coachid
GROUP BY c.coachid, c.name, c.surname;


--5.
SELECT 
    m.Name AS MemberName
FROM Members m
JOIN ActivitySchedules s ON m.scheduleid = s.scheduleid
WHERE s.appointment > CURRENT_DATE;


--6.
SELECT DISTINCT 
    c.Name, 
    c.Surname
FROM Coaches c
JOIN CoachActivities ca ON c.CoachID = ca.CoachID
JOIN ActivitySchedules s ON ca.ScheduleID = s.ScheduleID
WHERE s.Appointment BETWEEN '2019-01-01' AND '2022-12-31';


--7.
SELECT 
    co.Name AS Country, 
    a.Type AS ActivityType, 
    ROUND(AVG(members.MemberCount), 2) AS AverageMembers
FROM Countries co
JOIN Coaches c ON co.countryid = c.countryid
JOIN CoachActivities ca ON c.coachid = ca.coachid
JOIN Activityschedules s ON ca.scheduleid = s.scheduleid
JOIN Activities a ON s.activityid = a.activityid
JOIN (
    SELECT 
        scheduleid, 
        COUNT(memberid) AS MemberCount
    FROM Members
    GROUP BY scheduleid
) members ON members.scheduleid = s.scheduleid
GROUP BY co.name, a.type;


--8.
SELECT 
    co.name AS Country, 
    COUNT(m.memberid) AS MemberCount
FROM Members m
JOIN ActivitySchedules s ON m.scheduleid = s.scheduleid
JOIN Activities a ON s.activityid = a.activityid
JOIN CoachActivities ca ON s.scheduleid = ca.scheduleid
JOIN Coaches c ON ca.coachid = c.coachid
JOIN Countries co ON c.countryid = co.countryid
WHERE a.type = 'injury rehabilitation'
GROUP BY co.name
ORDER BY MemberCount DESC
LIMIT 10;


--9.
SELECT 
    s.scheduleid, 
    a.title AS Activity, 
    CASE 
        WHEN s.occupancy THEN 'FULL'
        ELSE 'AVAILABLE'
    END AS OccupancyStatus
FROM ActivitySchedules s
JOIN Activities a ON s.activityid = a.activityid;



--10.
SELECT 
    c.Name, 
    c.Surname, 
    SUM(members.member_count * a.priceperappointment) AS Revenue
FROM Coaches c
JOIN CoachActivities ca ON c.coachid = ca.coachid
JOIN ActivitySchedules s ON ca.scheduleid = s.scheduleid
JOIN Activities a ON a.activityid = s.activityid
JOIN (
    SELECT 
        scheduleid, 
        COUNT(memberid) AS member_count
    FROM Members
    GROUP BY scheduleid
) members ON members.scheduleid = s.scheduleid
GROUP BY c.coachid
ORDER BY revenue DESC
LIMIT 10;
