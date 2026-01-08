--Finding the crime report:
SELECT *
FROM crime_scene_report
WHERE date = 20180115 
AND type = 'murder' 
AND city = 'SQL City';

--Finding the first witness in the person table:
SELECT *
FROM person
WHERE address_street_name = "Northwestern Dr"
ORDER BY address_number DESC
LIMIT 1;

--Finding the second witness in the person table:
SELECT *
FROM person
WHERE address_street_name = "Franklin Ave" AND name LIKE 'Annabel%';

--Getting the interviews by the two witnesses:
SELECT *
FROM interview
WHERE person_id = 14887 OR person_id = 16371;

--Narrowing down suspects after interviews:
SELECT *
FROM get_fit_now_member
WHERE membership_status = "gold"
AND id LIKE "48Z%";

--Investigating the license plate:
SELECT *
FROM drivers_license
WHERE plate_number LIKE '%H42W%';

--Joining drivers license onto person:
SELECT *
FROM drivers_license AS dl
JOIN person AS p ON dl.id = p.license_id
WHERE plate_number LIKE '%H42W%';

--Filtering everything and joining to be 100% sure of suspect
SELECT *
FROM drivers_license AS dl
JOIN person AS p ON dl.id = p.license_id
JOIN get_fit_now_member AS gfnm ON gfnm.person_id = p.id
JOIN get_fit_now_check_in AS ci ON gfnm.id = ci.membership_id
WHERE plate_number LIKE '%H42W%'
	AND gfnm.membership_status = 'gold'
	AND gfnm.id LIKE '48Z%'
	AND ci.check_in_date = 20180109;

--Checking solution:
INSERT INTO solution VALUES (1, 'Jeremy Bowers');
        
        SELECT value FROM solution;

--Checking the interview transcript:
SELECT *
FROM interview
WHERE person_id = 67318;

--Checking drivers_license table with all information we have and joining onto person to get more information on suspects:
SELECT p.*
FROM drivers_license AS dl
JOIN person AS p ON p.license_id = dl.id
WHERE height BETWEEN 65 AND 67
	AND hair_color ='red'
	AND gender = 'female'
	AND car_make = 'Tesla'
	AND car_model = 'Model S';

--Checking events:
SELECT	
	person_id,
	event_name,
	COUNT(*) AS visits
FROM facebook_event_checkin
WHERE event_name = 'SQL Symphony Concert'
AND date BETWEEN 20171201 AND 20171231
GROUP BY person_id, event_name
HAVING COUNT(event_id)=3;

--Combining both using events check as a CTE and joining that on:
WITH event_count AS (
SELECT	
	person_id,
	event_name,
	COUNT(*) AS visits
FROM facebook_event_checkin
WHERE event_name = 'SQL Symphony Concert'
AND date BETWEEN 20171201 AND 20171231
GROUP BY person_id, event_name
HAVING COUNT(event_id)=3
  )
SELECT p.*, ec.event_name, ec.visits
FROM drivers_license AS dl
JOIN person AS p ON p.license_id = dl.id
JOIN event_count AS ec ON ec.person_id = p.id
WHERE height BETWEEN 65 AND 67
	AND hair_color ='red'
	AND gender = 'female'
	AND car_make = 'Tesla'
	AND car_model = 'Model S';