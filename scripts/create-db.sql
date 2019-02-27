
/*
Commentary:

The tables created here contain a bunch of fields that I don't
believe are applicable for what I'm doing with the data. If I was making
this app for real I would trim them out of the data as part of the
sanitation work that was done on them.

The varchar sizes are pretty arbitrary as well, they could also be
reduced. I would also like to look into the correct way to store bools.

If the database was getting writes from user submitted data I'd probably
also want to annotate the columns some more with things like NOT NULL.
But since the API is read only I'm not terribly worried about it for now.
*/

IF OBJECT_ID(N'dbo.Zones', N'U') IS NULL
BEGIN
    CREATE TABLE Zones (
        location_id int,
        borough varchar(255),
        zone varchar(255),
        service_zone varchar(255)
    )
END

IF OBJECT_ID(N'dbo.GreenCab', N'U') IS NULL
BEGIN
    CREATE TABLE GreenCab (
        vendor_id int,
        pickup_time datetime2,
        dropoff_time datetime2,
        store_and_fwd_flag varchar(10),
        ratecode_id int,
        pickup_location_id int,
        dropoff_location_id int,
        passenger_count int,
        trip_distance float,
        fare_amount float,
        extra float,
        mta_tax float,
        tip_amount float,
        tolls_amount float,
        ehail_fee float,
        improvement_surcharge float,
        total_amount float,
        payment_type int,
        trip_type int
    )
END

IF OBJECT_ID(N'dbo.YellowCab', N'U') IS NULL
BEGIN
    CREATE TABLE YellowCab (
        vendor_id int,
        pickup_time datetime,
        dropoff_time datetime,
        passenger_count int,
        trip_distance float,
        ratecode_id int,
        store_and_fwd_flag varchar(10),
        pickup_location_id int,
        dropoff_location_id int,
        payment_type int,
        fare_amount float,
        extra float,
        mta_tax float,
        tip_amount float,
        tolls_amount float,
        improvement_surcharge float,
        total_amount float,
    )
END

IF OBJECT_ID(N'dbo.ForHire', N'U') IS NULL
BEGIN
    CREATE TABLE ForHire (
        dispatching_base_num varchar(10),
        pickup_time datetime2,
        dropoff_time datetime2,
        pickup_location_id int,
        dropoff_location_id int,
        sr_flag varchar(4)
    )
END
