-- 1. Identify the artists whose artworks are displayed in multiple countries. 
select wrk.artist_id, art.full_name, count(mus.country) as Most_Country
From museum mus Join work wrk
On mus.museum_id = wrk.museum_id
Join artist art
On art.artist_id = wrk.artist_id
Group by wrk.artist_id, art.full_name
Order by Most_Country Desc;

-- 2. Retrieve the top 10 most popular themes of artwork. 
select subject, count(subject)as popular_themes
from subject
group by subject
order by popular_themes DESC
limit 10;

-- 3. Identify the artworks with a selling price less than half of their listed price. 
select wrk.name 
from work wrk Join product_size prs
on wrk.work_id = prs.work_id
where prs.sale_price < (prs.regular_price * 0.5) 
group by wrk.name;


-- 4 Remove duplicate entries from the artwork, product_dimensions, theme, and image tables
select * from work;
delete from work
where work_id in (
select work_id
from work
Group by work_id, name, artist_id, style, museum_id
having count(*) > 1
);

-- 5. Identify the galleries open on both Saturday and Sunday. Display gallery name and city. 
select name, city, mush.day
from museum mus  Join museum_hours mush
On mus.museum_id = mush.museum_id
where day in ('Saturday','Sunday')
group by name, city, mush.day;

-- 6. How many galleries are open every day of the week? 
select distinct name, mush.day
from museum mus Join museum_hours mush
On mus.museum_id = mush.museum_id
Where  mush.day in ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday')
Group by mush.day, name;


-- 7.	Which canvas size has the highest cost? 
select cas.label,  Max(sale_price) as price
from Canvas_size cas Join product_size prs
On cas.size_id = prs.size_id
group by cas.label
order by price desc
limit 1;

-- 8. Are there any galleries that do not have any artworks on display?  
select mus.name, mus.museum_id, wrk.museum_id
From museum mus Left Join work wrk 
On mus.museum_id = wrk.museum_id 
where wrk.museum_id is null
order by name Asc;

-- 9. Identify the galleries with incorrect city information in the dataset.
select name
from museum
where city Not like  ('%a-z%')
;


-- 10. Which gallery has the highest number of artworks in the most popular style?
-- Finding the popular painting style
select distinct style, count(style) as popular_painting_style
from work
Group by style
Order by popular_painting_style Desc;

select wrk.style, mus.name, count(wrk.style) as popular_painting_style
from work wrk Join museum mus 
On wrk.museum_id = mus.museum_id
Group by mus.name, wrk.style
Order by popular_painting_style Desc
limit 1;

-- 11. Which are the top 5 most visited galleries? (Popularity is based on the number of artworks displayed in a gallery) 
select  mus.name, count(wrk.name) num_of_painting
from work wrk Join museum mus
On wrk.museum_id = mus.museum_id
group by mus.name
order by num_of_painting Desc
limit 5;

-- 12.	How many artworks have a selling price higher than their listed price? 
select Distinct (prs.work_id), wrk.name, prs.sale_price AS Listed_Price, prs.regular_price as Selling_price
from  product_size prs Join work wrk
On wrk.work_id = prs.work_id
Where regular_price > sale_price  
group by work_id, wrk.name, prs.sale_price, prs.regular_price;

-- 13.	The Gallery_Hours table has one invalid entry. Identify and delete it.
Select *  From museum_hours;
Update museum_hours
set day = replace(day, 'Thusday', 'Thursday');

-- 14. Display the 3 least common canvas sizes. 

select cas.label, count(wrk.name) Most_Used_Label
From canvas_size cas Join product_size prs
On cas.size_id = prs.size_id
Join work wrk 
On wrk.work_id = prs.work_id
Group by cas.label
Order by Most_Used_Label Asc
Limit 3;

-- 15. Who are the top 5 most prolific artists? (Popularity is based on the number of artworks created by an artist)
select art.full_name, count(wrk.work_id) Most_work
from work wrk Join artist art
On wrk.artist_id = art.artist_id
group by art.full_name
order by Most_work desc
limit 5;

-- 16. Which gallery is open the longest each day? Display gallery name, state, hours open, and which day.
Select mus.museum_id, mus.name, mus.city, mush.day, ABS(open - close) as Hours
From museum_hours mush Join museum mus
On mush.museum_id = mus.museum_id
Group by mus.museum_id, mus.name, mus.city, mush.day, ABS(open - close)
Order by Hours Desc
Limit 1;

-- 17. List all the artworks that are not currently exhibited in any galleries.
select wrk.museum_id,mus.museum_id, mus.name
from work wrk Right Join museum as mus
On wrk.museum_id = mus.museum_id
Where wrk.museum_id is null;

-- 18. Which country has the fifth-highest number of artworks
select mus.Country, count(wrk.name) Art_work
from artist art Join work wrk
On art.artist_id = wrk.artist_id
Join museum mus 
On mus.museum_id = wrk.museum_id
group by mus.Country
order by Art_work desc
limit 5;

-- 19. Which are the 3 most popular and 3 least popular styles of artwork Most popular 3
select style, count(style) popularity
from work 
group by  style 
order by popularity desc
limit 3;

-- Least popular 3
select style, count(style) as popularity
from work$
group by style 
order by popularity Asc 
limit 3;

-- 20. Display the country and city with the highest number of galleries. 
-- Output two separate columns for city and country. 
-- If there are multiple values, separate them with commas.
select country, city, count(wrk.name) Most_Galleries
from museum mus Join work wrk
On mus.museum_id = wrk.museum_id
group by country, city
order by Most_Galleries Desc
limit 5;

-- 21. Identify the artist and gallery with the highest and lowest priced artwork. 
-- Display artist name, sale 
-- price, artwork name, gallery name, gallery city, and canvas label
select  art.full_name, wrk.name paint_name ,mus.name museum_name, mus.city, cas.label, pros.sale_price Expensive 
from work wrk Join museum mus
On wrk.museum_id = mus.museum_id
Join artist art 
On wrk.artist_id = art.artist_id
join product_size pros
On wrk.work_id = pros.work_id
join Canvas_size cas 
On pros.size_id = cas.size_id
group by  art.full_name,  pros.sale_price ,wrk.name ,mus.name,mus.city,cas.label
order by Expensive Desc
limit 5;

-- Least Expensive
select  art.full_name, wrk.name paint_name ,mus.name museum_name, mus.city, cas.label, pros.sale_price Expensive 
from work wrk Join museum mus
On wrk.museum_id = mus.museum_id
Join artist art 
On wrk.artist_id = art.artist_id
join product_size pros
On wrk.work_id = pros.work_id
join Canvas_size cas 
On pros.size_id = cas.size_id
group by  art.full_name,  pros.sale_price ,wrk.name ,mus.name,mus.city,cas.label
order by Expensive Asc
limit 5;

-- 22. Which artist has the most Portraits artworks outside the USA? Display artist name, number of artworks, and artist nationality
SELECT art.full_name, mus.country, COUNT(sub.subject) AS Num_Portraits, art.nationality AS Artist_Nationality
FROM artist art JOIN work wrk 
ON art.artist_id = wrk.artist_id 
JOIN museum mus 
ON mus.museum_id = wrk.museum_id
Join subject sub
On wrk.work_id = sub.work_id
WHERE mus.country != 'USA'
GROUP BY art.full_name, art.nationality, mus.country
ORDER BY Num_Portraits DESC
Limit 1;


