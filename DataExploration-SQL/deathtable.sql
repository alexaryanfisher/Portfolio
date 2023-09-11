-- Table: public.deaths

-- DROP TABLE IF EXISTS public.deaths;

CREATE TABLE IF NOT EXISTS public.deaths
(
	iso_code character varying NOT NULL,
	continent character varying COLLATE pg_catalog."default",
	location character varying COLLATE pg_catalog."default",
	date date,
	population numeric,
	total_cases numeric,
	new_cases numeric,
	new_cases_smoothed numeric,
	total_deaths numeric,
	new_deaths numeric,
	new_deaths_smoothed numeric,
	total_cases_per_million numeric,
	new_cases_per_million numeric,
	new_cases_smoothed_per_million numeric,
	total_deaths_per_million numeric,
	new_deaths_per_million numeric,
	new_deaths_smoothed_per_million numeric,
	reproduction_rate numeric,
	icu_patients numeric,
	icu_patients_per_million numeric,
	hosp_patients numeric,
	hosp_patients_per_million numeric,
	weekly_icu_admissions numeric,
	weekly_icu_admissions_per_million numeric,
	weekly_hosp_admissions numeric,
	weekly_hosp_admissions_per_million numeric	
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.deaths
    OWNER to postgres;
