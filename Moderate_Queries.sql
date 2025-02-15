----QUESTION SET 2

-- Q1:Write query to return the email, first name, last name, & Genre of all Rock Music
listeners. Return your list ordered alphabetically by email starting with A

SELECT DISTINCT email, first_name,last_name
FROM Customer
JOIN invoice ON Customer.customer_id = invoice.customer_id
JOIN Invoice_line ON Invoice.invoice_id = Invoice_line.invoice_id
WHERE track_id IN (
		SELECT track_id 
        FROM Track
		JOIN genre ON track.genre_id = genre.genre_id
		WHERE genre.name LIKE 'Rock'
)
ORDER BY email;

--Q2: Let's invite the artists who have written the most rock music in our dataset. Write a
query that returns the Artist name and total track count of the top 10 rock bands

SELECT artist.artist_id, artist.name, COUNT(artist.artist_id) AS number_of_songs
FROM track 
JOIN album ON album.album_id = track.album_id
JOIN artist ON album.artist_id = artist.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name  LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;


--Q3: Return all the track names that have a song length longer than the average song length.
Return the Name and Milliseconds for each track. Order by the song length with the
longest songs listed first

SELECT track.name, track.milliseconds
FROM track
WHERE milliseconds >
			(SELECT AVG(milliseconds) AS avg_track_length
			from track)
ORDER BY milliseconds DESC;


