-- Role: users_admin
-- DROP ROLE IF EXISTS users_admin;

--CREATE ROLE users_admin WITH
--  LOGIN
--  NOSUPERUSER
--  INHERIT
--  CREATEDB
--  NOCREATEROLE
--  NOREPLICATION
--  NOBYPASSRLS
--  ENCRYPTED PASSWORD 'SCRAM-SHA-256$4096:Ko3R9MHimZXDmeXwI1SiZA==$4GEgfSMpPVBGUF3v+FMZBycZB2FeJ1CjHBthsjLZucA=:uSDadYup3TTUxhlxYtn8hJWfZXt+yhS9HLauk8kCVyc=';


--CREATE SCHEMA IF NOT EXISTS users;

-- Table: users.users

--DROP TABLE users.users;

CREATE DATABASE "users-mgmt-db";

\c users-mgmt-db

CREATE SEQUENCE users_nextval_id
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

CREATE TABLE users
(
    id bigint NOT NULL DEFAULT nextval('users_nextval_id'::regclass),
    email character varying COLLATE pg_catalog."default",
    updated_at timestamp without time zone,
    created_at timestamp without time zone,
    status character varying COLLATE pg_catalog."default",
    CONSTRAINT users_pk PRIMARY KEY (id)
);

--TABLESPACE pg_default;
--
ALTER SEQUENCE users_nextval_id
    OWNED BY users.id;

--ALTER TABLE IF EXISTS users.users
--    OWNER to users_admin;
----
--ALTER SEQUENCE users.users_nextval_id
--    OWNER TO users_admin;
--
---- Table: users.houses
--
---- DROP TABLE IF EXISTS users.houses;
--

CREATE SEQUENCE IF NOT EXISTS houses_nextval_id
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

CREATE TABLE houses
(
    id bigint NOT NULL DEFAULT nextval('houses_nextval_id'::regclass),
    user_id bigint,
    address character varying COLLATE pg_catalog."default",
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    status character varying COLLATE pg_catalog."default",
    CONSTRAINT houses_pk PRIMARY KEY (id)
);
--
--TABLESPACE pg_default;

ALTER SEQUENCE houses_nextval_id
    OWNED BY houses.id;
--
--ALTER TABLE IF EXISTS users.houses
--    OWNER to users_admin;
--
--ALTER SEQUENCE users.houses_nextval_id
--    OWNER TO users_admin;

CREATE DATABASE "device-mgmt-db";

\c device-mgmt-db

CREATE SEQUENCE IF NOT EXISTS devices_nextval_id
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

CREATE TABLE IF NOT EXISTS devices
(
    id bigint NOT NULL DEFAULT nextval('devices_nextval_id'::regclass),
    user_id bigint,
    house_id character varying COLLATE pg_catalog."default",
    status character varying COLLATE pg_catalog."default",
    current_temperature bigint,
    bright bigint,
    is_open boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    device_type_code character varying COLLATE pg_catalog."default",
    name character varying COLLATE pg_catalog."default",
    serial_number character varying COLLATE pg_catalog."default",
    CONSTRAINT devices_pk PRIMARY KEY (id)
);
--TABLESPACE pg_default;

ALTER SEQUENCE devices_nextval_id
    OWNED BY devices.id;

--ALTER TABLE IF EXISTS devices.devices
--    OWNER to device_admin;
--
--ALTER SEQUENCE devices.devices_nextval_id
--    OWNER TO device_admin;

CREATE TABLE IF NOT EXISTS video_data
(
    device_id bigint,
    video_json_data character varying COLLATE pg_catalog."default"
);

CREATE DATABASE "smart_home";

\c smart_home

CREATE TABLE IF NOT EXISTS heating_systems (
    id BIGSERIAL PRIMARY KEY,
    is_on BOOLEAN NOT NULL,
    target_temperature DOUBLE PRECISION NOT NULL,
    current_temperature DOUBLE PRECISION NOT NULL
);

CREATE TABLE IF NOT EXISTS temperature_sensors (
    id BIGSERIAL PRIMARY KEY,
    current_temperature DOUBLE PRECISION NOT NULL,
    last_updated TIMESTAMP NOT NULL
);