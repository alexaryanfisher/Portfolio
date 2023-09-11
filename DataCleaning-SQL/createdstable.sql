-- Table: public.dsjobs

-- DROP TABLE IF EXISTS public.dsjobs;

CREATE TABLE IF NOT EXISTS public.dsjobs
(
    index character varying COLLATE pg_catalog."default" NOT NULL,
    job_title character varying COLLATE pg_catalog."default",
    salary character varying COLLATE pg_catalog."default",
    job_description character varying COLLATE pg_catalog."default",
    rating character varying COLLATE pg_catalog."default",
    company character varying COLLATE pg_catalog."default",
    location character varying COLLATE pg_catalog."default",
    headquarters character varying COLLATE pg_catalog."default",
    size character varying COLLATE pg_catalog."default",
    founded numeric,
    ownership character varying COLLATE pg_catalog."default",
    industry character varying COLLATE pg_catalog."default",
    sector character varying COLLATE pg_catalog."default",
    revenue character varying COLLATE pg_catalog."default",
    competitors character varying COLLATE pg_catalog."default",
    CONSTRAINT dsjobs_pkey PRIMARY KEY (index)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.dsjobs
    OWNER to postgres;

