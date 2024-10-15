/*
Database Load Issues

NOTE: If you are having issues with permissions. And you get an error like: "could not open file
"C:\file_path\file_name.csv" for reading: Permission denied."

1. Open pgAdmin

2. In Object Explorer (left-hand pane), navigate to `sql_course` database

3. Right-click `sql_course` and select `PSQL Tool`
        - This opens a terminal window to write the following code

4. Get the absolute file path of your csv files
        a. Find path by right-clicking a CSV file in VS Code and selecting “Copy Path”

5. Paste the following into `PSQL Tool`, (with the CORRECT file path):

\copy coviddeaths FROM '<<Your file path>>' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
\copy covidvaccinations FROM '<<Your file path>>' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
\copy housing_data FROM '<<Your file path>>' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
*/