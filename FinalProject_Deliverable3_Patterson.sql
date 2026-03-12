--Create a database called FishkeepingDB to hold all 16 tables
--CREATE DATABASE FishkeepingDB;

-- Merchant Table - Lookup Table
CREATE TABLE Merchant (
    merchantID INT IDENTITY(1,1), --https://www.w3schools.com/sql/sql_autoincrement.asp
    --IDENTITY keyword to perform an auto-increment feature, allows a unique number to 
    --be generated automatically when a new record is inserted into a table.

    merchantLoc VARCHAR(255) NOT NULL, --merchant address
    merchantState VARCHAR(255) NOT NULL, --merchant state
    merchantCity VARCHAR(255) NOT NULL, --merchant city
    merchantName VARCHAR(255) NOT NULL,
    merchantRating NUMERIC,
    PRIMARY KEY (merchantID)
);

-- Filters Table - Lookup Table
CREATE TABLE Filters (
    filterID INT IDENTITY(1,1),
    filterSize INT NOT NULL, --max gallons
    filterType VARCHAR(255) NOT NULL, --cannister, internal, sponge
    filterCleanDate DATE, --most recent cleaning date
    filterName VARCHAR(255) NOT NULL,
    PRIMARY KEY (filterID)
);

-- Biome Table - Lookup Table
CREATE TABLE Biome (
    biomeID INT IDENTITY(1,1),
    biomeName VARCHAR(255) NOT NULL,
    biomeRating NUMERIC,
    tempMin INT,
    tempMax INT,
    PRIMARY KEY (biomeID)
);

-- Tank Table
CREATE TABLE Tank (
    tankID INT IDENTITY(1,1),
    tankSize NUMERIC NOT NULL,
    tankHight NUMERIC NOT NULL,
    tankLength NUMERIC NOT NULL,
    tankDepth NUMERIC NOT NULL,
    tankType VARCHAR(255) NOT NULL, --breeder, growout, hospital, display
    tankRating NUMERIC,
    purchaseDate DATE, --optional
    purchaseCost DECIMAL(10, 2) NOT NULL,
    merchantID INT,
    filterID INT,
    biomeID INT,
    PRIMARY KEY (tankID),
    FOREIGN KEY (merchantID) REFERENCES Merchant(merchantID),
    FOREIGN KEY (filterID) REFERENCES Filters(filterID),
    FOREIGN KEY (biomeID) REFERENCES Biome(biomeID)
);

-- Species Table
CREATE TABLE Species (
    speciesID INT IDENTITY(1,1), 
    speciesName VARCHAR(255) NOT NULL,
    speciesQuantity INT NOT NULL,
    speciesType VARCHAR(255) NOT NULL,
    speciesRating NUMERIC, --optional
    tankID INT,
    PRIMARY KEY (speciesID),
    FOREIGN KEY (tankID) REFERENCES Tank(tankID) --references the Tank table
);

-- Livestock Table
CREATE TABLE Livestock (
    livestockID INT IDENTITY(1,1),
    livestockName VARCHAR(255) NOT NULL,
    livestockSize NUMERIC, --optional
    dateDeathSell DATE,
    purchaseDate DATE, --optional
    purchaseCost DECIMAL(10, 2) NOT NULL,
    age NUMERIC,
    livestockColor VARCHAR(255),
    speciesID INT,
    merchantID INT,
    PRIMARY KEY (livestockID),
    FOREIGN KEY (speciesID) REFERENCES Species(speciesID),
    FOREIGN KEY (merchantID) REFERENCES Merchant(merchantID)
);

-- Tank_Filters_Junction Table
CREATE TABLE Tank_Filters_Junction (
    TFjunct INT IDENTITY(1,1),
    tankID INT,
    filterID INT,
    PRIMARY KEY (TFjunct), --pirmary key for this table
    FOREIGN KEY (tankID) REFERENCES Tank(tankID),
    FOREIGN KEY (filterID) REFERENCES Filters(filterID)
);

-- Biome_Substrate Table - Lookup Table
CREATE TABLE Biome_Substrate (
    substrateID INT IDENTITY(1,1),
    substrateName VARCHAR(255) NOT NULL,
    substrateType VARCHAR(255) NOT NULL, --fine/coarse sand, pond/aquarium soil, pebbles, river stones
    substrateQuantity INT NOT NULL, --number of bags purchased
    purchaseDate DATE,
    purchaseCost DECIMAL(10, 2) NOT NULL,
    biomeID INT,
    merchantID INT,
    PRIMARY KEY (substrateID),
    FOREIGN KEY (biomeID) REFERENCES Biome(biomeID),
    FOREIGN KEY (merchantID) REFERENCES Merchant(merchantID)
);

-- Biome_Plant Table - Lookup Table
CREATE TABLE Biome_Plant (
    plantID INT IDENTITY(1,1),
    plantName VARCHAR(255) NOT NULL,
    plantType VARCHAR(255) NOT NULL, --epiphyte, nymphaeids, floaters, root-grower, stemmed
    purchaseDate DATE,
    purchaseCost DECIMAL(10, 2) NOT NULL,
    merchantID INT,
    biomeID INT,
    PRIMARY KEY (plantID),
    FOREIGN KEY (merchantID) REFERENCES Merchant(merchantID),
    FOREIGN KEY (biomeID) REFERENCES Biome(biomeID)
);

-- Biome_Hardscape Table - Lookup Table
CREATE TABLE Biome_Hardscape (
    hardscapeID INT IDENTITY(1,1),
    hardscapeName VARCHAR(255) NOT NULL,
    hardscapeType VARCHAR(255) NOT NULL, --stone, hardwood, decoration
    hardscapeQuantity INT, --number purchased
    purchaseDate DATE,
    purchaseCost DECIMAL(10, 2) NOT NULL,
    merchantID INT,
    biomeID INT,
    PRIMARY KEY (hardscapeID),
    FOREIGN KEY (merchantID) REFERENCES Merchant(merchantID),
    FOREIGN KEY (biomeID) REFERENCES Biome(biomeID)
);

-- Rating Table
CREATE TABLE Rating (
    ratingID INT IDENTITY(1,1),
    tankRating NUMERIC,
    biomeRating NUMERIC,
    speciesRating NUMERIC,
    merchantRating NUMERIC,
    PRIMARY KEY (ratingID)
);

-- Tank_Substrate_Junction Table
CREATE TABLE Tank_Substrate_Junction (
    TSjunct INT IDENTITY(1,1),
    tankID INT,
    substrateID INT,
    PRIMARY KEY (TSjunct),
    FOREIGN KEY (tankID) REFERENCES Tank(tankID),
    FOREIGN KEY (substrateID) REFERENCES Biome_Substrate(substrateID)
);

-- Tank_Plant_Junction Table
CREATE TABLE Tank_Plant_Junction (
    TPjunct INT IDENTITY(1,1),
    tankID INT,
    plantID INT,
    PRIMARY KEY (TPjunct),
    FOREIGN KEY (tankID) REFERENCES Tank(tankID),
    FOREIGN KEY (plantID) REFERENCES Biome_Plant(plantID)
);

-- Merchant_Hardscape_Junction Table
CREATE TABLE Merchant_Hardscape_Junction (
    MHjunct INT IDENTITY(1,1),
    merchantID INT,
    hardscapeID INT,
    PRIMARY KEY (MHjunct),
    FOREIGN KEY (merchantID) REFERENCES Merchant(merchantID),
    FOREIGN KEY (hardscapeID) REFERENCES Biome_Hardscape(hardscapeID)
);

-- Merchant_Plant_Junction Table
CREATE TABLE Merchant_Plant_Junction (
    MPjunct INT IDENTITY(1,1),
    merchantID INT,
    plantID INT,
    PRIMARY KEY (MPjunct),
    FOREIGN KEY (merchantID) REFERENCES Merchant(merchantID),
    FOREIGN KEY (plantID) REFERENCES Biome_Plant(plantID)
);

-- Merchant_Substrate_Junction Table
CREATE TABLE Merchant_Substrate_Junction (
    MSjunct INT IDENTITY(1,1),
    merchantID INT,
    substrateID INT,
    PRIMARY KEY (MSjunct),
    FOREIGN KEY (merchantID) REFERENCES Merchant(merchantID),
    FOREIGN KEY (substrateID) REFERENCES Biome_Substrate(substrateID)
);


--Populate Look up tables
-- Insert into Merchant
INSERT INTO Merchant (merchantLoc, merchantCity, merchantState, merchantName, merchantRating)
VALUES ('support@buceplant.com', 'Los Angeles', 'California, CA','Buce Plant', 3.5),
       ('orders@wetspottropicalfish.com', 'Portland', 'Oregon, OR','The Wet Spot', 5),
       ('emailsupport@petsonbroadway.com', 'Portland', 'Oregon, OR','Pets On Boradway', 4.5),
       ('support@petsmart.com', 'Portland', 'Oregon, OR','PetSmart', 2.5),
       ('shipping@aquariumcoop.com', 'Edmonds', 'Washington, WA','Aquarium Co-op', 4.5)

INSERT INTO Filters (filterSize, filterType, filterCleanDate, filterName)
VALUES (70, 'cannister', '2024-03-24','Fluval 307 Cannister Filter'),
       (45, 'cannister', '2024-01-13','Fluval 207 Cannister Filter'),
       (20, 'sponge', '2024-05-03','Top Fin Sponge Filter'),
       (150, 'sponge', '2024-07-25','AQUANEAT Aquarium X Large Bio Sponge Filter'),
       (150, 'internal', '2024-02-07','NICREW Aquarium Internal Filter')

INSERT INTO Biome (biomeName, biomeRating, tempMin, tempMax)
VALUES ('Amazon River', 4.5, 72, 82),
       ('Plant Growout', 3, 76, 81),
       ('Garden Pond', 2.5, 74, 82),
       ('Sandy River Shore', 5, 78, 84),
       ('SE Asian Blackwater', 5, 75, 80)

INSERT INTO Biome_Substrate (substrateName, substrateType, substrateQuantity, purchaseDate, purchaseCost, biomeID, merchantID)
VALUES ('Fine Sand', 'fine sand', 10, '2024-01-10', 30.00, 1, 10),
       ('Coarse Gravel', 'coarse sand', 5, '2024-02-15', 25.00, 2, 8),
       ('Pond Soil', 'pond soil', 7, '2024-03-05', 40.00, 3, 9),
       ('River Stones', 'river stones', 15, '2024-04-20', 50.00, 4, 9),
       ('Aquarium Soil', 'aquarium soil', 12, '2024-05-10', 35.00, 5, 11)

INSERT INTO Biome_Plant (plantName, plantType, purchaseDate, purchaseCost, biomeID, merchantID)
VALUES ('Java Fern', 'epiphyte', '2024-01-12', 15.00, 1, 10),
       ('Water Lily', 'nymphaeids', '2024-02-20', 20.00, 2, 8),
       ('Duckweed', 'floaters', '2024-03-15', 8.00, 3, 7),
       ('Cryptocoryne', 'root-grower', '2024-04-05', 12.00, 4, 7),
       ('Pearlweeed', 'stemmed', '2024-05-25', 18.00, 5, 9)

INSERT INTO Biome_Hardscape (hardscapeName, hardscapeType, hardscapeQuantity, purchaseDate, purchaseCost, biomeID, merchantID)
VALUES ('Lava Rock', 'stone', 5, '2024-01-20', 40.00, 1, 7),
       ('Driftwood', 'hardwood', 3, '2024-02-25', 30.00, 2, 11),
       ('Artificial Coral', 'decoration', 10, '2024-03-10', 25.00, 3, 9),
       ('Slate Rock', 'stone', 8, '2024-04-15', 45.00, 4, 10),
       ('Moss Covered Driftwood', 'hardwood', 2, '2024-05-30', 50.00, 5, 9)

--Insert other values for other tables for testing
INSERT INTO Tank (tankSize, tankHight, tankLength, tankDepth, tankType, tankRating, purchaseDate, purchaseCost, merchantID, filterID, biomeID)
VALUES (40, 17, 36.19, 18.25, 'display', 5, '2023-04-06', 64.99, 10, 1, 4),
       (20, 12.75, 30.25, 12.5, 'display', 4.5, '2022-09-15', 59.99, 8, 2, 1),
       (10, 12.56, 20.25, 10.5, 'growout', 2.5, '2021-07-13', 10, 10,3,2),
       (10, 12.56, 20.25, 10.5, 'hospital', 3.5, '2021-08-17', 10, 10,3,2),
       (20, 16.74, 24.25, 12.5, 'breeder', 3, '2021-12-31', 25.99, 8,4,3),
       (10, 12.56, 20.25, 10.5, 'display', 5, '2021-06-17', 10, 10,3,5)

INSERT INTO Livestock (livestockName, livestockSize, livestockColor, purchaseCost, purchaseDate, speciesID, merchantID)
VALUES ('Molly Fish', 1.5, 'black', 20, '2022-10-24', 1, 8),
       ('Angel Fish - Male', 4, 'multi', 7.99, '2023-04-20', 2, 10),
       ('Angel Fish - Female', 2, 'gold', 4.99, '2023-05-23', 2, 8),
       ('Angel Fish - Female', 2.5, 'multi', 4.99, '2023-05-23', 2, 8),
       ('Neocaridina Shirmp - Cherry', 0.5, 'red', 25,'2021-07-08', 4, 11)

INSERT INTO Species (speciesName, speciesQuantity, speciesType, speciesRating, tankID)
VALUES ('Molly Fish', 13, 'fish', 3, 2),
       ('Angel Fish', 3, 'fish', 4, 1),
       ('Nerite Snail', 2, 'snail', 2.5, 5),
       ('Neocaridina Shirmp', 10, 'shirmp', 5, 6),
       ('Mirco Rasbora', 25, 'fish', 4.5, 6),
       ('Dwarf Catfish', 6, 'fish', 3.5, 1),
       ('Guppies', 6, 'fish', 2.5, 5),
       ('Nerite Snail', 2, 'snail', 2.5, 1),
       ('Nerite Snail', 2, 'snail', 2.5, 2),
       ('Neocaridina Shirmp', 10, 'shirmp', 5, 2),
       ('Neocaridina Shirmp', 10, 'shirmp', 5, 3),
       ('Betta', 1, 'fish', 5, 3)
