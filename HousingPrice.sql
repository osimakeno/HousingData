-- Analyzing house prices in London
-- Using dataset from Kaggle

-- Viewing all the data from the houseprices table
SELECT 
    *
FROM 
    houseprices;

-- Deleting duplicate data

-- Identifying duplicate rows using a Common Table Expression (CTE)
WITH duplicates AS (
    SELECT
        id,
        street,
        garden,
        size_sqft,
        price_pounds,
        ROW_NUMBER() OVER (
            PARTITION BY
                id,
                street,
                size_sqft,
                price_pounds
            ORDER BY
                id
        ) AS row_num
    FROM
        houseprices
)
-- Deleting rows that have duplicate values
DELETE
FROM
    houseprices
WHERE
    (id, street, size_sqft, price_pounds) IN (
        SELECT
            id,
            street,
            size_sqft,
            price_pounds
        FROM
            duplicates
        WHERE
            row_num > 1
    );

-- Analyzing the data
-- Finding the average prices of houses based on the number of bedrooms
SELECT
    DISTINCT
    bedrooms,
    COUNT(bedrooms) AS house_count,
    ROUND(AVG(price_pounds)) AS average_price
FROM
    houseprices
WHERE
    bedrooms IS NOT NULL
GROUP BY
    bedrooms
ORDER BY
    bedrooms;

-- Finding the most expensive and cheapest houses in the dataset

-- Using a CTE to find the maximum and minimum house prices
WITH max_min_prices AS (
    SELECT
        MAX(price_pounds) AS max_price,
        MIN(price_pounds) AS min_price
    FROM
        houseprices
)
-- Selecting details of the houses with the maximum and minimum prices
SELECT
    h.id,
    h.bedrooms,
    h.street,
    h.price_pounds
FROM
    houseprices h
JOIN
    max_min_prices m
ON
    h.price_pounds = m.max_price OR h.price_pounds = m.min_price;
