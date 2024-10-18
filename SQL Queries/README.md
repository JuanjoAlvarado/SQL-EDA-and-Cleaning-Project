# Introduction
👨‍💻This project is to exemplify how we can answer questions with data; accessing, cleaning, and analyzing data that's stored in databases.👩‍💻

🏥 Curious about the impact of a global pandemic in people's lives? 🔍Check this small analysis on COVID-19: [EDA](EDA/README.md#the-analysis). 🏨🛎Are you interested about how big companies like AirBnb manage the information they gather? 🔦Look at this little data cleaning analysis [Cleaning](Cleaning/README.md#the-analysis).

# Background
As time passes by, being able to manage raw information to useful data is more important almost in every profession. The goal of this SQL project is to show an introduction to the world of data through a exploratory data analysis -EDA- and a data cleaning process. 

-   Data hails from *AlexTheAnalyst*💻💽 [Repositories](https://github.com/AlexTheAnalyst/PortfolioProjects) on GitHub under the following names: "CovidDeaths.xlsx", "CovidVaccinations.xlsx" and "Nashville Housing Data for Data Cleaning.xlxs". Feel free to check them out and all the content he shares there. 


# Tools I Used

- **SQL and PostgreSQL**: A lenguange that allows me to bring out critical information and insights from a database; one of the best  and in-demand systems to manage databases was used for this project.
- **Visual Studio Code**: The corner stone and fundamental tool for database management and executing SQL queries.
- **Git & GitHub**: Essential for sharing SQL scripts and analysis, ensuring collaboration and project tracking. 

# What I Learned
No matter how simple a query might be there is always something I update in my skills and knowledge repertoire:

-   Complementary use of distinct type of functions: Feeling confident in the comprehension of aggregating functions such as SUM() and how these change when used with a PARTITION BY windows functions. 

-   Making data more useful: Updating, replacing, populating a database with it's own information is something that I feel more and more comfortably doing as in the different cases of the data cleaning process. 


# Conclusions
### Exploratory Data Analysis

-   Several countries, most of them from the African continent, didn't seem to struggle much regarding Covid-19 infections and deceased. The same countries also exhibit a lack of data entries over large periods of time.

-   United States of America was the country where most infections, deceased and hospitalized people were recorded even though the pandemic had it's origin in the other side of the world. 

-   European countries were who contributed the most, at the beginning, in vaccinations. 

### Cleaning Process

-   Regardless the new format of columns such as "PropertyAddress" and "OwnerAddress", the usefulness the data can have might be none, when manipulating and extracting information through a database manager such as PostgreSQL. Breaking apart the information in a more detailed and precise data can be the perfect solution. 

-   Before consider getting information from another data source to fill out missing information, the best practice is to explore and observer carefully all the database. Thinking if it is possible that the missing information is scattered or under a different column name, etc.
