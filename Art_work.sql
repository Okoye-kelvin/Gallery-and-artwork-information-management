-- 1. Identify the artists whose artworks are displayed in multiple countries. 
select wrk.artist_id, count(art.nationality) most_country
from artist art left join work wrk 
on art.artist_id = wrk.artist_id
group by wrk.artist_id
order by most_country;

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
Group by work_id, name, artist_id,style,museum_id
having count(*) > 1
);

-- 5. Identify the galleries open on both Saturday and Sunday. Display gallery name and city. 
select name, city
from museum mus  Join museum_hours mush
On mus.museum_id = mush.museum_id
where day in ('Monday','Sunday')
group by name, city;

-- 6. How many galleries are open every day of the week? 
select day, count(name) as Daily_Count
from museum mus Join museum_hours mush
On mus.museum_id = mush.museum_id
group by day
order by Daily_Count;

-- 7.	Which canvas size has the highest cost? 
select cas.label,  Max(sale_price) as price
from Canvas_size cas Join product_size prs
On cas.size_id = prs.size_id
group by cas.label
order by price desc
limit 1;

-- 8. Are there any galleries that do not have any artworks on display? 
select distinct name from work
where museum_id is null
order by name Asc;

-- 9. Identify the galleries with incorrect city information in the dataset. 
select name, city
from museum
where city not like '[a-z]%';

-- 10. Which gallery has the highest number of artworks in the most popular style?
select mus.name, count(wrk.style) as popular_painting_style
from work wrk Join museum mus
On wrk.museum_id = mus.museum_id
group by mus.name
order by popular_painting_style desc
limit 1;

-- 11. Which are the top 5 most visited galleries? (Popularity is based on the number of artworks displayed in a gallery) 
select  art.full_name, count(wrk.name) num_of_painting
from work wrk Join artist art
On wrk.artist_id = art.artist_id
group by art.full_name, wrk.name
order by num_of_painting Desc
limit 5;

-- 12.	How many artworks have a selling price higher than their listed price? 
select wrk.name
from work wrk Join product_size prs
on wrk.work_id = prs.work_id
where prs.sale_price > prs.regular_price 
group by wrk.name;

-- 13.	The Gallery_Hours table has one invalid entry. Identify and delete it. 

-- 14. Display the 3 least common canvas sizes. 
select  label, count (label) AS Popular_canvas_size from  Canvas_size
group by label
order by Popular_canvas_size asc;

-- 15. Who are the top 5 most prolific artists? (Popularity is based on the number of artworks created by an artist)
select artist_id, count(work_id) Most_work
from work
group by artist_id
order by Most_work desc
limit 5;

-- 16. Which gallery is open the longest each day? Display gallery name, state, hours open, and which day.
SELECT mus.name, mus.state, mush.day,
       MIN(CAST(mush.open AS TIME)) AS open,
       MAX(CAST(mush.close AS TIME)) AS close,
       IFNULL(TIMESTAMPDIFF(MINUTE, MIN(CAST(mush.open AS TIME)), MAX(CAST(mush.close AS TIME))), 0) AS duration
FROM museum mus
JOIN museum_hours mush ON mus.museum_id = mush.museum_id
GROUP BY mus.name, mus.state, mush.day
ORDER BY duration DESC







;
select * from museum_hours;

-- 17. List all the artworks that are not currently exhibited in any galleries.
select wrk.name
from work wrk Join museum as mus
On wrk.museum_id = mus.museum_id
where wrk.name not in (select name from museum)
group by wrk.name;

-- 18. Which country has the fifth-highest number of artworks
select art.nationality, count(wrk.work_id) Art_work
from artist art Join work wrk
On art.artist_id = wrk.artist_id
group by art.nationality
order by Art_work desc
limit 5;

-- 19. Which are the 3 most popular and 3 least popular styles of artwork
-- Most popular 3
select  style, count (style) popularity
from work$ 
group by  style 
order by popularity desc
limit 3;

-- Least popular 3
select style, count(style) as popularity
from work$
group by style 
order by popularity Asc 
limit 3;

-- 20. Display the country and city with the highest number of galleries. Output two separate columns for 
-- city and country. If there are multiple values, separate them with commas.
select country, city, count(wrk.name) Most_Galleries
from museum mus Join work wrk
On mus.museum_id = wrk.museum_id
group by country, city
order by Most_Galleries Desc
limit 5;

-- 21. Identify the artist and gallery with the highest and lowest priced artwork. Display artist name, sale 
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

-- 22. Which artist has the most Portraits artworks outside the USA? Display artist name, number of 
-- artworks, and artist nationality
select art.full_name, count(wrk.work_id) Num_artwork, art.nationality, count(sub.subject) Most_Portraits_artwork
from artist art Join work wrk
on art.artist_id = wrk.artist_id
Join subject sub
On sub.work_id = wrk.work_id 
where sub.subject = 'Portraits' > 1
group by art.full_name, art.nationality
order by Most_Portraits_artwork Desc
