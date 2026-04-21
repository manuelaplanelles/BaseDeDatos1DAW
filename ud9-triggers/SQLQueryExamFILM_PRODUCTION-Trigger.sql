create database FILM_PRODUCTION

--1. UPDATE_PROP When a purchase is made from a supplier (insert into ORDERS_DETAILS), the trigger must 
--perform the following actions:
-- * Increase the stock of the prop (PROP)
-- * Update the retail price by increasing it by 20% in relation to the purchase price

-------------------------------------------------------------------------------------------------------
--2. UPDATE_SCENE_STATUS When a scene date is updated, if the new date is in the past, the trigger must 
--update the StatusScene to 'filmed'.

-------------------------------------------------------------------------------------------------------
--3. CHECK_PROP_STOCK When a prop is assigned to a scene (insert into SCENE_PROP), the trigger must 
--perform the following actions:
-- * Decrease the stock of the prop in PROP
-- * If the new stock is lower than or equal to FlagStock, set Flag to 1

-------------------------------------------------------------------------------------------------------
-- 4. UPDATE_SALARY_PREP When an employee works on a scene preparation (insert into PREPARATION), 
--the trigger must perform the following actions:
-- * Calculate the salary for that preparation (HoursPrep * Hourly_Rate)
-- * If there is already a record in SALARY for that employee, month and year, add the amount
-- * If there is no record, insert a new row

-------------------------------------------------------------------------------------------------------
-- 5. UPDATE_PROP_PRICE When a new order detail is inserted (insert into ORDERS_DETAILS), the trigger 
--must perform the following actions:
-- * Increase the stock of the prop
-- * Update the retail price to 20% above the purchase price
-- * If the new stock is greater than FlagStock, set Flag to 0

-------------------------------------------------------------------------------------------------------
-- 6. CHECK_SCENE_PREP When a new preparation is inserted, the trigger must check that the scene exists 
--and belongs to the movie. If not, display a message and rollback.

-------------------------------------------------------------------------------------------------------
-- 7. UPDATE_SALARY_SCENE When the status of a scene is updated to 'filmed', the trigger must perform 
--the following actions:
-- * Calculate the salary for each employee who prepared that scene (HoursPrep * Hourly_Rate)
-- * If there is already a record in SALARY for that employee, month and year, add the amount
-- * If there is no record, insert a new row

-------------------------------------------------------------------------------------------------------
-- 8. FILM_SCENE_PROPS When a scene is filmed (StatusScene updated to 'filmed'), the trigger must 
--perform the following actions:
-- * Decrease the stock of all props used in that scene (SCENE_PROP) in the PROP table
-- * For each prop whose stock falls to 5 or fewer, set Flag to 1

-------------------------------------------------------------------------------------------------------
-- 9. UPDATE_MOVIE_DURATION When a new scene is inserted into SCENE, the trigger must update the 
--DurationMinutes of the movie by adding 5 minutes per scene.
-- Additionally, for each employee who has already prepared a scene of that movie, update their salary adding 50€ bonus.

-------------------------------------------------------------------------------------------------------
-- 10. ORDER_PROPS_SCENE When a new order detail is inserted (insert into ORDERS_DETAILS), the trigger 
--must perform the following actions:
-- * Increase the stock of the prop in PROP
-- * Update the retail price to 20% above the purchase price
-- * For each scene that uses that prop (SCENE_PROP), if the updated stock covers the quantity needed, set the StatusScene to 'prepared'