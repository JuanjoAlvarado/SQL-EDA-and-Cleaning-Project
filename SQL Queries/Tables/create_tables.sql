CREATE TABLE public.CovidDeaths
(
    iso_code varchar(50),
    continent varchar(50),
    location varchar(50),
    date date,
    population bigint,
    total_cases int,
    new_cases int,
    new_cases_smoothed float,
    total_deaths int,
    new_deaths int,
    new_deaths_smoothed float,
    total_cases_per_million float,
    new_cases_per_million float,
    new_cases_smoothed_per_million float,
    total_deaths_per_million float,
    new_deaths_per_million float,
    new_deaths_smoothed_per_million float,
    reproduction_rate float,
    icu_patients float,
    icu_patients_per_million float,
    hosp_patients float,
    hosp_patients_per_million float,
    weekly_icu_admissions float,
    weekly_icu_admissions_per_million float,
    weekly_hosp_admissions float,
    weekly_hosp_admissions_per_million float,
    total_tests float
);

CREATE TABLE public.CovidVaccinations
(
    iso_code varchar(50),
    continent varchar(50),
    location varchar(50),
    date date,
    new_tests bigint,
    total_tests_per_thousand float,
    new_tests_per_thousand float,
    new_tests_smoothed float,
    new_tests_smoothed_per_thousand float,
    positive_rate float,
    tests_per_case float,
    tests_units varchar(50),
    total_vaccinations bigint,
    people_vaccinated bigint,
    people_fully_vaccinated bigint,
    total_boosters bigint,
    new_vaccinations int,
    new_vaccinations_smoothed float,
    total_vaccinations_per_hundred float,
    people_vaccinated_per_hundred float,
    people_fully_vaccinated_per_hundred float,
    total_boosters_per_hundred float,
    new_vaccinations_smoothed_per_million float,
    new_people_vaccinated_smoothed float,
    new_people_vaccinated_smoothed_per_hundred float,
    stringency_index float,
    population_density float,
    median_age float,
    aged_65_older float,
    aged_70_older float,
    gdp_per_capita float,
    extreme_poverty float,
    cardiovasc_death_rate float,
    diabetes_prevalence float,
    female_smokers float,
    male_smokers float,
    handwashing_facilities float,
    hospital_beds_per_thousand float,
    life_expectancy float,
    human_development_index float,
    excess_mortality_cumulative_absolute float,
    excess_mortality_cumulative float,
    excess_mortality float,
    excess_mortality_cumulative_per_million float
);

CREATE TABLE public.housing_data
(
    UniqueID 	varchar(50) PRIMARY KEY,
    ParcelID	varchar(50),
    LandUse	varchar(50),
    PropertyAddress	varchar(50),
    SaleDate	varchar(50),
    SalePrice	varchar(50),
    LegalReference	varchar(50),
    SoldAsVacant	varchar(50),
    OwnerName	varchar(255),
    OwnerAddress	varchar(50),
    Acreage	float,
    TaxDistrict	varchar(50),
    LandValue	int,
    BuildingValue	int,
    TotalValue	int,
    YearBuilt	int,
    Bedrooms	int,
    FullBath	int,
    HalfBath	int 
);

ALTER TABLE public.CovidDeaths OWNER to postgres;

ALTER TABLE public.CovidVaccinations OWNER to postgres;

ALTER TABLE public.housing_data OWNER to postgres;
CREATE INDEX idx_UniqueID ON public.housing_data (UniqueID);
