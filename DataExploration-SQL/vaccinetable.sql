-- Table: public.vaccines

-- DROP TABLE IF EXISTS public.vaccines;

CREATE TABLE IF NOT EXISTS public.vaccines
(
	iso_code character varying NOT  NULL,
	continent character varying COLLATE pg_catalog."default",
	location character varying COLLATE pg_catalog."default",
	date date,
	total_tests numeric,
	new_tests numeric,
	total_tests_per_thousand numeric,
	new_tests_per_thousand numeric,
	new_tests_smoothed numeric,
	new_tests_smoothed_per_thousand numeric,
	positive_rate numeric,
	tests_per_case numeric,
	tests_units character varying COLLATE pg_catalog."default",
	total_vaccinations numeric,
	people_vaccinated numeric,
	people_fully_vaccinated numeric,
	total_boosters numeric,
	new_vaccinations numeric,
	new_vaccinations_smoothed numeric,
	total_vaccinations_per_hundred numeric,
	people_vaccinated_per_hundred numeric,
	people_fully_vaccinated_per_hundred numeric,
	total_boosters_per_hundred numeric,
	new_vaccinations_smoothed_per_million numeric,
	new_people_vaccinated_smoothed numeric,
	new_people_vaccinated_smoothed_per_hundred numeric,
	stringency_index numeric,
	population_density numeric,
	median_age numeric,
	aged_65_older numeric,
	aged_70_older numeric,
	gdp_per_capita numeric,
	extreme_poverty numeric,
	cardiovasc_death_rate numeric,
	diabetes_prevalence numeric,
	female_smokers numeric,
	male_smokers numeric,
	handwashing_facilities numeric,
	hospital_beds_per_thousand numeric,
	life_expectancy numeric,
	human_development_index numeric,
	excess_mortality_cumulative_absolute numeric,
	excess_mortality_cumulative numeric,
	excess_mortality numeric,
	excess_mortality_cumulative_per_million numeric
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.vaccines
    OWNER to postgres
