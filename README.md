# SQL_MUSIC_STORE_INSIGHTS
This project analyzes an online music store's database to uncover trends in sales, customer behavior, and business performance. By leveraging SQL queries, the analysis provides key insights into revenue patterns, top-selling genres, customer demographics, and employee performance.

## Table of Contents
- [Introduction](#introduction)
- [Dataset](#dataset)
- [Questions and Answers](#questions-and-answers)
- [Project Structure](#project-structure)
- [Usage](#usage)
- [Result and Findings](#result-and-findings)
- [Acknowledgments](#acknowledgments)
- [Technologies Used](#technologies-used)

## Introduction
📌 Project Overview

This project focuses on analyzing an online music store’s database using SQL. The dataset consists of 11 tables covering employees, customers, invoices, tracks, and more. By running SQL queries, we aim to answer key business questions and extract valuable insights regarding sales, customer behavior, and top-performing genres/artists.

## Dataset
📝  The dataset consists of 11 tables:

- Employee, Customer, Invoice, InvoiceLine, Track, MediaType, Genre, Album, Artist, PlaylistTrack, Playlist

This data helps analyze sales trends, customer preferences, and top-performing artists/genres.

<img width="594" alt="schema_diagram" src="https://github.com/user-attachments/assets/1e1fc09b-b8c1-4a19-8715-3fb97ddc805f" />

## Questions and Answers
❓ Questions & Queries - These are divided into three sets.

🔹 Easy Queries

**Q1: Who is the most senior employee based on job title?**

```sql
SELECT * FROM EMPLOYEE
ORDER BY LEVELS DESC
LIMIT 1;
```
**Q2: Which countries have the most Invoices?**

```sql
SELECT BILLING_COUNTRY, COUNT(*) AS Most_Invoices 
FROM INVOICE
GROUP BY BILLING_COUNTRY
ORDER BY Most_Invoices DESC;
```

**Q3: What are top 3 values of total invoice?**

```sql
SELECT total FROM Invoice
ORDER BY total DESC
LIMIT 3
```
**Q4:Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals**

```sql
SELECT SUM(total) as invoice_total, billing_city
FROM Invoice
GROUP BY billing_city
ORDER BY invoice_total DESC
```
**Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most money**

```sql
SELECT Customer.customer_id, Customer.first_name, Customer.last_name, SUM(invoice.total) AS total 
FROM Customer
JOIN invoice ON Customer.customer_id = invoice.customer_id
GROUP BY Customer.customer_id
ORDER BY total DESC
LIMIT 1
```

🔸 Moderate Queries

**Q1:Write query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A**

```sql
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
```

**Q2: Let's invite the artists who have written the most rock music in our dataset. Write a query that returns the Artist name and total track count of the top 10 rock bands**

```sql
SELECT artist.artist_id, artist.name, COUNT(artist.artist_id) AS number_of_songs
FROM track 
JOIN album ON album.album_id = track.album_id
JOIN artist ON album.artist_id = artist.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name  LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;
```

**Q3: Return all the track names that have a song length longer than the average song length. Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first**

```sql
SELECT track.name, track.milliseconds
FROM track
WHERE milliseconds >
			(SELECT AVG(milliseconds) AS avg_track_length
			from track)
ORDER BY milliseconds DESC;
```

⚡ Advanced Queries

**Q1: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent**

```sql
WITH best_selling_artist AS (
	SELECT artist.artist_id AS artist_id, artist.name AS artist_name, 
	SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, 
SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;
```

**Q2: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared return all Genres**

```sql
WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1
```

**Q3: Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount**

```sql
WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1
```

## Project Structure
📁 The project repository is structured as follows

```sql
├── data/                  # Directory containing the dataset
├── queries/               # Directory containing SQL query files
└── README.md              # Project README file
```

## Usage

🚀 The usage is as follows

1. Clone the repository:

```sql
https://github.com/Atharv521/SQL_MUSIC_STORE_INSIGHTS.git
```

2. Import the dataset into your SQL database management system.

3. Run SQL queries located in the queries/ directory against the database to perform data analysis and generate insights.
   

## Result and Findings

📈 Following were the fidings from the dataset

✔️ Identified top-selling genres and artists

✔️ Analyzed customer purchase patterns by country

✔️ Determined the highest revenue-generating customers

✔️ Examined employee sales performance and contributions


## Acknowledgments

- This project was inspired by similar SQL data analysis case studies.


## Technologies Used

- SQL (PostgreSQL)
  
- pgAdmin4 (for database management)

