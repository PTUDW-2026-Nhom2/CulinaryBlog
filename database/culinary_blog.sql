--
-- PostgreSQL database dump
--

\restrict 6RCdUclvRdcDeIKeuZuBvhWmbrE4XdVo17aI89Z6ht49Yx0bJhKGqgewxlZbIPP

-- Dumped from database version 16.15
-- Dumped by pg_dump version 16.15

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: drizzle; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA drizzle;


--
-- Name: recipe_difficulty; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.recipe_difficulty AS ENUM (
    'Easy',
    'Medium',
    'Hard'
);


--
-- Name: recipe_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.recipe_status AS ENUM (
    'Draft',
    'Published',
    'Archived'
);


--
-- Name: user_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.user_role AS ENUM (
    'Author',
    'Admin'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: __drizzle_migrations; Type: TABLE; Schema: drizzle; Owner: -
--

CREATE TABLE drizzle.__drizzle_migrations (
    id integer NOT NULL,
    hash text NOT NULL,
    created_at bigint
);


--
-- Name: __drizzle_migrations_id_seq; Type: SEQUENCE; Schema: drizzle; Owner: -
--

CREATE SEQUENCE drizzle.__drizzle_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: __drizzle_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: drizzle; Owner: -
--

ALTER SEQUENCE drizzle.__drizzle_migrations_id_seq OWNED BY drizzle.__drizzle_migrations.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    is_deleted boolean DEFAULT false NOT NULL,
    row_version integer DEFAULT 1 NOT NULL,
    name character varying(100) NOT NULL,
    slug character varying(120) NOT NULL,
    description text,
    image_url character varying(500),
    order_index integer DEFAULT 0 NOT NULL
);


--
-- Name: recipe_ingredients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recipe_ingredients (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    is_deleted boolean DEFAULT false NOT NULL,
    row_version integer DEFAULT 1 NOT NULL,
    recipe_id uuid NOT NULL,
    name character varying(200) NOT NULL,
    quantity numeric(10,3),
    unit character varying(50),
    notes character varying(500),
    order_index integer DEFAULT 0 NOT NULL
);


--
-- Name: recipe_steps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recipe_steps (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    is_deleted boolean DEFAULT false NOT NULL,
    row_version integer DEFAULT 1 NOT NULL,
    recipe_id uuid NOT NULL,
    step_number integer NOT NULL,
    title character varying(200) NOT NULL,
    description text NOT NULL,
    timer_minutes integer,
    image_url character varying(500)
);


--
-- Name: recipes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recipes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    is_deleted boolean DEFAULT false NOT NULL,
    row_version integer DEFAULT 1 NOT NULL,
    category_id uuid NOT NULL,
    status public.recipe_status DEFAULT 'Draft'::public.recipe_status NOT NULL,
    title character varying(200) NOT NULL,
    slug character varying(220) NOT NULL,
    description text NOT NULL,
    instructions text NOT NULL,
    prep_time integer NOT NULL,
    cook_time integer NOT NULL,
    servings integer NOT NULL,
    difficulty public.recipe_difficulty DEFAULT 'Easy'::public.recipe_difficulty NOT NULL,
    author_id uuid NOT NULL,
    published_at timestamp with time zone,
    nutrition_calories numeric(8,2),
    nutrition_protein numeric(8,2),
    nutrition_carbohydrates numeric(8,2),
    nutrition_fat numeric(8,2),
    nutrition_fiber numeric(8,2),
    nutrition_sodium numeric(8,2)
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    is_deleted boolean DEFAULT false NOT NULL,
    row_version integer DEFAULT 1 NOT NULL,
    email character varying(255) NOT NULL,
    password_hash text,
    display_name character varying(100) NOT NULL,
    avatar_url character varying(500),
    bio text,
    role public.user_role DEFAULT 'Author'::public.user_role NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    failed_login_attempts integer DEFAULT 0 NOT NULL,
    locked_until timestamp with time zone
);


--
-- Name: __drizzle_migrations id; Type: DEFAULT; Schema: drizzle; Owner: -
--

ALTER TABLE ONLY drizzle.__drizzle_migrations ALTER COLUMN id SET DEFAULT nextval('drizzle.__drizzle_migrations_id_seq'::regclass);


--
-- Data for Name: __drizzle_migrations; Type: TABLE DATA; Schema: drizzle; Owner: -
--

COPY drizzle.__drizzle_migrations (id, hash, created_at) FROM stdin;
1	034b0f5277333be4bc53b80a91598569a86da52091dac68c8a8c628bfc4cd8e5	1789558297211
2	8be067b4e78135819f28eafd5c07c4210442f53d93d8df02b954deb2414d4c03	1789570506801
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.categories (id, created_at, updated_at, is_deleted, row_version, name, slug, description, image_url, order_index) FROM stdin;
84195f7c-4f8b-45a5-8bff-59d7520c4322	2026-09-22 16:40:27.935108+00	\N	f	1	Lab 2 - Món Việt	lab2-category-01	Danh mục mẫu món việt cho lab 2.	\N	0
82d6aa2c-4c63-4208-afcb-39a2b20e25fe	2026-09-22 16:40:27.935108+00	\N	f	1	Lab 2 - Món Á	lab2-category-02	Danh mục mẫu món á cho lab 2.	\N	1
058020db-2ae1-444d-9dd8-36925696092d	2026-09-22 16:40:27.935108+00	\N	f	1	Lab 2 - Món Âu	lab2-category-03	Danh mục mẫu món âu cho lab 2.	\N	2
af794161-e952-4746-9bfe-ae1023f82546	2026-09-22 16:40:27.935108+00	\N	f	1	Lab 2 - Món chay	lab2-category-04	Danh mục mẫu món chay cho lab 2.	\N	3
19d6294c-4afb-4fac-901b-1f474784a6cd	2026-09-22 16:40:27.935108+00	\N	f	1	Lab 2 - Món nướng	lab2-category-05	Danh mục mẫu món nướng cho lab 2.	\N	4
0aef3997-c3e3-4a21-90c5-7a094bfd1846	2026-09-22 16:40:27.935108+00	\N	f	1	Lab 2 - Món hấp	lab2-category-06	Danh mục mẫu món hấp cho lab 2.	\N	5
18f03254-878b-42c6-95bd-b19c6aa08642	2026-09-22 16:40:27.935108+00	\N	f	1	Lab 2 - Món xào	lab2-category-07	Danh mục mẫu món xào cho lab 2.	\N	6
cc7b4987-5b04-4d3d-8dfb-bdb425310a43	2026-09-22 16:40:27.935108+00	\N	f	1	Lab 2 - Món chiên	lab2-category-08	Danh mục mẫu món chiên cho lab 2.	\N	7
e66b86e1-4212-428a-a67d-c93d7b13491e	2026-09-22 16:40:27.935108+00	\N	f	1	Lab 2 - Món kho	lab2-category-09	Danh mục mẫu món kho cho lab 2.	\N	8
bff0da8f-b4d4-4abf-9ee0-6745b206152e	2026-09-22 16:40:27.935108+00	\N	f	1	Lab 2 - Món canh	lab2-category-10	Danh mục mẫu món canh cho lab 2.	\N	9
db88f651-9af0-457c-8479-e358ae00119a	2026-09-22 16:40:27.935108+00	\N	f	1	Lab 2 - Món súp	lab2-category-11	Danh mục mẫu món súp cho lab 2.	\N	10
9e9a056b-76d8-4803-b59e-b28e2f0728c1	2026-09-22 16:40:27.935108+00	\N	f	1	Lab 2 - Món cơm	lab2-category-12	Danh mục mẫu món cơm cho lab 2.	\N	11
c8bad750-acdb-4077-a4e1-2ae6d13b63c2	2026-09-22 16:40:27.935108+00	\N	f	1	Lab 2 - Món mì	lab2-category-13	Danh mục mẫu món mì cho lab 2.	\N	12
b6763cb8-2c61-423c-9c26-f0ddd11eaa51	2026-09-22 16:40:27.935108+00	\N	f	1	Lab 2 - Món bún	lab2-category-14	Danh mục mẫu món bún cho lab 2.	\N	13
87366ac5-9a02-419a-af8c-7dc296ded1dc	2026-09-22 16:40:27.935108+00	\N	f	1	Lab 2 - Món bánh	lab2-category-15	Danh mục mẫu món bánh cho lab 2.	\N	14
a9a5cf88-5f7a-420a-9c33-d3ccc7e83405	2026-09-22 16:40:27.935108+00	\N	f	1	Lab 2 - Món tráng miệng	lab2-category-16	Danh mục mẫu món tráng miệng cho lab 2.	\N	15
96cfe3d7-3e7b-4863-ac69-3223877f6fda	2026-09-22 16:40:27.935108+00	\N	f	1	Lab 2 - Món ăn sáng	lab2-category-17	Danh mục mẫu món ăn sáng cho lab 2.	\N	16
2c0638cb-2557-4242-b543-1f520de0ed53	2026-09-22 16:40:27.935108+00	\N	f	1	Lab 2 - Món ăn nhẹ	lab2-category-18	Danh mục mẫu món ăn nhẹ cho lab 2.	\N	17
c0fe3e7d-920b-43bd-97fd-90eab8b8eb3a	2026-09-22 16:40:27.935108+00	\N	f	1	Lab 2 - Món gia đình	lab2-category-19	Danh mục mẫu món gia đình cho lab 2.	\N	18
5b8d9b6c-4ebc-4012-bd51-6b12ab970582	2026-09-22 16:40:27.935108+00	\N	f	1	Lab 2 - Món ngày lễ	lab2-category-20	Danh mục mẫu món ngày lễ cho lab 2.	\N	19
\.


--
-- Data for Name: recipe_ingredients; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.recipe_ingredients (id, created_at, updated_at, is_deleted, row_version, recipe_id, name, quantity, unit, notes, order_index) FROM stdin;
9fbdaf12-25f7-4afa-8a64-5ad69d48bb2d	2026-09-22 16:40:27.935108+00	\N	f	1	3787d4e3-76f7-4e24-b1ec-02d9dc13d6e0	trứng	2.000	phần	\N	0
ed61d55f-70de-44c2-ba99-ef10083e0eff	2026-09-22 16:40:27.935108+00	\N	f	1	3787d4e3-76f7-4e24-b1ec-02d9dc13d6e0	rau thơm	1.000	phần	\N	1
1e0e6b1e-cb7a-4e3b-b0ec-cfd93bc25237	2026-09-22 16:40:27.935108+00	\N	f	1	3787d4e3-76f7-4e24-b1ec-02d9dc13d6e0	ớt chuông	2.000	phần	\N	2
23133bcc-4dc8-415b-b184-f1db1e29a8b5	2026-09-22 16:40:27.935108+00	\N	f	1	3787d4e3-76f7-4e24-b1ec-02d9dc13d6e0	nấm	2.000	phần	\N	3
a84b11d8-77e0-4eef-bc63-a8180483c116	2026-09-22 16:40:27.935108+00	\N	f	1	3787d4e3-76f7-4e24-b1ec-02d9dc13d6e0	đường	2.000	phần	\N	4
ff67b32e-34be-494e-b0cc-17c2b201eaff	2026-09-22 16:40:27.935108+00	\N	f	1	3787d4e3-76f7-4e24-b1ec-02d9dc13d6e0	đậu que	2.000	phần	\N	5
d11209d0-ca2e-4f30-a256-2c3b4051def3	2026-09-22 16:40:27.935108+00	\N	f	1	3787d4e3-76f7-4e24-b1ec-02d9dc13d6e0	dầu ăn	1.000	phần	\N	6
7762f0ef-3d0e-42c8-a847-217971c6be3f	2026-09-22 16:40:27.935108+00	\N	f	1	3787d4e3-76f7-4e24-b1ec-02d9dc13d6e0	hành lá	2.000	phần	\N	7
2b0c6554-1662-4df5-a56d-5038d91ac069	2026-09-22 16:40:27.935108+00	\N	f	1	3787d4e3-76f7-4e24-b1ec-02d9dc13d6e0	gạo	5.000	phần	\N	8
8320fef1-0a1b-444c-b171-d7775596886e	2026-09-22 16:40:27.935108+00	\N	f	1	3787d4e3-76f7-4e24-b1ec-02d9dc13d6e0	thịt gà	3.000	phần	\N	9
53ab375b-42bd-4495-8711-2c5f82318094	2026-09-22 16:40:27.935108+00	\N	f	1	1703c731-fb1d-4e84-ba8a-adbdeed3dad6	tiêu	3.000	phần	\N	0
ca7e5296-676b-45e0-8533-a10ea8097aad	2026-09-22 16:40:27.935108+00	\N	f	1	1703c731-fb1d-4e84-ba8a-adbdeed3dad6	đậu hũ	1.000	phần	\N	1
e18a1eb6-fcbe-4d96-bb19-99132dcc19ed	2026-09-22 16:40:27.935108+00	\N	f	1	1703c731-fb1d-4e84-ba8a-adbdeed3dad6	cá	4.000	phần	\N	2
19755bdb-9075-40aa-ad33-9ac0c3d42d02	2026-09-22 16:40:27.935108+00	\N	f	1	1703c731-fb1d-4e84-ba8a-adbdeed3dad6	hành lá	1.000	phần	\N	3
94830472-94a6-4e3e-bb1b-025ab00f532b	2026-09-22 16:40:27.935108+00	\N	f	1	1703c731-fb1d-4e84-ba8a-adbdeed3dad6	gạo	2.000	phần	\N	4
a59fca93-7098-44e3-a21b-b018e1926883	2026-09-22 16:40:27.935108+00	\N	f	1	1703c731-fb1d-4e84-ba8a-adbdeed3dad6	rau cải	5.000	phần	\N	5
c57ad79e-2ee1-442e-b33d-8f7e955b1632	2026-09-22 16:40:27.935108+00	\N	f	1	1703c731-fb1d-4e84-ba8a-adbdeed3dad6	bí đỏ	5.000	phần	\N	6
d27d5587-0242-421d-a5a4-db18a2be0281	2026-09-22 16:40:27.935108+00	\N	f	1	1703c731-fb1d-4e84-ba8a-adbdeed3dad6	gừng	5.000	phần	\N	7
323dde51-311f-4f40-b7fd-82c4d1d8ecd6	2026-09-22 16:40:27.935108+00	\N	f	1	1703c731-fb1d-4e84-ba8a-adbdeed3dad6	ớt chuông	1.000	phần	\N	8
881afc69-846c-4c90-b36e-328b1bae13fc	2026-09-22 16:40:27.935108+00	\N	f	1	1703c731-fb1d-4e84-ba8a-adbdeed3dad6	muối	2.000	phần	\N	9
e30d30e0-5330-44fb-890a-4f6f3390c7b4	2026-09-22 16:40:27.935108+00	\N	f	1	b40ee684-3a0c-495f-b9a6-bfc26d73e009	nấm	1.000	phần	\N	0
a369bf7a-fa97-4b53-8a53-5b2e8ecdbd6c	2026-09-22 16:40:27.935108+00	\N	f	1	b40ee684-3a0c-495f-b9a6-bfc26d73e009	rau thơm	4.000	phần	\N	1
7c5eb330-9112-4ad8-9cef-80e7740a37d1	2026-09-22 16:40:27.935108+00	\N	f	1	b40ee684-3a0c-495f-b9a6-bfc26d73e009	bắp cải	1.000	phần	\N	2
a6d2a966-3659-4bfd-a7b4-94675d2d91dc	2026-09-22 16:40:27.935108+00	\N	f	1	b40ee684-3a0c-495f-b9a6-bfc26d73e009	bún	2.000	phần	\N	3
7ee0226b-dc7c-40b2-aebe-fa1924b54e12	2026-09-22 16:40:27.935108+00	\N	f	1	b40ee684-3a0c-495f-b9a6-bfc26d73e009	đậu que	1.000	phần	\N	4
1c4c98eb-3c13-45cb-986b-8887832a2333	2026-09-22 16:40:27.935108+00	\N	f	1	b40ee684-3a0c-495f-b9a6-bfc26d73e009	bí đỏ	5.000	phần	\N	5
83130239-dab6-4a6f-a3ab-0901784301af	2026-09-22 16:40:27.935108+00	\N	f	1	b40ee684-3a0c-495f-b9a6-bfc26d73e009	thịt bò	2.000	phần	\N	6
ab4289ef-ad0b-4a0e-b5a4-ded4a36582bc	2026-09-22 16:40:27.935108+00	\N	f	1	b40ee684-3a0c-495f-b9a6-bfc26d73e009	gạo	2.000	phần	\N	7
d974868e-5b12-4977-8158-b678b23c49b6	2026-09-22 16:40:27.935108+00	\N	f	1	b40ee684-3a0c-495f-b9a6-bfc26d73e009	cà chua	1.000	phần	\N	8
0bf827f3-2da8-4139-b268-fca6e3d63850	2026-09-22 16:40:27.935108+00	\N	f	1	b40ee684-3a0c-495f-b9a6-bfc26d73e009	thịt heo	3.000	phần	\N	9
ed7640e4-f5e3-4b94-b4f9-13041e504514	2026-09-22 16:40:27.935108+00	\N	f	1	050092b5-1c6f-4445-a54e-612ce26146a9	muối	5.000	phần	\N	0
c1b13728-0a2f-426d-834e-7cbabdb26a97	2026-09-22 16:40:27.935108+00	\N	f	1	050092b5-1c6f-4445-a54e-612ce26146a9	nấm	1.000	phần	\N	1
862694b5-f21e-4f9f-a8f1-2102fc01ba43	2026-09-22 16:40:27.935108+00	\N	f	1	050092b5-1c6f-4445-a54e-612ce26146a9	ớt chuông	2.000	phần	\N	2
edba9e43-a01f-47cb-9e9c-d52e25268c11	2026-09-22 16:40:27.935108+00	\N	f	1	050092b5-1c6f-4445-a54e-612ce26146a9	thịt bò	2.000	phần	\N	3
e594cf29-02f5-4ee1-8a94-0bdb8cf05383	2026-09-22 16:40:27.935108+00	\N	f	1	050092b5-1c6f-4445-a54e-612ce26146a9	nước mắm	5.000	phần	\N	4
ec6890ab-b7d0-4a0e-9bcc-4b570ef6169f	2026-09-22 16:40:27.935108+00	\N	f	1	050092b5-1c6f-4445-a54e-612ce26146a9	nước tương	2.000	phần	\N	5
3da0685e-bf09-4cdb-81e0-16e29e08feba	2026-09-22 16:40:27.935108+00	\N	f	1	050092b5-1c6f-4445-a54e-612ce26146a9	cá	5.000	phần	\N	6
659ec7a6-9c14-4bf3-8826-c8fb42c50091	2026-09-22 16:40:27.935108+00	\N	f	1	050092b5-1c6f-4445-a54e-612ce26146a9	mì	2.000	phần	\N	7
08163de5-160c-4bf8-9014-e54187b3cf5c	2026-09-22 16:40:27.935108+00	\N	f	1	050092b5-1c6f-4445-a54e-612ce26146a9	hành lá	5.000	phần	\N	8
58e94331-d769-4cf1-98c6-446364b39a7a	2026-09-22 16:40:27.935108+00	\N	f	1	050092b5-1c6f-4445-a54e-612ce26146a9	cà rốt	1.000	phần	\N	9
b92f2cb2-2144-4c12-ac27-c1bb64550b12	2026-09-22 16:40:27.935108+00	\N	f	1	2394e84b-4eee-4ad5-9013-515f70a3ab4d	cà chua	5.000	phần	\N	0
63150a34-b2d2-43b7-bd13-196b1f27b0a3	2026-09-22 16:40:27.935108+00	\N	f	1	2394e84b-4eee-4ad5-9013-515f70a3ab4d	thịt heo	5.000	phần	\N	1
dd07cef2-295d-4e5a-9199-c7844c48bead	2026-09-22 16:40:27.935108+00	\N	f	1	2394e84b-4eee-4ad5-9013-515f70a3ab4d	hành lá	2.000	phần	\N	2
fdc452b6-97ca-42bc-9f6e-74495e2c57e7	2026-09-22 16:40:27.935108+00	\N	f	1	2394e84b-4eee-4ad5-9013-515f70a3ab4d	bí đỏ	2.000	phần	\N	3
5bb9ec2d-110b-4ce6-b286-8287b0cca9c1	2026-09-22 16:40:27.935108+00	\N	f	1	2394e84b-4eee-4ad5-9013-515f70a3ab4d	nước mắm	4.000	phần	\N	4
0884809c-ec33-460b-9ff8-e69983d70032	2026-09-22 16:40:27.935108+00	\N	f	1	2394e84b-4eee-4ad5-9013-515f70a3ab4d	thịt bò	2.000	phần	\N	5
453ffc09-c4a4-4358-9036-0c963817964e	2026-09-22 16:40:27.935108+00	\N	f	1	2394e84b-4eee-4ad5-9013-515f70a3ab4d	cà rốt	3.000	phần	\N	6
08b259f3-b468-4535-9c3c-b0318bf3d617	2026-09-22 16:40:27.935108+00	\N	f	1	2394e84b-4eee-4ad5-9013-515f70a3ab4d	dầu ăn	1.000	phần	\N	7
749300b2-24c3-4811-91d5-79668c47c541	2026-09-22 16:40:27.935108+00	\N	f	1	2394e84b-4eee-4ad5-9013-515f70a3ab4d	bún	1.000	phần	\N	8
4efae6f0-f5b7-411e-8716-cfe74fcf063a	2026-09-22 16:40:27.935108+00	\N	f	1	2394e84b-4eee-4ad5-9013-515f70a3ab4d	rau cải	5.000	phần	\N	9
2b0a69d8-849b-4974-aecd-fc99388e1515	2026-09-22 16:40:27.935108+00	\N	f	1	2394e84b-4eee-4ad5-9013-515f70a3ab4d	nước tương	4.000	phần	\N	10
21d99702-93c0-4ead-ad8a-092f4b426825	2026-09-22 16:40:27.935108+00	\N	f	1	0c889484-df93-4a39-897a-e992dcf725e4	hành lá	3.000	phần	\N	0
fcbd5c03-bdac-495b-acc9-003ffd101913	2026-09-22 16:40:27.935108+00	\N	f	1	0c889484-df93-4a39-897a-e992dcf725e4	bún	5.000	phần	\N	1
6007f005-78de-4cd9-b3e7-0397b5be6d29	2026-09-22 16:40:27.935108+00	\N	f	1	0c889484-df93-4a39-897a-e992dcf725e4	dầu ăn	1.000	phần	\N	2
3cdbee0d-5d30-4fb2-83f9-657aa81fe36a	2026-09-22 16:40:27.935108+00	\N	f	1	0c889484-df93-4a39-897a-e992dcf725e4	bắp cải	3.000	phần	\N	3
01ae3071-a7f8-4e0f-9fe7-5ea0f9cd3557	2026-09-22 16:40:27.935108+00	\N	f	1	0c889484-df93-4a39-897a-e992dcf725e4	gừng	4.000	phần	\N	4
12cde7a6-8d1b-40f8-8d49-4d792a0e3abd	2026-09-22 16:40:27.935108+00	\N	f	1	0c889484-df93-4a39-897a-e992dcf725e4	gạo	5.000	phần	\N	5
1b9b5bcd-9cb8-43b1-8b59-2d5e6b18d0af	2026-09-22 16:40:27.935108+00	\N	f	1	0c889484-df93-4a39-897a-e992dcf725e4	đường	1.000	phần	\N	6
af2ff997-109e-429a-8758-4aae15582d5e	2026-09-22 16:40:27.935108+00	\N	f	1	0c889484-df93-4a39-897a-e992dcf725e4	tiêu	5.000	phần	\N	7
1ed0c5a9-d70d-4245-9866-6d16c1470820	2026-09-22 16:40:27.935108+00	\N	f	1	0c889484-df93-4a39-897a-e992dcf725e4	đậu hũ	1.000	phần	\N	8
25e76253-e54a-44f7-9ea7-8737b7493c6e	2026-09-22 16:40:27.935108+00	\N	f	1	0c889484-df93-4a39-897a-e992dcf725e4	nấm	1.000	phần	\N	9
902ba354-1d0c-432a-9b26-39a87b03e092	2026-09-22 16:40:27.935108+00	\N	f	1	0c889484-df93-4a39-897a-e992dcf725e4	đậu que	1.000	phần	\N	10
24ec7509-a754-4ef2-a7b0-7e43b4b06a65	2026-09-22 16:40:27.935108+00	\N	f	1	6510d19c-8538-43f3-8d99-6ec5f71ac9cf	gừng	5.000	phần	\N	0
56ed6c63-edc0-4c89-8089-64df96661cc2	2026-09-22 16:40:27.935108+00	\N	f	1	6510d19c-8538-43f3-8d99-6ec5f71ac9cf	thịt bò	5.000	phần	\N	1
b3c1ef46-9701-4d6d-ba87-8aed5cbeccb3	2026-09-22 16:40:27.935108+00	\N	f	1	6510d19c-8538-43f3-8d99-6ec5f71ac9cf	thịt heo	5.000	phần	\N	2
4e07e5e9-257f-44b4-9a9c-8e43bb287cca	2026-09-22 16:40:27.935108+00	\N	f	1	6510d19c-8538-43f3-8d99-6ec5f71ac9cf	tiêu	4.000	phần	\N	3
d3ba83f8-f814-4612-9488-79debff0a130	2026-09-22 16:40:27.935108+00	\N	f	1	6510d19c-8538-43f3-8d99-6ec5f71ac9cf	khoai tây	5.000	phần	\N	4
6e9ca3a5-070e-4bad-b511-fdefc771aaa8	2026-09-22 16:40:27.935108+00	\N	f	1	6510d19c-8538-43f3-8d99-6ec5f71ac9cf	nước tương	2.000	phần	\N	5
ce79adcc-bdfd-4b47-9685-9c927c9ad1a7	2026-09-22 16:40:27.935108+00	\N	f	1	6510d19c-8538-43f3-8d99-6ec5f71ac9cf	muối	4.000	phần	\N	6
1bc3143c-8607-45be-840a-48d6c173c9f8	2026-09-22 16:40:27.935108+00	\N	f	1	6510d19c-8538-43f3-8d99-6ec5f71ac9cf	ớt chuông	1.000	phần	\N	7
82f2361c-ab1d-432f-bffd-32f844bec93a	2026-09-22 16:40:27.935108+00	\N	f	1	6510d19c-8538-43f3-8d99-6ec5f71ac9cf	bí đỏ	5.000	phần	\N	8
fcd55a1b-7652-4bdb-b210-05ffa0ed9e13	2026-09-22 16:40:27.935108+00	\N	f	1	6510d19c-8538-43f3-8d99-6ec5f71ac9cf	đường	2.000	phần	\N	9
96433f82-9a76-458f-be46-fc3cb1d4c178	2026-09-22 16:40:27.935108+00	\N	f	1	6510d19c-8538-43f3-8d99-6ec5f71ac9cf	đậu hũ	4.000	phần	\N	10
130adb53-d1d8-4659-b477-8b0b13509fe5	2026-09-22 16:40:27.935108+00	\N	f	1	970ab102-0421-42a7-8494-6b67971d7ac3	nước mắm	2.000	phần	\N	0
3214f947-427d-4a86-bc61-88045e05d870	2026-09-22 16:40:27.935108+00	\N	f	1	970ab102-0421-42a7-8494-6b67971d7ac3	thịt gà	1.000	phần	\N	1
68374821-ac6f-47a5-8bb2-4c77aa3b50f8	2026-09-22 16:40:27.935108+00	\N	f	1	970ab102-0421-42a7-8494-6b67971d7ac3	thịt bò	2.000	phần	\N	2
d916860a-96c4-445b-a100-0370f5b08bce	2026-09-22 16:40:27.935108+00	\N	f	1	970ab102-0421-42a7-8494-6b67971d7ac3	gạo	3.000	phần	\N	3
d7848912-6c29-47c4-b607-d6ba72ebce5d	2026-09-22 16:40:27.935108+00	\N	f	1	970ab102-0421-42a7-8494-6b67971d7ac3	nước tương	3.000	phần	\N	4
05dc89b0-03c9-40fc-a6a3-769af3748df9	2026-09-22 16:40:27.935108+00	\N	f	1	970ab102-0421-42a7-8494-6b67971d7ac3	hành lá	5.000	phần	\N	5
bd3d67e6-4afc-489e-a54f-775157b8c689	2026-09-22 16:40:27.935108+00	\N	f	1	970ab102-0421-42a7-8494-6b67971d7ac3	bắp cải	1.000	phần	\N	6
6bfe697c-1ad2-4249-84c0-fe35764e4fbf	2026-09-22 16:40:27.935108+00	\N	f	1	970ab102-0421-42a7-8494-6b67971d7ac3	mì	3.000	phần	\N	7
7e4a83a8-ff8e-402b-8362-3f0450262e25	2026-09-22 16:40:27.935108+00	\N	f	1	970ab102-0421-42a7-8494-6b67971d7ac3	đậu que	2.000	phần	\N	8
8f9139da-0623-4822-b202-b946bb6461e6	2026-09-22 16:40:27.935108+00	\N	f	1	970ab102-0421-42a7-8494-6b67971d7ac3	muối	2.000	phần	\N	9
6261206b-7198-41f6-bbb8-35cbc6fe1659	2026-09-22 16:40:27.935108+00	\N	f	1	970ab102-0421-42a7-8494-6b67971d7ac3	trứng	5.000	phần	\N	10
37b377f6-53a2-45e7-90f6-fa4e7f3896e0	2026-09-22 16:40:27.935108+00	\N	f	1	75cfa00e-2706-4f44-bb2e-a391e66446d1	tôm	2.000	phần	\N	0
6baafdda-2443-4b45-939a-bae8df673b0b	2026-09-22 16:40:27.935108+00	\N	f	1	75cfa00e-2706-4f44-bb2e-a391e66446d1	ớt chuông	5.000	phần	\N	1
5bd44564-5d9d-4af5-9a68-c845b7d1011c	2026-09-22 16:40:27.935108+00	\N	f	1	75cfa00e-2706-4f44-bb2e-a391e66446d1	cà chua	1.000	phần	\N	2
58df9cca-e35b-4367-8e6b-2f6936906e9b	2026-09-22 16:40:27.935108+00	\N	f	1	75cfa00e-2706-4f44-bb2e-a391e66446d1	nước mắm	4.000	phần	\N	3
793696fb-eca1-4908-8a6d-a3a6d5382d26	2026-09-22 16:40:27.935108+00	\N	f	1	75cfa00e-2706-4f44-bb2e-a391e66446d1	hành tây	1.000	phần	\N	4
b9c9d869-6748-401a-948f-e68811deb9b4	2026-09-22 16:40:27.935108+00	\N	f	1	75cfa00e-2706-4f44-bb2e-a391e66446d1	tiêu	4.000	phần	\N	5
5af4e36e-2ef8-4932-81df-29bafa1cbc82	2026-09-22 16:40:27.935108+00	\N	f	1	75cfa00e-2706-4f44-bb2e-a391e66446d1	cà rốt	1.000	phần	\N	6
40c4c150-2e44-4ead-a0ac-921bdde078dc	2026-09-22 16:40:27.935108+00	\N	f	1	75cfa00e-2706-4f44-bb2e-a391e66446d1	trứng	1.000	phần	\N	7
f6e66327-af1c-49c1-8e78-fe01d2eb536c	2026-09-22 16:40:27.935108+00	\N	f	1	75cfa00e-2706-4f44-bb2e-a391e66446d1	đường	2.000	phần	\N	8
8f6025d9-6466-49b2-b006-ef7e48f43884	2026-09-22 16:40:27.935108+00	\N	f	1	75cfa00e-2706-4f44-bb2e-a391e66446d1	tỏi	5.000	phần	\N	9
8fafeb5e-0998-44a5-8ad0-914c770ab351	2026-09-22 16:40:27.935108+00	\N	f	1	75cfa00e-2706-4f44-bb2e-a391e66446d1	bí đỏ	4.000	phần	\N	10
7bafe0b4-652c-48df-8862-29a7e302dd0e	2026-09-22 16:40:27.935108+00	\N	f	1	788bda25-29a3-4dc9-887a-229470df72b1	khoai tây	4.000	phần	\N	0
0aa9f048-103e-4060-aed2-a8ad8376f764	2026-09-22 16:40:27.935108+00	\N	f	1	788bda25-29a3-4dc9-887a-229470df72b1	hành tây	2.000	phần	\N	1
0809a837-610f-4820-8464-e2d1a07821b7	2026-09-22 16:40:27.935108+00	\N	f	1	788bda25-29a3-4dc9-887a-229470df72b1	thịt heo	2.000	phần	\N	2
bb693e5a-87e8-4826-a545-e809d5b22d9e	2026-09-22 16:40:27.935108+00	\N	f	1	788bda25-29a3-4dc9-887a-229470df72b1	gạo	4.000	phần	\N	3
11afe0f0-f2d1-428e-8b23-2b6979ecdd5a	2026-09-22 16:40:27.935108+00	\N	f	1	788bda25-29a3-4dc9-887a-229470df72b1	muối	5.000	phần	\N	4
dde35a11-5484-4006-8ab0-9367ed7a770b	2026-09-22 16:40:27.935108+00	\N	f	1	788bda25-29a3-4dc9-887a-229470df72b1	nước tương	2.000	phần	\N	5
f0b88f06-e19e-44c6-969c-c4a316349fba	2026-09-22 16:40:27.935108+00	\N	f	1	788bda25-29a3-4dc9-887a-229470df72b1	gừng	1.000	phần	\N	6
3a1bb11c-3b2d-4a97-ad4a-9f3b70bee132	2026-09-22 16:40:27.935108+00	\N	f	1	788bda25-29a3-4dc9-887a-229470df72b1	cà rốt	3.000	phần	\N	7
b0568e57-b228-4f04-ae27-ad0fc72c3475	2026-09-22 16:40:27.935108+00	\N	f	1	788bda25-29a3-4dc9-887a-229470df72b1	dầu ăn	4.000	phần	\N	8
2a504c7b-43e1-49d1-8e4e-fbb7ae4fc80b	2026-09-22 16:40:27.935108+00	\N	f	1	788bda25-29a3-4dc9-887a-229470df72b1	đậu que	1.000	phần	\N	9
54ac450f-fa0a-49a7-bfa7-6ed0eb33b362	2026-09-22 16:40:27.935108+00	\N	f	1	788bda25-29a3-4dc9-887a-229470df72b1	bí đỏ	5.000	phần	\N	10
f9286faf-28ff-459f-b73b-1cdf5a435050	2026-09-22 16:40:27.935108+00	\N	f	1	6c5a11c1-fbae-44ca-92e5-e723cc2041e9	hành lá	5.000	phần	\N	0
ae1601c1-a625-4998-9b71-26713b70b52c	2026-09-22 16:40:27.935108+00	\N	f	1	6c5a11c1-fbae-44ca-92e5-e723cc2041e9	nước mắm	4.000	phần	\N	1
3decb3d8-6903-45a0-b086-696e4d3841e8	2026-09-22 16:40:27.935108+00	\N	f	1	6c5a11c1-fbae-44ca-92e5-e723cc2041e9	gừng	4.000	phần	\N	2
e894fbec-f036-4191-915c-38f22af7c00b	2026-09-22 16:40:27.935108+00	\N	f	1	6c5a11c1-fbae-44ca-92e5-e723cc2041e9	bắp cải	3.000	phần	\N	3
8754f547-0613-4ddc-b24f-03a77946128e	2026-09-22 16:40:27.935108+00	\N	f	1	6c5a11c1-fbae-44ca-92e5-e723cc2041e9	hành tây	2.000	phần	\N	4
fcb47071-9fdf-4284-b164-152494b93e57	2026-09-22 16:40:27.935108+00	\N	f	1	6c5a11c1-fbae-44ca-92e5-e723cc2041e9	đường	2.000	phần	\N	5
17a632fe-d968-43a2-acea-6d86a60b2506	2026-09-22 16:40:27.935108+00	\N	f	1	6c5a11c1-fbae-44ca-92e5-e723cc2041e9	ớt chuông	3.000	phần	\N	6
fa72391b-5fe0-4631-afcd-04d5d6a968cc	2026-09-22 16:40:27.935108+00	\N	f	1	6c5a11c1-fbae-44ca-92e5-e723cc2041e9	nước tương	3.000	phần	\N	7
85e2c2f0-3386-4f34-a6dd-7a2bfe96b9f9	2026-09-22 16:40:27.935108+00	\N	f	1	6c5a11c1-fbae-44ca-92e5-e723cc2041e9	dầu ăn	1.000	phần	\N	8
9d89f6dc-b92c-4688-abcb-bf6ca4eb924d	2026-09-22 16:40:27.935108+00	\N	f	1	6c5a11c1-fbae-44ca-92e5-e723cc2041e9	trứng	5.000	phần	\N	9
d3da8e97-dca3-47e4-a519-af746506c702	2026-09-22 16:40:27.935108+00	\N	f	1	64ec096c-f2d9-410a-aa22-ee25b77345cb	hành lá	5.000	phần	\N	0
959ec9ef-0905-415c-9837-ee35749af5b7	2026-09-22 16:40:27.935108+00	\N	f	1	64ec096c-f2d9-410a-aa22-ee25b77345cb	nước tương	3.000	phần	\N	1
59223c9b-ba6c-4721-9790-c3e01c4e3d2f	2026-09-22 16:40:27.935108+00	\N	f	1	64ec096c-f2d9-410a-aa22-ee25b77345cb	đậu hũ	2.000	phần	\N	2
d0e56668-a6e3-4cbd-9b4d-c8ecf48925d7	2026-09-22 16:40:27.935108+00	\N	f	1	64ec096c-f2d9-410a-aa22-ee25b77345cb	hành tây	5.000	phần	\N	3
e89db2e8-923a-4879-a3f5-23906b14b163	2026-09-22 16:40:27.935108+00	\N	f	1	64ec096c-f2d9-410a-aa22-ee25b77345cb	bún	5.000	phần	\N	4
30162a6f-3b14-4dde-bc9c-315ffe1c0d8d	2026-09-22 16:40:27.935108+00	\N	f	1	64ec096c-f2d9-410a-aa22-ee25b77345cb	mì	4.000	phần	\N	5
c738c0c8-058f-4f79-aff3-ccd706698591	2026-09-22 16:40:27.935108+00	\N	f	1	64ec096c-f2d9-410a-aa22-ee25b77345cb	rau thơm	5.000	phần	\N	6
72a26ed4-5c9d-46f3-be66-4ee006609b7e	2026-09-22 16:40:27.935108+00	\N	f	1	64ec096c-f2d9-410a-aa22-ee25b77345cb	gừng	3.000	phần	\N	7
8ad75edb-0763-45ad-8a4b-c2ed86d0b000	2026-09-22 16:40:27.935108+00	\N	f	1	64ec096c-f2d9-410a-aa22-ee25b77345cb	rau cải	4.000	phần	\N	8
e1bea6d2-6917-4914-9076-567c95466269	2026-09-22 16:40:27.935108+00	\N	f	1	64ec096c-f2d9-410a-aa22-ee25b77345cb	tỏi	2.000	phần	\N	9
f0a23e37-9b50-45b4-87e3-38b15b70313a	2026-09-22 16:40:27.935108+00	\N	f	1	f1a8a3e3-9e06-4520-94f8-7b1dcce6166a	hành lá	5.000	phần	\N	0
645658e4-df13-4536-b5ec-f06a413edf5e	2026-09-22 16:40:27.935108+00	\N	f	1	f1a8a3e3-9e06-4520-94f8-7b1dcce6166a	cà rốt	5.000	phần	\N	1
1072604b-0faa-4b2b-8177-ec6a0cb1d60e	2026-09-22 16:40:27.935108+00	\N	f	1	f1a8a3e3-9e06-4520-94f8-7b1dcce6166a	bún	1.000	phần	\N	2
b5343986-2f6d-46e0-a0a4-09ae44e2f55b	2026-09-22 16:40:27.935108+00	\N	f	1	f1a8a3e3-9e06-4520-94f8-7b1dcce6166a	tôm	1.000	phần	\N	3
fc0db9c2-f59d-47b9-905c-2687b52eefab	2026-09-22 16:40:27.935108+00	\N	f	1	f1a8a3e3-9e06-4520-94f8-7b1dcce6166a	khoai tây	1.000	phần	\N	4
11f33f71-344d-4d30-916e-cbfb4a26e7b9	2026-09-22 16:40:27.935108+00	\N	f	1	f1a8a3e3-9e06-4520-94f8-7b1dcce6166a	đường	3.000	phần	\N	5
4bf9745d-891b-449a-a5d2-a1bc2f12ba26	2026-09-22 16:40:27.935108+00	\N	f	1	f1a8a3e3-9e06-4520-94f8-7b1dcce6166a	ớt chuông	1.000	phần	\N	6
945200dc-5d15-4815-8804-43e0b65d1071	2026-09-22 16:40:27.935108+00	\N	f	1	f1a8a3e3-9e06-4520-94f8-7b1dcce6166a	hành tây	4.000	phần	\N	7
3df2327e-e45e-4030-880f-dafa2683399a	2026-09-22 16:40:27.935108+00	\N	f	1	f1a8a3e3-9e06-4520-94f8-7b1dcce6166a	trứng	3.000	phần	\N	8
6c52cbad-024f-4d78-81f2-c2c76d677061	2026-09-22 16:40:27.935108+00	\N	f	1	f1a8a3e3-9e06-4520-94f8-7b1dcce6166a	nước mắm	4.000	phần	\N	9
1e413dfe-344d-42c3-8967-78923e50d99e	2026-09-22 16:40:27.935108+00	\N	f	1	a347dce3-40ce-4ffb-8e3d-f24d88d19404	bún	5.000	phần	\N	0
31fc2d83-adf1-4761-a113-198ac9c5d226	2026-09-22 16:40:27.935108+00	\N	f	1	a347dce3-40ce-4ffb-8e3d-f24d88d19404	thịt gà	1.000	phần	\N	1
fbdff362-9041-4f51-9c9e-966cf5482dad	2026-09-22 16:40:27.935108+00	\N	f	1	a347dce3-40ce-4ffb-8e3d-f24d88d19404	thịt bò	3.000	phần	\N	2
8da7c821-fe4b-43a1-a619-cf250f38d99b	2026-09-22 16:40:27.935108+00	\N	f	1	a347dce3-40ce-4ffb-8e3d-f24d88d19404	đường	3.000	phần	\N	3
5944aa85-30a5-4f30-972c-7913ce8a2754	2026-09-22 16:40:27.935108+00	\N	f	1	a347dce3-40ce-4ffb-8e3d-f24d88d19404	hành lá	5.000	phần	\N	4
f9d28c2e-1565-408b-87d1-cf002811f284	2026-09-22 16:40:27.935108+00	\N	f	1	a347dce3-40ce-4ffb-8e3d-f24d88d19404	rau cải	4.000	phần	\N	5
94770733-974a-46c9-bb64-97e7938ca0b5	2026-09-22 16:40:27.935108+00	\N	f	1	a347dce3-40ce-4ffb-8e3d-f24d88d19404	gừng	1.000	phần	\N	6
1fd8d609-fde1-4475-ab0a-1914ab59401d	2026-09-22 16:40:27.935108+00	\N	f	1	a347dce3-40ce-4ffb-8e3d-f24d88d19404	muối	2.000	phần	\N	7
205a5845-9c4e-487d-ba78-32ad7125f2d6	2026-09-22 16:40:27.935108+00	\N	f	1	a347dce3-40ce-4ffb-8e3d-f24d88d19404	rau thơm	3.000	phần	\N	8
f4fc6b56-f8f6-4938-9fa8-c8b2d5218645	2026-09-22 16:40:27.935108+00	\N	f	1	a347dce3-40ce-4ffb-8e3d-f24d88d19404	cà chua	4.000	phần	\N	9
827b3081-ca80-435b-812a-74891fe12c3e	2026-09-22 16:40:27.935108+00	\N	f	1	a347dce3-40ce-4ffb-8e3d-f24d88d19404	ớt chuông	5.000	phần	\N	10
70d2304b-e552-4d34-8ded-5a0c3d1a8a81	2026-09-22 16:40:27.935108+00	\N	f	1	a347dce3-40ce-4ffb-8e3d-f24d88d19404	khoai tây	2.000	phần	\N	11
c587a1d7-233a-4a41-9420-f4e033188a8c	2026-09-22 16:40:27.935108+00	\N	f	1	018f344f-43b8-4593-bb41-5c94eb229f62	tôm	5.000	phần	\N	0
242d774b-0761-44d3-a742-7aa669b8134d	2026-09-22 16:40:27.935108+00	\N	f	1	018f344f-43b8-4593-bb41-5c94eb229f62	cà rốt	2.000	phần	\N	1
6ebe3f12-db7b-43a3-a095-b387beb24631	2026-09-22 16:40:27.935108+00	\N	f	1	018f344f-43b8-4593-bb41-5c94eb229f62	bún	2.000	phần	\N	2
cd793489-c57e-494b-ac3e-7a7749ed76f5	2026-09-22 16:40:27.935108+00	\N	f	1	018f344f-43b8-4593-bb41-5c94eb229f62	bí đỏ	4.000	phần	\N	3
2a5f34ce-dee4-4ba2-ad33-3189fb51b294	2026-09-22 16:40:27.935108+00	\N	f	1	018f344f-43b8-4593-bb41-5c94eb229f62	gừng	3.000	phần	\N	4
f3e65859-2269-4c0b-ab1d-0b5033899491	2026-09-22 16:40:27.935108+00	\N	f	1	018f344f-43b8-4593-bb41-5c94eb229f62	đậu que	2.000	phần	\N	5
4656655e-1946-47f7-b12e-aeef75ee3b32	2026-09-22 16:40:27.935108+00	\N	f	1	018f344f-43b8-4593-bb41-5c94eb229f62	cá	1.000	phần	\N	6
64c4c1eb-d593-48a5-a016-c957a3a314fb	2026-09-22 16:40:27.935108+00	\N	f	1	018f344f-43b8-4593-bb41-5c94eb229f62	rau thơm	3.000	phần	\N	7
400007f7-0942-47bc-a091-b1ebc70fb79b	2026-09-22 16:40:27.935108+00	\N	f	1	018f344f-43b8-4593-bb41-5c94eb229f62	mì	2.000	phần	\N	8
ef71256e-e313-4043-a98a-691f07c4611d	2026-09-22 16:40:27.935108+00	\N	f	1	018f344f-43b8-4593-bb41-5c94eb229f62	tiêu	1.000	phần	\N	9
85961cc1-884a-40b1-93f4-d957b3f689a7	2026-09-22 16:40:27.935108+00	\N	f	1	faf4d8d6-f61e-4245-ac7d-c2e75e566caa	nấm	3.000	phần	\N	0
1108a3ff-15ca-4fcf-8b16-2b1b2a15e825	2026-09-22 16:40:27.935108+00	\N	f	1	faf4d8d6-f61e-4245-ac7d-c2e75e566caa	đậu hũ	4.000	phần	\N	1
63d4e5f9-b2a0-4356-966e-76ab41ea80ab	2026-09-22 16:40:27.935108+00	\N	f	1	faf4d8d6-f61e-4245-ac7d-c2e75e566caa	mì	5.000	phần	\N	2
a0f677fa-b92c-4c5a-8e7f-537590363385	2026-09-22 16:40:27.935108+00	\N	f	1	faf4d8d6-f61e-4245-ac7d-c2e75e566caa	hành lá	5.000	phần	\N	3
e367c313-32f1-4971-8275-4a85482fa0d0	2026-09-22 16:40:27.935108+00	\N	f	1	faf4d8d6-f61e-4245-ac7d-c2e75e566caa	cá	3.000	phần	\N	4
fb2b8364-f448-45ec-b1fc-5ab41b9afe12	2026-09-22 16:40:27.935108+00	\N	f	1	faf4d8d6-f61e-4245-ac7d-c2e75e566caa	nước mắm	4.000	phần	\N	5
652d5c5d-ce77-418a-99e4-d3f642350c59	2026-09-22 16:40:27.935108+00	\N	f	1	faf4d8d6-f61e-4245-ac7d-c2e75e566caa	tỏi	2.000	phần	\N	6
f28d350f-0150-4af4-aac7-f0d748da66cf	2026-09-22 16:40:27.935108+00	\N	f	1	faf4d8d6-f61e-4245-ac7d-c2e75e566caa	tôm	5.000	phần	\N	7
5a5ba36a-21c7-4bab-8592-05f6bf37f6cb	2026-09-22 16:40:27.935108+00	\N	f	1	faf4d8d6-f61e-4245-ac7d-c2e75e566caa	thịt bò	3.000	phần	\N	8
0c1b1cfd-4fc4-4a88-b6fd-cbdf9fccdfd7	2026-09-22 16:40:27.935108+00	\N	f	1	faf4d8d6-f61e-4245-ac7d-c2e75e566caa	nước tương	5.000	phần	\N	9
86a7dba2-5626-44e8-9d15-8974e2e2ea05	2026-09-22 16:40:27.935108+00	\N	f	1	faf4d8d6-f61e-4245-ac7d-c2e75e566caa	gạo	2.000	phần	\N	10
61c32c75-8d0d-4170-b5e5-8bb4151b9bf5	2026-09-22 16:40:27.935108+00	\N	f	1	d158485e-362a-424a-97e5-09b0c64ef412	thịt gà	5.000	phần	\N	0
f67a75fa-933c-431a-83fc-ca6e5a12d9d1	2026-09-22 16:40:27.935108+00	\N	f	1	d158485e-362a-424a-97e5-09b0c64ef412	bí đỏ	4.000	phần	\N	1
ab7e249c-62bb-4dfe-bf7a-701751475525	2026-09-22 16:40:27.935108+00	\N	f	1	d158485e-362a-424a-97e5-09b0c64ef412	rau cải	3.000	phần	\N	2
77324be9-0232-4d9e-b5ca-2e8693167551	2026-09-22 16:40:27.935108+00	\N	f	1	d158485e-362a-424a-97e5-09b0c64ef412	gạo	5.000	phần	\N	3
c6617139-f28f-4160-bd05-b9e2681e9d3a	2026-09-22 16:40:27.935108+00	\N	f	1	d158485e-362a-424a-97e5-09b0c64ef412	cà chua	5.000	phần	\N	4
916ff797-ff41-4813-87ac-c1ec0a69d19b	2026-09-22 16:40:27.935108+00	\N	f	1	d158485e-362a-424a-97e5-09b0c64ef412	cá	3.000	phần	\N	5
01f18b58-2351-4783-9dff-343b53f45c17	2026-09-22 16:40:27.935108+00	\N	f	1	d158485e-362a-424a-97e5-09b0c64ef412	tỏi	1.000	phần	\N	6
8c7b2ee0-2074-4efc-a3c1-5cf36ad3da9c	2026-09-22 16:40:27.935108+00	\N	f	1	d158485e-362a-424a-97e5-09b0c64ef412	nấm	5.000	phần	\N	7
56cfaa40-94d5-4231-b48d-1ab15b7cc9e9	2026-09-22 16:40:27.935108+00	\N	f	1	d158485e-362a-424a-97e5-09b0c64ef412	mì	3.000	phần	\N	8
6ceee696-8a07-4183-adb1-14b0dd3c1b39	2026-09-22 16:40:27.935108+00	\N	f	1	d158485e-362a-424a-97e5-09b0c64ef412	bún	4.000	phần	\N	9
23526d47-31b0-45d8-b992-16d52c773744	2026-09-22 16:40:27.935108+00	\N	f	1	d158485e-362a-424a-97e5-09b0c64ef412	rau thơm	3.000	phần	\N	10
9536b638-8e8f-4327-834b-00e15684425e	2026-09-22 16:40:27.935108+00	\N	f	1	4282d768-5d60-4c3b-bb2a-022ef252b7fe	thịt heo	5.000	phần	\N	0
d204f163-331b-43ec-b80b-ded480d44914	2026-09-22 16:40:27.935108+00	\N	f	1	4282d768-5d60-4c3b-bb2a-022ef252b7fe	thịt bò	3.000	phần	\N	1
6fe1381e-999c-44ae-8bb0-1ad74a2489c9	2026-09-22 16:40:27.935108+00	\N	f	1	4282d768-5d60-4c3b-bb2a-022ef252b7fe	nấm	3.000	phần	\N	2
2c5db26d-9392-421a-ab28-690c7f3e006d	2026-09-22 16:40:27.935108+00	\N	f	1	4282d768-5d60-4c3b-bb2a-022ef252b7fe	đậu que	5.000	phần	\N	3
a0e171d0-40f2-4b84-83ee-2796c395fc8f	2026-09-22 16:40:27.935108+00	\N	f	1	4282d768-5d60-4c3b-bb2a-022ef252b7fe	dầu ăn	1.000	phần	\N	4
4d1c47fc-673c-4a58-bb06-b323f4260d2b	2026-09-22 16:40:27.935108+00	\N	f	1	4282d768-5d60-4c3b-bb2a-022ef252b7fe	khoai tây	2.000	phần	\N	5
4ab15213-959c-4483-ac9b-8c56b9378eb1	2026-09-22 16:40:27.935108+00	\N	f	1	4282d768-5d60-4c3b-bb2a-022ef252b7fe	tiêu	1.000	phần	\N	6
8384baa9-5bea-4c96-946b-514c734e5d90	2026-09-22 16:40:27.935108+00	\N	f	1	4282d768-5d60-4c3b-bb2a-022ef252b7fe	bún	5.000	phần	\N	7
8a37de92-1fa6-45f0-9a22-528c5d2aebcd	2026-09-22 16:40:27.935108+00	\N	f	1	4282d768-5d60-4c3b-bb2a-022ef252b7fe	hành lá	2.000	phần	\N	8
b323a168-9f0f-42d5-9344-13f83b1c6b28	2026-09-22 16:40:27.935108+00	\N	f	1	4282d768-5d60-4c3b-bb2a-022ef252b7fe	rau cải	2.000	phần	\N	9
6dee8b62-2a17-4c18-b1fb-014d68b35f29	2026-09-22 16:40:27.935108+00	\N	f	1	4282d768-5d60-4c3b-bb2a-022ef252b7fe	đường	4.000	phần	\N	10
58cb8aff-ce94-4e61-9fea-3889e25f0f03	2026-09-22 16:40:27.935108+00	\N	f	1	25dc4e45-c780-4f24-bf7f-30f10f1c8cfe	hành lá	3.000	phần	\N	0
ca6a59f2-23bd-498d-bffe-1781f89315b3	2026-09-22 16:40:27.935108+00	\N	f	1	25dc4e45-c780-4f24-bf7f-30f10f1c8cfe	hành tây	2.000	phần	\N	1
b3254edb-934f-465f-acc7-2f6c89570317	2026-09-22 16:40:27.935108+00	\N	f	1	25dc4e45-c780-4f24-bf7f-30f10f1c8cfe	gạo	2.000	phần	\N	2
ee41f957-b8be-4a90-86d4-e432464aa548	2026-09-22 16:40:27.935108+00	\N	f	1	25dc4e45-c780-4f24-bf7f-30f10f1c8cfe	nước mắm	2.000	phần	\N	3
ed1b16bb-e785-40df-8e77-aec7911dbe7a	2026-09-22 16:40:27.935108+00	\N	f	1	25dc4e45-c780-4f24-bf7f-30f10f1c8cfe	khoai tây	1.000	phần	\N	4
ff85c417-f2a3-4a7e-9efe-cf4346fa2b68	2026-09-22 16:40:27.935108+00	\N	f	1	25dc4e45-c780-4f24-bf7f-30f10f1c8cfe	ớt chuông	1.000	phần	\N	5
042dee2b-2b5d-4099-9dfc-276c43db8c27	2026-09-22 16:40:27.935108+00	\N	f	1	25dc4e45-c780-4f24-bf7f-30f10f1c8cfe	rau thơm	1.000	phần	\N	6
203b146b-6d1a-4951-82b3-d7e37a71af40	2026-09-22 16:40:27.935108+00	\N	f	1	25dc4e45-c780-4f24-bf7f-30f10f1c8cfe	tôm	3.000	phần	\N	7
eab64f45-9948-4c32-ba22-44c8d0a8f615	2026-09-22 16:40:27.935108+00	\N	f	1	25dc4e45-c780-4f24-bf7f-30f10f1c8cfe	thịt gà	5.000	phần	\N	8
ee1a6ea0-c371-49f8-820f-4c9703f5e855	2026-09-22 16:40:27.935108+00	\N	f	1	25dc4e45-c780-4f24-bf7f-30f10f1c8cfe	nước tương	3.000	phần	\N	9
bf38206f-ad6d-4e52-9859-10fd7efc5eb7	2026-09-22 16:40:27.935108+00	\N	f	1	25dc4e45-c780-4f24-bf7f-30f10f1c8cfe	cà chua	1.000	phần	\N	10
d99af1a7-276c-4d92-ad82-442dc142a4e0	2026-09-22 16:40:27.935108+00	\N	f	1	65dde4a2-ae27-4dfe-ba8d-0d8acf6d615e	hành lá	5.000	phần	\N	0
b41699a8-e349-4533-9321-d763c28563d8	2026-09-22 16:40:27.935108+00	\N	f	1	65dde4a2-ae27-4dfe-ba8d-0d8acf6d615e	gừng	1.000	phần	\N	1
641a5f7e-c749-4c79-9d6b-eb06796e5deb	2026-09-22 16:40:27.935108+00	\N	f	1	65dde4a2-ae27-4dfe-ba8d-0d8acf6d615e	tiêu	4.000	phần	\N	2
57e79fea-e451-4b2d-bfab-e308541ed6a2	2026-09-22 16:40:27.935108+00	\N	f	1	65dde4a2-ae27-4dfe-ba8d-0d8acf6d615e	đậu hũ	1.000	phần	\N	3
219f83ce-fe79-46e0-80fc-3c070c6ad48e	2026-09-22 16:40:27.935108+00	\N	f	1	65dde4a2-ae27-4dfe-ba8d-0d8acf6d615e	nước mắm	5.000	phần	\N	4
00e91936-cdf4-4c08-9339-2b02272767b5	2026-09-22 16:40:27.935108+00	\N	f	1	65dde4a2-ae27-4dfe-ba8d-0d8acf6d615e	muối	5.000	phần	\N	5
6b5339dd-e8b8-4243-9f66-a99801eec2d1	2026-09-22 16:40:27.935108+00	\N	f	1	65dde4a2-ae27-4dfe-ba8d-0d8acf6d615e	tôm	1.000	phần	\N	6
81d2138f-2c21-457f-b5eb-c87705a5aecb	2026-09-22 16:40:27.935108+00	\N	f	1	65dde4a2-ae27-4dfe-ba8d-0d8acf6d615e	mì	2.000	phần	\N	7
90d6a360-9e84-4d28-aabd-0d8219b31f4e	2026-09-22 16:40:27.935108+00	\N	f	1	65dde4a2-ae27-4dfe-ba8d-0d8acf6d615e	thịt gà	1.000	phần	\N	8
3160504a-48ec-4fbe-82bd-739fee17c1ee	2026-09-22 16:40:27.935108+00	\N	f	1	65dde4a2-ae27-4dfe-ba8d-0d8acf6d615e	cá	1.000	phần	\N	9
a35117fd-adf8-4781-bdbd-8d9c900bdbc0	2026-09-22 16:40:27.935108+00	\N	f	1	65dde4a2-ae27-4dfe-ba8d-0d8acf6d615e	bí đỏ	4.000	phần	\N	10
fd080624-f252-4c64-a153-25b10c5ef381	2026-09-22 16:40:27.935108+00	\N	f	1	bddd9f3d-8139-420a-aecc-70be4d87d38d	mì	4.000	phần	\N	0
3a09fd6e-9166-440a-9cc6-e19ac86e9a6d	2026-09-22 16:40:27.935108+00	\N	f	1	bddd9f3d-8139-420a-aecc-70be4d87d38d	cà chua	2.000	phần	\N	1
828ffa27-9e15-4872-9d16-e6c7908794cf	2026-09-22 16:40:27.935108+00	\N	f	1	bddd9f3d-8139-420a-aecc-70be4d87d38d	ớt chuông	2.000	phần	\N	2
8266dc07-86fa-4392-98a4-aec2e8d16a92	2026-09-22 16:40:27.935108+00	\N	f	1	bddd9f3d-8139-420a-aecc-70be4d87d38d	thịt bò	1.000	phần	\N	3
beb2bc6e-c2de-4877-8f99-9dfd3e1f832c	2026-09-22 16:40:27.935108+00	\N	f	1	bddd9f3d-8139-420a-aecc-70be4d87d38d	nước tương	5.000	phần	\N	4
1dc9081e-b88c-4405-a20e-1b85eb8ee8f0	2026-09-22 16:40:27.935108+00	\N	f	1	bddd9f3d-8139-420a-aecc-70be4d87d38d	muối	1.000	phần	\N	5
80cc8bfd-9d95-4734-8c74-02c371cda553	2026-09-22 16:40:27.935108+00	\N	f	1	bddd9f3d-8139-420a-aecc-70be4d87d38d	thịt gà	4.000	phần	\N	6
f2f576ff-5e94-4430-8709-4812d0fce4f2	2026-09-22 16:40:27.935108+00	\N	f	1	bddd9f3d-8139-420a-aecc-70be4d87d38d	tỏi	3.000	phần	\N	7
b710d035-81ea-4e12-aed6-6b7652e90418	2026-09-22 16:40:27.935108+00	\N	f	1	bddd9f3d-8139-420a-aecc-70be4d87d38d	rau cải	1.000	phần	\N	8
bbfbf8da-623a-41ee-942b-6dddf0ca60b8	2026-09-22 16:40:27.935108+00	\N	f	1	bddd9f3d-8139-420a-aecc-70be4d87d38d	tiêu	2.000	phần	\N	9
a7524b2a-1070-440b-a4ff-19225539bae4	2026-09-22 16:40:27.935108+00	\N	f	1	32b68618-1ac3-4b3c-95fb-6fb93ef0fa5b	đậu hũ	3.000	phần	\N	0
3ea9943a-50ed-45d8-b994-3c5b0884a9b6	2026-09-22 16:40:27.935108+00	\N	f	1	32b68618-1ac3-4b3c-95fb-6fb93ef0fa5b	đậu que	5.000	phần	\N	1
1fb9625c-25ff-4f03-a8a4-9b4aae13cd5a	2026-09-22 16:40:27.935108+00	\N	f	1	32b68618-1ac3-4b3c-95fb-6fb93ef0fa5b	trứng	4.000	phần	\N	2
553b45bf-8cca-4f0f-aa3c-fb8074c4673b	2026-09-22 16:40:27.935108+00	\N	f	1	32b68618-1ac3-4b3c-95fb-6fb93ef0fa5b	rau cải	4.000	phần	\N	3
83e7d173-a8ab-47b9-93a9-c960fc9cd299	2026-09-22 16:40:27.935108+00	\N	f	1	32b68618-1ac3-4b3c-95fb-6fb93ef0fa5b	khoai tây	2.000	phần	\N	4
9e42f154-9287-4229-9510-92c598eec17e	2026-09-22 16:40:27.935108+00	\N	f	1	32b68618-1ac3-4b3c-95fb-6fb93ef0fa5b	tỏi	3.000	phần	\N	5
c004d9bc-6e6b-4343-8d9f-d87edc06762f	2026-09-22 16:40:27.935108+00	\N	f	1	32b68618-1ac3-4b3c-95fb-6fb93ef0fa5b	nước tương	2.000	phần	\N	6
7f52b952-b82f-4378-b569-b6318efa1f87	2026-09-22 16:40:27.935108+00	\N	f	1	32b68618-1ac3-4b3c-95fb-6fb93ef0fa5b	mì	1.000	phần	\N	7
c4c5d8e9-747e-4f80-a5cf-e90cd22c9d86	2026-09-22 16:40:27.935108+00	\N	f	1	32b68618-1ac3-4b3c-95fb-6fb93ef0fa5b	bún	5.000	phần	\N	8
d2231398-b057-4198-8680-21eb406549fd	2026-09-22 16:40:27.935108+00	\N	f	1	32b68618-1ac3-4b3c-95fb-6fb93ef0fa5b	thịt gà	3.000	phần	\N	9
b3c5558f-bc72-4960-8fa8-efb17690bba0	2026-09-22 16:40:27.935108+00	\N	f	1	420a4583-b573-4ae5-9323-c9e6d990fdcd	tôm	4.000	phần	\N	0
88c72636-9e3a-45be-aeac-1fec860ec273	2026-09-22 16:40:27.935108+00	\N	f	1	420a4583-b573-4ae5-9323-c9e6d990fdcd	hành tây	2.000	phần	\N	1
81cc064a-5301-4f73-8910-49fa5e2c51d4	2026-09-22 16:40:27.935108+00	\N	f	1	420a4583-b573-4ae5-9323-c9e6d990fdcd	ớt chuông	3.000	phần	\N	2
fb3fd215-04f5-4b62-9024-8b85d3e282e4	2026-09-22 16:40:27.935108+00	\N	f	1	420a4583-b573-4ae5-9323-c9e6d990fdcd	thịt bò	3.000	phần	\N	3
4eae1e57-ab98-4e43-aa61-38fd630dbee5	2026-09-22 16:40:27.935108+00	\N	f	1	420a4583-b573-4ae5-9323-c9e6d990fdcd	cá	1.000	phần	\N	4
5663164c-a36c-4be7-ac1b-a00f596eddcb	2026-09-22 16:40:27.935108+00	\N	f	1	420a4583-b573-4ae5-9323-c9e6d990fdcd	bún	4.000	phần	\N	5
570cbad7-b8d4-49fa-b32f-5e7b81b18653	2026-09-22 16:40:27.935108+00	\N	f	1	420a4583-b573-4ae5-9323-c9e6d990fdcd	đường	3.000	phần	\N	6
6e178d76-a73c-48fa-a439-b31479a34601	2026-09-22 16:40:27.935108+00	\N	f	1	420a4583-b573-4ae5-9323-c9e6d990fdcd	tiêu	4.000	phần	\N	7
6459e752-2453-46e3-8534-0a0887bbb3dc	2026-09-22 16:40:27.935108+00	\N	f	1	420a4583-b573-4ae5-9323-c9e6d990fdcd	đậu que	1.000	phần	\N	8
8b96dd7d-dd9d-4689-b9f9-8ef43964346e	2026-09-22 16:40:27.935108+00	\N	f	1	420a4583-b573-4ae5-9323-c9e6d990fdcd	gừng	2.000	phần	\N	9
4b31b54c-4b3e-4e31-b4de-e0bc3b6ecdc7	2026-09-22 16:40:27.935108+00	\N	f	1	38804e6d-578b-4e82-9cdb-94d6589cd8bc	khoai tây	1.000	phần	\N	0
6d93ede9-e795-4f34-a555-a2a8fe57678d	2026-09-22 16:40:27.935108+00	\N	f	1	38804e6d-578b-4e82-9cdb-94d6589cd8bc	thịt gà	2.000	phần	\N	1
3f327c9a-035f-4107-8fa8-1a4be008fdb6	2026-09-22 16:40:27.935108+00	\N	f	1	38804e6d-578b-4e82-9cdb-94d6589cd8bc	gạo	2.000	phần	\N	2
1c62e9da-6b79-4269-8ea2-6b767aee8516	2026-09-22 16:40:27.935108+00	\N	f	1	38804e6d-578b-4e82-9cdb-94d6589cd8bc	cà rốt	5.000	phần	\N	3
93d99e2c-29d6-4920-aa17-0409a65e0af3	2026-09-22 16:40:27.935108+00	\N	f	1	38804e6d-578b-4e82-9cdb-94d6589cd8bc	gừng	1.000	phần	\N	4
0e7a4603-7db0-479b-bde6-493f48ccdc5f	2026-09-22 16:40:27.935108+00	\N	f	1	38804e6d-578b-4e82-9cdb-94d6589cd8bc	cà chua	4.000	phần	\N	5
dc79fc3e-159f-47bc-b091-140feecc4671	2026-09-22 16:40:27.935108+00	\N	f	1	38804e6d-578b-4e82-9cdb-94d6589cd8bc	cá	3.000	phần	\N	6
9a5d0fe2-43fb-4c28-9fde-3fc51e5052d8	2026-09-22 16:40:27.935108+00	\N	f	1	38804e6d-578b-4e82-9cdb-94d6589cd8bc	tỏi	4.000	phần	\N	7
bfc69692-a4e8-4397-8e95-558d9c5d1ba5	2026-09-22 16:40:27.935108+00	\N	f	1	38804e6d-578b-4e82-9cdb-94d6589cd8bc	nước tương	3.000	phần	\N	8
a789cb59-ebd3-4aa6-88bb-db02858e1a52	2026-09-22 16:40:27.935108+00	\N	f	1	38804e6d-578b-4e82-9cdb-94d6589cd8bc	bắp cải	3.000	phần	\N	9
13f716db-cee7-45ac-8b47-faaacea3ed09	2026-09-22 16:40:27.935108+00	\N	f	1	38804e6d-578b-4e82-9cdb-94d6589cd8bc	hành tây	3.000	phần	\N	10
b986f966-618a-4911-85d3-940e0a4bfe80	2026-09-22 16:40:27.935108+00	\N	f	1	38804e6d-578b-4e82-9cdb-94d6589cd8bc	nước mắm	3.000	phần	\N	11
0a26f3b8-4db1-49cb-bbe2-646095d5bc11	2026-09-22 16:40:27.935108+00	\N	f	1	02c695ba-3c71-4ca4-bf1f-305be744eba2	ớt chuông	5.000	phần	\N	0
b8989842-cea4-455a-8972-b82a9c4ce3cb	2026-09-22 16:40:27.935108+00	\N	f	1	02c695ba-3c71-4ca4-bf1f-305be744eba2	đậu que	2.000	phần	\N	1
a42b44fe-f7c2-4719-b12a-6abda3717522	2026-09-22 16:40:27.935108+00	\N	f	1	02c695ba-3c71-4ca4-bf1f-305be744eba2	bí đỏ	5.000	phần	\N	2
966a4c8a-2054-4b9c-ac6a-bfa0914d0e66	2026-09-22 16:40:27.935108+00	\N	f	1	02c695ba-3c71-4ca4-bf1f-305be744eba2	thịt heo	1.000	phần	\N	3
d672924b-faf4-43a6-ae0a-29f1d09a26b0	2026-09-22 16:40:27.935108+00	\N	f	1	02c695ba-3c71-4ca4-bf1f-305be744eba2	tôm	5.000	phần	\N	4
a890eea4-7d72-4cb5-aa5c-d32cd86a33c9	2026-09-22 16:40:27.935108+00	\N	f	1	02c695ba-3c71-4ca4-bf1f-305be744eba2	rau cải	2.000	phần	\N	5
2b57d447-0fee-443d-8d23-5bfa987cba84	2026-09-22 16:40:27.935108+00	\N	f	1	02c695ba-3c71-4ca4-bf1f-305be744eba2	nấm	3.000	phần	\N	6
10264624-c59c-45cd-89f4-7226d59d480d	2026-09-22 16:40:27.935108+00	\N	f	1	02c695ba-3c71-4ca4-bf1f-305be744eba2	nước tương	4.000	phần	\N	7
22c48b54-4b9c-47a8-a85c-fbeb0ac6d496	2026-09-22 16:40:27.935108+00	\N	f	1	02c695ba-3c71-4ca4-bf1f-305be744eba2	mì	5.000	phần	\N	8
4b385cfb-170e-45b5-ac71-614dbef3afc5	2026-09-22 16:40:27.935108+00	\N	f	1	02c695ba-3c71-4ca4-bf1f-305be744eba2	muối	1.000	phần	\N	9
86e57ae1-3952-4b35-b8c2-f6ada873a695	2026-09-22 16:40:27.935108+00	\N	f	1	4311dbd4-6e85-453a-a8cf-3c412f8e3ce0	đường	1.000	phần	\N	0
f13e6879-3bfa-4acd-abd9-6538c3c4a592	2026-09-22 16:40:27.935108+00	\N	f	1	4311dbd4-6e85-453a-a8cf-3c412f8e3ce0	bí đỏ	1.000	phần	\N	1
e80f2ffd-e66d-4300-9d23-7255cc4f5831	2026-09-22 16:40:27.935108+00	\N	f	1	4311dbd4-6e85-453a-a8cf-3c412f8e3ce0	khoai tây	5.000	phần	\N	2
2f08da9e-882f-4017-8bbe-b8bc76f80de9	2026-09-22 16:40:27.935108+00	\N	f	1	4311dbd4-6e85-453a-a8cf-3c412f8e3ce0	gừng	3.000	phần	\N	3
986b2663-d2d5-4868-bda3-2fd61f206ada	2026-09-22 16:40:27.935108+00	\N	f	1	4311dbd4-6e85-453a-a8cf-3c412f8e3ce0	gạo	3.000	phần	\N	4
4eb4a921-a589-4ced-95aa-763045b20ce9	2026-09-22 16:40:27.935108+00	\N	f	1	4311dbd4-6e85-453a-a8cf-3c412f8e3ce0	nước mắm	5.000	phần	\N	5
3b81b577-bafc-443c-b2e6-309d422e3922	2026-09-22 16:40:27.935108+00	\N	f	1	4311dbd4-6e85-453a-a8cf-3c412f8e3ce0	đậu que	3.000	phần	\N	6
4b26f037-1e3e-4f81-a2f3-f02055f27d30	2026-09-22 16:40:27.935108+00	\N	f	1	4311dbd4-6e85-453a-a8cf-3c412f8e3ce0	nước tương	2.000	phần	\N	7
97755249-1f18-4755-9f65-bf681b5e4434	2026-09-22 16:40:27.935108+00	\N	f	1	4311dbd4-6e85-453a-a8cf-3c412f8e3ce0	muối	1.000	phần	\N	8
f620a118-f1f9-4474-8a38-4423997977a3	2026-09-22 16:40:27.935108+00	\N	f	1	4311dbd4-6e85-453a-a8cf-3c412f8e3ce0	ớt chuông	5.000	phần	\N	9
518aae74-154e-424c-99cf-4e32e2439831	2026-09-22 16:40:27.935108+00	\N	f	1	4311dbd4-6e85-453a-a8cf-3c412f8e3ce0	tiêu	3.000	phần	\N	10
4490f073-a3cf-4159-a6f0-209fae53dac3	2026-09-22 16:40:27.935108+00	\N	f	1	d242f842-9539-4034-8f4f-c021704e5abb	tiêu	3.000	phần	\N	0
8bfec99a-091c-4ca2-895a-6384708efd1c	2026-09-22 16:40:27.935108+00	\N	f	1	d242f842-9539-4034-8f4f-c021704e5abb	dầu ăn	2.000	phần	\N	1
03c6f7bb-cf5e-4ea8-b2e9-1f40cc241b3f	2026-09-22 16:40:27.935108+00	\N	f	1	d242f842-9539-4034-8f4f-c021704e5abb	ớt chuông	2.000	phần	\N	2
97fac058-33fc-4aaa-af4a-2bf923bcec0b	2026-09-22 16:40:27.935108+00	\N	f	1	d242f842-9539-4034-8f4f-c021704e5abb	bún	4.000	phần	\N	3
54559192-f960-48c0-ad1b-2c8c7bc266c9	2026-09-22 16:40:27.935108+00	\N	f	1	d242f842-9539-4034-8f4f-c021704e5abb	nấm	1.000	phần	\N	4
b4d68c9b-9798-41da-ab1c-c872cb4b6408	2026-09-22 16:40:27.935108+00	\N	f	1	d242f842-9539-4034-8f4f-c021704e5abb	hành lá	1.000	phần	\N	5
0c5fd1e1-cbb7-44e8-97fb-2e24fc40f8f7	2026-09-22 16:40:27.935108+00	\N	f	1	d242f842-9539-4034-8f4f-c021704e5abb	nước tương	5.000	phần	\N	6
8e946b22-4da7-489c-8993-8824a1bb2a4b	2026-09-22 16:40:27.935108+00	\N	f	1	d242f842-9539-4034-8f4f-c021704e5abb	mì	3.000	phần	\N	7
4c416eab-9f07-4ec6-b05d-10f51d7d47e2	2026-09-22 16:40:27.935108+00	\N	f	1	d242f842-9539-4034-8f4f-c021704e5abb	muối	5.000	phần	\N	8
d1a0c7cb-13b2-4715-a584-bd2f52cd9e97	2026-09-22 16:40:27.935108+00	\N	f	1	d242f842-9539-4034-8f4f-c021704e5abb	bắp cải	5.000	phần	\N	9
955a1338-743d-4400-b764-2a209c2f1208	2026-09-22 16:40:27.935108+00	\N	f	1	d242f842-9539-4034-8f4f-c021704e5abb	tỏi	5.000	phần	\N	10
410ea00d-110c-4d6d-a56e-9e042dc5ac70	2026-09-22 16:40:27.935108+00	\N	f	1	bb91ff4a-ebdc-4aba-90f0-aa1f32b7bcde	ớt chuông	4.000	phần	\N	0
27ed3d4a-857e-422f-a033-e7f9b986abab	2026-09-22 16:40:27.935108+00	\N	f	1	bb91ff4a-ebdc-4aba-90f0-aa1f32b7bcde	rau cải	4.000	phần	\N	1
a49b8bac-0487-471b-865b-cc1c15b32ea3	2026-09-22 16:40:27.935108+00	\N	f	1	bb91ff4a-ebdc-4aba-90f0-aa1f32b7bcde	nước mắm	3.000	phần	\N	2
9f230e1f-b74d-4eb3-9185-abeec940668a	2026-09-22 16:40:27.935108+00	\N	f	1	bb91ff4a-ebdc-4aba-90f0-aa1f32b7bcde	cá	1.000	phần	\N	3
f7559880-793c-48da-a1bc-dd3f1f39bf59	2026-09-22 16:40:27.935108+00	\N	f	1	bb91ff4a-ebdc-4aba-90f0-aa1f32b7bcde	đậu que	2.000	phần	\N	4
c9d08921-4c6c-46b2-ad8b-7b26a884524a	2026-09-22 16:40:27.935108+00	\N	f	1	bb91ff4a-ebdc-4aba-90f0-aa1f32b7bcde	khoai tây	1.000	phần	\N	5
747e6966-1123-4a4b-a222-bec2d0dbe8a8	2026-09-22 16:40:27.935108+00	\N	f	1	bb91ff4a-ebdc-4aba-90f0-aa1f32b7bcde	nấm	3.000	phần	\N	6
561bb8f1-4e76-4612-a9d3-aed395d434c6	2026-09-22 16:40:27.935108+00	\N	f	1	bb91ff4a-ebdc-4aba-90f0-aa1f32b7bcde	tôm	5.000	phần	\N	7
aad4c81e-6893-43ae-b4f4-be780cc084ba	2026-09-22 16:40:27.935108+00	\N	f	1	bb91ff4a-ebdc-4aba-90f0-aa1f32b7bcde	đậu hũ	3.000	phần	\N	8
b59e1a51-d3c4-487b-9aee-2d7d319fc9a8	2026-09-22 16:40:27.935108+00	\N	f	1	bb91ff4a-ebdc-4aba-90f0-aa1f32b7bcde	tỏi	4.000	phần	\N	9
b4fae84e-9266-4350-9f43-a5cee0df4335	2026-09-22 16:40:27.935108+00	\N	f	1	88fa97ba-ecba-4c7e-8ea4-064022350579	đậu que	5.000	phần	\N	0
31303161-c1c9-452b-89aa-0e570b3fc306	2026-09-22 16:40:27.935108+00	\N	f	1	88fa97ba-ecba-4c7e-8ea4-064022350579	ớt chuông	4.000	phần	\N	1
25bf2e09-fa17-4d73-9118-1c19b5725357	2026-09-22 16:40:27.935108+00	\N	f	1	88fa97ba-ecba-4c7e-8ea4-064022350579	thịt gà	4.000	phần	\N	2
39b69d51-4ee3-4788-9fcc-1c3550ebc0d3	2026-09-22 16:40:27.935108+00	\N	f	1	88fa97ba-ecba-4c7e-8ea4-064022350579	nước tương	2.000	phần	\N	3
7755c870-117e-4e00-abf3-34ad994e87dd	2026-09-22 16:40:27.935108+00	\N	f	1	88fa97ba-ecba-4c7e-8ea4-064022350579	tỏi	2.000	phần	\N	4
bc14b2fe-dede-410c-b0f5-5e8a185d37eb	2026-09-22 16:40:27.935108+00	\N	f	1	88fa97ba-ecba-4c7e-8ea4-064022350579	rau thơm	5.000	phần	\N	5
93b8b72d-26f0-4133-93a2-7e5d185247b6	2026-09-22 16:40:27.935108+00	\N	f	1	88fa97ba-ecba-4c7e-8ea4-064022350579	tiêu	3.000	phần	\N	6
5bee4112-5307-400d-8ee0-9f7e6b791a8a	2026-09-22 16:40:27.935108+00	\N	f	1	88fa97ba-ecba-4c7e-8ea4-064022350579	nước mắm	3.000	phần	\N	7
64ad211f-f9bf-441a-9b6c-abea7779c085	2026-09-22 16:40:27.935108+00	\N	f	1	88fa97ba-ecba-4c7e-8ea4-064022350579	cà chua	2.000	phần	\N	8
835e2d11-60a8-476d-aeff-e3ae0f5debec	2026-09-22 16:40:27.935108+00	\N	f	1	88fa97ba-ecba-4c7e-8ea4-064022350579	bí đỏ	5.000	phần	\N	9
dd32f244-22d0-494a-8b2a-f2d134432941	2026-09-22 16:40:27.935108+00	\N	f	1	88fa97ba-ecba-4c7e-8ea4-064022350579	hành lá	3.000	phần	\N	10
97e71783-b427-41a0-9fa9-ead01ce1f8cd	2026-09-22 16:40:27.935108+00	\N	f	1	88fa97ba-ecba-4c7e-8ea4-064022350579	thịt heo	5.000	phần	\N	11
fbfaa328-5cee-4fce-b9ec-d6aca2a0bf3b	2026-09-22 16:40:27.935108+00	\N	f	1	6e5dc0c4-9ebd-4c6f-9b12-a6a866a6fd2d	thịt gà	5.000	phần	\N	0
cc8bacbc-0d66-4dbf-96ef-243a93cddcad	2026-09-22 16:40:27.935108+00	\N	f	1	6e5dc0c4-9ebd-4c6f-9b12-a6a866a6fd2d	đậu hũ	2.000	phần	\N	1
c92bcd6d-065a-41d8-a44d-192b9e4f752a	2026-09-22 16:40:27.935108+00	\N	f	1	6e5dc0c4-9ebd-4c6f-9b12-a6a866a6fd2d	mì	5.000	phần	\N	2
59b4716f-9210-4de9-b884-7c819469eba9	2026-09-22 16:40:27.935108+00	\N	f	1	6e5dc0c4-9ebd-4c6f-9b12-a6a866a6fd2d	thịt heo	1.000	phần	\N	3
54d070f0-5d2a-4502-9ab6-1eaa57136d6e	2026-09-22 16:40:27.935108+00	\N	f	1	6e5dc0c4-9ebd-4c6f-9b12-a6a866a6fd2d	nước mắm	2.000	phần	\N	4
2192fedf-bd87-4b97-84ce-8b8ba8a7bf31	2026-09-22 16:40:27.935108+00	\N	f	1	6e5dc0c4-9ebd-4c6f-9b12-a6a866a6fd2d	khoai tây	3.000	phần	\N	5
08ab071f-08e8-437a-bb4f-c5d31e4481f7	2026-09-22 16:40:27.935108+00	\N	f	1	6e5dc0c4-9ebd-4c6f-9b12-a6a866a6fd2d	trứng	2.000	phần	\N	6
27bc61a7-426c-45cc-bf61-5c523f6e9880	2026-09-22 16:40:27.935108+00	\N	f	1	6e5dc0c4-9ebd-4c6f-9b12-a6a866a6fd2d	thịt bò	4.000	phần	\N	7
165ed030-abeb-435c-a13f-df5c9517da3f	2026-09-22 16:40:27.935108+00	\N	f	1	6e5dc0c4-9ebd-4c6f-9b12-a6a866a6fd2d	nấm	4.000	phần	\N	8
1a1e1328-84a9-496c-9e9a-0cfddab5dcd0	2026-09-22 16:40:27.935108+00	\N	f	1	6e5dc0c4-9ebd-4c6f-9b12-a6a866a6fd2d	hành tây	5.000	phần	\N	9
1f11c43b-907e-4dc1-b786-8e31a45659c6	2026-09-22 16:40:27.935108+00	\N	f	1	6e5dc0c4-9ebd-4c6f-9b12-a6a866a6fd2d	cá	3.000	phần	\N	10
b1bba0b2-ca85-4757-957b-39b708c41258	2026-09-22 16:40:27.935108+00	\N	f	1	aa6fb2ef-abf8-403f-aa8e-426b37f45c7c	cá	2.000	phần	\N	0
d0a200bd-733c-4920-9a4a-09d999aaef78	2026-09-22 16:40:27.935108+00	\N	f	1	aa6fb2ef-abf8-403f-aa8e-426b37f45c7c	rau thơm	5.000	phần	\N	1
b8b00866-c873-453f-8f28-010695890683	2026-09-22 16:40:27.935108+00	\N	f	1	aa6fb2ef-abf8-403f-aa8e-426b37f45c7c	dầu ăn	5.000	phần	\N	2
f3822d56-ffe1-4016-9f36-b6a60d810a8d	2026-09-22 16:40:27.935108+00	\N	f	1	aa6fb2ef-abf8-403f-aa8e-426b37f45c7c	gạo	5.000	phần	\N	3
d57864fd-cb71-44ac-8851-47a75d327d76	2026-09-22 16:40:27.935108+00	\N	f	1	aa6fb2ef-abf8-403f-aa8e-426b37f45c7c	nước mắm	1.000	phần	\N	4
fd245efc-5642-4935-a813-2feec37eb1d3	2026-09-22 16:40:27.935108+00	\N	f	1	aa6fb2ef-abf8-403f-aa8e-426b37f45c7c	đường	2.000	phần	\N	5
3b345880-76cb-44cd-984f-524b9b5b37cd	2026-09-22 16:40:27.935108+00	\N	f	1	aa6fb2ef-abf8-403f-aa8e-426b37f45c7c	tiêu	3.000	phần	\N	6
186a768c-467f-4553-9d8c-cddb3069790c	2026-09-22 16:40:27.935108+00	\N	f	1	aa6fb2ef-abf8-403f-aa8e-426b37f45c7c	bún	4.000	phần	\N	7
d3ca3162-9cb1-4204-9d0d-9e0966a0c6bf	2026-09-22 16:40:27.935108+00	\N	f	1	aa6fb2ef-abf8-403f-aa8e-426b37f45c7c	nước tương	5.000	phần	\N	8
3626d933-1003-4d75-8882-d044b9667391	2026-09-22 16:40:27.935108+00	\N	f	1	aa6fb2ef-abf8-403f-aa8e-426b37f45c7c	cà chua	4.000	phần	\N	9
3db9230f-5fa5-4157-aa7b-3bd502a754f1	2026-09-22 16:40:27.935108+00	\N	f	1	aa6fb2ef-abf8-403f-aa8e-426b37f45c7c	khoai tây	5.000	phần	\N	10
65fe65a6-49ac-497f-abd1-143a62933c82	2026-09-22 16:40:27.935108+00	\N	f	1	40da8dea-a2d9-49d0-b54c-ed06024f7f9c	thịt heo	4.000	phần	\N	0
230aa187-ffd0-4d58-9b90-9def49423ddb	2026-09-22 16:40:27.935108+00	\N	f	1	40da8dea-a2d9-49d0-b54c-ed06024f7f9c	cá	3.000	phần	\N	1
721fa9a8-4ddb-46be-bb37-113b7738254b	2026-09-22 16:40:27.935108+00	\N	f	1	40da8dea-a2d9-49d0-b54c-ed06024f7f9c	khoai tây	4.000	phần	\N	2
4c328d0a-e0c5-4bc0-b61d-aba8641ac84a	2026-09-22 16:40:27.935108+00	\N	f	1	40da8dea-a2d9-49d0-b54c-ed06024f7f9c	tôm	3.000	phần	\N	3
08db372a-edae-4c4f-bde7-6c087568bdde	2026-09-22 16:40:27.935108+00	\N	f	1	40da8dea-a2d9-49d0-b54c-ed06024f7f9c	rau cải	2.000	phần	\N	4
e91b39d3-9c6a-4164-87ef-fb8a8e11b5b3	2026-09-22 16:40:27.935108+00	\N	f	1	40da8dea-a2d9-49d0-b54c-ed06024f7f9c	nấm	3.000	phần	\N	5
35798a9c-acc9-4358-afe1-31fdd6963a04	2026-09-22 16:40:27.935108+00	\N	f	1	40da8dea-a2d9-49d0-b54c-ed06024f7f9c	đậu que	1.000	phần	\N	6
b245f574-cebb-4bff-b1c8-462f1ea9c3ee	2026-09-22 16:40:27.935108+00	\N	f	1	40da8dea-a2d9-49d0-b54c-ed06024f7f9c	hành tây	3.000	phần	\N	7
84c632c5-ca61-4ce4-97d4-a4a56ad3fcfb	2026-09-22 16:40:27.935108+00	\N	f	1	40da8dea-a2d9-49d0-b54c-ed06024f7f9c	tỏi	4.000	phần	\N	8
94b01464-eeb9-44d9-9da7-1a0b92fdecad	2026-09-22 16:40:27.935108+00	\N	f	1	40da8dea-a2d9-49d0-b54c-ed06024f7f9c	gạo	2.000	phần	\N	9
92ea75b1-be67-48be-94d0-203ef09ac807	2026-09-22 16:40:27.935108+00	\N	f	1	40da8dea-a2d9-49d0-b54c-ed06024f7f9c	mì	2.000	phần	\N	10
a93e82c1-bcb9-425a-b735-628226ad7150	2026-09-22 16:40:27.935108+00	\N	f	1	644080d9-bb15-4924-942f-11382b57b7d2	muối	3.000	phần	\N	0
4d2820ba-f395-460c-b312-e2dd3fca95f7	2026-09-22 16:40:27.935108+00	\N	f	1	644080d9-bb15-4924-942f-11382b57b7d2	tỏi	5.000	phần	\N	1
17466a57-8f2d-4d89-a41a-1a476a2a14b5	2026-09-22 16:40:27.935108+00	\N	f	1	644080d9-bb15-4924-942f-11382b57b7d2	tiêu	1.000	phần	\N	2
fc21325c-4e08-4711-914d-d41bd82969c1	2026-09-22 16:40:27.935108+00	\N	f	1	644080d9-bb15-4924-942f-11382b57b7d2	cà rốt	1.000	phần	\N	3
834503c2-ed81-4c26-9a1d-fea7158311be	2026-09-22 16:40:27.935108+00	\N	f	1	644080d9-bb15-4924-942f-11382b57b7d2	khoai tây	5.000	phần	\N	4
afc8ab7e-adc3-436b-b6d1-a87a69686043	2026-09-22 16:40:27.935108+00	\N	f	1	644080d9-bb15-4924-942f-11382b57b7d2	cà chua	4.000	phần	\N	5
3af29a4d-710c-4407-b539-dcaae5bb3ad9	2026-09-22 16:40:27.935108+00	\N	f	1	644080d9-bb15-4924-942f-11382b57b7d2	gạo	1.000	phần	\N	6
cc157bdb-c665-4ee8-a36e-a59be31698e3	2026-09-22 16:40:27.935108+00	\N	f	1	644080d9-bb15-4924-942f-11382b57b7d2	đường	1.000	phần	\N	7
fd74c14c-d81e-4bc3-bfa9-2484a728e7ba	2026-09-22 16:40:27.935108+00	\N	f	1	644080d9-bb15-4924-942f-11382b57b7d2	hành lá	5.000	phần	\N	8
a774688a-dea8-4b2c-a391-c6846a5e7849	2026-09-22 16:40:27.935108+00	\N	f	1	644080d9-bb15-4924-942f-11382b57b7d2	gừng	1.000	phần	\N	9
05dd0688-5f2a-4232-9eac-7ad051889a65	2026-09-22 16:40:27.935108+00	\N	f	1	b66fb87b-4e6b-43d2-ad8f-5dbc6cab2cef	khoai tây	1.000	phần	\N	0
49b100a5-4104-4dc2-abca-7fee5188b67d	2026-09-22 16:40:27.935108+00	\N	f	1	b66fb87b-4e6b-43d2-ad8f-5dbc6cab2cef	rau thơm	4.000	phần	\N	1
0ce9fc88-e9a5-421a-9af6-57d0bba782c3	2026-09-22 16:40:27.935108+00	\N	f	1	b66fb87b-4e6b-43d2-ad8f-5dbc6cab2cef	mì	4.000	phần	\N	2
d30cb810-824c-42da-860c-1c829d01a132	2026-09-22 16:40:27.935108+00	\N	f	1	b66fb87b-4e6b-43d2-ad8f-5dbc6cab2cef	trứng	2.000	phần	\N	3
236602c0-d9a9-4d14-a97f-b3115ead17f0	2026-09-22 16:40:27.935108+00	\N	f	1	b66fb87b-4e6b-43d2-ad8f-5dbc6cab2cef	bún	1.000	phần	\N	4
3daa2fc2-1310-4c8f-891a-03ef853ebaa8	2026-09-22 16:40:27.935108+00	\N	f	1	b66fb87b-4e6b-43d2-ad8f-5dbc6cab2cef	hành lá	4.000	phần	\N	5
656680cd-f821-4df3-8e39-369c3d2b99a6	2026-09-22 16:40:27.935108+00	\N	f	1	b66fb87b-4e6b-43d2-ad8f-5dbc6cab2cef	hành tây	5.000	phần	\N	6
d3e92a94-fa89-48ef-aaca-431e9eefba42	2026-09-22 16:40:27.935108+00	\N	f	1	b66fb87b-4e6b-43d2-ad8f-5dbc6cab2cef	thịt gà	4.000	phần	\N	7
82a04109-7d3f-487d-863b-605c2ef2debe	2026-09-22 16:40:27.935108+00	\N	f	1	b66fb87b-4e6b-43d2-ad8f-5dbc6cab2cef	nước tương	5.000	phần	\N	8
9321d36a-38ea-4d69-bed1-ada44352ffb8	2026-09-22 16:40:27.935108+00	\N	f	1	b66fb87b-4e6b-43d2-ad8f-5dbc6cab2cef	cà chua	4.000	phần	\N	9
d8d18796-5cc0-455c-b292-f40719c08665	2026-09-22 16:40:27.935108+00	\N	f	1	b66fb87b-4e6b-43d2-ad8f-5dbc6cab2cef	đường	3.000	phần	\N	10
4431b3d2-6e31-44b2-9b3f-8c3d1eb1d00f	2026-09-22 16:40:27.935108+00	\N	f	1	b66fb87b-4e6b-43d2-ad8f-5dbc6cab2cef	tôm	1.000	phần	\N	11
1281c95d-f234-4e21-a95d-b47bf80f6f27	2026-09-22 16:40:27.935108+00	\N	f	1	664c65ce-22e6-4391-a9ba-61d862f98ff8	thịt bò	2.000	phần	\N	0
b116ffaa-4ea9-4294-9b9a-525480139815	2026-09-22 16:40:27.935108+00	\N	f	1	664c65ce-22e6-4391-a9ba-61d862f98ff8	tỏi	5.000	phần	\N	1
2ce118c9-9665-49f7-baf5-4affc7ad63c6	2026-09-22 16:40:27.935108+00	\N	f	1	664c65ce-22e6-4391-a9ba-61d862f98ff8	thịt gà	4.000	phần	\N	2
838219ae-116f-4a02-a4e6-a99919273b83	2026-09-22 16:40:27.935108+00	\N	f	1	664c65ce-22e6-4391-a9ba-61d862f98ff8	khoai tây	4.000	phần	\N	3
2f8eb3ff-f8f6-46b5-a203-674cb2c9ea0c	2026-09-22 16:40:27.935108+00	\N	f	1	664c65ce-22e6-4391-a9ba-61d862f98ff8	đậu hũ	1.000	phần	\N	4
a612542f-b17d-4bad-85fd-1c357c0dcd72	2026-09-22 16:40:27.935108+00	\N	f	1	664c65ce-22e6-4391-a9ba-61d862f98ff8	bắp cải	1.000	phần	\N	5
92652999-108c-4842-a0b4-0211bb93ed01	2026-09-22 16:40:27.935108+00	\N	f	1	664c65ce-22e6-4391-a9ba-61d862f98ff8	nước mắm	1.000	phần	\N	6
4ca0a4a4-b001-4583-95ca-ba10fe8a39b3	2026-09-22 16:40:27.935108+00	\N	f	1	664c65ce-22e6-4391-a9ba-61d862f98ff8	thịt heo	3.000	phần	\N	7
354660e9-5d27-4f84-b95f-de33f78e949b	2026-09-22 16:40:27.935108+00	\N	f	1	664c65ce-22e6-4391-a9ba-61d862f98ff8	trứng	4.000	phần	\N	8
7024bad5-9121-415d-96a0-d776b6a8ed18	2026-09-22 16:40:27.935108+00	\N	f	1	664c65ce-22e6-4391-a9ba-61d862f98ff8	rau thơm	4.000	phần	\N	9
602fe524-4c76-4dd4-a5ad-93741691048b	2026-09-22 16:40:27.935108+00	\N	f	1	3b0774bd-aa26-49e3-bff4-1ebaaca8f01c	hành tây	2.000	phần	\N	0
88758173-9f42-48f0-8023-ef1645e4d36b	2026-09-22 16:40:27.935108+00	\N	f	1	3b0774bd-aa26-49e3-bff4-1ebaaca8f01c	đậu que	5.000	phần	\N	1
0c3e69d2-25ef-4d74-a183-e6015e2d3c48	2026-09-22 16:40:27.935108+00	\N	f	1	3b0774bd-aa26-49e3-bff4-1ebaaca8f01c	bún	3.000	phần	\N	2
9cee0b3f-88ff-4f76-8a51-738277523a45	2026-09-22 16:40:27.935108+00	\N	f	1	3b0774bd-aa26-49e3-bff4-1ebaaca8f01c	hành lá	3.000	phần	\N	3
c90a88d0-23d8-462d-ad9e-10c1f621fd0c	2026-09-22 16:40:27.935108+00	\N	f	1	3b0774bd-aa26-49e3-bff4-1ebaaca8f01c	rau cải	3.000	phần	\N	4
7f080fe5-8e29-4c82-9a4c-7a7fc50e53a5	2026-09-22 16:40:27.935108+00	\N	f	1	3b0774bd-aa26-49e3-bff4-1ebaaca8f01c	cà rốt	2.000	phần	\N	5
f06354e7-b4f5-4090-9772-99d365d38f57	2026-09-22 16:40:27.935108+00	\N	f	1	3b0774bd-aa26-49e3-bff4-1ebaaca8f01c	thịt heo	2.000	phần	\N	6
5e4a1bca-20dc-4ee1-8aeb-30b97c81f45c	2026-09-22 16:40:27.935108+00	\N	f	1	3b0774bd-aa26-49e3-bff4-1ebaaca8f01c	thịt bò	4.000	phần	\N	7
6c45249e-1b78-4460-a9c7-f9172f31b6d4	2026-09-22 16:40:27.935108+00	\N	f	1	3b0774bd-aa26-49e3-bff4-1ebaaca8f01c	nấm	5.000	phần	\N	8
7fd4bddc-494d-4e9a-8314-dcf996eade3f	2026-09-22 16:40:27.935108+00	\N	f	1	3b0774bd-aa26-49e3-bff4-1ebaaca8f01c	khoai tây	3.000	phần	\N	9
97049d66-8f3b-4752-add7-3fbc3691d243	2026-09-22 16:40:27.935108+00	\N	f	1	3b0774bd-aa26-49e3-bff4-1ebaaca8f01c	thịt gà	3.000	phần	\N	10
be5dadf4-2e04-48d0-9cc5-0d82d045e618	2026-09-22 16:40:27.935108+00	\N	f	1	f38b31dd-0ed1-405f-84fd-de5aafe547e7	ớt chuông	1.000	phần	\N	0
74fd6483-c09d-4ed8-af4d-46f5e9d9ecc3	2026-09-22 16:40:27.935108+00	\N	f	1	f38b31dd-0ed1-405f-84fd-de5aafe547e7	bún	2.000	phần	\N	1
5d34bc03-6fb6-4678-a708-f373db31f194	2026-09-22 16:40:27.935108+00	\N	f	1	f38b31dd-0ed1-405f-84fd-de5aafe547e7	thịt gà	5.000	phần	\N	2
a7b16d7f-f7a4-4397-83e3-7f40e1deab38	2026-09-22 16:40:27.935108+00	\N	f	1	f38b31dd-0ed1-405f-84fd-de5aafe547e7	trứng	4.000	phần	\N	3
6c21ecdd-3611-42d9-aebc-6f3b464d4ec5	2026-09-22 16:40:27.935108+00	\N	f	1	f38b31dd-0ed1-405f-84fd-de5aafe547e7	thịt bò	4.000	phần	\N	4
54865317-628f-4693-9f9a-ff736ed44aa1	2026-09-22 16:40:27.935108+00	\N	f	1	f38b31dd-0ed1-405f-84fd-de5aafe547e7	khoai tây	4.000	phần	\N	5
4bbc2a04-4673-4849-8305-0d7050cb2b65	2026-09-22 16:40:27.935108+00	\N	f	1	f38b31dd-0ed1-405f-84fd-de5aafe547e7	nước mắm	1.000	phần	\N	6
384d5f36-862b-40e7-a468-7a1b526b7952	2026-09-22 16:40:27.935108+00	\N	f	1	f38b31dd-0ed1-405f-84fd-de5aafe547e7	gừng	1.000	phần	\N	7
39d821e2-09e1-40ca-88f9-41fc0c04cc25	2026-09-22 16:40:27.935108+00	\N	f	1	f38b31dd-0ed1-405f-84fd-de5aafe547e7	đường	5.000	phần	\N	8
ccf49a29-0add-4193-884a-46820ffe57b2	2026-09-22 16:40:27.935108+00	\N	f	1	f38b31dd-0ed1-405f-84fd-de5aafe547e7	rau cải	1.000	phần	\N	9
4e31817e-8922-4d6c-b783-991ad2b29fe9	2026-09-22 16:40:27.935108+00	\N	f	1	f38b31dd-0ed1-405f-84fd-de5aafe547e7	cá	5.000	phần	\N	10
8b3095c6-20c8-4be1-b55f-ceb8fae6d42e	2026-09-22 16:40:27.935108+00	\N	f	1	f38b31dd-0ed1-405f-84fd-de5aafe547e7	thịt heo	2.000	phần	\N	11
c454e796-c1fb-49a3-8216-235133dda596	2026-09-22 16:40:27.935108+00	\N	f	1	ab32138f-bda8-4ae3-a101-c5e9ac792092	hành lá	3.000	phần	\N	0
b686b4de-650c-4a7a-a464-aa7ee97ff908	2026-09-22 16:40:27.935108+00	\N	f	1	ab32138f-bda8-4ae3-a101-c5e9ac792092	dầu ăn	4.000	phần	\N	1
60e7f645-66e1-4213-8644-395dc22184d3	2026-09-22 16:40:27.935108+00	\N	f	1	ab32138f-bda8-4ae3-a101-c5e9ac792092	khoai tây	4.000	phần	\N	2
a0bedbe6-3e2a-4b22-b644-d3695cfe81c5	2026-09-22 16:40:27.935108+00	\N	f	1	ab32138f-bda8-4ae3-a101-c5e9ac792092	rau thơm	4.000	phần	\N	3
166532bd-0fcc-4d8a-8a03-1d8611aab6cd	2026-09-22 16:40:27.935108+00	\N	f	1	ab32138f-bda8-4ae3-a101-c5e9ac792092	bắp cải	4.000	phần	\N	4
f350fb89-5017-4605-be9b-8d5214640071	2026-09-22 16:40:27.935108+00	\N	f	1	ab32138f-bda8-4ae3-a101-c5e9ac792092	thịt bò	3.000	phần	\N	5
8c274447-d575-4151-869f-495aded3f5a9	2026-09-22 16:40:27.935108+00	\N	f	1	ab32138f-bda8-4ae3-a101-c5e9ac792092	muối	5.000	phần	\N	6
60ed24fe-3d6c-49e6-9362-7fa4a7600e89	2026-09-22 16:40:27.935108+00	\N	f	1	ab32138f-bda8-4ae3-a101-c5e9ac792092	đậu hũ	1.000	phần	\N	7
02602c77-0974-4df9-b56b-d64470092629	2026-09-22 16:40:27.935108+00	\N	f	1	ab32138f-bda8-4ae3-a101-c5e9ac792092	trứng	3.000	phần	\N	8
bfd93d26-3436-47c9-a91c-28055d737e73	2026-09-22 16:40:27.935108+00	\N	f	1	ab32138f-bda8-4ae3-a101-c5e9ac792092	hành tây	5.000	phần	\N	9
a8c900ba-dc57-46ab-b66b-9461495cab97	2026-09-22 16:40:27.935108+00	\N	f	1	7ad9241a-0d83-4794-8307-e94ebf4194e9	cà chua	1.000	phần	\N	0
8ef6f8c5-280c-469d-b02e-f595b6dbd40c	2026-09-22 16:40:27.935108+00	\N	f	1	7ad9241a-0d83-4794-8307-e94ebf4194e9	bí đỏ	4.000	phần	\N	1
5b27bec0-1589-4db8-8317-0fb344fed974	2026-09-22 16:40:27.935108+00	\N	f	1	7ad9241a-0d83-4794-8307-e94ebf4194e9	cà rốt	2.000	phần	\N	2
0bc64888-5fb7-41cb-ae0d-71f3ef6b7730	2026-09-22 16:40:27.935108+00	\N	f	1	7ad9241a-0d83-4794-8307-e94ebf4194e9	gạo	5.000	phần	\N	3
aaa38a58-d449-4e2a-ba2d-8cecbfba2444	2026-09-22 16:40:27.935108+00	\N	f	1	7ad9241a-0d83-4794-8307-e94ebf4194e9	gừng	2.000	phần	\N	4
3e595d02-69d2-4d0b-85d7-fcd156575218	2026-09-22 16:40:27.935108+00	\N	f	1	7ad9241a-0d83-4794-8307-e94ebf4194e9	nấm	2.000	phần	\N	5
0791c0c2-f3d9-4dec-bc41-111107661a82	2026-09-22 16:40:27.935108+00	\N	f	1	7ad9241a-0d83-4794-8307-e94ebf4194e9	ớt chuông	5.000	phần	\N	6
67b23786-0fff-433b-a96f-b4ca16487c3f	2026-09-22 16:40:27.935108+00	\N	f	1	7ad9241a-0d83-4794-8307-e94ebf4194e9	trứng	1.000	phần	\N	7
9597ef51-434d-4a1a-ab13-1cf245470a12	2026-09-22 16:40:27.935108+00	\N	f	1	7ad9241a-0d83-4794-8307-e94ebf4194e9	hành lá	2.000	phần	\N	8
537cd506-82ae-47b0-aa06-d723c76f4974	2026-09-22 16:40:27.935108+00	\N	f	1	7ad9241a-0d83-4794-8307-e94ebf4194e9	đường	2.000	phần	\N	9
97531a59-7b64-4a3c-8776-f6adca7d82f5	2026-09-22 16:40:27.935108+00	\N	f	1	40548af9-3dd2-4ce5-810c-82997ed49b9f	khoai tây	4.000	phần	\N	0
a5834369-c21b-4c64-85b7-3639ce585749	2026-09-22 16:40:27.935108+00	\N	f	1	40548af9-3dd2-4ce5-810c-82997ed49b9f	nước tương	3.000	phần	\N	1
efca5ef9-5949-4841-a762-bd85851ec4dd	2026-09-22 16:40:27.935108+00	\N	f	1	40548af9-3dd2-4ce5-810c-82997ed49b9f	thịt gà	1.000	phần	\N	2
a85b8826-d40b-4049-9f9e-b09119e4a45a	2026-09-22 16:40:27.935108+00	\N	f	1	40548af9-3dd2-4ce5-810c-82997ed49b9f	nước mắm	2.000	phần	\N	3
60e644fd-a3ab-48d4-b966-98407a11fdda	2026-09-22 16:40:27.935108+00	\N	f	1	40548af9-3dd2-4ce5-810c-82997ed49b9f	tiêu	4.000	phần	\N	4
a7bd6dce-6d14-4a01-ad5d-f2908b092903	2026-09-22 16:40:27.935108+00	\N	f	1	40548af9-3dd2-4ce5-810c-82997ed49b9f	bún	5.000	phần	\N	5
874cfb7d-8284-41d5-a9c5-8b0245c00931	2026-09-22 16:40:27.935108+00	\N	f	1	40548af9-3dd2-4ce5-810c-82997ed49b9f	thịt bò	4.000	phần	\N	6
4a1fe7de-35e1-4f16-bbd6-4c09bebdff38	2026-09-22 16:40:27.935108+00	\N	f	1	40548af9-3dd2-4ce5-810c-82997ed49b9f	mì	5.000	phần	\N	7
e441ae7b-baf8-40f9-9b27-9ae0c22b32f3	2026-09-22 16:40:27.935108+00	\N	f	1	40548af9-3dd2-4ce5-810c-82997ed49b9f	đậu hũ	1.000	phần	\N	8
884b4f83-153d-41d1-8af6-e1afad93d3c2	2026-09-22 16:40:27.935108+00	\N	f	1	40548af9-3dd2-4ce5-810c-82997ed49b9f	tỏi	1.000	phần	\N	9
72f8c010-df60-4495-9343-ec5a9835dddb	2026-09-22 16:40:27.935108+00	\N	f	1	40548af9-3dd2-4ce5-810c-82997ed49b9f	dầu ăn	4.000	phần	\N	10
018a4d48-e5ab-4704-a22d-3040f085c8fc	2026-09-22 16:40:27.935108+00	\N	f	1	e386d488-0cc6-4148-a6f4-a0d843ef4ae1	hành tây	2.000	phần	\N	0
0635dd43-5f64-489e-b536-d615691697b4	2026-09-22 16:40:27.935108+00	\N	f	1	e386d488-0cc6-4148-a6f4-a0d843ef4ae1	thịt bò	4.000	phần	\N	1
c78fae09-3c7d-4904-b442-a550f104e617	2026-09-22 16:40:27.935108+00	\N	f	1	e386d488-0cc6-4148-a6f4-a0d843ef4ae1	gừng	4.000	phần	\N	2
d5c8ee72-a060-49be-a0b1-b67652e777b1	2026-09-22 16:40:27.935108+00	\N	f	1	e386d488-0cc6-4148-a6f4-a0d843ef4ae1	nấm	2.000	phần	\N	3
aeac095c-1ee9-4356-a586-037b30a29efb	2026-09-22 16:40:27.935108+00	\N	f	1	e386d488-0cc6-4148-a6f4-a0d843ef4ae1	trứng	3.000	phần	\N	4
42bc9595-ef35-4e60-806c-d62eacacb0b3	2026-09-22 16:40:27.935108+00	\N	f	1	e386d488-0cc6-4148-a6f4-a0d843ef4ae1	tỏi	2.000	phần	\N	5
2e4c16b7-75e1-49a9-8a76-585decb969f0	2026-09-22 16:40:27.935108+00	\N	f	1	e386d488-0cc6-4148-a6f4-a0d843ef4ae1	nước tương	2.000	phần	\N	6
f05b680a-186b-4e92-834a-78e0faf01a48	2026-09-22 16:40:27.935108+00	\N	f	1	e386d488-0cc6-4148-a6f4-a0d843ef4ae1	rau cải	5.000	phần	\N	7
824e56d3-8e51-42dc-a79b-32b88dd3c35d	2026-09-22 16:40:27.935108+00	\N	f	1	e386d488-0cc6-4148-a6f4-a0d843ef4ae1	ớt chuông	5.000	phần	\N	8
dd00811e-c645-4711-9d61-ef43772dd933	2026-09-22 16:40:27.935108+00	\N	f	1	e386d488-0cc6-4148-a6f4-a0d843ef4ae1	gạo	3.000	phần	\N	9
d5a38b0e-2989-48e2-b723-08d55a353c14	2026-09-22 16:40:27.935108+00	\N	f	1	e386d488-0cc6-4148-a6f4-a0d843ef4ae1	cá	4.000	phần	\N	10
8a272f79-7ba8-4acf-9ab2-283ec97fcbc6	2026-09-22 16:40:27.935108+00	\N	f	1	e386d488-0cc6-4148-a6f4-a0d843ef4ae1	tiêu	4.000	phần	\N	11
cb232ba1-962b-4178-b988-32b34d1b3ad4	2026-09-22 16:40:27.935108+00	\N	f	1	bd5136c1-3f17-4512-868b-1f41b331b3e4	mì	3.000	phần	\N	0
1c6162e8-ede0-4b56-bcf8-ead48f18ce60	2026-09-22 16:40:27.935108+00	\N	f	1	bd5136c1-3f17-4512-868b-1f41b331b3e4	bí đỏ	5.000	phần	\N	1
97abc581-ad7f-4bca-9c2c-6870fe34821a	2026-09-22 16:40:27.935108+00	\N	f	1	bd5136c1-3f17-4512-868b-1f41b331b3e4	thịt heo	2.000	phần	\N	2
dc4a4802-d1b5-4a6f-85ff-0fc2a4f01fa8	2026-09-22 16:40:27.935108+00	\N	f	1	bd5136c1-3f17-4512-868b-1f41b331b3e4	cà chua	3.000	phần	\N	3
fb870f3b-b813-43aa-9542-92cb5a421607	2026-09-22 16:40:27.935108+00	\N	f	1	bd5136c1-3f17-4512-868b-1f41b331b3e4	hành tây	5.000	phần	\N	4
9ed3c564-17e2-4e75-9f71-3d768392286c	2026-09-22 16:40:27.935108+00	\N	f	1	bd5136c1-3f17-4512-868b-1f41b331b3e4	khoai tây	1.000	phần	\N	5
becb919e-1b07-4d02-af0a-10305681b121	2026-09-22 16:40:27.935108+00	\N	f	1	bd5136c1-3f17-4512-868b-1f41b331b3e4	nấm	3.000	phần	\N	6
7271116c-59eb-472f-bcdc-c9208a342040	2026-09-22 16:40:27.935108+00	\N	f	1	bd5136c1-3f17-4512-868b-1f41b331b3e4	thịt bò	5.000	phần	\N	7
0031c2e4-c533-4468-a61d-da1f89700929	2026-09-22 16:40:27.935108+00	\N	f	1	bd5136c1-3f17-4512-868b-1f41b331b3e4	tôm	2.000	phần	\N	8
6e807830-b104-4654-8775-08e3362ff2c8	2026-09-22 16:40:27.935108+00	\N	f	1	bd5136c1-3f17-4512-868b-1f41b331b3e4	bắp cải	5.000	phần	\N	9
14160f22-4928-45da-bf99-b851d084ff3c	2026-09-22 16:40:27.935108+00	\N	f	1	bd5136c1-3f17-4512-868b-1f41b331b3e4	bún	1.000	phần	\N	10
c342543a-80f6-44b7-a6f1-c6db14b4cafd	2026-09-22 16:40:27.935108+00	\N	f	1	bd5136c1-3f17-4512-868b-1f41b331b3e4	rau thơm	1.000	phần	\N	11
ecd421b7-bf71-40b6-8e63-9b2ef7823a1a	2026-09-22 16:40:27.935108+00	\N	f	1	66a59220-a831-40de-9488-373cf8906b51	thịt heo	4.000	phần	\N	0
ca732ea8-0ba6-4aa2-8734-1073e68f9d51	2026-09-22 16:40:27.935108+00	\N	f	1	66a59220-a831-40de-9488-373cf8906b51	tỏi	1.000	phần	\N	1
948185d8-9400-485b-b3e0-28a51b565d5c	2026-09-22 16:40:27.935108+00	\N	f	1	66a59220-a831-40de-9488-373cf8906b51	đậu que	2.000	phần	\N	2
84335c75-041d-4be4-992a-ad07bad4598c	2026-09-22 16:40:27.935108+00	\N	f	1	66a59220-a831-40de-9488-373cf8906b51	mì	2.000	phần	\N	3
4d2e7c6c-0931-432a-969c-df5f07b0a08f	2026-09-22 16:40:27.935108+00	\N	f	1	66a59220-a831-40de-9488-373cf8906b51	cá	1.000	phần	\N	4
12d48ffd-271c-4f18-b7ba-90a67fbb01a1	2026-09-22 16:40:27.935108+00	\N	f	1	66a59220-a831-40de-9488-373cf8906b51	tôm	4.000	phần	\N	5
a74bd405-999b-4f85-8ab8-4bf3f746fc75	2026-09-22 16:40:27.935108+00	\N	f	1	66a59220-a831-40de-9488-373cf8906b51	hành lá	1.000	phần	\N	6
cd8ad9df-716b-4680-9d90-b799997bee10	2026-09-22 16:40:27.935108+00	\N	f	1	66a59220-a831-40de-9488-373cf8906b51	thịt gà	5.000	phần	\N	7
c2fe9930-99b2-40f8-8654-79284238d5c6	2026-09-22 16:40:27.935108+00	\N	f	1	66a59220-a831-40de-9488-373cf8906b51	trứng	5.000	phần	\N	8
eeb0fec5-e641-4632-b72b-383d7db4e6a2	2026-09-22 16:40:27.935108+00	\N	f	1	66a59220-a831-40de-9488-373cf8906b51	ớt chuông	1.000	phần	\N	9
7e657682-4880-4f1b-b4dd-ac58fedb15ae	2026-09-22 16:40:27.935108+00	\N	f	1	66a59220-a831-40de-9488-373cf8906b51	muối	1.000	phần	\N	10
b899444e-2625-4f11-8247-be1401e3a733	2026-09-22 16:40:27.935108+00	\N	f	1	fbb77065-b828-4f55-b260-d0555e7f2e4c	đậu hũ	4.000	phần	\N	0
67e0453a-e77a-4778-b3c6-f33ff8e2510c	2026-09-22 16:40:27.935108+00	\N	f	1	fbb77065-b828-4f55-b260-d0555e7f2e4c	thịt heo	5.000	phần	\N	1
3e99b945-07be-48a2-ab23-3e006807b25c	2026-09-22 16:40:27.935108+00	\N	f	1	fbb77065-b828-4f55-b260-d0555e7f2e4c	tiêu	1.000	phần	\N	2
c6a09361-92ed-4bb2-a843-603f42577890	2026-09-22 16:40:27.935108+00	\N	f	1	fbb77065-b828-4f55-b260-d0555e7f2e4c	cá	3.000	phần	\N	3
5a3ba8a0-fadf-4303-b459-5de6ea764fda	2026-09-22 16:40:27.935108+00	\N	f	1	fbb77065-b828-4f55-b260-d0555e7f2e4c	gừng	1.000	phần	\N	4
55b8d6de-b958-4c7f-80f5-e9c0a5d7b27c	2026-09-22 16:40:27.935108+00	\N	f	1	fbb77065-b828-4f55-b260-d0555e7f2e4c	đường	1.000	phần	\N	5
2ff93e9c-9dcb-43c6-959a-c2a1d8793d04	2026-09-22 16:40:27.935108+00	\N	f	1	fbb77065-b828-4f55-b260-d0555e7f2e4c	cà chua	3.000	phần	\N	6
3d2ab94c-8a52-4e54-bd43-9939be826b02	2026-09-22 16:40:27.935108+00	\N	f	1	fbb77065-b828-4f55-b260-d0555e7f2e4c	gạo	1.000	phần	\N	7
bec3f468-e4dc-424d-a2ae-4fa56680d6bf	2026-09-22 16:40:27.935108+00	\N	f	1	fbb77065-b828-4f55-b260-d0555e7f2e4c	dầu ăn	5.000	phần	\N	8
246c28ed-9e7a-48d1-a3a8-1fb577cb12f2	2026-09-22 16:40:27.935108+00	\N	f	1	fbb77065-b828-4f55-b260-d0555e7f2e4c	tôm	3.000	phần	\N	9
c2ec0e04-8c5b-4517-8c59-70899741439a	2026-09-22 16:40:27.935108+00	\N	f	1	fbb77065-b828-4f55-b260-d0555e7f2e4c	muối	3.000	phần	\N	10
82d48ca0-8816-46e6-a74d-a9853dfb9827	2026-09-22 16:40:27.935108+00	\N	f	1	fbb77065-b828-4f55-b260-d0555e7f2e4c	bún	3.000	phần	\N	11
8ea67612-5692-4ed0-aaaf-2542b950dca5	2026-09-22 16:40:27.935108+00	\N	f	1	ddf9a41b-987e-4232-9719-1dad2566daef	hành lá	2.000	phần	\N	0
aed4aaef-e24a-4f1c-9253-21dea94762a0	2026-09-22 16:40:27.935108+00	\N	f	1	ddf9a41b-987e-4232-9719-1dad2566daef	thịt heo	5.000	phần	\N	1
a33ba922-6ae9-424a-aca8-fe51e6cb9ed4	2026-09-22 16:40:27.935108+00	\N	f	1	ddf9a41b-987e-4232-9719-1dad2566daef	bún	2.000	phần	\N	2
a22e6f76-68c3-4b37-9301-e9abec45107e	2026-09-22 16:40:27.935108+00	\N	f	1	ddf9a41b-987e-4232-9719-1dad2566daef	nước mắm	2.000	phần	\N	3
8891fe78-c4e1-4559-b9b5-93cf67b9ccb4	2026-09-22 16:40:27.935108+00	\N	f	1	ddf9a41b-987e-4232-9719-1dad2566daef	muối	4.000	phần	\N	4
d6e0b3f5-5912-492b-93f1-4dd6280ac5c1	2026-09-22 16:40:27.935108+00	\N	f	1	ddf9a41b-987e-4232-9719-1dad2566daef	trứng	5.000	phần	\N	5
7c544285-3a8b-489e-9f82-4d27b436d4b4	2026-09-22 16:40:27.935108+00	\N	f	1	ddf9a41b-987e-4232-9719-1dad2566daef	gạo	5.000	phần	\N	6
603c6353-0622-41a6-b628-75f932255697	2026-09-22 16:40:27.935108+00	\N	f	1	ddf9a41b-987e-4232-9719-1dad2566daef	gừng	1.000	phần	\N	7
7864732d-fb44-4606-a368-63c41451d4a1	2026-09-22 16:40:27.935108+00	\N	f	1	ddf9a41b-987e-4232-9719-1dad2566daef	rau cải	2.000	phần	\N	8
83e6752e-b7d6-4874-bccf-ab7b85f89758	2026-09-22 16:40:27.935108+00	\N	f	1	ddf9a41b-987e-4232-9719-1dad2566daef	mì	3.000	phần	\N	9
8b6f0910-a86f-4377-9600-af9ab1bfae1b	2026-09-22 16:40:27.935108+00	\N	f	1	562c335a-10be-4338-b035-3c1e2cffd334	thịt bò	5.000	phần	\N	0
067afeeb-543a-4fb9-afae-5d00c33fa83d	2026-09-22 16:40:27.935108+00	\N	f	1	562c335a-10be-4338-b035-3c1e2cffd334	hành lá	2.000	phần	\N	1
4c9c3355-95fa-4eba-9506-f13488383a78	2026-09-22 16:40:27.935108+00	\N	f	1	562c335a-10be-4338-b035-3c1e2cffd334	cà chua	1.000	phần	\N	2
0a00587f-da41-4ac5-b137-26e032fc2bef	2026-09-22 16:40:27.935108+00	\N	f	1	562c335a-10be-4338-b035-3c1e2cffd334	gừng	4.000	phần	\N	3
adc97bb1-5ff9-47e9-b7e1-67f3d9613658	2026-09-22 16:40:27.935108+00	\N	f	1	562c335a-10be-4338-b035-3c1e2cffd334	gạo	4.000	phần	\N	4
2e715e3f-5a66-41d7-a90f-4c459992f189	2026-09-22 16:40:27.935108+00	\N	f	1	562c335a-10be-4338-b035-3c1e2cffd334	cà rốt	1.000	phần	\N	5
703662d2-9ace-4c28-9091-6852152b36e4	2026-09-22 16:40:27.935108+00	\N	f	1	562c335a-10be-4338-b035-3c1e2cffd334	đậu que	2.000	phần	\N	6
12603e94-7014-4c71-9c3f-eb8adb1464f4	2026-09-22 16:40:27.935108+00	\N	f	1	562c335a-10be-4338-b035-3c1e2cffd334	tôm	5.000	phần	\N	7
161b3d89-2530-425a-ad08-25e6027ec983	2026-09-22 16:40:27.935108+00	\N	f	1	562c335a-10be-4338-b035-3c1e2cffd334	bí đỏ	3.000	phần	\N	8
121affba-738c-4a28-9cdf-8c63db922f26	2026-09-22 16:40:27.935108+00	\N	f	1	562c335a-10be-4338-b035-3c1e2cffd334	bún	3.000	phần	\N	9
80a0c3ca-3c21-4ad2-bf58-4b1a73def82d	2026-09-22 16:40:27.935108+00	\N	f	1	562c335a-10be-4338-b035-3c1e2cffd334	thịt gà	1.000	phần	\N	10
bfc679a0-ab3b-4086-bbfb-4b1f60ba0921	2026-09-22 16:40:27.935108+00	\N	f	1	562c335a-10be-4338-b035-3c1e2cffd334	nấm	3.000	phần	\N	11
6347868e-4fdf-44d5-abd9-95994b11a6ec	2026-09-22 16:40:27.935108+00	\N	f	1	8dccba9d-12b4-4d2d-9a1d-5fc14008d51c	mì	5.000	phần	\N	0
83782403-c559-4f78-a56b-c58071a24b4f	2026-09-22 16:40:27.935108+00	\N	f	1	8dccba9d-12b4-4d2d-9a1d-5fc14008d51c	bí đỏ	3.000	phần	\N	1
4c99c4a3-fc5e-4724-9b55-18bf70cd2937	2026-09-22 16:40:27.935108+00	\N	f	1	8dccba9d-12b4-4d2d-9a1d-5fc14008d51c	ớt chuông	1.000	phần	\N	2
f6135689-159a-433b-a541-1fe12f0e7935	2026-09-22 16:40:27.935108+00	\N	f	1	8dccba9d-12b4-4d2d-9a1d-5fc14008d51c	đậu que	4.000	phần	\N	3
e74ef040-3443-4670-805d-34c0f8e3f2f0	2026-09-22 16:40:27.935108+00	\N	f	1	8dccba9d-12b4-4d2d-9a1d-5fc14008d51c	bún	2.000	phần	\N	4
27fcfbe1-1992-4aa4-b54f-47a040e1cd2a	2026-09-22 16:40:27.935108+00	\N	f	1	8dccba9d-12b4-4d2d-9a1d-5fc14008d51c	gừng	3.000	phần	\N	5
fddc91e6-d1cb-4e43-9112-1f68ed948a70	2026-09-22 16:40:27.935108+00	\N	f	1	8dccba9d-12b4-4d2d-9a1d-5fc14008d51c	tôm	1.000	phần	\N	6
577b8397-f559-4c03-9e30-dc0a8b8f19a7	2026-09-22 16:40:27.935108+00	\N	f	1	8dccba9d-12b4-4d2d-9a1d-5fc14008d51c	rau cải	5.000	phần	\N	7
580248e4-a824-4c74-bb4f-f31a9ae43288	2026-09-22 16:40:27.935108+00	\N	f	1	8dccba9d-12b4-4d2d-9a1d-5fc14008d51c	muối	2.000	phần	\N	8
6a30ba67-6f12-471b-b8db-a1e332229e18	2026-09-22 16:40:27.935108+00	\N	f	1	8dccba9d-12b4-4d2d-9a1d-5fc14008d51c	nước mắm	4.000	phần	\N	9
1ea56398-3436-4d9d-a5dc-f4f401a95849	2026-09-22 16:40:27.935108+00	\N	f	1	8dccba9d-12b4-4d2d-9a1d-5fc14008d51c	trứng	4.000	phần	\N	10
998d5e3a-8011-474b-931f-873959b5fa49	2026-09-22 16:40:27.935108+00	\N	f	1	8dccba9d-12b4-4d2d-9a1d-5fc14008d51c	cà rốt	5.000	phần	\N	11
f98deba4-0692-482c-90bb-f078720e475d	2026-09-22 16:40:27.935108+00	\N	f	1	24a10494-0371-4fb9-94cf-4758144aedd3	bắp cải	2.000	phần	\N	0
2f689efd-d9ae-4432-96d1-78cb3ae28759	2026-09-22 16:40:27.935108+00	\N	f	1	24a10494-0371-4fb9-94cf-4758144aedd3	dầu ăn	1.000	phần	\N	1
de625bef-3354-475e-bced-3f3e7232fc1c	2026-09-22 16:40:27.935108+00	\N	f	1	24a10494-0371-4fb9-94cf-4758144aedd3	thịt heo	5.000	phần	\N	2
7d78c427-a907-421d-9f55-2e94c2dbaccc	2026-09-22 16:40:27.935108+00	\N	f	1	24a10494-0371-4fb9-94cf-4758144aedd3	thịt gà	2.000	phần	\N	3
75b3b7cd-58dc-4238-abc3-44f2747f8852	2026-09-22 16:40:27.935108+00	\N	f	1	24a10494-0371-4fb9-94cf-4758144aedd3	đậu hũ	5.000	phần	\N	4
dc6bad7d-4335-441f-8d2b-1dca2ac68ca2	2026-09-22 16:40:27.935108+00	\N	f	1	24a10494-0371-4fb9-94cf-4758144aedd3	cà rốt	2.000	phần	\N	5
be1bdee6-a3b8-4293-b6a4-952bb263a3e9	2026-09-22 16:40:27.935108+00	\N	f	1	24a10494-0371-4fb9-94cf-4758144aedd3	mì	1.000	phần	\N	6
22f57550-a6e7-475d-b737-c8c079584e4c	2026-09-22 16:40:27.935108+00	\N	f	1	24a10494-0371-4fb9-94cf-4758144aedd3	hành tây	2.000	phần	\N	7
d7884f9a-fef6-44ed-a3c3-db0cced55104	2026-09-22 16:40:27.935108+00	\N	f	1	24a10494-0371-4fb9-94cf-4758144aedd3	thịt bò	1.000	phần	\N	8
0a9c1b9d-3db6-45e1-bdc1-0e323138d156	2026-09-22 16:40:27.935108+00	\N	f	1	24a10494-0371-4fb9-94cf-4758144aedd3	đậu que	5.000	phần	\N	9
fb533319-0e7c-4b29-97a5-484a64d6018e	2026-09-22 16:40:27.935108+00	\N	f	1	24a10494-0371-4fb9-94cf-4758144aedd3	tiêu	1.000	phần	\N	10
1694cd0e-709a-4a67-a4fb-736f7f09ffd3	2026-09-22 16:40:27.935108+00	\N	f	1	002b91a9-5ca6-4239-b385-339e48d88bd6	đậu hũ	5.000	phần	\N	0
fe8d4973-9212-4949-9f05-a6fa7fbf02cb	2026-09-22 16:40:27.935108+00	\N	f	1	002b91a9-5ca6-4239-b385-339e48d88bd6	đậu que	2.000	phần	\N	1
f882d344-5192-43ff-9fb4-636626b95d8f	2026-09-22 16:40:27.935108+00	\N	f	1	002b91a9-5ca6-4239-b385-339e48d88bd6	thịt bò	1.000	phần	\N	2
18b0f0d7-1fb9-4298-83d4-7590174cab0b	2026-09-22 16:40:27.935108+00	\N	f	1	002b91a9-5ca6-4239-b385-339e48d88bd6	rau cải	4.000	phần	\N	3
dc9072be-e34e-42fd-a07f-03ab3316d693	2026-09-22 16:40:27.935108+00	\N	f	1	002b91a9-5ca6-4239-b385-339e48d88bd6	nước mắm	1.000	phần	\N	4
7455fde5-ee28-4910-89f6-9f2088ce1ace	2026-09-22 16:40:27.935108+00	\N	f	1	002b91a9-5ca6-4239-b385-339e48d88bd6	hành tây	4.000	phần	\N	5
00383c36-924b-4d48-afb6-d660a1b42a8b	2026-09-22 16:40:27.935108+00	\N	f	1	002b91a9-5ca6-4239-b385-339e48d88bd6	cà chua	1.000	phần	\N	6
2c9a0e0a-b4c8-466b-8b51-d655852f383b	2026-09-22 16:40:27.935108+00	\N	f	1	002b91a9-5ca6-4239-b385-339e48d88bd6	gừng	5.000	phần	\N	7
4124840c-5119-4e2f-a5e9-4001a57ef314	2026-09-22 16:40:27.935108+00	\N	f	1	002b91a9-5ca6-4239-b385-339e48d88bd6	cà rốt	1.000	phần	\N	8
63c326b9-8a9d-4af4-9d80-fb9cca235f38	2026-09-22 16:40:27.935108+00	\N	f	1	002b91a9-5ca6-4239-b385-339e48d88bd6	cá	4.000	phần	\N	9
11c6d8c7-2927-4ce7-97cc-d60a8f785fb3	2026-09-22 16:40:27.935108+00	\N	f	1	4928facf-c82b-48f1-9886-2db427ee7301	thịt gà	5.000	phần	\N	0
f549b9b1-0574-4106-a6ad-60915b9a07cd	2026-09-22 16:40:27.935108+00	\N	f	1	4928facf-c82b-48f1-9886-2db427ee7301	rau cải	1.000	phần	\N	1
35852e19-a903-491e-bcf1-5b22ea48646d	2026-09-22 16:40:27.935108+00	\N	f	1	4928facf-c82b-48f1-9886-2db427ee7301	nước tương	5.000	phần	\N	2
ab45702a-a8e5-4028-a9f5-c918c2de3109	2026-09-22 16:40:27.935108+00	\N	f	1	4928facf-c82b-48f1-9886-2db427ee7301	muối	1.000	phần	\N	3
f24780fa-1164-465c-a7f1-045057d6b570	2026-09-22 16:40:27.935108+00	\N	f	1	4928facf-c82b-48f1-9886-2db427ee7301	tỏi	4.000	phần	\N	4
b0f9d805-8d90-42fa-9667-0b089df50705	2026-09-22 16:40:27.935108+00	\N	f	1	4928facf-c82b-48f1-9886-2db427ee7301	cà chua	3.000	phần	\N	5
2dd7eff9-718a-4993-aa68-71a7fccd2271	2026-09-22 16:40:27.935108+00	\N	f	1	4928facf-c82b-48f1-9886-2db427ee7301	thịt bò	3.000	phần	\N	6
0a08bc0f-b01d-4f93-89dd-f5bc918476aa	2026-09-22 16:40:27.935108+00	\N	f	1	4928facf-c82b-48f1-9886-2db427ee7301	nước mắm	3.000	phần	\N	7
f784f125-7a4a-495f-a9ff-025fb0713160	2026-09-22 16:40:27.935108+00	\N	f	1	4928facf-c82b-48f1-9886-2db427ee7301	đậu que	3.000	phần	\N	8
2b09658f-79cf-4828-aa1e-718c08b8fea2	2026-09-22 16:40:27.935108+00	\N	f	1	4928facf-c82b-48f1-9886-2db427ee7301	khoai tây	5.000	phần	\N	9
423e31fa-0720-409c-9a97-3c44e21e91d8	2026-09-22 16:40:27.935108+00	\N	f	1	4928facf-c82b-48f1-9886-2db427ee7301	gạo	1.000	phần	\N	10
fa9c9752-fa52-4a9b-ac29-5b6d6ef480cb	2026-09-22 16:40:27.935108+00	\N	f	1	f4a63e23-a5aa-4d23-8822-77aa3ee9ed24	thịt bò	1.000	phần	\N	0
d19cfcc9-61df-4355-a37e-efc2e62c62f1	2026-09-22 16:40:27.935108+00	\N	f	1	f4a63e23-a5aa-4d23-8822-77aa3ee9ed24	đậu que	2.000	phần	\N	1
284d0258-a016-4209-b67f-0288a4f3663c	2026-09-22 16:40:27.935108+00	\N	f	1	f4a63e23-a5aa-4d23-8822-77aa3ee9ed24	tiêu	3.000	phần	\N	2
98e14eb4-fd92-4c2a-9d1a-ca7f6ee548ef	2026-09-22 16:40:27.935108+00	\N	f	1	f4a63e23-a5aa-4d23-8822-77aa3ee9ed24	thịt heo	3.000	phần	\N	3
92632c1c-7796-41f6-a003-7a4ebbef4615	2026-09-22 16:40:27.935108+00	\N	f	1	f4a63e23-a5aa-4d23-8822-77aa3ee9ed24	trứng	5.000	phần	\N	4
b66dd197-b8fb-4775-9544-86944c52cf68	2026-09-22 16:40:27.935108+00	\N	f	1	f4a63e23-a5aa-4d23-8822-77aa3ee9ed24	đường	3.000	phần	\N	5
595884f3-a518-4578-8319-f895803f943d	2026-09-22 16:40:27.935108+00	\N	f	1	f4a63e23-a5aa-4d23-8822-77aa3ee9ed24	cà chua	2.000	phần	\N	6
e629a3ce-aca8-4c90-a74b-588530f3bbc4	2026-09-22 16:40:27.935108+00	\N	f	1	f4a63e23-a5aa-4d23-8822-77aa3ee9ed24	gạo	2.000	phần	\N	7
8a0e58f0-3cce-4bf4-9b92-a4e1a321151b	2026-09-22 16:40:27.935108+00	\N	f	1	f4a63e23-a5aa-4d23-8822-77aa3ee9ed24	gừng	3.000	phần	\N	8
131b0766-19bd-45ef-b5fc-a6403f5bea1b	2026-09-22 16:40:27.935108+00	\N	f	1	f4a63e23-a5aa-4d23-8822-77aa3ee9ed24	nước tương	5.000	phần	\N	9
6dbb611c-8839-44aa-bbe4-16898fb0676e	2026-09-22 16:40:27.935108+00	\N	f	1	67b9aad3-b7ff-4922-b6ce-ba52462074ad	cà chua	1.000	phần	\N	0
f56cc293-2437-40a8-903c-90abdda830b5	2026-09-22 16:40:27.935108+00	\N	f	1	67b9aad3-b7ff-4922-b6ce-ba52462074ad	nước mắm	2.000	phần	\N	1
e3981a90-98f6-41d9-8e47-7c6c27727e5e	2026-09-22 16:40:27.935108+00	\N	f	1	67b9aad3-b7ff-4922-b6ce-ba52462074ad	đậu que	3.000	phần	\N	2
ce0b3f2f-bbc7-46a8-b3d4-ef0371a8fc05	2026-09-22 16:40:27.935108+00	\N	f	1	67b9aad3-b7ff-4922-b6ce-ba52462074ad	tiêu	5.000	phần	\N	3
6ae7a814-7713-4ed2-b915-ec302ff18acd	2026-09-22 16:40:27.935108+00	\N	f	1	67b9aad3-b7ff-4922-b6ce-ba52462074ad	rau cải	3.000	phần	\N	4
665e1197-26da-4d8b-b573-ece22664c13b	2026-09-22 16:40:27.935108+00	\N	f	1	67b9aad3-b7ff-4922-b6ce-ba52462074ad	rau thơm	5.000	phần	\N	5
3eb8a9c0-70b4-429a-8b03-52ef139cd6a8	2026-09-22 16:40:27.935108+00	\N	f	1	67b9aad3-b7ff-4922-b6ce-ba52462074ad	thịt heo	1.000	phần	\N	6
94597615-02a5-4b33-9dfe-f6b592e298c8	2026-09-22 16:40:27.935108+00	\N	f	1	67b9aad3-b7ff-4922-b6ce-ba52462074ad	trứng	4.000	phần	\N	7
af53aaf5-6b43-4fa8-95fc-d85f3582e947	2026-09-22 16:40:27.935108+00	\N	f	1	67b9aad3-b7ff-4922-b6ce-ba52462074ad	nấm	1.000	phần	\N	8
269b30e9-8739-45c5-adda-4b6e71f38d43	2026-09-22 16:40:27.935108+00	\N	f	1	67b9aad3-b7ff-4922-b6ce-ba52462074ad	bắp cải	3.000	phần	\N	9
fdcc4fd1-0591-4c5c-acd6-59a617667156	2026-09-22 16:40:27.935108+00	\N	f	1	67b9aad3-b7ff-4922-b6ce-ba52462074ad	thịt bò	3.000	phần	\N	10
81d1ada8-8d0e-4e15-9c28-d56314994e29	2026-09-22 16:40:27.935108+00	\N	f	1	f7735694-c470-473b-b4d3-8557fb5a642c	gừng	2.000	phần	\N	0
a74ba8dc-e7cf-4471-a97a-4f44a6cea8b4	2026-09-22 16:40:27.935108+00	\N	f	1	f7735694-c470-473b-b4d3-8557fb5a642c	hành tây	4.000	phần	\N	1
9b5118a7-3b2e-4bd7-b0ce-2d0db6eef226	2026-09-22 16:40:27.935108+00	\N	f	1	f7735694-c470-473b-b4d3-8557fb5a642c	mì	1.000	phần	\N	2
d957c6e2-1b14-49af-b054-678ca118d970	2026-09-22 16:40:27.935108+00	\N	f	1	f7735694-c470-473b-b4d3-8557fb5a642c	bún	5.000	phần	\N	3
af711c50-8ce4-4da9-abf9-abe053a07216	2026-09-22 16:40:27.935108+00	\N	f	1	f7735694-c470-473b-b4d3-8557fb5a642c	bí đỏ	1.000	phần	\N	4
591b9444-d42a-4dbf-a9f4-8b5c59da5493	2026-09-22 16:40:27.935108+00	\N	f	1	f7735694-c470-473b-b4d3-8557fb5a642c	tiêu	4.000	phần	\N	5
a8109023-3c52-4b6b-9d4e-2c6164d1ce54	2026-09-22 16:40:27.935108+00	\N	f	1	f7735694-c470-473b-b4d3-8557fb5a642c	đậu hũ	4.000	phần	\N	6
72d5cf34-f659-4ccf-a3ce-cfb6c5d0eeab	2026-09-22 16:40:27.935108+00	\N	f	1	f7735694-c470-473b-b4d3-8557fb5a642c	dầu ăn	3.000	phần	\N	7
98516e33-a199-4f5e-b181-389a7e1c919b	2026-09-22 16:40:27.935108+00	\N	f	1	f7735694-c470-473b-b4d3-8557fb5a642c	muối	2.000	phần	\N	8
67b28639-371d-40c6-aeac-d1196446669f	2026-09-22 16:40:27.935108+00	\N	f	1	f7735694-c470-473b-b4d3-8557fb5a642c	đường	5.000	phần	\N	9
e63f3146-bd15-48fc-86fa-288c9bfcafd1	2026-09-22 16:40:27.935108+00	\N	f	1	f7735694-c470-473b-b4d3-8557fb5a642c	ớt chuông	3.000	phần	\N	10
d9805a7e-5a38-45bd-a308-41d9bb89ce72	2026-09-22 16:40:27.935108+00	\N	f	1	4548ae76-9712-45e4-a504-aa9907e39f05	nước mắm	5.000	phần	\N	0
4491fef7-03e5-4b9d-b374-22b90a5855a0	2026-09-22 16:40:27.935108+00	\N	f	1	4548ae76-9712-45e4-a504-aa9907e39f05	cá	1.000	phần	\N	1
ccd688bc-0ce5-4c1f-b9df-90c2570447b4	2026-09-22 16:40:27.935108+00	\N	f	1	4548ae76-9712-45e4-a504-aa9907e39f05	thịt gà	5.000	phần	\N	2
c77b7e25-9869-499f-8c75-b431c355f8ad	2026-09-22 16:40:27.935108+00	\N	f	1	4548ae76-9712-45e4-a504-aa9907e39f05	đậu hũ	3.000	phần	\N	3
76d039f4-7810-422b-9507-3088ec822734	2026-09-22 16:40:27.935108+00	\N	f	1	4548ae76-9712-45e4-a504-aa9907e39f05	hành lá	1.000	phần	\N	4
368833f7-6f60-4aa7-ad65-b1253bed8581	2026-09-22 16:40:27.935108+00	\N	f	1	4548ae76-9712-45e4-a504-aa9907e39f05	dầu ăn	2.000	phần	\N	5
e2feba77-f9fc-4336-88d3-a41985be323b	2026-09-22 16:40:27.935108+00	\N	f	1	4548ae76-9712-45e4-a504-aa9907e39f05	tôm	5.000	phần	\N	6
97dcdc17-dcd3-4e8d-aa04-61e09aaf7e7a	2026-09-22 16:40:27.935108+00	\N	f	1	4548ae76-9712-45e4-a504-aa9907e39f05	muối	1.000	phần	\N	7
611d804d-70db-4291-b342-c93130852c81	2026-09-22 16:40:27.935108+00	\N	f	1	4548ae76-9712-45e4-a504-aa9907e39f05	bắp cải	5.000	phần	\N	8
87a8b0d8-dbad-4acd-a7f7-e2710105643b	2026-09-22 16:40:27.935108+00	\N	f	1	4548ae76-9712-45e4-a504-aa9907e39f05	gừng	4.000	phần	\N	9
b5cc82a9-1738-45b1-943e-9d09eb7cee2e	2026-09-22 16:40:27.935108+00	\N	f	1	4548ae76-9712-45e4-a504-aa9907e39f05	nấm	1.000	phần	\N	10
2390cc3d-53a2-4d7d-b8b2-be1bcae23bc8	2026-09-22 16:40:27.935108+00	\N	f	1	0b417a11-2833-4b53-9222-3a9856648872	bắp cải	2.000	phần	\N	0
606e6dce-4298-4c03-bd6d-18982f00fb0c	2026-09-22 16:40:27.935108+00	\N	f	1	0b417a11-2833-4b53-9222-3a9856648872	thịt bò	2.000	phần	\N	1
9618254b-76e1-4b5d-884d-43134768976a	2026-09-22 16:40:27.935108+00	\N	f	1	0b417a11-2833-4b53-9222-3a9856648872	trứng	2.000	phần	\N	2
65aeb6b3-005f-4292-8176-204502019efa	2026-09-22 16:40:27.935108+00	\N	f	1	0b417a11-2833-4b53-9222-3a9856648872	bí đỏ	3.000	phần	\N	3
55b1f928-0431-416c-a415-4261b67d1eb4	2026-09-22 16:40:27.935108+00	\N	f	1	0b417a11-2833-4b53-9222-3a9856648872	đậu que	1.000	phần	\N	4
ea539f57-6b2b-43a2-ae9b-aef5c4eb76ce	2026-09-22 16:40:27.935108+00	\N	f	1	0b417a11-2833-4b53-9222-3a9856648872	mì	5.000	phần	\N	5
d91add95-6e35-4710-992e-d6536ffab669	2026-09-22 16:40:27.935108+00	\N	f	1	0b417a11-2833-4b53-9222-3a9856648872	tỏi	4.000	phần	\N	6
0d2e1876-f25e-426e-b25d-744a91e8fffb	2026-09-22 16:40:27.935108+00	\N	f	1	0b417a11-2833-4b53-9222-3a9856648872	rau cải	1.000	phần	\N	7
9e76f5ef-96f9-4324-bff5-2fc6eca505a9	2026-09-22 16:40:27.935108+00	\N	f	1	0b417a11-2833-4b53-9222-3a9856648872	dầu ăn	5.000	phần	\N	8
d9f05e6d-9c7b-4c59-b2cd-ebfea126e789	2026-09-22 16:40:27.935108+00	\N	f	1	0b417a11-2833-4b53-9222-3a9856648872	ớt chuông	2.000	phần	\N	9
fef63e5e-715c-4f8c-bab2-4e5d0784858f	2026-09-22 16:40:27.935108+00	\N	f	1	0b417a11-2833-4b53-9222-3a9856648872	tiêu	3.000	phần	\N	10
a1fe954a-3e32-46de-b34f-c6a8fe6cd0a7	2026-09-22 16:40:27.935108+00	\N	f	1	0b417a11-2833-4b53-9222-3a9856648872	nước mắm	4.000	phần	\N	11
f501ca15-e289-4507-bbde-81ff10fe1ade	2026-09-22 16:40:27.935108+00	\N	f	1	4c69c3ad-4c91-4e42-9a0e-31bc940cdb3a	khoai tây	5.000	phần	\N	0
cf9c4cb7-55ff-44b7-bbe5-39a0905eb770	2026-09-22 16:40:27.935108+00	\N	f	1	4c69c3ad-4c91-4e42-9a0e-31bc940cdb3a	tiêu	4.000	phần	\N	1
c5e440c6-435b-4b9d-9055-99ae0bf24890	2026-09-22 16:40:27.935108+00	\N	f	1	4c69c3ad-4c91-4e42-9a0e-31bc940cdb3a	rau thơm	1.000	phần	\N	2
fd9c9a43-8e9a-44a8-9704-3c26c609ea65	2026-09-22 16:40:27.935108+00	\N	f	1	4c69c3ad-4c91-4e42-9a0e-31bc940cdb3a	bún	4.000	phần	\N	3
d8cc4287-61bb-4fc8-b273-2a24bcca07c6	2026-09-22 16:40:27.935108+00	\N	f	1	4c69c3ad-4c91-4e42-9a0e-31bc940cdb3a	cá	4.000	phần	\N	4
f8c4de6a-4f6d-4b1d-bc6a-b4d3362374c0	2026-09-22 16:40:27.935108+00	\N	f	1	4c69c3ad-4c91-4e42-9a0e-31bc940cdb3a	bắp cải	3.000	phần	\N	5
bfdb6737-a44b-4b52-b6fa-e21f9dcd6894	2026-09-22 16:40:27.935108+00	\N	f	1	4c69c3ad-4c91-4e42-9a0e-31bc940cdb3a	rau cải	1.000	phần	\N	6
c99dd911-649a-416e-9905-1b3d04475dec	2026-09-22 16:40:27.935108+00	\N	f	1	4c69c3ad-4c91-4e42-9a0e-31bc940cdb3a	tôm	2.000	phần	\N	7
4a04a3c8-cd6a-4288-b983-12289509bb97	2026-09-22 16:40:27.935108+00	\N	f	1	4c69c3ad-4c91-4e42-9a0e-31bc940cdb3a	gừng	3.000	phần	\N	8
bb792f46-0c78-4801-ac1d-c84e9da56c5c	2026-09-22 16:40:27.935108+00	\N	f	1	4c69c3ad-4c91-4e42-9a0e-31bc940cdb3a	thịt gà	2.000	phần	\N	9
03678d8b-c9de-46f4-bcc0-df4f0ec37144	2026-09-22 16:40:27.935108+00	\N	f	1	4c69c3ad-4c91-4e42-9a0e-31bc940cdb3a	dầu ăn	5.000	phần	\N	10
31efaf9f-21d4-47e8-b50d-f17217942d23	2026-09-22 16:40:27.935108+00	\N	f	1	254dc0a9-d270-47ab-ba08-d4cd5408a1b7	tôm	3.000	phần	\N	0
1e7abf48-6d5b-43a3-95bf-701c84ef695d	2026-09-22 16:40:27.935108+00	\N	f	1	254dc0a9-d270-47ab-ba08-d4cd5408a1b7	thịt gà	2.000	phần	\N	1
3546de5f-defe-49da-af94-db86a394109a	2026-09-22 16:40:27.935108+00	\N	f	1	254dc0a9-d270-47ab-ba08-d4cd5408a1b7	mì	1.000	phần	\N	2
b7e77ab0-d4d1-4fe8-a4c4-49aff68a77ba	2026-09-22 16:40:27.935108+00	\N	f	1	254dc0a9-d270-47ab-ba08-d4cd5408a1b7	bí đỏ	3.000	phần	\N	3
1bda002f-5efc-4a90-bf75-8b02ecb2e604	2026-09-22 16:40:27.935108+00	\N	f	1	254dc0a9-d270-47ab-ba08-d4cd5408a1b7	rau cải	1.000	phần	\N	4
09dc1797-fdf6-49d2-933b-87938b235f97	2026-09-22 16:40:27.935108+00	\N	f	1	254dc0a9-d270-47ab-ba08-d4cd5408a1b7	rau thơm	1.000	phần	\N	5
3581d8d5-2175-4313-8ef4-219ff2ea64a7	2026-09-22 16:40:27.935108+00	\N	f	1	254dc0a9-d270-47ab-ba08-d4cd5408a1b7	hành tây	2.000	phần	\N	6
2b48f304-fca8-4a02-9420-73d14013048c	2026-09-22 16:40:27.935108+00	\N	f	1	254dc0a9-d270-47ab-ba08-d4cd5408a1b7	nước mắm	5.000	phần	\N	7
cc9608be-f0c4-442d-b341-446be5cb8b84	2026-09-22 16:40:27.935108+00	\N	f	1	254dc0a9-d270-47ab-ba08-d4cd5408a1b7	thịt bò	1.000	phần	\N	8
391b78d5-90bf-4879-b064-186d7e8ebb30	2026-09-22 16:40:27.935108+00	\N	f	1	254dc0a9-d270-47ab-ba08-d4cd5408a1b7	dầu ăn	5.000	phần	\N	9
2821cead-d281-4299-9a96-6a33599836f9	2026-09-22 16:40:27.935108+00	\N	f	1	c1621222-23ce-4ea4-8779-9882684c6adf	tỏi	5.000	phần	\N	0
96fe47dc-f131-46c5-8129-fa97131c66d0	2026-09-22 16:40:27.935108+00	\N	f	1	c1621222-23ce-4ea4-8779-9882684c6adf	hành tây	5.000	phần	\N	1
f108936a-9fba-48da-9df5-6f884eb1d778	2026-09-22 16:40:27.935108+00	\N	f	1	c1621222-23ce-4ea4-8779-9882684c6adf	cà chua	1.000	phần	\N	2
2f4e3c5b-6b27-4c85-8dac-390d066057e1	2026-09-22 16:40:27.935108+00	\N	f	1	c1621222-23ce-4ea4-8779-9882684c6adf	bắp cải	5.000	phần	\N	3
fba7b859-cff2-4ca6-9ada-fd46482de5eb	2026-09-22 16:40:27.935108+00	\N	f	1	c1621222-23ce-4ea4-8779-9882684c6adf	trứng	4.000	phần	\N	4
26139a5e-aaaf-4880-88c4-bcd1e252b97f	2026-09-22 16:40:27.935108+00	\N	f	1	c1621222-23ce-4ea4-8779-9882684c6adf	cá	1.000	phần	\N	5
d0a4a4c7-7a6e-4a5b-b7f5-20fca6a258a0	2026-09-22 16:40:27.935108+00	\N	f	1	c1621222-23ce-4ea4-8779-9882684c6adf	bí đỏ	1.000	phần	\N	6
cd840fdb-0294-4c57-8aaf-1049cf0b96c9	2026-09-22 16:40:27.935108+00	\N	f	1	c1621222-23ce-4ea4-8779-9882684c6adf	muối	1.000	phần	\N	7
a6fbdbca-eefb-44a3-8e4f-4ec3f4f451d6	2026-09-22 16:40:27.935108+00	\N	f	1	c1621222-23ce-4ea4-8779-9882684c6adf	bún	2.000	phần	\N	8
a473f145-0f7d-415c-a425-b008d83ede10	2026-09-22 16:40:27.935108+00	\N	f	1	c1621222-23ce-4ea4-8779-9882684c6adf	nấm	5.000	phần	\N	9
29589379-30ab-49fb-820d-23dfdbe0df81	2026-09-22 16:40:27.935108+00	\N	f	1	c1621222-23ce-4ea4-8779-9882684c6adf	gạo	4.000	phần	\N	10
6eb7e20d-d4a9-4143-9daa-657f92f2f7f3	2026-09-22 16:40:27.935108+00	\N	f	1	c1621222-23ce-4ea4-8779-9882684c6adf	khoai tây	3.000	phần	\N	11
bca607ec-e314-46e5-b927-9786c6404b08	2026-09-22 16:40:27.935108+00	\N	f	1	c3668171-26a6-485b-b0bd-1beb69f63762	thịt heo	3.000	phần	\N	0
dc77f54b-0dea-4ce5-a751-98358ad74956	2026-09-22 16:40:27.935108+00	\N	f	1	c3668171-26a6-485b-b0bd-1beb69f63762	mì	3.000	phần	\N	1
13660d5b-ec5d-4a22-be88-399da2c46920	2026-09-22 16:40:27.935108+00	\N	f	1	c3668171-26a6-485b-b0bd-1beb69f63762	tôm	2.000	phần	\N	2
fb2d3b19-c24e-4cf5-8927-b470e0090903	2026-09-22 16:40:27.935108+00	\N	f	1	c3668171-26a6-485b-b0bd-1beb69f63762	muối	5.000	phần	\N	3
3e43e113-0d30-4d50-b886-269fb70f05d4	2026-09-22 16:40:27.935108+00	\N	f	1	c3668171-26a6-485b-b0bd-1beb69f63762	bắp cải	1.000	phần	\N	4
1ee3d2cf-2b09-4bbe-9778-f393c03a58b6	2026-09-22 16:40:27.935108+00	\N	f	1	c3668171-26a6-485b-b0bd-1beb69f63762	đậu hũ	2.000	phần	\N	5
e5f8e3e0-90e1-4fad-b839-d2dcee0f8654	2026-09-22 16:40:27.935108+00	\N	f	1	c3668171-26a6-485b-b0bd-1beb69f63762	nước tương	2.000	phần	\N	6
436d2e71-9bce-4ccb-93b4-1b4e303bd3d3	2026-09-22 16:40:27.935108+00	\N	f	1	c3668171-26a6-485b-b0bd-1beb69f63762	cá	4.000	phần	\N	7
33ce996a-5691-4010-b963-9b00d3c023a9	2026-09-22 16:40:27.935108+00	\N	f	1	c3668171-26a6-485b-b0bd-1beb69f63762	bí đỏ	4.000	phần	\N	8
6f6a0eee-5e82-4ae6-a834-7efd839aaa8f	2026-09-22 16:40:27.935108+00	\N	f	1	c3668171-26a6-485b-b0bd-1beb69f63762	nấm	2.000	phần	\N	9
aa3b68ad-3d95-4ca2-83bd-dd773d53f456	2026-09-22 16:40:27.935108+00	\N	f	1	c3668171-26a6-485b-b0bd-1beb69f63762	hành tây	2.000	phần	\N	10
86fa4d72-7faa-4b4b-9937-bfcbf8b67021	2026-09-22 16:40:27.935108+00	\N	f	1	55912428-102a-4a22-9469-dbd50bf77a30	thịt heo	5.000	phần	\N	0
940516cb-0dd0-4693-9c96-802eb21092f0	2026-09-22 16:40:27.935108+00	\N	f	1	55912428-102a-4a22-9469-dbd50bf77a30	rau cải	4.000	phần	\N	1
04d0d4a6-7e74-48c7-902a-87459c56494b	2026-09-22 16:40:27.935108+00	\N	f	1	55912428-102a-4a22-9469-dbd50bf77a30	cà chua	2.000	phần	\N	2
18e0c58a-cdd6-4f6e-b66a-6c176a4c6668	2026-09-22 16:40:27.935108+00	\N	f	1	55912428-102a-4a22-9469-dbd50bf77a30	hành tây	3.000	phần	\N	3
78991e7a-7e20-4df0-af91-9843a9b1db3f	2026-09-22 16:40:27.935108+00	\N	f	1	55912428-102a-4a22-9469-dbd50bf77a30	tiêu	2.000	phần	\N	4
2e338cd9-a6d3-4e69-9ad5-84004deb219f	2026-09-22 16:40:27.935108+00	\N	f	1	55912428-102a-4a22-9469-dbd50bf77a30	cà rốt	5.000	phần	\N	5
6019487e-0c41-4511-bfbc-34f9fd536fed	2026-09-22 16:40:27.935108+00	\N	f	1	55912428-102a-4a22-9469-dbd50bf77a30	rau thơm	1.000	phần	\N	6
f1eca1d4-3030-4853-b173-7dcb6fb40609	2026-09-22 16:40:27.935108+00	\N	f	1	55912428-102a-4a22-9469-dbd50bf77a30	cá	2.000	phần	\N	7
f78c030a-7832-4e2b-8485-05f6936a0a30	2026-09-22 16:40:27.935108+00	\N	f	1	55912428-102a-4a22-9469-dbd50bf77a30	đường	4.000	phần	\N	8
11566d90-c420-46db-a9a4-24693e55e9bd	2026-09-22 16:40:27.935108+00	\N	f	1	55912428-102a-4a22-9469-dbd50bf77a30	bún	3.000	phần	\N	9
061db260-54e4-4f93-b97f-fe77145d27a3	2026-09-22 16:40:27.935108+00	\N	f	1	07941b56-fc37-4e04-ba2b-0909d1c5eafa	ớt chuông	1.000	phần	\N	0
0bd7c35a-d550-44d9-a111-7950637cfe3b	2026-09-22 16:40:27.935108+00	\N	f	1	07941b56-fc37-4e04-ba2b-0909d1c5eafa	đậu que	1.000	phần	\N	1
ebaab080-7088-4b7f-9015-9eb8bbe37a87	2026-09-22 16:40:27.935108+00	\N	f	1	07941b56-fc37-4e04-ba2b-0909d1c5eafa	khoai tây	1.000	phần	\N	2
bcf10121-4f01-4232-8f6e-0ec2a2ad2dc1	2026-09-22 16:40:27.935108+00	\N	f	1	07941b56-fc37-4e04-ba2b-0909d1c5eafa	gừng	4.000	phần	\N	3
b3256a1e-762b-460c-ab27-cb3194162d7a	2026-09-22 16:40:27.935108+00	\N	f	1	07941b56-fc37-4e04-ba2b-0909d1c5eafa	đường	1.000	phần	\N	4
1a656144-7803-4490-b00f-ee96ab2f24ad	2026-09-22 16:40:27.935108+00	\N	f	1	07941b56-fc37-4e04-ba2b-0909d1c5eafa	tiêu	1.000	phần	\N	5
bf3204ad-1b8e-45f2-8eef-daf024e8abe0	2026-09-22 16:40:27.935108+00	\N	f	1	07941b56-fc37-4e04-ba2b-0909d1c5eafa	bắp cải	3.000	phần	\N	6
f9b21bf0-1ba4-46c7-b7f1-888702f787a5	2026-09-22 16:40:27.935108+00	\N	f	1	07941b56-fc37-4e04-ba2b-0909d1c5eafa	hành lá	2.000	phần	\N	7
ee4d92ac-c599-4512-ba19-d08a87ed4828	2026-09-22 16:40:27.935108+00	\N	f	1	07941b56-fc37-4e04-ba2b-0909d1c5eafa	thịt gà	4.000	phần	\N	8
aab6e53a-377f-4676-be30-cab6a7b7a90c	2026-09-22 16:40:27.935108+00	\N	f	1	07941b56-fc37-4e04-ba2b-0909d1c5eafa	mì	1.000	phần	\N	9
eaa33039-e860-49de-885c-e7ae0e64bcc5	2026-09-22 16:40:27.935108+00	\N	f	1	db57d063-8581-44b7-9ae7-4357288c86c6	cà chua	3.000	phần	\N	0
0645a57f-727e-4102-a9fe-11f5fed0b560	2026-09-22 16:40:27.935108+00	\N	f	1	db57d063-8581-44b7-9ae7-4357288c86c6	cá	3.000	phần	\N	1
534dd0ff-5056-49d6-87fa-94ab4df1f92b	2026-09-22 16:40:27.935108+00	\N	f	1	db57d063-8581-44b7-9ae7-4357288c86c6	ớt chuông	2.000	phần	\N	2
8943b2bf-4e20-44fd-875f-990edfc798ee	2026-09-22 16:40:27.935108+00	\N	f	1	db57d063-8581-44b7-9ae7-4357288c86c6	thịt gà	1.000	phần	\N	3
a07d817a-a042-4bbc-9bf5-7499dc474f56	2026-09-22 16:40:27.935108+00	\N	f	1	db57d063-8581-44b7-9ae7-4357288c86c6	mì	2.000	phần	\N	4
0c6f5550-0935-4fd3-b61a-ac71bc0d07d1	2026-09-22 16:40:27.935108+00	\N	f	1	db57d063-8581-44b7-9ae7-4357288c86c6	gạo	5.000	phần	\N	5
db7f06e5-b8db-4bc6-99b8-22521c10d589	2026-09-22 16:40:27.935108+00	\N	f	1	db57d063-8581-44b7-9ae7-4357288c86c6	đường	3.000	phần	\N	6
0264e6cb-de4b-489f-8447-9eb54ad2b64f	2026-09-22 16:40:27.935108+00	\N	f	1	db57d063-8581-44b7-9ae7-4357288c86c6	rau cải	5.000	phần	\N	7
3c304e81-1a2a-4a22-9d9f-427085bce999	2026-09-22 16:40:27.935108+00	\N	f	1	db57d063-8581-44b7-9ae7-4357288c86c6	dầu ăn	4.000	phần	\N	8
2156db2a-f993-40e0-bc3b-ef8075924978	2026-09-22 16:40:27.935108+00	\N	f	1	db57d063-8581-44b7-9ae7-4357288c86c6	hành lá	1.000	phần	\N	9
51611715-6695-48bb-848b-3c604572dd11	2026-09-22 16:40:27.935108+00	\N	f	1	db57d063-8581-44b7-9ae7-4357288c86c6	nấm	4.000	phần	\N	10
a9015a39-402f-4edd-bbed-c35eff66ccdf	2026-09-22 16:40:27.935108+00	\N	f	1	db57d063-8581-44b7-9ae7-4357288c86c6	thịt heo	5.000	phần	\N	11
66ba5ab4-335f-4736-9928-450767854198	2026-09-22 16:40:27.935108+00	\N	f	1	d559b794-996c-4ca7-a987-6a17c5327fcd	ớt chuông	1.000	phần	\N	0
49e26e8c-9a52-402b-9a3d-4e832f4fdb28	2026-09-22 16:40:27.935108+00	\N	f	1	d559b794-996c-4ca7-a987-6a17c5327fcd	muối	4.000	phần	\N	1
f8da6716-0cbe-4221-9324-7e7f95bb2a02	2026-09-22 16:40:27.935108+00	\N	f	1	d559b794-996c-4ca7-a987-6a17c5327fcd	tỏi	4.000	phần	\N	2
79b6b031-b981-45d0-93d5-de64f2d54c6e	2026-09-22 16:40:27.935108+00	\N	f	1	d559b794-996c-4ca7-a987-6a17c5327fcd	cà chua	3.000	phần	\N	3
0f7f7781-8667-4d4d-8f70-ebe258769b61	2026-09-22 16:40:27.935108+00	\N	f	1	d559b794-996c-4ca7-a987-6a17c5327fcd	gạo	4.000	phần	\N	4
5fc77f75-8a0e-4148-b02c-e676267c894d	2026-09-22 16:40:27.935108+00	\N	f	1	d559b794-996c-4ca7-a987-6a17c5327fcd	thịt gà	2.000	phần	\N	5
d28ab6b1-ac7e-4a77-9e9f-6d79226f5a2c	2026-09-22 16:40:27.935108+00	\N	f	1	d559b794-996c-4ca7-a987-6a17c5327fcd	bắp cải	1.000	phần	\N	6
e04bb951-488f-489a-b752-d55770a6e4d6	2026-09-22 16:40:27.935108+00	\N	f	1	d559b794-996c-4ca7-a987-6a17c5327fcd	tiêu	3.000	phần	\N	7
ff9ea55d-0df8-49e8-9582-82bcfe7ac371	2026-09-22 16:40:27.935108+00	\N	f	1	d559b794-996c-4ca7-a987-6a17c5327fcd	trứng	3.000	phần	\N	8
3d0853c8-1e84-44e5-9982-34ca84ada233	2026-09-22 16:40:27.935108+00	\N	f	1	d559b794-996c-4ca7-a987-6a17c5327fcd	nấm	5.000	phần	\N	9
e5720826-053c-432b-9161-b2d89fb0114d	2026-09-22 16:40:27.935108+00	\N	f	1	d559b794-996c-4ca7-a987-6a17c5327fcd	khoai tây	2.000	phần	\N	10
308074c4-4b03-4f21-bd6d-451a0c3d8fb1	2026-09-22 16:40:27.935108+00	\N	f	1	d559b794-996c-4ca7-a987-6a17c5327fcd	nước mắm	5.000	phần	\N	11
93f0155e-39cc-472a-ae41-ab1454cbc47c	2026-09-22 16:40:27.935108+00	\N	f	1	348fddfe-7f64-4fb3-95b6-c14a3ad63c00	hành lá	5.000	phần	\N	0
3afdaf38-cdb9-4ac5-b868-8e398efd1752	2026-09-22 16:40:27.935108+00	\N	f	1	348fddfe-7f64-4fb3-95b6-c14a3ad63c00	trứng	2.000	phần	\N	1
796151fa-bf0a-485e-b6e2-8cbd02855a1e	2026-09-22 16:40:27.935108+00	\N	f	1	348fddfe-7f64-4fb3-95b6-c14a3ad63c00	tiêu	1.000	phần	\N	2
7210c688-0e9c-4a8c-bd9e-6ba05c248bd8	2026-09-22 16:40:27.935108+00	\N	f	1	348fddfe-7f64-4fb3-95b6-c14a3ad63c00	thịt heo	2.000	phần	\N	3
04e36245-89e9-4b48-896a-af0d8a451daf	2026-09-22 16:40:27.935108+00	\N	f	1	348fddfe-7f64-4fb3-95b6-c14a3ad63c00	bí đỏ	5.000	phần	\N	4
acfb6e5c-7f51-4f11-bcbd-aec656e90f0d	2026-09-22 16:40:27.935108+00	\N	f	1	348fddfe-7f64-4fb3-95b6-c14a3ad63c00	thịt gà	4.000	phần	\N	5
7cec267f-5b67-4642-952a-80ca1434758f	2026-09-22 16:40:27.935108+00	\N	f	1	348fddfe-7f64-4fb3-95b6-c14a3ad63c00	đường	4.000	phần	\N	6
df62bbd3-5461-460c-9a8e-6cbb5b881eb2	2026-09-22 16:40:27.935108+00	\N	f	1	348fddfe-7f64-4fb3-95b6-c14a3ad63c00	đậu hũ	3.000	phần	\N	7
df3baf9f-ca0c-4d2c-85cb-8ed67ab2bd2c	2026-09-22 16:40:27.935108+00	\N	f	1	348fddfe-7f64-4fb3-95b6-c14a3ad63c00	tôm	4.000	phần	\N	8
4e925d4a-10ab-4351-b09a-58f378c4e64d	2026-09-22 16:40:27.935108+00	\N	f	1	348fddfe-7f64-4fb3-95b6-c14a3ad63c00	ớt chuông	2.000	phần	\N	9
14d1bb9a-053b-42f5-a745-5851020787c9	2026-09-22 16:40:27.935108+00	\N	f	1	348fddfe-7f64-4fb3-95b6-c14a3ad63c00	cá	2.000	phần	\N	10
7aa42901-39ff-4fcf-907c-d3b2f8f03815	2026-09-22 16:40:27.935108+00	\N	f	1	e129e855-dd11-41d6-8189-fb3d3044f076	hành lá	1.000	phần	\N	0
fa261ac8-9254-43ed-89c1-7c463fc7598d	2026-09-22 16:40:27.935108+00	\N	f	1	e129e855-dd11-41d6-8189-fb3d3044f076	dầu ăn	4.000	phần	\N	1
dd6ee517-4081-4415-bac8-0f1546914dd7	2026-09-22 16:40:27.935108+00	\N	f	1	e129e855-dd11-41d6-8189-fb3d3044f076	trứng	4.000	phần	\N	2
1188c011-a93a-429a-9a32-4da587eececa	2026-09-22 16:40:27.935108+00	\N	f	1	e129e855-dd11-41d6-8189-fb3d3044f076	gừng	2.000	phần	\N	3
4e500183-a51e-4738-a322-fc95519e4c61	2026-09-22 16:40:27.935108+00	\N	f	1	e129e855-dd11-41d6-8189-fb3d3044f076	nấm	5.000	phần	\N	4
a703314a-2b72-4517-8af6-8ecec4cf4ca3	2026-09-22 16:40:27.935108+00	\N	f	1	e129e855-dd11-41d6-8189-fb3d3044f076	rau cải	5.000	phần	\N	5
dcd9dae0-86f8-48a6-a240-c98a96e30148	2026-09-22 16:40:27.935108+00	\N	f	1	e129e855-dd11-41d6-8189-fb3d3044f076	rau thơm	4.000	phần	\N	6
3c6df24b-2fe1-433f-ae27-fcd29b5d2f45	2026-09-22 16:40:27.935108+00	\N	f	1	e129e855-dd11-41d6-8189-fb3d3044f076	bắp cải	1.000	phần	\N	7
c07a2cbc-90ff-45ca-a97e-1b583f746fb2	2026-09-22 16:40:27.935108+00	\N	f	1	e129e855-dd11-41d6-8189-fb3d3044f076	ớt chuông	2.000	phần	\N	8
701fa6f0-0188-4207-9f51-6961640b9097	2026-09-22 16:40:27.935108+00	\N	f	1	e129e855-dd11-41d6-8189-fb3d3044f076	thịt bò	1.000	phần	\N	9
afa81512-b4e0-4a20-83e8-6f9ac0760cf8	2026-09-22 16:40:27.935108+00	\N	f	1	e129e855-dd11-41d6-8189-fb3d3044f076	gạo	5.000	phần	\N	10
d367426c-f279-4aae-aae7-f2280a727849	2026-09-22 16:40:27.935108+00	\N	f	1	e129e855-dd11-41d6-8189-fb3d3044f076	khoai tây	2.000	phần	\N	11
5a34cf9c-823b-4d22-8394-7a699f13d5c7	2026-09-22 16:40:27.935108+00	\N	f	1	4037f256-e830-4bea-a6e2-1ca411095a6f	dầu ăn	4.000	phần	\N	0
86959eb5-ccaa-4502-87fe-92f3073f1097	2026-09-22 16:40:27.935108+00	\N	f	1	4037f256-e830-4bea-a6e2-1ca411095a6f	rau thơm	4.000	phần	\N	1
680f1ab8-c63d-43bd-b334-6716dc87b660	2026-09-22 16:40:27.935108+00	\N	f	1	4037f256-e830-4bea-a6e2-1ca411095a6f	hành lá	3.000	phần	\N	2
8585ccfa-de3d-4427-abd9-a70970fee5f5	2026-09-22 16:40:27.935108+00	\N	f	1	4037f256-e830-4bea-a6e2-1ca411095a6f	tỏi	4.000	phần	\N	3
14e2031b-5646-4693-9d58-2a185ae6685c	2026-09-22 16:40:27.935108+00	\N	f	1	4037f256-e830-4bea-a6e2-1ca411095a6f	trứng	4.000	phần	\N	4
fcca2f53-bbaa-48da-9c54-d8a8a1a96618	2026-09-22 16:40:27.935108+00	\N	f	1	4037f256-e830-4bea-a6e2-1ca411095a6f	cà chua	5.000	phần	\N	5
c48f3c5e-8573-469f-9e6a-f0d5a22c9dbf	2026-09-22 16:40:27.935108+00	\N	f	1	4037f256-e830-4bea-a6e2-1ca411095a6f	muối	1.000	phần	\N	6
26bdc45f-1671-486e-b9a6-f6c68adf8d35	2026-09-22 16:40:27.935108+00	\N	f	1	4037f256-e830-4bea-a6e2-1ca411095a6f	cà rốt	5.000	phần	\N	7
323d122a-f4d1-4d0e-a587-edc04d44fa50	2026-09-22 16:40:27.935108+00	\N	f	1	4037f256-e830-4bea-a6e2-1ca411095a6f	nước tương	3.000	phần	\N	8
a7373e13-37fc-47c8-bd5b-052180b7ef18	2026-09-22 16:40:27.935108+00	\N	f	1	4037f256-e830-4bea-a6e2-1ca411095a6f	tiêu	1.000	phần	\N	9
83109b99-fc24-441f-ac33-e7048d0a8756	2026-09-22 16:40:27.935108+00	\N	f	1	4037f256-e830-4bea-a6e2-1ca411095a6f	thịt heo	2.000	phần	\N	10
f4027e83-ca59-4d0a-a320-1f6ab083c7b7	2026-09-22 16:40:27.935108+00	\N	f	1	2e96fe2e-5745-4849-b64b-9ed07902a179	tỏi	5.000	phần	\N	0
187508a5-0820-403b-b01c-46bbc973ec89	2026-09-22 16:40:27.935108+00	\N	f	1	2e96fe2e-5745-4849-b64b-9ed07902a179	khoai tây	2.000	phần	\N	1
48613c44-3995-4fe0-8f33-544d9d68df2d	2026-09-22 16:40:27.935108+00	\N	f	1	2e96fe2e-5745-4849-b64b-9ed07902a179	nấm	4.000	phần	\N	2
13fb61f7-214a-4163-929d-9b804ef2bbdc	2026-09-22 16:40:27.935108+00	\N	f	1	2e96fe2e-5745-4849-b64b-9ed07902a179	rau thơm	3.000	phần	\N	3
e8c2041b-57b5-49cb-a41c-7d11a4715146	2026-09-22 16:40:27.935108+00	\N	f	1	2e96fe2e-5745-4849-b64b-9ed07902a179	cà chua	2.000	phần	\N	4
10311690-717a-4d0f-90f8-608228b8146d	2026-09-22 16:40:27.935108+00	\N	f	1	2e96fe2e-5745-4849-b64b-9ed07902a179	trứng	3.000	phần	\N	5
ea8f48d1-aa5f-4204-80e0-dd331df87354	2026-09-22 16:40:27.935108+00	\N	f	1	2e96fe2e-5745-4849-b64b-9ed07902a179	cà rốt	4.000	phần	\N	6
e912bd36-66d5-46e0-9d43-ce7399b25a42	2026-09-22 16:40:27.935108+00	\N	f	1	2e96fe2e-5745-4849-b64b-9ed07902a179	muối	5.000	phần	\N	7
31638e3d-4422-40fb-bafd-8e4ab6505395	2026-09-22 16:40:27.935108+00	\N	f	1	2e96fe2e-5745-4849-b64b-9ed07902a179	gạo	2.000	phần	\N	8
aa944743-748d-40f4-8c34-b709fa5fcdad	2026-09-22 16:40:27.935108+00	\N	f	1	2e96fe2e-5745-4849-b64b-9ed07902a179	đường	1.000	phần	\N	9
58cc3bee-82bb-4af9-b052-0565733b6389	2026-09-22 16:40:27.935108+00	\N	f	1	f1c3df32-5906-492a-beba-4197b0ca4f8b	hành lá	5.000	phần	\N	0
a74f5c5a-80ca-4d56-9341-95e7a417f16a	2026-09-22 16:40:27.935108+00	\N	f	1	f1c3df32-5906-492a-beba-4197b0ca4f8b	mì	5.000	phần	\N	1
b4d49ad6-d3ed-48a6-a0ab-8958d6acec05	2026-09-22 16:40:27.935108+00	\N	f	1	f1c3df32-5906-492a-beba-4197b0ca4f8b	cá	2.000	phần	\N	2
6b03bb15-fc94-463e-9476-03c04810e075	2026-09-22 16:40:27.935108+00	\N	f	1	f1c3df32-5906-492a-beba-4197b0ca4f8b	thịt bò	1.000	phần	\N	3
49328032-f607-414d-a121-e0e239829fd7	2026-09-22 16:40:27.935108+00	\N	f	1	f1c3df32-5906-492a-beba-4197b0ca4f8b	tiêu	1.000	phần	\N	4
68f6a4ee-c0d6-4ffa-9f92-d3b4c2c32673	2026-09-22 16:40:27.935108+00	\N	f	1	f1c3df32-5906-492a-beba-4197b0ca4f8b	gạo	1.000	phần	\N	5
af8d44d1-b61c-41fa-9b73-1c9d77c1d0ae	2026-09-22 16:40:27.935108+00	\N	f	1	f1c3df32-5906-492a-beba-4197b0ca4f8b	dầu ăn	4.000	phần	\N	6
ee7b72b2-04c6-421e-8971-d9247a64e52a	2026-09-22 16:40:27.935108+00	\N	f	1	f1c3df32-5906-492a-beba-4197b0ca4f8b	nấm	4.000	phần	\N	7
39d7d61a-e513-4322-a295-db12c5858f0d	2026-09-22 16:40:27.935108+00	\N	f	1	f1c3df32-5906-492a-beba-4197b0ca4f8b	bắp cải	4.000	phần	\N	8
671bbba9-318e-4a6c-a75a-9b9eb99240f6	2026-09-22 16:40:27.935108+00	\N	f	1	f1c3df32-5906-492a-beba-4197b0ca4f8b	nước tương	3.000	phần	\N	9
0a6fded6-cd89-4298-9884-771cc31dad77	2026-09-22 16:40:27.935108+00	\N	f	1	a1957e38-5472-4dab-93db-31c54769f19c	ớt chuông	2.000	phần	\N	0
3eb8a62c-9c68-4911-96e4-b4fe0fcfb1c3	2026-09-22 16:40:27.935108+00	\N	f	1	a1957e38-5472-4dab-93db-31c54769f19c	thịt gà	4.000	phần	\N	1
e45ad109-af19-4780-80fc-4b76143f4e5a	2026-09-22 16:40:27.935108+00	\N	f	1	a1957e38-5472-4dab-93db-31c54769f19c	cà chua	2.000	phần	\N	2
bd52cbc9-0567-46d9-8801-2cfed3b0cec1	2026-09-22 16:40:27.935108+00	\N	f	1	a1957e38-5472-4dab-93db-31c54769f19c	cà rốt	5.000	phần	\N	3
88f7ee05-08cb-415d-b7dc-db91ac162c61	2026-09-22 16:40:27.935108+00	\N	f	1	a1957e38-5472-4dab-93db-31c54769f19c	bí đỏ	1.000	phần	\N	4
8dc9a65e-9942-4da4-906d-aae92b550eda	2026-09-22 16:40:27.935108+00	\N	f	1	a1957e38-5472-4dab-93db-31c54769f19c	bắp cải	4.000	phần	\N	5
a53625cf-c12b-46ef-8131-99c1cc2eda1e	2026-09-22 16:40:27.935108+00	\N	f	1	a1957e38-5472-4dab-93db-31c54769f19c	tỏi	2.000	phần	\N	6
6136c4d2-44c0-47a8-b5df-ea5bd3aa2ff4	2026-09-22 16:40:27.935108+00	\N	f	1	a1957e38-5472-4dab-93db-31c54769f19c	tiêu	2.000	phần	\N	7
87c29de0-5119-40c0-ac1c-575800795dcc	2026-09-22 16:40:27.935108+00	\N	f	1	a1957e38-5472-4dab-93db-31c54769f19c	hành lá	3.000	phần	\N	8
b95d96d9-aaee-431e-afb7-6d713bd2d665	2026-09-22 16:40:27.935108+00	\N	f	1	a1957e38-5472-4dab-93db-31c54769f19c	gừng	2.000	phần	\N	9
96c02d83-113b-473a-a2ec-65b23e469226	2026-09-22 16:40:27.935108+00	\N	f	1	a1957e38-5472-4dab-93db-31c54769f19c	cá	5.000	phần	\N	10
a102a2cd-bcdf-48f0-a001-d3f305cae69a	2026-09-22 16:40:27.935108+00	\N	f	1	a1957e38-5472-4dab-93db-31c54769f19c	đậu hũ	3.000	phần	\N	11
8e2d7d06-1828-484d-89f7-cf9a4cb83c90	2026-09-22 16:40:27.935108+00	\N	f	1	010d72a8-39ab-4e3f-8c70-0854712210f8	hành tây	1.000	phần	\N	0
27120117-0dd2-44e0-a742-38a9f76cad0e	2026-09-22 16:40:27.935108+00	\N	f	1	010d72a8-39ab-4e3f-8c70-0854712210f8	ớt chuông	4.000	phần	\N	1
0882f275-be30-491e-9591-4a3591c30433	2026-09-22 16:40:27.935108+00	\N	f	1	010d72a8-39ab-4e3f-8c70-0854712210f8	thịt heo	3.000	phần	\N	2
576c1587-2a4b-47b1-8801-0fbac897119b	2026-09-22 16:40:27.935108+00	\N	f	1	010d72a8-39ab-4e3f-8c70-0854712210f8	hành lá	3.000	phần	\N	3
a509592e-5a0e-4459-861f-fe88a5114fdc	2026-09-22 16:40:27.935108+00	\N	f	1	010d72a8-39ab-4e3f-8c70-0854712210f8	bún	5.000	phần	\N	4
cfc3e97a-14d3-4836-9b60-fb91617f6cf3	2026-09-22 16:40:27.935108+00	\N	f	1	010d72a8-39ab-4e3f-8c70-0854712210f8	bắp cải	2.000	phần	\N	5
bf3b1882-fa03-4a58-8bb6-0bfa863fb172	2026-09-22 16:40:27.935108+00	\N	f	1	010d72a8-39ab-4e3f-8c70-0854712210f8	cà rốt	1.000	phần	\N	6
863634cc-fb45-4271-8288-5a6e30c49a69	2026-09-22 16:40:27.935108+00	\N	f	1	010d72a8-39ab-4e3f-8c70-0854712210f8	thịt gà	5.000	phần	\N	7
d5e3e046-4767-4f33-a619-8f3d8c95a01a	2026-09-22 16:40:27.935108+00	\N	f	1	010d72a8-39ab-4e3f-8c70-0854712210f8	mì	4.000	phần	\N	8
2c05ee2c-3d3d-46f2-8944-38825d5d9f25	2026-09-22 16:40:27.935108+00	\N	f	1	010d72a8-39ab-4e3f-8c70-0854712210f8	khoai tây	1.000	phần	\N	9
bd6d5e00-fd58-40c4-a2ef-1c0d3d6b3cd7	2026-09-22 16:40:27.935108+00	\N	f	1	010d72a8-39ab-4e3f-8c70-0854712210f8	cà chua	4.000	phần	\N	10
643e35a5-431c-42d7-a54c-e835c5963d57	2026-09-22 16:40:27.935108+00	\N	f	1	9deb3613-087f-4e6a-af02-a6ac3785e666	rau cải	4.000	phần	\N	0
2d318c50-486d-4be6-ad5d-5efd19339bed	2026-09-22 16:40:27.935108+00	\N	f	1	9deb3613-087f-4e6a-af02-a6ac3785e666	nấm	2.000	phần	\N	1
5ae5f11c-8424-43fc-b797-add7a2c0263f	2026-09-22 16:40:27.935108+00	\N	f	1	9deb3613-087f-4e6a-af02-a6ac3785e666	ớt chuông	2.000	phần	\N	2
3b520d68-e3dd-4996-a299-90d62017e573	2026-09-22 16:40:27.935108+00	\N	f	1	9deb3613-087f-4e6a-af02-a6ac3785e666	thịt bò	1.000	phần	\N	3
29ea67e0-230c-45a9-a84c-a529c9f72f11	2026-09-22 16:40:27.935108+00	\N	f	1	9deb3613-087f-4e6a-af02-a6ac3785e666	thịt gà	5.000	phần	\N	4
6e7b04c2-0f6a-413f-a978-9647aa3e7916	2026-09-22 16:40:27.935108+00	\N	f	1	9deb3613-087f-4e6a-af02-a6ac3785e666	cà rốt	1.000	phần	\N	5
9a111bb4-b109-4472-ba05-7a18bee41e52	2026-09-22 16:40:27.935108+00	\N	f	1	9deb3613-087f-4e6a-af02-a6ac3785e666	gạo	1.000	phần	\N	6
2f353b31-bc3b-4334-9720-af66f46885f6	2026-09-22 16:40:27.935108+00	\N	f	1	9deb3613-087f-4e6a-af02-a6ac3785e666	muối	1.000	phần	\N	7
33067519-7937-4030-bb5b-53ec2f4e8565	2026-09-22 16:40:27.935108+00	\N	f	1	9deb3613-087f-4e6a-af02-a6ac3785e666	trứng	4.000	phần	\N	8
f5a7b4e7-da37-417a-9797-aa2b14ae2547	2026-09-22 16:40:27.935108+00	\N	f	1	9deb3613-087f-4e6a-af02-a6ac3785e666	hành lá	3.000	phần	\N	9
3b2ca3bc-da8f-4ef0-bfbc-8bab76a82ad1	2026-09-22 16:40:27.935108+00	\N	f	1	9deb3613-087f-4e6a-af02-a6ac3785e666	bún	2.000	phần	\N	10
e2b4ce89-0188-4f3d-b203-56976bda9ca3	2026-09-22 16:40:27.935108+00	\N	f	1	88d059e3-ed60-4381-8b70-b16b10d11154	cá	4.000	phần	\N	0
087b5660-7faf-488c-b847-940049fa6465	2026-09-22 16:40:27.935108+00	\N	f	1	88d059e3-ed60-4381-8b70-b16b10d11154	bún	4.000	phần	\N	1
3d0fb972-d200-4f60-9823-cb217d87a97a	2026-09-22 16:40:27.935108+00	\N	f	1	88d059e3-ed60-4381-8b70-b16b10d11154	trứng	2.000	phần	\N	2
94e5b304-ae49-407a-8d19-52df7fbc1739	2026-09-22 16:40:27.935108+00	\N	f	1	88d059e3-ed60-4381-8b70-b16b10d11154	muối	5.000	phần	\N	3
6b8df163-6af4-4f8d-b8b4-6e51593fe0c1	2026-09-22 16:40:27.935108+00	\N	f	1	88d059e3-ed60-4381-8b70-b16b10d11154	khoai tây	2.000	phần	\N	4
a67cae8e-a924-4624-8779-741c857ba9d4	2026-09-22 16:40:27.935108+00	\N	f	1	88d059e3-ed60-4381-8b70-b16b10d11154	tôm	1.000	phần	\N	5
f1cb14f4-e0ab-4949-ac75-dbe54a6c23a8	2026-09-22 16:40:27.935108+00	\N	f	1	88d059e3-ed60-4381-8b70-b16b10d11154	cà chua	4.000	phần	\N	6
689f849b-e1a3-491f-9f23-23ced53dd263	2026-09-22 16:40:27.935108+00	\N	f	1	88d059e3-ed60-4381-8b70-b16b10d11154	hành lá	2.000	phần	\N	7
5001fd1f-3213-4ae2-a2d3-e516fc54a4d1	2026-09-22 16:40:27.935108+00	\N	f	1	88d059e3-ed60-4381-8b70-b16b10d11154	cà rốt	3.000	phần	\N	8
ed5f8522-0424-4a6c-9dab-216d882e7a60	2026-09-22 16:40:27.935108+00	\N	f	1	88d059e3-ed60-4381-8b70-b16b10d11154	mì	1.000	phần	\N	9
4123c12a-96c7-4bec-bdbf-665751df8155	2026-09-22 16:40:27.935108+00	\N	f	1	88d059e3-ed60-4381-8b70-b16b10d11154	rau cải	1.000	phần	\N	10
10d5ea12-5be5-48d3-8e2f-b0d2ee18e294	2026-09-22 16:40:27.935108+00	\N	f	1	88d059e3-ed60-4381-8b70-b16b10d11154	đậu hũ	5.000	phần	\N	11
6db149d7-96af-4495-ba1f-d65a1fe4fc65	2026-09-22 16:40:27.935108+00	\N	f	1	d3564a99-ff0d-4f2e-b129-d214c229ca39	khoai tây	3.000	phần	\N	0
bc66dbda-6863-4079-a21d-9f47f0e130cb	2026-09-22 16:40:27.935108+00	\N	f	1	d3564a99-ff0d-4f2e-b129-d214c229ca39	gừng	5.000	phần	\N	1
aa63137e-f09d-4826-b5b6-4b7b18912921	2026-09-22 16:40:27.935108+00	\N	f	1	d3564a99-ff0d-4f2e-b129-d214c229ca39	tỏi	1.000	phần	\N	2
22c49317-61f0-4193-af71-ba0deac9773e	2026-09-22 16:40:27.935108+00	\N	f	1	d3564a99-ff0d-4f2e-b129-d214c229ca39	đậu hũ	5.000	phần	\N	3
b2095300-3d07-43f1-986b-6cea312ffcf4	2026-09-22 16:40:27.935108+00	\N	f	1	d3564a99-ff0d-4f2e-b129-d214c229ca39	tiêu	1.000	phần	\N	4
b912bca3-7593-4945-bf44-998f815fd293	2026-09-22 16:40:27.935108+00	\N	f	1	d3564a99-ff0d-4f2e-b129-d214c229ca39	mì	5.000	phần	\N	5
8678d172-4cc8-4bba-a8ec-09bbac0478fb	2026-09-22 16:40:27.935108+00	\N	f	1	d3564a99-ff0d-4f2e-b129-d214c229ca39	đường	3.000	phần	\N	6
93be86e3-bd49-452f-b2ff-13947405db68	2026-09-22 16:40:27.935108+00	\N	f	1	d3564a99-ff0d-4f2e-b129-d214c229ca39	thịt gà	3.000	phần	\N	7
21e6896c-3f76-4f0e-ab4e-c7637945f2ff	2026-09-22 16:40:27.935108+00	\N	f	1	d3564a99-ff0d-4f2e-b129-d214c229ca39	dầu ăn	2.000	phần	\N	8
2cd87187-63ea-4e7a-8d33-3b9da3635b0a	2026-09-22 16:40:27.935108+00	\N	f	1	d3564a99-ff0d-4f2e-b129-d214c229ca39	rau thơm	1.000	phần	\N	9
07287a86-7934-4887-b715-133701847723	2026-09-22 16:40:27.935108+00	\N	f	1	f0e97260-a94a-4228-8b66-43092cc4d960	thịt bò	5.000	phần	\N	0
a37356f8-048a-4f61-8a44-a967f36c5e6a	2026-09-22 16:40:27.935108+00	\N	f	1	f0e97260-a94a-4228-8b66-43092cc4d960	dầu ăn	2.000	phần	\N	1
705177ca-1f76-41ac-82c8-7b328893b8d8	2026-09-22 16:40:27.935108+00	\N	f	1	f0e97260-a94a-4228-8b66-43092cc4d960	nấm	3.000	phần	\N	2
04258d19-d4bc-4f7a-8298-e9330265581c	2026-09-22 16:40:27.935108+00	\N	f	1	f0e97260-a94a-4228-8b66-43092cc4d960	bí đỏ	4.000	phần	\N	3
c7c6d8c7-80d0-4952-bf9f-319a869c2a0a	2026-09-22 16:40:27.935108+00	\N	f	1	f0e97260-a94a-4228-8b66-43092cc4d960	nước tương	5.000	phần	\N	4
042b45ec-3662-4bd1-a23d-f949c4f474b5	2026-09-22 16:40:27.935108+00	\N	f	1	f0e97260-a94a-4228-8b66-43092cc4d960	cà chua	2.000	phần	\N	5
2b6ba4a8-8291-41d2-bef1-f02c4ebb0e6d	2026-09-22 16:40:27.935108+00	\N	f	1	f0e97260-a94a-4228-8b66-43092cc4d960	đậu hũ	4.000	phần	\N	6
dfce1db4-da91-4a09-9375-4873ea981c65	2026-09-22 16:40:27.935108+00	\N	f	1	f0e97260-a94a-4228-8b66-43092cc4d960	thịt gà	4.000	phần	\N	7
0e46eb7d-9506-4ab5-a330-4e4ac1823bc3	2026-09-22 16:40:27.935108+00	\N	f	1	f0e97260-a94a-4228-8b66-43092cc4d960	cà rốt	1.000	phần	\N	8
1b6d0fc1-66c4-4ea6-8c79-a33c5c022cdf	2026-09-22 16:40:27.935108+00	\N	f	1	f0e97260-a94a-4228-8b66-43092cc4d960	nước mắm	5.000	phần	\N	9
ceb837ca-43d7-45cb-b283-2150afbf8d70	2026-09-22 16:40:27.935108+00	\N	f	1	efa700aa-6196-4fb7-a624-f1794047dc83	tôm	2.000	phần	\N	0
5067ebbc-8db0-420e-a8dd-398abaeeb7ae	2026-09-22 16:40:27.935108+00	\N	f	1	efa700aa-6196-4fb7-a624-f1794047dc83	rau cải	1.000	phần	\N	1
9210dfc9-6201-4cf5-8fb8-dbc2ecbd497d	2026-09-22 16:40:27.935108+00	\N	f	1	efa700aa-6196-4fb7-a624-f1794047dc83	hành lá	1.000	phần	\N	2
b8f4f588-3f82-4d48-a396-13daa9bb0044	2026-09-22 16:40:27.935108+00	\N	f	1	efa700aa-6196-4fb7-a624-f1794047dc83	dầu ăn	2.000	phần	\N	3
0bedf0f7-f511-45cf-ba3b-744ab34c4585	2026-09-22 16:40:27.935108+00	\N	f	1	efa700aa-6196-4fb7-a624-f1794047dc83	gạo	2.000	phần	\N	4
c09efc50-9bcd-4d95-8cd3-c517c67e2254	2026-09-22 16:40:27.935108+00	\N	f	1	efa700aa-6196-4fb7-a624-f1794047dc83	đường	3.000	phần	\N	5
eede07f2-12c9-4672-be44-911e9c830fdb	2026-09-22 16:40:27.935108+00	\N	f	1	efa700aa-6196-4fb7-a624-f1794047dc83	bún	4.000	phần	\N	6
b8999688-81ca-4acb-817b-d756daa0d4ca	2026-09-22 16:40:27.935108+00	\N	f	1	efa700aa-6196-4fb7-a624-f1794047dc83	đậu hũ	2.000	phần	\N	7
5c6f9b85-9d41-4a89-a16d-878b84603134	2026-09-22 16:40:27.935108+00	\N	f	1	efa700aa-6196-4fb7-a624-f1794047dc83	bắp cải	1.000	phần	\N	8
249dc04a-aaa6-4652-bb49-f93d9921cad7	2026-09-22 16:40:27.935108+00	\N	f	1	efa700aa-6196-4fb7-a624-f1794047dc83	ớt chuông	3.000	phần	\N	9
2856a8aa-bc44-4b6c-8d89-95fa4a4b7489	2026-09-22 16:40:27.935108+00	\N	f	1	c70f9112-e933-4cf3-bc7c-f3597318dc92	cà rốt	2.000	phần	\N	0
b43fe248-40be-4a92-ae64-8b632c4d1ad6	2026-09-22 16:40:27.935108+00	\N	f	1	c70f9112-e933-4cf3-bc7c-f3597318dc92	dầu ăn	3.000	phần	\N	1
9519c9bb-e1e9-4440-a5c4-9b79c3891f09	2026-09-22 16:40:27.935108+00	\N	f	1	c70f9112-e933-4cf3-bc7c-f3597318dc92	nước mắm	3.000	phần	\N	2
995b02e0-c684-4a1b-a3c3-cfde039e2b1f	2026-09-22 16:40:27.935108+00	\N	f	1	c70f9112-e933-4cf3-bc7c-f3597318dc92	thịt gà	4.000	phần	\N	3
10d29694-b703-4e38-ab6a-e009310c3357	2026-09-22 16:40:27.935108+00	\N	f	1	c70f9112-e933-4cf3-bc7c-f3597318dc92	bún	2.000	phần	\N	4
f4bd1eaa-6662-4235-856d-53c8574874e8	2026-09-22 16:40:27.935108+00	\N	f	1	c70f9112-e933-4cf3-bc7c-f3597318dc92	hành lá	2.000	phần	\N	5
48dcb5ec-227c-4583-b8bf-18132b3c5717	2026-09-22 16:40:27.935108+00	\N	f	1	c70f9112-e933-4cf3-bc7c-f3597318dc92	rau thơm	2.000	phần	\N	6
f2f9338b-e23c-4417-ac40-8141fa60f4bb	2026-09-22 16:40:27.935108+00	\N	f	1	c70f9112-e933-4cf3-bc7c-f3597318dc92	bí đỏ	4.000	phần	\N	7
9e2f7505-530b-44ac-9c89-c527afc15bf7	2026-09-22 16:40:27.935108+00	\N	f	1	c70f9112-e933-4cf3-bc7c-f3597318dc92	nước tương	1.000	phần	\N	8
57b1f66b-c7cb-447a-8e3a-1c0436fa4672	2026-09-22 16:40:27.935108+00	\N	f	1	c70f9112-e933-4cf3-bc7c-f3597318dc92	khoai tây	1.000	phần	\N	9
d2e47a5d-b122-4c4b-8f5c-eeab4e631294	2026-09-22 16:40:27.935108+00	\N	f	1	c70f9112-e933-4cf3-bc7c-f3597318dc92	gừng	1.000	phần	\N	10
90ebd3ae-69cf-4862-a43b-7c505286dfa7	2026-09-22 16:40:27.935108+00	\N	f	1	b45deffb-8faf-489e-8b94-1b8db806314f	đậu que	2.000	phần	\N	0
afd370a6-a2f6-42c1-aa02-2d39d9829627	2026-09-22 16:40:27.935108+00	\N	f	1	b45deffb-8faf-489e-8b94-1b8db806314f	bắp cải	3.000	phần	\N	1
6faed87d-1ea8-4c74-acdf-4b995a3284bb	2026-09-22 16:40:27.935108+00	\N	f	1	b45deffb-8faf-489e-8b94-1b8db806314f	dầu ăn	2.000	phần	\N	2
eb6e581e-ae00-4718-954c-8d9f39ca3634	2026-09-22 16:40:27.935108+00	\N	f	1	b45deffb-8faf-489e-8b94-1b8db806314f	nấm	1.000	phần	\N	3
e5d3b7fb-3696-4273-b2e4-3cc4b89c9ab7	2026-09-22 16:40:27.935108+00	\N	f	1	b45deffb-8faf-489e-8b94-1b8db806314f	mì	1.000	phần	\N	4
a251ba22-5cdc-4066-8609-45821f7e8c11	2026-09-22 16:40:27.935108+00	\N	f	1	b45deffb-8faf-489e-8b94-1b8db806314f	đậu hũ	1.000	phần	\N	5
10cbef2a-2bed-4d93-91a1-49dd8b1f013b	2026-09-22 16:40:27.935108+00	\N	f	1	b45deffb-8faf-489e-8b94-1b8db806314f	gừng	1.000	phần	\N	6
9c280984-a618-4597-a320-d94d16624ed2	2026-09-22 16:40:27.935108+00	\N	f	1	b45deffb-8faf-489e-8b94-1b8db806314f	tỏi	4.000	phần	\N	7
b78f9ecf-8c97-4fbd-a8f0-e37cfbd41e20	2026-09-22 16:40:27.935108+00	\N	f	1	b45deffb-8faf-489e-8b94-1b8db806314f	bí đỏ	3.000	phần	\N	8
3d17c741-5c79-411c-bcc3-6c6c7351a5f1	2026-09-22 16:40:27.935108+00	\N	f	1	b45deffb-8faf-489e-8b94-1b8db806314f	rau cải	4.000	phần	\N	9
860a51ee-52bd-45de-9d73-eed6ac4512dd	2026-09-22 16:40:27.935108+00	\N	f	1	f852915b-e743-4648-bc53-354564274cbe	nước tương	5.000	phần	\N	0
47e6e87b-f204-4ce6-9867-18e9df7a417a	2026-09-22 16:40:27.935108+00	\N	f	1	f852915b-e743-4648-bc53-354564274cbe	hành tây	3.000	phần	\N	1
c0a44e9a-ef5f-4744-808c-69ae9479b859	2026-09-22 16:40:27.935108+00	\N	f	1	f852915b-e743-4648-bc53-354564274cbe	tôm	5.000	phần	\N	2
9309c71d-bb2d-4a66-98e2-7092cd41f357	2026-09-22 16:40:27.935108+00	\N	f	1	f852915b-e743-4648-bc53-354564274cbe	đường	4.000	phần	\N	3
5579cc8c-143f-428c-8aca-fa17faa7dae8	2026-09-22 16:40:27.935108+00	\N	f	1	f852915b-e743-4648-bc53-354564274cbe	cà chua	2.000	phần	\N	4
2cbf6af1-560a-48b4-b2d7-c0d985a6f6dd	2026-09-22 16:40:27.935108+00	\N	f	1	f852915b-e743-4648-bc53-354564274cbe	cá	5.000	phần	\N	5
30c944a7-f84a-4eb5-8c18-63db5ed23a74	2026-09-22 16:40:27.935108+00	\N	f	1	f852915b-e743-4648-bc53-354564274cbe	bắp cải	5.000	phần	\N	6
6ba05b50-fcb4-4e0e-9f9d-6c32aef30cfa	2026-09-22 16:40:27.935108+00	\N	f	1	f852915b-e743-4648-bc53-354564274cbe	thịt bò	1.000	phần	\N	7
71de8c2c-3f82-40d7-8a1d-1edbb18308a2	2026-09-22 16:40:27.935108+00	\N	f	1	f852915b-e743-4648-bc53-354564274cbe	tiêu	1.000	phần	\N	8
0de7179d-78db-498e-be58-fb38ce973a18	2026-09-22 16:40:27.935108+00	\N	f	1	f852915b-e743-4648-bc53-354564274cbe	rau thơm	1.000	phần	\N	9
8bb1348d-6be4-44a9-ab3b-adbc1d26c03f	2026-09-22 16:40:27.935108+00	\N	f	1	f852915b-e743-4648-bc53-354564274cbe	nấm	2.000	phần	\N	10
c2c74a73-e893-4c0b-913c-0b7ca8ad22b0	2026-09-22 16:40:27.935108+00	\N	f	1	8903560f-3e94-4465-a48f-e2add7ec29b9	nước mắm	4.000	phần	\N	0
69f9b549-a6b5-408f-b3b3-96f96e9da2d0	2026-09-22 16:40:27.935108+00	\N	f	1	8903560f-3e94-4465-a48f-e2add7ec29b9	bún	1.000	phần	\N	1
a20b2e59-704c-4b2e-add3-7199ff460207	2026-09-22 16:40:27.935108+00	\N	f	1	8903560f-3e94-4465-a48f-e2add7ec29b9	trứng	4.000	phần	\N	2
4a945461-b56a-43c2-bf91-dfa825dc5646	2026-09-22 16:40:27.935108+00	\N	f	1	8903560f-3e94-4465-a48f-e2add7ec29b9	rau cải	5.000	phần	\N	3
eaa9ac03-b287-43b3-a848-07479fd3a30b	2026-09-22 16:40:27.935108+00	\N	f	1	8903560f-3e94-4465-a48f-e2add7ec29b9	hành tây	1.000	phần	\N	4
5bcc869c-cec3-4e1d-bb48-badbe85de4b2	2026-09-22 16:40:27.935108+00	\N	f	1	8903560f-3e94-4465-a48f-e2add7ec29b9	mì	1.000	phần	\N	5
849a0601-acb1-433a-aea2-e5d362247453	2026-09-22 16:40:27.935108+00	\N	f	1	8903560f-3e94-4465-a48f-e2add7ec29b9	cá	1.000	phần	\N	6
7e555ee0-5468-45f7-bdf5-b1df435ec83c	2026-09-22 16:40:27.935108+00	\N	f	1	8903560f-3e94-4465-a48f-e2add7ec29b9	đậu hũ	3.000	phần	\N	7
b643f924-00b5-4501-b3ea-e347465c5a63	2026-09-22 16:40:27.935108+00	\N	f	1	8903560f-3e94-4465-a48f-e2add7ec29b9	thịt bò	5.000	phần	\N	8
a300d6d5-e818-4c56-900c-7cd36df61e3c	2026-09-22 16:40:27.935108+00	\N	f	1	8903560f-3e94-4465-a48f-e2add7ec29b9	nước tương	4.000	phần	\N	9
afa324f0-46a1-45e3-b000-dfb13bb2bc7a	2026-09-22 16:40:27.935108+00	\N	f	1	d5fc07e8-c8ef-4829-b86d-7672a4f9430e	gạo	2.000	phần	\N	0
7aed42dd-32cb-4287-a1a7-a856c69d99b2	2026-09-22 16:40:27.935108+00	\N	f	1	d5fc07e8-c8ef-4829-b86d-7672a4f9430e	thịt bò	3.000	phần	\N	1
909b7b49-5b91-4f41-9f12-91343fbdd02b	2026-09-22 16:40:27.935108+00	\N	f	1	d5fc07e8-c8ef-4829-b86d-7672a4f9430e	bún	1.000	phần	\N	2
a598ffa1-72c8-4837-a8e1-20817f581bb4	2026-09-22 16:40:27.935108+00	\N	f	1	d5fc07e8-c8ef-4829-b86d-7672a4f9430e	nước tương	5.000	phần	\N	3
f3778b4f-0f82-43f1-aa1a-b283638410cd	2026-09-22 16:40:27.935108+00	\N	f	1	d5fc07e8-c8ef-4829-b86d-7672a4f9430e	cà chua	1.000	phần	\N	4
4271446c-e950-4af3-b51b-1cb2ea62833a	2026-09-22 16:40:27.935108+00	\N	f	1	d5fc07e8-c8ef-4829-b86d-7672a4f9430e	tỏi	2.000	phần	\N	5
043fbd08-9851-4986-94af-ac6a85dd740b	2026-09-22 16:40:27.935108+00	\N	f	1	d5fc07e8-c8ef-4829-b86d-7672a4f9430e	mì	5.000	phần	\N	6
872b9170-cb00-4ac5-8e02-e986ca2144f6	2026-09-22 16:40:27.935108+00	\N	f	1	d5fc07e8-c8ef-4829-b86d-7672a4f9430e	muối	3.000	phần	\N	7
de159c22-f775-46e1-98d3-d1d2418e478e	2026-09-22 16:40:27.935108+00	\N	f	1	d5fc07e8-c8ef-4829-b86d-7672a4f9430e	gừng	5.000	phần	\N	8
a39f6d66-ae6d-40f5-91c2-5ff5be8dadf7	2026-09-22 16:40:27.935108+00	\N	f	1	d5fc07e8-c8ef-4829-b86d-7672a4f9430e	rau thơm	4.000	phần	\N	9
0b47e68b-f3be-474f-a8c1-286499857b52	2026-09-22 16:40:27.935108+00	\N	f	1	7124d61c-c57e-41db-8620-3280b7ee79f6	đậu hũ	2.000	phần	\N	0
31dc2756-aa00-400b-804c-66d2692318f0	2026-09-22 16:40:27.935108+00	\N	f	1	7124d61c-c57e-41db-8620-3280b7ee79f6	tỏi	2.000	phần	\N	1
1cbd45e1-51f8-4a48-b28a-5103796ab5af	2026-09-22 16:40:27.935108+00	\N	f	1	7124d61c-c57e-41db-8620-3280b7ee79f6	dầu ăn	2.000	phần	\N	2
b2110f70-bd64-40e6-90ad-a907fcfc2879	2026-09-22 16:40:27.935108+00	\N	f	1	7124d61c-c57e-41db-8620-3280b7ee79f6	thịt heo	3.000	phần	\N	3
b97d1209-9658-4d92-8fa6-2d3353f9abcd	2026-09-22 16:40:27.935108+00	\N	f	1	7124d61c-c57e-41db-8620-3280b7ee79f6	mì	4.000	phần	\N	4
8f334fa6-288f-4b9e-8b1e-fa3487319424	2026-09-22 16:40:27.935108+00	\N	f	1	7124d61c-c57e-41db-8620-3280b7ee79f6	bắp cải	2.000	phần	\N	5
3e9b2060-0834-44a8-810d-a04fae51f6aa	2026-09-22 16:40:27.935108+00	\N	f	1	7124d61c-c57e-41db-8620-3280b7ee79f6	nước tương	2.000	phần	\N	6
c2d14371-a2d2-4c71-a1ee-4c135ebe58e0	2026-09-22 16:40:27.935108+00	\N	f	1	7124d61c-c57e-41db-8620-3280b7ee79f6	thịt bò	2.000	phần	\N	7
2e70d83e-8281-4b59-b44e-022c19267ecb	2026-09-22 16:40:27.935108+00	\N	f	1	7124d61c-c57e-41db-8620-3280b7ee79f6	tiêu	4.000	phần	\N	8
e66146e0-da37-4593-8542-0e14f4eca4a1	2026-09-22 16:40:27.935108+00	\N	f	1	7124d61c-c57e-41db-8620-3280b7ee79f6	cà chua	1.000	phần	\N	9
cd742d48-2657-4056-a23c-060c146f5b3f	2026-09-22 16:40:27.935108+00	\N	f	1	7e91259b-de31-4da3-8cb1-952047e7f1d8	nước tương	5.000	phần	\N	0
c7803139-b3b4-457f-b7b5-8f142796aba3	2026-09-22 16:40:27.935108+00	\N	f	1	7e91259b-de31-4da3-8cb1-952047e7f1d8	thịt gà	3.000	phần	\N	1
926236e5-2047-46d0-b826-5b9d8bc17791	2026-09-22 16:40:27.935108+00	\N	f	1	7e91259b-de31-4da3-8cb1-952047e7f1d8	rau cải	1.000	phần	\N	2
4ae3d4ff-31d9-4cf1-9a2f-26c4b5f17701	2026-09-22 16:40:27.935108+00	\N	f	1	7e91259b-de31-4da3-8cb1-952047e7f1d8	tiêu	1.000	phần	\N	3
4501d045-beca-40d3-a81a-d02720ac6c2c	2026-09-22 16:40:27.935108+00	\N	f	1	7e91259b-de31-4da3-8cb1-952047e7f1d8	đậu que	5.000	phần	\N	4
85bebc4a-2868-40ff-9922-fb10a7583633	2026-09-22 16:40:27.935108+00	\N	f	1	7e91259b-de31-4da3-8cb1-952047e7f1d8	thịt heo	5.000	phần	\N	5
11e4e10b-1342-4ccc-8e0d-9a8afe4d693d	2026-09-22 16:40:27.935108+00	\N	f	1	7e91259b-de31-4da3-8cb1-952047e7f1d8	bí đỏ	4.000	phần	\N	6
4c5f9ccb-1b45-4925-b2d1-63e49116626e	2026-09-22 16:40:27.935108+00	\N	f	1	7e91259b-de31-4da3-8cb1-952047e7f1d8	mì	1.000	phần	\N	7
30f69240-b5f6-4418-8e77-8c03ba1ad5b4	2026-09-22 16:40:27.935108+00	\N	f	1	7e91259b-de31-4da3-8cb1-952047e7f1d8	muối	3.000	phần	\N	8
1db06b61-509d-4b50-9a63-f21ee1618a18	2026-09-22 16:40:27.935108+00	\N	f	1	7e91259b-de31-4da3-8cb1-952047e7f1d8	cá	3.000	phần	\N	9
94e2c341-bd65-42dc-8651-7cdebe1f5d27	2026-09-22 16:40:27.935108+00	\N	f	1	7e91259b-de31-4da3-8cb1-952047e7f1d8	rau thơm	5.000	phần	\N	10
cabb9a5f-45db-4b7e-9285-29e8529f72f9	2026-09-22 16:40:27.935108+00	\N	f	1	d633c604-10a2-4556-a684-c0ce020d58a3	ớt chuông	4.000	phần	\N	0
15508ab9-d0aa-492e-90ea-58ee1fb8a019	2026-09-22 16:40:27.935108+00	\N	f	1	d633c604-10a2-4556-a684-c0ce020d58a3	bí đỏ	1.000	phần	\N	1
7ec0a992-bf9e-4a08-b8aa-33bb32f4ab82	2026-09-22 16:40:27.935108+00	\N	f	1	d633c604-10a2-4556-a684-c0ce020d58a3	tiêu	1.000	phần	\N	2
f8238de4-0a60-4da9-9f76-8885fddb5fcc	2026-09-22 16:40:27.935108+00	\N	f	1	d633c604-10a2-4556-a684-c0ce020d58a3	muối	4.000	phần	\N	3
f1202f85-1546-401a-b6a2-024829cf586b	2026-09-22 16:40:27.935108+00	\N	f	1	d633c604-10a2-4556-a684-c0ce020d58a3	trứng	3.000	phần	\N	4
e8dba6d8-9429-4d37-ac67-de9e7f66440c	2026-09-22 16:40:27.935108+00	\N	f	1	d633c604-10a2-4556-a684-c0ce020d58a3	thịt gà	2.000	phần	\N	5
23e9dc66-31a6-40a8-958c-d884fd864652	2026-09-22 16:40:27.935108+00	\N	f	1	d633c604-10a2-4556-a684-c0ce020d58a3	nấm	5.000	phần	\N	6
63237c9a-97c2-4131-b244-0fe865e50b4d	2026-09-22 16:40:27.935108+00	\N	f	1	d633c604-10a2-4556-a684-c0ce020d58a3	rau cải	3.000	phần	\N	7
fe306808-4a2f-43cd-bc8a-909e39778151	2026-09-22 16:40:27.935108+00	\N	f	1	d633c604-10a2-4556-a684-c0ce020d58a3	rau thơm	4.000	phần	\N	8
58fdb444-be25-4c29-bd59-41b041053844	2026-09-22 16:40:27.935108+00	\N	f	1	d633c604-10a2-4556-a684-c0ce020d58a3	nước tương	1.000	phần	\N	9
0d0e3bac-e1df-4f08-9f6d-118f61ee9921	2026-09-22 16:40:27.935108+00	\N	f	1	d633c604-10a2-4556-a684-c0ce020d58a3	thịt bò	1.000	phần	\N	10
28ccc584-746b-46f3-98dd-555e4aafc435	2026-09-22 16:40:27.935108+00	\N	f	1	d633c604-10a2-4556-a684-c0ce020d58a3	gừng	2.000	phần	\N	11
46141f51-0e0f-4681-b3f1-3b3d1a13e0a2	2026-09-22 16:40:27.935108+00	\N	f	1	d5d9066a-2580-452a-b50a-01614390485e	thịt bò	1.000	phần	\N	0
f517e021-ebf3-49e9-ab2c-f7bb29eb5618	2026-09-22 16:40:27.935108+00	\N	f	1	d5d9066a-2580-452a-b50a-01614390485e	bí đỏ	4.000	phần	\N	1
ae0cfdfb-bef7-4a02-ab9a-685a76b00573	2026-09-22 16:40:27.935108+00	\N	f	1	d5d9066a-2580-452a-b50a-01614390485e	tỏi	3.000	phần	\N	2
115c35c1-5a82-4526-9a45-7b07aad5a487	2026-09-22 16:40:27.935108+00	\N	f	1	d5d9066a-2580-452a-b50a-01614390485e	thịt heo	4.000	phần	\N	3
effebeb7-27cf-467a-8937-cc867bfbe981	2026-09-22 16:40:27.935108+00	\N	f	1	d5d9066a-2580-452a-b50a-01614390485e	rau cải	3.000	phần	\N	4
a987eaab-7d09-46a8-a746-a76270aa0d3d	2026-09-22 16:40:27.935108+00	\N	f	1	d5d9066a-2580-452a-b50a-01614390485e	mì	3.000	phần	\N	5
62daa390-a2be-48e1-ad1f-0e0cf39e719a	2026-09-22 16:40:27.935108+00	\N	f	1	d5d9066a-2580-452a-b50a-01614390485e	cá	1.000	phần	\N	6
1434ce8a-b6f3-42f1-ae0a-b9e0007ac7d9	2026-09-22 16:40:27.935108+00	\N	f	1	d5d9066a-2580-452a-b50a-01614390485e	muối	3.000	phần	\N	7
8e2a0a0b-cb74-46cd-8624-4b42842c44f8	2026-09-22 16:40:27.935108+00	\N	f	1	d5d9066a-2580-452a-b50a-01614390485e	đường	4.000	phần	\N	8
25638577-4af7-4f38-8c66-fba82fb58833	2026-09-22 16:40:27.935108+00	\N	f	1	d5d9066a-2580-452a-b50a-01614390485e	tiêu	5.000	phần	\N	9
2589731b-8a71-4c7c-a3ab-486dfe9504cb	2026-09-22 16:40:27.935108+00	\N	f	1	d5d9066a-2580-452a-b50a-01614390485e	ớt chuông	4.000	phần	\N	10
e2a8dc48-3fe0-4883-bc92-d49c184efe1e	2026-09-22 16:40:27.935108+00	\N	f	1	81d1e8e4-7cda-4041-b16e-e8deb0cff897	ớt chuông	1.000	phần	\N	0
349f033a-ed1d-4313-a2a4-e0d1a6ab87d0	2026-09-22 16:40:27.935108+00	\N	f	1	81d1e8e4-7cda-4041-b16e-e8deb0cff897	bí đỏ	4.000	phần	\N	1
f48dde55-5969-4ec5-a7d3-f14673d91647	2026-09-22 16:40:27.935108+00	\N	f	1	81d1e8e4-7cda-4041-b16e-e8deb0cff897	muối	2.000	phần	\N	2
b2ea909b-a752-45b4-9f4c-f877408a82a5	2026-09-22 16:40:27.935108+00	\N	f	1	81d1e8e4-7cda-4041-b16e-e8deb0cff897	tiêu	5.000	phần	\N	3
d0405628-1e1d-43a9-b28c-98ce18cfddd2	2026-09-22 16:40:27.935108+00	\N	f	1	81d1e8e4-7cda-4041-b16e-e8deb0cff897	thịt heo	3.000	phần	\N	4
a9a84c17-78c4-450e-bdf9-9895b1b3077f	2026-09-22 16:40:27.935108+00	\N	f	1	81d1e8e4-7cda-4041-b16e-e8deb0cff897	tôm	3.000	phần	\N	5
08eacea9-54ac-4ba1-8895-bfed3dda807a	2026-09-22 16:40:27.935108+00	\N	f	1	81d1e8e4-7cda-4041-b16e-e8deb0cff897	thịt gà	3.000	phần	\N	6
9ea5a7f6-1b0a-45d9-97f2-389a5c14eb1a	2026-09-22 16:40:27.935108+00	\N	f	1	81d1e8e4-7cda-4041-b16e-e8deb0cff897	dầu ăn	1.000	phần	\N	7
efebd71e-db20-42f8-b4f8-b69db074f31b	2026-09-22 16:40:27.935108+00	\N	f	1	81d1e8e4-7cda-4041-b16e-e8deb0cff897	tỏi	2.000	phần	\N	8
2873f9fd-1fa5-4a4c-b5e7-56e203c08df1	2026-09-22 16:40:27.935108+00	\N	f	1	81d1e8e4-7cda-4041-b16e-e8deb0cff897	khoai tây	4.000	phần	\N	9
1a0bee54-520b-42cb-8a6b-18f63f4939b6	2026-09-22 16:40:27.935108+00	\N	f	1	81d1e8e4-7cda-4041-b16e-e8deb0cff897	gừng	5.000	phần	\N	10
8a2b0745-7ce5-4724-a048-50db3187eb25	2026-09-22 16:40:27.935108+00	\N	f	1	81d1e8e4-7cda-4041-b16e-e8deb0cff897	nấm	2.000	phần	\N	11
8c4d2fdd-260c-4aee-950d-10c9808ca0af	2026-09-22 16:40:27.935108+00	\N	f	1	ce535140-4132-41cc-b688-4600cd898301	rau thơm	2.000	phần	\N	0
67fc5e16-b7f8-45ad-ac62-ccd48630695c	2026-09-22 16:40:27.935108+00	\N	f	1	ce535140-4132-41cc-b688-4600cd898301	khoai tây	2.000	phần	\N	1
611f058b-ccd9-492a-9b91-ea5372887b19	2026-09-22 16:40:27.935108+00	\N	f	1	ce535140-4132-41cc-b688-4600cd898301	đường	3.000	phần	\N	2
6a031eca-5b2f-41c2-a0a8-a1db67016e24	2026-09-22 16:40:27.935108+00	\N	f	1	ce535140-4132-41cc-b688-4600cd898301	tôm	1.000	phần	\N	3
bed1532b-4843-4983-9342-e852dd90c92e	2026-09-22 16:40:27.935108+00	\N	f	1	ce535140-4132-41cc-b688-4600cd898301	bún	1.000	phần	\N	4
f07d082f-b253-4281-a62b-30ca09a58998	2026-09-22 16:40:27.935108+00	\N	f	1	ce535140-4132-41cc-b688-4600cd898301	đậu que	3.000	phần	\N	5
e95ef329-ecf8-4ea0-9719-161e75a0e93b	2026-09-22 16:40:27.935108+00	\N	f	1	ce535140-4132-41cc-b688-4600cd898301	thịt heo	5.000	phần	\N	6
89d2b45f-e835-4ec9-9338-25f1252202a6	2026-09-22 16:40:27.935108+00	\N	f	1	ce535140-4132-41cc-b688-4600cd898301	trứng	1.000	phần	\N	7
53d9b66f-f533-446a-9fdd-5adee12b2803	2026-09-22 16:40:27.935108+00	\N	f	1	ce535140-4132-41cc-b688-4600cd898301	bắp cải	5.000	phần	\N	8
83b723b7-c57e-454d-b822-af0a540a124b	2026-09-22 16:40:27.935108+00	\N	f	1	ce535140-4132-41cc-b688-4600cd898301	thịt bò	1.000	phần	\N	9
9af03473-e0ad-4843-bb5e-a63a65dc1145	2026-09-22 16:40:27.935108+00	\N	f	1	051ff554-9d6d-430e-aa97-a33c5cfd02f3	dầu ăn	4.000	phần	\N	0
592116f8-aa99-4b60-a44f-c165e8d70377	2026-09-22 16:40:27.935108+00	\N	f	1	051ff554-9d6d-430e-aa97-a33c5cfd02f3	bún	3.000	phần	\N	1
262e280e-763a-4465-9763-92ee7994cb9d	2026-09-22 16:40:27.935108+00	\N	f	1	051ff554-9d6d-430e-aa97-a33c5cfd02f3	bắp cải	2.000	phần	\N	2
d2a52611-d185-4c48-b478-cbb82027d70a	2026-09-22 16:40:27.935108+00	\N	f	1	051ff554-9d6d-430e-aa97-a33c5cfd02f3	đậu que	5.000	phần	\N	3
c40a8174-1527-48f9-b533-ac09f3044f53	2026-09-22 16:40:27.935108+00	\N	f	1	051ff554-9d6d-430e-aa97-a33c5cfd02f3	tôm	5.000	phần	\N	4
fe3c29a6-3e03-475c-919f-1632b63ac8c5	2026-09-22 16:40:27.935108+00	\N	f	1	051ff554-9d6d-430e-aa97-a33c5cfd02f3	bí đỏ	1.000	phần	\N	5
1dcdfa97-23ef-4427-be93-a0833a9958d6	2026-09-22 16:40:27.935108+00	\N	f	1	051ff554-9d6d-430e-aa97-a33c5cfd02f3	gừng	1.000	phần	\N	6
9242c71b-815a-4d60-9640-725260f1af6e	2026-09-22 16:40:27.935108+00	\N	f	1	051ff554-9d6d-430e-aa97-a33c5cfd02f3	đậu hũ	4.000	phần	\N	7
3b08456b-4d1d-41d7-9ad8-07e2587a6932	2026-09-22 16:40:27.935108+00	\N	f	1	051ff554-9d6d-430e-aa97-a33c5cfd02f3	trứng	5.000	phần	\N	8
94bbb0d3-b397-4f28-b8f7-a15a39abcc79	2026-09-22 16:40:27.935108+00	\N	f	1	051ff554-9d6d-430e-aa97-a33c5cfd02f3	rau thơm	3.000	phần	\N	9
70fcea32-50ff-450d-8ae7-afa48830e64b	2026-09-22 16:40:27.935108+00	\N	f	1	051ff554-9d6d-430e-aa97-a33c5cfd02f3	hành lá	5.000	phần	\N	10
1b22b58f-d5e6-4476-8437-27c8ea7daba6	2026-09-22 16:40:27.935108+00	\N	f	1	051ff554-9d6d-430e-aa97-a33c5cfd02f3	đường	2.000	phần	\N	11
e52cefc8-14fd-4ad6-acf1-b72a24340c5a	2026-09-22 16:40:27.935108+00	\N	f	1	fc4b83b7-4471-4d88-b9ff-7bf95c2bdec5	hành lá	2.000	phần	\N	0
7a3e88e1-342e-441a-841f-04accc747132	2026-09-22 16:40:27.935108+00	\N	f	1	fc4b83b7-4471-4d88-b9ff-7bf95c2bdec5	tiêu	5.000	phần	\N	1
eb97a376-623a-4072-8da5-c17fa18ce444	2026-09-22 16:40:27.935108+00	\N	f	1	fc4b83b7-4471-4d88-b9ff-7bf95c2bdec5	bắp cải	5.000	phần	\N	2
dd4c72ce-114e-48e5-b589-9c8ccd76976d	2026-09-22 16:40:27.935108+00	\N	f	1	fc4b83b7-4471-4d88-b9ff-7bf95c2bdec5	tôm	1.000	phần	\N	3
26ce254a-1375-487f-a3c7-1ec2c466e355	2026-09-22 16:40:27.935108+00	\N	f	1	fc4b83b7-4471-4d88-b9ff-7bf95c2bdec5	đậu que	1.000	phần	\N	4
39e2e0b2-cf5a-4963-8af2-7080ab228d77	2026-09-22 16:40:27.935108+00	\N	f	1	fc4b83b7-4471-4d88-b9ff-7bf95c2bdec5	tỏi	2.000	phần	\N	5
f3a38f46-f230-4d12-9ab3-2c08cba3fa52	2026-09-22 16:40:27.935108+00	\N	f	1	fc4b83b7-4471-4d88-b9ff-7bf95c2bdec5	rau cải	1.000	phần	\N	6
361b6c29-29c1-432f-affa-ab0825e8f9a9	2026-09-22 16:40:27.935108+00	\N	f	1	fc4b83b7-4471-4d88-b9ff-7bf95c2bdec5	ớt chuông	5.000	phần	\N	7
2a653462-37d8-43f7-b370-5500fa2e4399	2026-09-22 16:40:27.935108+00	\N	f	1	fc4b83b7-4471-4d88-b9ff-7bf95c2bdec5	nước mắm	1.000	phần	\N	8
9d41c2ee-10d3-44f7-98a5-6061a2a23efe	2026-09-22 16:40:27.935108+00	\N	f	1	fc4b83b7-4471-4d88-b9ff-7bf95c2bdec5	khoai tây	4.000	phần	\N	9
9a9ba395-565c-4cd7-ac6c-d6882072b96f	2026-09-22 16:40:27.935108+00	\N	f	1	fc4b83b7-4471-4d88-b9ff-7bf95c2bdec5	thịt bò	5.000	phần	\N	10
ad5dcdc1-b734-4111-9bc8-7ddf5dfe3243	2026-09-22 16:40:27.935108+00	\N	f	1	fc4b83b7-4471-4d88-b9ff-7bf95c2bdec5	bí đỏ	3.000	phần	\N	11
5ab3ac0c-57a8-47c6-b130-e84220dae67a	2026-09-22 16:40:27.935108+00	\N	f	1	a6f16e93-82b8-4735-b8ae-cf751bcc2ba9	đậu que	4.000	phần	\N	0
1eb6976f-995b-42e6-87d7-20f29443a7a2	2026-09-22 16:40:27.935108+00	\N	f	1	a6f16e93-82b8-4735-b8ae-cf751bcc2ba9	ớt chuông	5.000	phần	\N	1
7ae19d07-9862-4f9a-bac1-920832d90562	2026-09-22 16:40:27.935108+00	\N	f	1	a6f16e93-82b8-4735-b8ae-cf751bcc2ba9	cá	5.000	phần	\N	2
886ade64-8002-4b8a-8f39-102589ca8056	2026-09-22 16:40:27.935108+00	\N	f	1	a6f16e93-82b8-4735-b8ae-cf751bcc2ba9	hành lá	3.000	phần	\N	3
5ffb964c-2f25-413a-af8c-c40b666872a2	2026-09-22 16:40:27.935108+00	\N	f	1	a6f16e93-82b8-4735-b8ae-cf751bcc2ba9	nước tương	4.000	phần	\N	4
f3f37eb2-3ee0-4f2c-adfc-d0a97ecdad4b	2026-09-22 16:40:27.935108+00	\N	f	1	a6f16e93-82b8-4735-b8ae-cf751bcc2ba9	nấm	3.000	phần	\N	5
2fbbf7f1-224e-4079-8400-bdd4ee378b8d	2026-09-22 16:40:27.935108+00	\N	f	1	a6f16e93-82b8-4735-b8ae-cf751bcc2ba9	đường	2.000	phần	\N	6
22681cde-892d-4788-8f14-bd198db04814	2026-09-22 16:40:27.935108+00	\N	f	1	a6f16e93-82b8-4735-b8ae-cf751bcc2ba9	thịt heo	3.000	phần	\N	7
854a3043-2952-4009-96e0-b150836f46b3	2026-09-22 16:40:27.935108+00	\N	f	1	a6f16e93-82b8-4735-b8ae-cf751bcc2ba9	muối	1.000	phần	\N	8
3b93aeb5-463e-4d41-95bb-8e157f42f931	2026-09-22 16:40:27.935108+00	\N	f	1	a6f16e93-82b8-4735-b8ae-cf751bcc2ba9	bắp cải	1.000	phần	\N	9
5dc2d7c0-1bcf-4e9b-8c82-5d9735b14006	2026-09-22 16:40:27.935108+00	\N	f	1	62eda459-2322-4352-ba9a-a9d14aba6b6e	trứng	4.000	phần	\N	0
1025ba69-ecac-4f25-852f-4f5537995468	2026-09-22 16:40:27.935108+00	\N	f	1	62eda459-2322-4352-ba9a-a9d14aba6b6e	thịt heo	5.000	phần	\N	1
8d633ee0-d885-42d0-9676-a11c51eb5ed2	2026-09-22 16:40:27.935108+00	\N	f	1	62eda459-2322-4352-ba9a-a9d14aba6b6e	nấm	2.000	phần	\N	2
c4b016ad-d60e-4150-805b-67f65f29c616	2026-09-22 16:40:27.935108+00	\N	f	1	62eda459-2322-4352-ba9a-a9d14aba6b6e	cà chua	4.000	phần	\N	3
bffa099b-b699-4241-933f-13dd2ce836a3	2026-09-22 16:40:27.935108+00	\N	f	1	62eda459-2322-4352-ba9a-a9d14aba6b6e	rau cải	3.000	phần	\N	4
a4412621-1bfe-475a-938a-4cf70191215f	2026-09-22 16:40:27.935108+00	\N	f	1	62eda459-2322-4352-ba9a-a9d14aba6b6e	nước mắm	2.000	phần	\N	5
c4f3917e-dde9-4aaa-851b-a2f3739b12ec	2026-09-22 16:40:27.935108+00	\N	f	1	62eda459-2322-4352-ba9a-a9d14aba6b6e	muối	3.000	phần	\N	6
48a54fa9-a173-4ea6-b1d5-46e89c413eed	2026-09-22 16:40:27.935108+00	\N	f	1	62eda459-2322-4352-ba9a-a9d14aba6b6e	thịt bò	5.000	phần	\N	7
ef2785d8-eb17-46dc-9f7e-5bd6387c864d	2026-09-22 16:40:27.935108+00	\N	f	1	62eda459-2322-4352-ba9a-a9d14aba6b6e	hành tây	3.000	phần	\N	8
de86b0d0-2717-4ab0-8d02-fed47ad781f4	2026-09-22 16:40:27.935108+00	\N	f	1	62eda459-2322-4352-ba9a-a9d14aba6b6e	đậu que	2.000	phần	\N	9
a3a09d1d-b6f7-4477-9ae9-635294ad6c56	2026-09-22 16:40:27.935108+00	\N	f	1	62eda459-2322-4352-ba9a-a9d14aba6b6e	đường	3.000	phần	\N	10
64b8686f-4495-44dc-b34e-8eb09d5c4bb6	2026-09-22 16:40:27.935108+00	\N	f	1	6265c5ea-183c-438d-b7c7-3930970b563f	nấm	1.000	phần	\N	0
4314b4ab-662d-43a2-97f4-eaa87926e16f	2026-09-22 16:40:27.935108+00	\N	f	1	6265c5ea-183c-438d-b7c7-3930970b563f	hành lá	2.000	phần	\N	1
b12fa8b0-0eb9-46fd-91b9-831910a102cd	2026-09-22 16:40:27.935108+00	\N	f	1	6265c5ea-183c-438d-b7c7-3930970b563f	đường	3.000	phần	\N	2
351bd711-d24e-4c0d-b7fa-ff22c9667c1d	2026-09-22 16:40:27.935108+00	\N	f	1	6265c5ea-183c-438d-b7c7-3930970b563f	thịt heo	4.000	phần	\N	3
ea0fac6e-7fa0-49fe-b835-50481ad39056	2026-09-22 16:40:27.935108+00	\N	f	1	6265c5ea-183c-438d-b7c7-3930970b563f	đậu hũ	5.000	phần	\N	4
603ad7b2-90b1-44ca-b3d3-4061ed79394f	2026-09-22 16:40:27.935108+00	\N	f	1	6265c5ea-183c-438d-b7c7-3930970b563f	rau thơm	4.000	phần	\N	5
e7f2a6cc-5938-4073-bec2-87f21b90498a	2026-09-22 16:40:27.935108+00	\N	f	1	6265c5ea-183c-438d-b7c7-3930970b563f	dầu ăn	4.000	phần	\N	6
d97aacec-245a-4d41-b005-020935a68bed	2026-09-22 16:40:27.935108+00	\N	f	1	6265c5ea-183c-438d-b7c7-3930970b563f	mì	4.000	phần	\N	7
3a7ba8a1-c5fb-4bf8-9d21-19c34e6756fc	2026-09-22 16:40:27.935108+00	\N	f	1	6265c5ea-183c-438d-b7c7-3930970b563f	gạo	3.000	phần	\N	8
d08ed401-cc82-4c6e-a21b-740114c1dc5d	2026-09-22 16:40:27.935108+00	\N	f	1	6265c5ea-183c-438d-b7c7-3930970b563f	tỏi	1.000	phần	\N	9
d88b95e8-167f-4e4c-93c0-5b42454a0f95	2026-09-22 16:40:27.935108+00	\N	f	1	25f17627-db23-487f-a6b2-aca2abb11e51	trứng	5.000	phần	\N	0
25ade44c-c1b4-4248-aae6-5291f51c8c00	2026-09-22 16:40:27.935108+00	\N	f	1	25f17627-db23-487f-a6b2-aca2abb11e51	bí đỏ	5.000	phần	\N	1
387f0738-8c8d-4534-88de-907771564dfd	2026-09-22 16:40:27.935108+00	\N	f	1	25f17627-db23-487f-a6b2-aca2abb11e51	gừng	4.000	phần	\N	2
8f9f265e-3c39-4eb1-b6d7-5856191d01db	2026-09-22 16:40:27.935108+00	\N	f	1	25f17627-db23-487f-a6b2-aca2abb11e51	thịt bò	2.000	phần	\N	3
521e8b69-72e1-4869-b2c6-b9c7809c58a8	2026-09-22 16:40:27.935108+00	\N	f	1	25f17627-db23-487f-a6b2-aca2abb11e51	bắp cải	3.000	phần	\N	4
bd8396a6-ace8-48e7-a860-77783b3898f6	2026-09-22 16:40:27.935108+00	\N	f	1	25f17627-db23-487f-a6b2-aca2abb11e51	đường	2.000	phần	\N	5
9d1a8984-086b-4b05-a2b9-95710ef20814	2026-09-22 16:40:27.935108+00	\N	f	1	25f17627-db23-487f-a6b2-aca2abb11e51	nấm	4.000	phần	\N	6
a031c139-a5db-4c1b-b81f-faf1380c2e8e	2026-09-22 16:40:27.935108+00	\N	f	1	25f17627-db23-487f-a6b2-aca2abb11e51	tôm	5.000	phần	\N	7
35d72890-aa58-4988-8931-c981075d69f9	2026-09-22 16:40:27.935108+00	\N	f	1	25f17627-db23-487f-a6b2-aca2abb11e51	bún	4.000	phần	\N	8
f1caad60-f997-4142-9d1e-b74ddbb85e6f	2026-09-22 16:40:27.935108+00	\N	f	1	25f17627-db23-487f-a6b2-aca2abb11e51	cá	3.000	phần	\N	9
a7ed1094-03b0-4b13-b357-517ffb7f7b4a	2026-09-22 16:40:27.935108+00	\N	f	1	1997d118-cbc5-4be5-a65d-093e23c14fce	thịt gà	5.000	phần	\N	0
c249aef0-4eac-4e48-a9f7-9b30df9add15	2026-09-22 16:40:27.935108+00	\N	f	1	1997d118-cbc5-4be5-a65d-093e23c14fce	dầu ăn	1.000	phần	\N	1
61c554a6-4b68-45c5-80d5-07ec15f6d9ce	2026-09-22 16:40:27.935108+00	\N	f	1	1997d118-cbc5-4be5-a65d-093e23c14fce	đường	1.000	phần	\N	2
0cbabbec-1b62-4de4-8640-99332059af53	2026-09-22 16:40:27.935108+00	\N	f	1	1997d118-cbc5-4be5-a65d-093e23c14fce	tôm	5.000	phần	\N	3
548b9e08-9602-4aa3-83df-4ff408f8b12b	2026-09-22 16:40:27.935108+00	\N	f	1	1997d118-cbc5-4be5-a65d-093e23c14fce	cà rốt	4.000	phần	\N	4
77409108-0e73-46dd-9355-dfab4b3db13d	2026-09-22 16:40:27.935108+00	\N	f	1	1997d118-cbc5-4be5-a65d-093e23c14fce	tỏi	5.000	phần	\N	5
9dab3a56-86f3-48e5-99aa-ccf976ad7c2e	2026-09-22 16:40:27.935108+00	\N	f	1	1997d118-cbc5-4be5-a65d-093e23c14fce	nước tương	4.000	phần	\N	6
1d116a34-c8bb-4a56-9077-5066b7576cb1	2026-09-22 16:40:27.935108+00	\N	f	1	1997d118-cbc5-4be5-a65d-093e23c14fce	muối	5.000	phần	\N	7
2a8c2ee0-5a06-4925-88c1-f3bd5cfb16a3	2026-09-22 16:40:27.935108+00	\N	f	1	1997d118-cbc5-4be5-a65d-093e23c14fce	cá	2.000	phần	\N	8
a8b04235-fb0d-4d52-a965-4a68f98d1f42	2026-09-22 16:40:27.935108+00	\N	f	1	1997d118-cbc5-4be5-a65d-093e23c14fce	ớt chuông	4.000	phần	\N	9
cd77ce30-9f43-446e-829c-b6991020b195	2026-09-22 16:40:27.935108+00	\N	f	1	9715c962-5702-4b62-9f10-6111b76cfef4	hành tây	3.000	phần	\N	0
c650761c-eb14-458b-b120-7538d56c7c05	2026-09-22 16:40:27.935108+00	\N	f	1	9715c962-5702-4b62-9f10-6111b76cfef4	mì	3.000	phần	\N	1
071b15c4-b682-475e-bcce-9ed8f1c8a297	2026-09-22 16:40:27.935108+00	\N	f	1	9715c962-5702-4b62-9f10-6111b76cfef4	thịt gà	2.000	phần	\N	2
b56da421-2532-4043-8068-fdb62fd45817	2026-09-22 16:40:27.935108+00	\N	f	1	9715c962-5702-4b62-9f10-6111b76cfef4	trứng	4.000	phần	\N	3
1ed41b5f-0ed9-41c8-a7ef-247e0efa806c	2026-09-22 16:40:27.935108+00	\N	f	1	9715c962-5702-4b62-9f10-6111b76cfef4	đậu que	3.000	phần	\N	4
90f9b969-c9f1-4ace-b383-0f0431627a3b	2026-09-22 16:40:27.935108+00	\N	f	1	9715c962-5702-4b62-9f10-6111b76cfef4	bí đỏ	3.000	phần	\N	5
6b59445e-b5e5-4639-bbb7-8a5d9d7ca2a4	2026-09-22 16:40:27.935108+00	\N	f	1	9715c962-5702-4b62-9f10-6111b76cfef4	khoai tây	3.000	phần	\N	6
48886360-7684-4f70-8d31-7460ce696f26	2026-09-22 16:40:27.935108+00	\N	f	1	9715c962-5702-4b62-9f10-6111b76cfef4	ớt chuông	3.000	phần	\N	7
4e56e7f8-eb88-4a77-a904-10015d2c3966	2026-09-22 16:40:27.935108+00	\N	f	1	9715c962-5702-4b62-9f10-6111b76cfef4	muối	3.000	phần	\N	8
23922bd1-468c-470f-99f6-2a095498d0a4	2026-09-22 16:40:27.935108+00	\N	f	1	9715c962-5702-4b62-9f10-6111b76cfef4	nấm	4.000	phần	\N	9
b1d1e1a8-e05b-4959-bc9e-cff27381edc9	2026-09-22 16:40:27.935108+00	\N	f	1	a0596eb3-1063-4178-b49c-8ea5186af4d4	rau cải	5.000	phần	\N	0
d7da54e0-1009-4175-a517-9ee9ff38752f	2026-09-22 16:40:27.935108+00	\N	f	1	a0596eb3-1063-4178-b49c-8ea5186af4d4	tỏi	3.000	phần	\N	1
a1c0de7c-efba-4537-bd3a-8bff77f87cbe	2026-09-22 16:40:27.935108+00	\N	f	1	a0596eb3-1063-4178-b49c-8ea5186af4d4	ớt chuông	4.000	phần	\N	2
87aca93c-14df-49d4-859d-5af6cacc2b3a	2026-09-22 16:40:27.935108+00	\N	f	1	a0596eb3-1063-4178-b49c-8ea5186af4d4	cà chua	5.000	phần	\N	3
dc68ca61-42d4-4ebd-80fc-d997c95ae262	2026-09-22 16:40:27.935108+00	\N	f	1	a0596eb3-1063-4178-b49c-8ea5186af4d4	nấm	4.000	phần	\N	4
bef2d95d-b1cc-4df5-8e78-54f334b9a4af	2026-09-22 16:40:27.935108+00	\N	f	1	a0596eb3-1063-4178-b49c-8ea5186af4d4	tiêu	2.000	phần	\N	5
10c24b3e-61f2-444c-b505-7482564d907a	2026-09-22 16:40:27.935108+00	\N	f	1	a0596eb3-1063-4178-b49c-8ea5186af4d4	trứng	4.000	phần	\N	6
5dfdb7ba-abae-4efe-a2ed-6b21e3402b1e	2026-09-22 16:40:27.935108+00	\N	f	1	a0596eb3-1063-4178-b49c-8ea5186af4d4	cà rốt	4.000	phần	\N	7
4b3cc24a-8829-4129-bbe9-bbdf91849f6e	2026-09-22 16:40:27.935108+00	\N	f	1	a0596eb3-1063-4178-b49c-8ea5186af4d4	muối	3.000	phần	\N	8
58073d6a-e016-4b6b-9cc8-a32cc46b3f65	2026-09-22 16:40:27.935108+00	\N	f	1	a0596eb3-1063-4178-b49c-8ea5186af4d4	nước mắm	1.000	phần	\N	9
72a1ef9e-e7f1-43ed-8fae-f9cf7043bd03	2026-09-22 16:40:27.935108+00	\N	f	1	a0596eb3-1063-4178-b49c-8ea5186af4d4	đậu hũ	5.000	phần	\N	10
2be04f49-60cb-4d6c-82ff-de7dc1f3f258	2026-09-22 16:40:27.935108+00	\N	f	1	a0596eb3-1063-4178-b49c-8ea5186af4d4	mì	3.000	phần	\N	11
f6e0269b-add5-4c93-9ef7-680782ad332f	2026-09-22 16:40:27.935108+00	\N	f	1	f9624aa7-7f5d-4a13-85eb-c10edb84d182	muối	5.000	phần	\N	0
404df003-4d94-4bfa-b870-384a23da1a9c	2026-09-22 16:40:27.935108+00	\N	f	1	f9624aa7-7f5d-4a13-85eb-c10edb84d182	nước mắm	2.000	phần	\N	1
47b5c6fc-b9e9-405c-9fd4-9081d635e0af	2026-09-22 16:40:27.935108+00	\N	f	1	f9624aa7-7f5d-4a13-85eb-c10edb84d182	cà rốt	1.000	phần	\N	2
fbfe0bb3-b2c4-4434-968f-abd71fd1cec5	2026-09-22 16:40:27.935108+00	\N	f	1	f9624aa7-7f5d-4a13-85eb-c10edb84d182	nấm	2.000	phần	\N	3
c3d38284-d591-4869-bf40-ba46cca63069	2026-09-22 16:40:27.935108+00	\N	f	1	f9624aa7-7f5d-4a13-85eb-c10edb84d182	thịt bò	1.000	phần	\N	4
cd4a576a-925d-4c98-b1bc-454b6345cf39	2026-09-22 16:40:27.935108+00	\N	f	1	f9624aa7-7f5d-4a13-85eb-c10edb84d182	bí đỏ	4.000	phần	\N	5
a4d5c1de-3077-4311-96ef-2d99c5a955cb	2026-09-22 16:40:27.935108+00	\N	f	1	f9624aa7-7f5d-4a13-85eb-c10edb84d182	gừng	4.000	phần	\N	6
0669f0e8-8f85-458e-9abd-23b6b70fada7	2026-09-22 16:40:27.935108+00	\N	f	1	f9624aa7-7f5d-4a13-85eb-c10edb84d182	thịt heo	4.000	phần	\N	7
205ae77c-91df-4db0-86c4-872ce677a746	2026-09-22 16:40:27.935108+00	\N	f	1	f9624aa7-7f5d-4a13-85eb-c10edb84d182	thịt gà	5.000	phần	\N	8
f6f0a9ab-d3d6-4108-9559-8a6069053c22	2026-09-22 16:40:27.935108+00	\N	f	1	f9624aa7-7f5d-4a13-85eb-c10edb84d182	rau thơm	2.000	phần	\N	9
b80e9b95-db22-4a14-ae69-f232c4ad7ae8	2026-09-22 16:40:27.935108+00	\N	f	1	f9624aa7-7f5d-4a13-85eb-c10edb84d182	đường	1.000	phần	\N	10
be985882-361f-48c7-a81c-67b58456f644	2026-09-22 16:40:27.935108+00	\N	f	1	f9624aa7-7f5d-4a13-85eb-c10edb84d182	tỏi	2.000	phần	\N	11
b212946d-e9ee-4630-9a9d-7ef5574aac37	2026-09-22 16:40:27.935108+00	\N	f	1	94173c5c-f916-413b-9405-8f6f415899fb	rau cải	1.000	phần	\N	0
7af7b061-f939-4cf4-adf0-9fdc50720e8a	2026-09-22 16:40:27.935108+00	\N	f	1	94173c5c-f916-413b-9405-8f6f415899fb	tỏi	2.000	phần	\N	1
1d1657a6-a184-4fb8-9d69-6259f6836010	2026-09-22 16:40:27.935108+00	\N	f	1	94173c5c-f916-413b-9405-8f6f415899fb	rau thơm	4.000	phần	\N	2
0e096639-bd19-42f8-bebc-e9b7334a2322	2026-09-22 16:40:27.935108+00	\N	f	1	94173c5c-f916-413b-9405-8f6f415899fb	cá	3.000	phần	\N	3
82059945-f425-4a7c-9ea2-15efa921f427	2026-09-22 16:40:27.935108+00	\N	f	1	94173c5c-f916-413b-9405-8f6f415899fb	mì	2.000	phần	\N	4
a09198bd-9166-4376-997e-e34acde94a1c	2026-09-22 16:40:27.935108+00	\N	f	1	94173c5c-f916-413b-9405-8f6f415899fb	tôm	4.000	phần	\N	5
697320e7-33e7-4df8-943d-9a893a7e8460	2026-09-22 16:40:27.935108+00	\N	f	1	94173c5c-f916-413b-9405-8f6f415899fb	tiêu	5.000	phần	\N	6
f1703e1f-cbc3-4e5d-b8bf-97cfea478e06	2026-09-22 16:40:27.935108+00	\N	f	1	94173c5c-f916-413b-9405-8f6f415899fb	đậu hũ	2.000	phần	\N	7
61533fb3-0c67-4437-afa7-65895c82af68	2026-09-22 16:40:27.935108+00	\N	f	1	94173c5c-f916-413b-9405-8f6f415899fb	bí đỏ	2.000	phần	\N	8
4ccb0c07-fd58-4b1f-92c1-73417dc831c1	2026-09-22 16:40:27.935108+00	\N	f	1	94173c5c-f916-413b-9405-8f6f415899fb	hành tây	5.000	phần	\N	9
90c8a10b-afbd-4976-9353-21a4554a4d0d	2026-09-22 16:40:27.935108+00	\N	f	1	94173c5c-f916-413b-9405-8f6f415899fb	dầu ăn	2.000	phần	\N	10
bbac5e1f-a2e6-459c-9232-8b6c17c4ff14	2026-09-22 16:40:27.935108+00	\N	f	1	b87f3df8-f610-4fea-8971-f0239c09372a	tôm	3.000	phần	\N	0
357bea17-214e-4fa9-b35d-5275e5a8dc9f	2026-09-22 16:40:27.935108+00	\N	f	1	b87f3df8-f610-4fea-8971-f0239c09372a	khoai tây	5.000	phần	\N	1
53e043a1-e8f4-4935-8bde-5d83c4e65e99	2026-09-22 16:40:27.935108+00	\N	f	1	b87f3df8-f610-4fea-8971-f0239c09372a	thịt bò	5.000	phần	\N	2
2e36a80c-8389-4b0f-a3ff-1ffa872f4ba9	2026-09-22 16:40:27.935108+00	\N	f	1	b87f3df8-f610-4fea-8971-f0239c09372a	tiêu	2.000	phần	\N	3
04662e2e-3794-4e45-a244-a6073f89eb6e	2026-09-22 16:40:27.935108+00	\N	f	1	b87f3df8-f610-4fea-8971-f0239c09372a	thịt heo	3.000	phần	\N	4
a39489e0-ada3-4f96-a29a-ec639324851c	2026-09-22 16:40:27.935108+00	\N	f	1	b87f3df8-f610-4fea-8971-f0239c09372a	đậu hũ	1.000	phần	\N	5
acfd29db-c1c7-4654-9315-e84680ff53b7	2026-09-22 16:40:27.935108+00	\N	f	1	b87f3df8-f610-4fea-8971-f0239c09372a	mì	4.000	phần	\N	6
f0ccb7b5-d88c-4d58-93d7-3bb0b3246205	2026-09-22 16:40:27.935108+00	\N	f	1	b87f3df8-f610-4fea-8971-f0239c09372a	hành lá	2.000	phần	\N	7
20fd858b-af4a-45d9-a148-79f130d2631e	2026-09-22 16:40:27.935108+00	\N	f	1	b87f3df8-f610-4fea-8971-f0239c09372a	bí đỏ	1.000	phần	\N	8
4402fc77-2546-403d-8a49-6ac8288a633e	2026-09-22 16:40:27.935108+00	\N	f	1	b87f3df8-f610-4fea-8971-f0239c09372a	cà rốt	1.000	phần	\N	9
e5d9f93e-8778-4456-b9c5-273ba3790ef2	2026-09-22 16:40:27.935108+00	\N	f	1	b87f3df8-f610-4fea-8971-f0239c09372a	cá	3.000	phần	\N	10
56f309a1-4e1b-49a4-b501-6c7d0ca764d3	2026-09-22 16:40:27.935108+00	\N	f	1	6e4ba959-1bfc-4f17-a5ea-cca315f28167	trứng	1.000	phần	\N	0
18ebb42f-cd5f-49a8-8d28-865658e1ba37	2026-09-22 16:40:27.935108+00	\N	f	1	6e4ba959-1bfc-4f17-a5ea-cca315f28167	mì	1.000	phần	\N	1
958eb237-9e1c-4c00-af13-7a630b520b26	2026-09-22 16:40:27.935108+00	\N	f	1	6e4ba959-1bfc-4f17-a5ea-cca315f28167	bún	4.000	phần	\N	2
27760ae5-ee80-4d58-bcb6-519f9989b80c	2026-09-22 16:40:27.935108+00	\N	f	1	6e4ba959-1bfc-4f17-a5ea-cca315f28167	rau cải	1.000	phần	\N	3
08d8a8f4-bf94-4d46-b934-5ab05abe89cd	2026-09-22 16:40:27.935108+00	\N	f	1	6e4ba959-1bfc-4f17-a5ea-cca315f28167	nấm	4.000	phần	\N	4
e142b4ad-fd98-4b10-992c-064d852318a8	2026-09-22 16:40:27.935108+00	\N	f	1	6e4ba959-1bfc-4f17-a5ea-cca315f28167	hành tây	1.000	phần	\N	5
6cc379a9-5231-4d3d-8ade-ae1fcbca71cb	2026-09-22 16:40:27.935108+00	\N	f	1	6e4ba959-1bfc-4f17-a5ea-cca315f28167	muối	5.000	phần	\N	6
a05a51ec-826f-4742-8b47-8228992fd5fa	2026-09-22 16:40:27.935108+00	\N	f	1	6e4ba959-1bfc-4f17-a5ea-cca315f28167	nước tương	1.000	phần	\N	7
c3ec4bb2-76cf-4f7a-a586-0812e883d335	2026-09-22 16:40:27.935108+00	\N	f	1	6e4ba959-1bfc-4f17-a5ea-cca315f28167	cà rốt	2.000	phần	\N	8
719cb3bc-71ed-4201-8023-67c452fe084e	2026-09-22 16:40:27.935108+00	\N	f	1	6e4ba959-1bfc-4f17-a5ea-cca315f28167	khoai tây	4.000	phần	\N	9
3d969fdf-2ac8-4933-9caa-cb836f1fbfac	2026-09-22 16:40:27.935108+00	\N	f	1	6e4ba959-1bfc-4f17-a5ea-cca315f28167	nước mắm	5.000	phần	\N	10
4d2371e8-f158-4b5c-ab75-6311a6238542	2026-09-22 16:40:27.935108+00	\N	f	1	a2252302-6dcd-4676-9894-6d61e5bdbc95	cá	4.000	phần	\N	0
529b555f-d728-491a-b49e-ecbda6c95d94	2026-09-22 16:40:27.935108+00	\N	f	1	a2252302-6dcd-4676-9894-6d61e5bdbc95	tỏi	4.000	phần	\N	1
382544f6-3e73-412c-b4ec-4e748efe51cb	2026-09-22 16:40:27.935108+00	\N	f	1	a2252302-6dcd-4676-9894-6d61e5bdbc95	bún	3.000	phần	\N	2
0e8bf06f-ca42-4e3d-b1d8-4ee1b1a71cd8	2026-09-22 16:40:27.935108+00	\N	f	1	a2252302-6dcd-4676-9894-6d61e5bdbc95	mì	5.000	phần	\N	3
22df72f3-5043-4916-8a46-52178ea28d5e	2026-09-22 16:40:27.935108+00	\N	f	1	a2252302-6dcd-4676-9894-6d61e5bdbc95	cà rốt	2.000	phần	\N	4
73579bbe-e388-4621-9195-d4d2faefd2c3	2026-09-22 16:40:27.935108+00	\N	f	1	a2252302-6dcd-4676-9894-6d61e5bdbc95	đậu hũ	2.000	phần	\N	5
029d2649-72b6-45f0-b0df-fef84b2f1652	2026-09-22 16:40:27.935108+00	\N	f	1	a2252302-6dcd-4676-9894-6d61e5bdbc95	trứng	3.000	phần	\N	6
e1d66965-7271-4e31-ba56-2737df606908	2026-09-22 16:40:27.935108+00	\N	f	1	a2252302-6dcd-4676-9894-6d61e5bdbc95	tiêu	5.000	phần	\N	7
6565d5e8-aaac-4f46-9ffc-72b60fd3e5ef	2026-09-22 16:40:27.935108+00	\N	f	1	a2252302-6dcd-4676-9894-6d61e5bdbc95	gừng	2.000	phần	\N	8
bceecc91-0fe1-4adc-8dd5-ae3e785d25a0	2026-09-22 16:40:27.935108+00	\N	f	1	a2252302-6dcd-4676-9894-6d61e5bdbc95	cà chua	1.000	phần	\N	9
fa1f71d4-12bd-4da9-bc34-9de6a5e2b363	2026-09-22 16:40:27.935108+00	\N	f	1	a2252302-6dcd-4676-9894-6d61e5bdbc95	thịt heo	5.000	phần	\N	10
a2cec36e-0c31-418b-8541-bc25351fe8de	2026-09-22 16:40:27.935108+00	\N	f	1	a2252302-6dcd-4676-9894-6d61e5bdbc95	đường	4.000	phần	\N	11
\.


--
-- Data for Name: recipe_steps; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.recipe_steps (id, created_at, updated_at, is_deleted, row_version, recipe_id, step_number, title, description, timer_minutes, image_url) FROM stdin;
6a013ec3-8ea9-43b6-93cc-71213a7601ec	2026-09-22 16:40:27.935108+00	\N	f	1	3787d4e3-76f7-4e24-b1ec-02d9dc13d6e0	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho cơm gà phiên bản 001, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.	16	\N
be86626d-6270-48b5-9014-91a48bcecabc	2026-09-22 16:40:27.935108+00	\N	f	1	3787d4e3-76f7-4e24-b1ec-02d9dc13d6e0	2	Sơ chế	Sơ chế cho cơm gà phiên bản 001, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	20	\N
d3bbc2dd-f542-4a2d-bc61-375e8be86bb8	2026-09-22 16:40:27.935108+00	\N	f	1	3787d4e3-76f7-4e24-b1ec-02d9dc13d6e0	3	Ướp gia vị	Ướp gia vị cho cơm gà phiên bản 001, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	13	\N
db9ae096-2d7b-4b10-aebf-f29eda0ab9d3	2026-09-22 16:40:27.935108+00	\N	f	1	3787d4e3-76f7-4e24-b1ec-02d9dc13d6e0	4	Làm nóng chảo	Làm nóng chảo cho cơm gà phiên bản 001, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	11	\N
764f9750-de08-4f0b-a519-e9b602f6cb33	2026-09-22 16:40:27.935108+00	\N	f	1	3787d4e3-76f7-4e24-b1ec-02d9dc13d6e0	5	Chế biến phần chính	Chế biến phần chính cho cơm gà phiên bản 001, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	15	\N
6091937d-a4cb-48f4-a469-137bab6463f8	2026-09-22 16:40:27.935108+00	\N	f	1	1703c731-fb1d-4e84-ba8a-adbdeed3dad6	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho bún bò phiên bản 002, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	15	\N
c5858287-02d1-407f-a4b7-3fd5b16c461f	2026-09-22 16:40:27.935108+00	\N	f	1	1703c731-fb1d-4e84-ba8a-adbdeed3dad6	2	Sơ chế	Sơ chế cho bún bò phiên bản 002, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	20	\N
10fc1e13-eb39-47e8-b32b-0f24cdb25e39	2026-09-22 16:40:27.935108+00	\N	f	1	1703c731-fb1d-4e84-ba8a-adbdeed3dad6	3	Ướp gia vị	Ướp gia vị cho bún bò phiên bản 002, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	7	\N
7d4b83b4-95e7-4fbb-ba5c-8f78b9482e77	2026-09-22 16:40:27.935108+00	\N	f	1	1703c731-fb1d-4e84-ba8a-adbdeed3dad6	4	Làm nóng chảo	Làm nóng chảo cho bún bò phiên bản 002, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	15	\N
fa8df195-e92c-47f3-8b7e-c780bdfbd393	2026-09-22 16:40:27.935108+00	\N	f	1	1703c731-fb1d-4e84-ba8a-adbdeed3dad6	5	Chế biến phần chính	Chế biến phần chính cho bún bò phiên bản 002, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	7	\N
f704d35d-84d4-4c95-b312-d85ccc37d363	2026-09-22 16:40:27.935108+00	\N	f	1	1703c731-fb1d-4e84-ba8a-adbdeed3dad6	6	Nêm nếm	Nêm nếm cho bún bò phiên bản 002, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	13	\N
03c8b4c0-72ab-4b64-a804-6d64ab63f760	2026-09-22 16:40:27.935108+00	\N	f	1	1703c731-fb1d-4e84-ba8a-adbdeed3dad6	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho bún bò phiên bản 002, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	12	\N
a19eeb92-3a3a-4499-851d-cfca4d2e2a5e	2026-09-22 16:40:27.935108+00	\N	f	1	b40ee684-3a0c-495f-b9a6-bfc26d73e009	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho mì rau củ phiên bản 003, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	20	\N
a37221a5-6e43-45a2-907a-cb3e19331f22	2026-09-22 16:40:27.935108+00	\N	f	1	b40ee684-3a0c-495f-b9a6-bfc26d73e009	2	Sơ chế	Sơ chế cho mì rau củ phiên bản 003, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	19	\N
89603715-47f0-432e-9c67-b19d0fb82916	2026-09-22 16:40:27.935108+00	\N	f	1	b40ee684-3a0c-495f-b9a6-bfc26d73e009	3	Ướp gia vị	Ướp gia vị cho mì rau củ phiên bản 003, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	6	\N
d4c8c584-1dec-46f3-b8c9-c9a5d7b99d4a	2026-09-22 16:40:27.935108+00	\N	f	1	b40ee684-3a0c-495f-b9a6-bfc26d73e009	4	Làm nóng chảo	Làm nóng chảo cho mì rau củ phiên bản 003, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	12	\N
283c58a3-76a1-4cc3-ba96-7b85767ef02e	2026-09-22 16:40:27.935108+00	\N	f	1	b40ee684-3a0c-495f-b9a6-bfc26d73e009	5	Chế biến phần chính	Chế biến phần chính cho mì rau củ phiên bản 003, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	12	\N
38201726-ab5b-4e16-b233-16d77314362c	2026-09-22 16:40:27.935108+00	\N	f	1	050092b5-1c6f-4445-a54e-612ce26146a9	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho đậu hũ sốt phiên bản 004, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	16	\N
c0bea25a-d245-453f-be93-8b1b157ab74d	2026-09-22 16:40:27.935108+00	\N	f	1	050092b5-1c6f-4445-a54e-612ce26146a9	2	Sơ chế	Sơ chế cho đậu hũ sốt phiên bản 004, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	7	\N
32a7e87d-ab2b-47ad-b9dd-d370ce02ebcd	2026-09-22 16:40:27.935108+00	\N	f	1	050092b5-1c6f-4445-a54e-612ce26146a9	3	Ướp gia vị	Ướp gia vị cho đậu hũ sốt phiên bản 004, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	18	\N
4e6837a7-2280-4372-ae46-8d576e52ffbb	2026-09-22 16:40:27.935108+00	\N	f	1	050092b5-1c6f-4445-a54e-612ce26146a9	4	Làm nóng chảo	Làm nóng chảo cho đậu hũ sốt phiên bản 004, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	18	\N
fcb037d4-9a2f-43b2-a8ad-d4bcf528d14a	2026-09-22 16:40:27.935108+00	\N	f	1	050092b5-1c6f-4445-a54e-612ce26146a9	5	Chế biến phần chính	Chế biến phần chính cho đậu hũ sốt phiên bản 004, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	16	\N
568a1a9b-7316-4b7f-9da0-600b15b2ac29	2026-09-22 16:40:27.935108+00	\N	f	1	050092b5-1c6f-4445-a54e-612ce26146a9	6	Nêm nếm	Nêm nếm cho đậu hũ sốt phiên bản 004, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	13	\N
138136b0-3327-4758-8986-1ee17e7733ea	2026-09-22 16:40:27.935108+00	\N	f	1	050092b5-1c6f-4445-a54e-612ce26146a9	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho đậu hũ sốt phiên bản 004, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	7	\N
8473317c-97ef-4826-ba0c-606f07762d35	2026-09-22 16:40:27.935108+00	\N	f	1	2394e84b-4eee-4ad5-9013-515f70a3ab4d	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho cá nướng phiên bản 005, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	12	\N
66d17e9c-6708-4f6a-b249-4bd2bd7232b0	2026-09-22 16:40:27.935108+00	\N	f	1	2394e84b-4eee-4ad5-9013-515f70a3ab4d	2	Sơ chế	Sơ chế cho cá nướng phiên bản 005, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	19	\N
10c3713a-5595-4b8b-aa31-0177c86dbf90	2026-09-22 16:40:27.935108+00	\N	f	1	2394e84b-4eee-4ad5-9013-515f70a3ab4d	3	Ướp gia vị	Ướp gia vị cho cá nướng phiên bản 005, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	15	\N
6f71fdc5-74d0-4c73-b972-4cad1fd90bc5	2026-09-22 16:40:27.935108+00	\N	f	1	2394e84b-4eee-4ad5-9013-515f70a3ab4d	4	Làm nóng chảo	Làm nóng chảo cho cá nướng phiên bản 005, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	16	\N
6e89bac3-2249-4547-adfd-836de828cf83	2026-09-22 16:40:27.935108+00	\N	f	1	2394e84b-4eee-4ad5-9013-515f70a3ab4d	5	Chế biến phần chính	Chế biến phần chính cho cá nướng phiên bản 005, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	13	\N
b74fd0a1-03ae-438d-a4df-5d40fac7ad0b	2026-09-22 16:40:27.935108+00	\N	f	1	2394e84b-4eee-4ad5-9013-515f70a3ab4d	6	Nêm nếm	Nêm nếm cho cá nướng phiên bản 005, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	9	\N
9b3f5619-6799-41e1-9479-e1a556e5eb18	2026-09-22 16:40:27.935108+00	\N	f	1	2394e84b-4eee-4ad5-9013-515f70a3ab4d	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho cá nướng phiên bản 005, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	14	\N
776957ce-99de-4a24-9749-10df2719512a	2026-09-22 16:40:27.935108+00	\N	f	1	0c889484-df93-4a39-897a-e992dcf725e4	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho gà hấp phiên bản 006, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	5	\N
83ee31ff-4e0c-43f1-a9fd-a82e57b3f7b2	2026-09-22 16:40:27.935108+00	\N	f	1	0c889484-df93-4a39-897a-e992dcf725e4	2	Sơ chế	Sơ chế cho gà hấp phiên bản 006, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	18	\N
70fe16ad-6d4f-4eb9-bd73-b6928db51250	2026-09-22 16:40:27.935108+00	\N	f	1	0c889484-df93-4a39-897a-e992dcf725e4	3	Ướp gia vị	Ướp gia vị cho gà hấp phiên bản 006, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	7	\N
cd77a9eb-8ecd-49a6-ad9c-b6dba0c41650	2026-09-22 16:40:27.935108+00	\N	f	1	0c889484-df93-4a39-897a-e992dcf725e4	4	Làm nóng chảo	Làm nóng chảo cho gà hấp phiên bản 006, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	12	\N
4691a2c6-4f10-4c84-a865-3bb18703d6e8	2026-09-22 16:40:27.935108+00	\N	f	1	0c889484-df93-4a39-897a-e992dcf725e4	5	Chế biến phần chính	Chế biến phần chính cho gà hấp phiên bản 006, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	8	\N
8117fe8d-75ad-470e-9fbc-2894f542fb99	2026-09-22 16:40:27.935108+00	\N	f	1	0c889484-df93-4a39-897a-e992dcf725e4	6	Nêm nếm	Nêm nếm cho gà hấp phiên bản 006, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	18	\N
6c2b02ad-8237-487f-a5e1-4fb34dd4815e	2026-09-22 16:40:27.935108+00	\N	f	1	6510d19c-8538-43f3-8d99-6ec5f71ac9cf	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho thịt xào phiên bản 007, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	7	\N
6619e63e-2545-46f9-80c0-7a9f69b812cc	2026-09-22 16:40:27.935108+00	\N	f	1	6510d19c-8538-43f3-8d99-6ec5f71ac9cf	2	Sơ chế	Sơ chế cho thịt xào phiên bản 007, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	9	\N
60d1d273-03e4-47ef-bd1d-d41066090fba	2026-09-22 16:40:27.935108+00	\N	f	1	6510d19c-8538-43f3-8d99-6ec5f71ac9cf	3	Ướp gia vị	Ướp gia vị cho thịt xào phiên bản 007, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	14	\N
8432f31d-d3a1-4016-9ca4-67d76ecea8cf	2026-09-22 16:40:27.935108+00	\N	f	1	6510d19c-8538-43f3-8d99-6ec5f71ac9cf	4	Làm nóng chảo	Làm nóng chảo cho thịt xào phiên bản 007, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	17	\N
9257e499-ef00-4a04-ac86-df059d4c6d00	2026-09-22 16:40:27.935108+00	\N	f	1	6510d19c-8538-43f3-8d99-6ec5f71ac9cf	5	Chế biến phần chính	Chế biến phần chính cho thịt xào phiên bản 007, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	14	\N
240d827c-0cec-4206-bffd-706a146ace8d	2026-09-22 16:40:27.935108+00	\N	f	1	970ab102-0421-42a7-8494-6b67971d7ac3	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho tôm chiên phiên bản 008, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	18	\N
2fa8964d-87a9-4fce-9cbd-8fd1a3e4a245	2026-09-22 16:40:27.935108+00	\N	f	1	970ab102-0421-42a7-8494-6b67971d7ac3	2	Sơ chế	Sơ chế cho tôm chiên phiên bản 008, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	14	\N
721cacbf-a067-42b6-9462-c4740489df4c	2026-09-22 16:40:27.935108+00	\N	f	1	970ab102-0421-42a7-8494-6b67971d7ac3	3	Ướp gia vị	Ướp gia vị cho tôm chiên phiên bản 008, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	18	\N
2300784f-bddb-4672-95d5-998bfbfee5c5	2026-09-22 16:40:27.935108+00	\N	f	1	970ab102-0421-42a7-8494-6b67971d7ac3	4	Làm nóng chảo	Làm nóng chảo cho tôm chiên phiên bản 008, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	8	\N
ce1e9e10-ce17-4a83-8fe9-06ae25fc99df	2026-09-22 16:40:27.935108+00	\N	f	1	970ab102-0421-42a7-8494-6b67971d7ac3	5	Chế biến phần chính	Chế biến phần chính cho tôm chiên phiên bản 008, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	8	\N
fe0e477a-5b24-427b-bb14-3da13e4835fe	2026-09-22 16:40:27.935108+00	\N	f	1	970ab102-0421-42a7-8494-6b67971d7ac3	6	Nêm nếm	Nêm nếm cho tôm chiên phiên bản 008, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	7	\N
1bfe777a-63bc-43cd-8748-4fad9424a6fc	2026-09-22 16:40:27.935108+00	\N	f	1	970ab102-0421-42a7-8494-6b67971d7ac3	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho tôm chiên phiên bản 008, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	17	\N
462e5d4f-58d0-42dc-b92a-0e5d826d7442	2026-09-22 16:40:27.935108+00	\N	f	1	75cfa00e-2706-4f44-bb2e-a391e66446d1	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho cá kho phiên bản 009, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	12	\N
d736fec4-8182-4e31-bb16-72c7947fcda3	2026-09-22 16:40:27.935108+00	\N	f	1	75cfa00e-2706-4f44-bb2e-a391e66446d1	2	Sơ chế	Sơ chế cho cá kho phiên bản 009, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	6	\N
5f2f143a-7b36-4c09-a640-ed5eb00056fc	2026-09-22 16:40:27.935108+00	\N	f	1	75cfa00e-2706-4f44-bb2e-a391e66446d1	3	Ướp gia vị	Ướp gia vị cho cá kho phiên bản 009, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	18	\N
513054bd-1825-43f7-9b55-0bbefeba7a97	2026-09-22 16:40:27.935108+00	\N	f	1	75cfa00e-2706-4f44-bb2e-a391e66446d1	4	Làm nóng chảo	Làm nóng chảo cho cá kho phiên bản 009, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	9	\N
45c38548-957d-49b2-9dbf-014723a3b3ba	2026-09-22 16:40:27.935108+00	\N	f	1	75cfa00e-2706-4f44-bb2e-a391e66446d1	5	Chế biến phần chính	Chế biến phần chính cho cá kho phiên bản 009, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	8	\N
238b6a26-0308-43c4-bc6b-b3e5d8a2e9f9	2026-09-22 16:40:27.935108+00	\N	f	1	75cfa00e-2706-4f44-bb2e-a391e66446d1	6	Nêm nếm	Nêm nếm cho cá kho phiên bản 009, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	9	\N
88a9a248-529c-4dba-83a9-b36505e13a4e	2026-09-22 16:40:27.935108+00	\N	f	1	75cfa00e-2706-4f44-bb2e-a391e66446d1	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho cá kho phiên bản 009, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	5	\N
dd63522f-c4ba-4148-83f0-d748ff951309	2026-09-22 16:40:27.935108+00	\N	f	1	788bda25-29a3-4dc9-887a-229470df72b1	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho canh bí phiên bản 010, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	7	\N
78d9f23f-1beb-4a50-a6bc-0bd3e1b97e58	2026-09-22 16:40:27.935108+00	\N	f	1	788bda25-29a3-4dc9-887a-229470df72b1	2	Sơ chế	Sơ chế cho canh bí phiên bản 010, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	6	\N
723f8927-e013-426d-a623-c8c1fc3452e5	2026-09-22 16:40:27.935108+00	\N	f	1	788bda25-29a3-4dc9-887a-229470df72b1	3	Ướp gia vị	Ướp gia vị cho canh bí phiên bản 010, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	10	\N
3816375d-47e2-455e-a620-f806434f377b	2026-09-22 16:40:27.935108+00	\N	f	1	788bda25-29a3-4dc9-887a-229470df72b1	4	Làm nóng chảo	Làm nóng chảo cho canh bí phiên bản 010, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	14	\N
47b7cae8-dd37-469a-a74f-6318455f2cfe	2026-09-22 16:40:27.935108+00	\N	f	1	788bda25-29a3-4dc9-887a-229470df72b1	5	Chế biến phần chính	Chế biến phần chính cho canh bí phiên bản 010, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	11	\N
164ca3c2-7021-44c5-801e-edaac8c2b94b	2026-09-22 16:40:27.935108+00	\N	f	1	788bda25-29a3-4dc9-887a-229470df72b1	6	Nêm nếm	Nêm nếm cho canh bí phiên bản 010, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	9	\N
96fc791f-8ada-4bfa-914e-c0a62f5eeaa8	2026-09-22 16:40:27.935108+00	\N	f	1	6c5a11c1-fbae-44ca-92e5-e723cc2041e9	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho súp nấm phiên bản 011, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	13	\N
620750bc-041d-40e2-9518-dc813ad374a7	2026-09-22 16:40:27.935108+00	\N	f	1	6c5a11c1-fbae-44ca-92e5-e723cc2041e9	2	Sơ chế	Sơ chế cho súp nấm phiên bản 011, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	5	\N
03dffa32-b2ef-4635-b6eb-af17a330e5ac	2026-09-22 16:40:27.935108+00	\N	f	1	6c5a11c1-fbae-44ca-92e5-e723cc2041e9	3	Ướp gia vị	Ướp gia vị cho súp nấm phiên bản 011, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	8	\N
ffd64026-b9fe-4d39-88c0-260b25e0e7af	2026-09-22 16:40:27.935108+00	\N	f	1	6c5a11c1-fbae-44ca-92e5-e723cc2041e9	4	Làm nóng chảo	Làm nóng chảo cho súp nấm phiên bản 011, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	20	\N
3094ad9e-0d0e-4e43-9d85-e916c3832bb6	2026-09-22 16:40:27.935108+00	\N	f	1	faf4d8d6-f61e-4245-ac7d-c2e75e566caa	6	Nêm nếm	Nêm nếm cho chè đậu phiên bản 016, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	19	\N
9acabb20-b300-4179-9956-9713b8e62759	2026-09-22 16:40:27.935108+00	\N	f	1	6c5a11c1-fbae-44ca-92e5-e723cc2041e9	5	Chế biến phần chính	Chế biến phần chính cho súp nấm phiên bản 011, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	9	\N
ceb07e7e-448d-40f9-8278-a11d8d08cc27	2026-09-22 16:40:27.935108+00	\N	f	1	6c5a11c1-fbae-44ca-92e5-e723cc2041e9	6	Nêm nếm	Nêm nếm cho súp nấm phiên bản 011, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	13	\N
cc037d75-466d-4305-8d0c-5e351b9c4c4e	2026-09-22 16:40:27.935108+00	\N	f	1	64ec096c-f2d9-410a-aa22-ee25b77345cb	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho cơm rang phiên bản 012, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	16	\N
d320a767-da56-4527-b9e8-3e9fbcd74088	2026-09-22 16:40:27.935108+00	\N	f	1	64ec096c-f2d9-410a-aa22-ee25b77345cb	2	Sơ chế	Sơ chế cho cơm rang phiên bản 012, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	5	\N
6ab02e4c-d232-4ac0-8cc5-66ca5aaafdcc	2026-09-22 16:40:27.935108+00	\N	f	1	64ec096c-f2d9-410a-aa22-ee25b77345cb	3	Ướp gia vị	Ướp gia vị cho cơm rang phiên bản 012, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	16	\N
140f1922-f8c2-42a7-ab86-081be4b799ba	2026-09-22 16:40:27.935108+00	\N	f	1	64ec096c-f2d9-410a-aa22-ee25b77345cb	4	Làm nóng chảo	Làm nóng chảo cho cơm rang phiên bản 012, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	16	\N
2ffd91df-ef93-4129-a8c2-3c1c0ee7c2b9	2026-09-22 16:40:27.935108+00	\N	f	1	64ec096c-f2d9-410a-aa22-ee25b77345cb	5	Chế biến phần chính	Chế biến phần chính cho cơm rang phiên bản 012, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	18	\N
6968ccb8-92af-43a9-bd36-a12d80801b77	2026-09-22 16:40:27.935108+00	\N	f	1	64ec096c-f2d9-410a-aa22-ee25b77345cb	6	Nêm nếm	Nêm nếm cho cơm rang phiên bản 012, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	14	\N
e84739c8-f09d-45ad-9d59-1325d566ed1b	2026-09-22 16:40:27.935108+00	\N	f	1	f1a8a3e3-9e06-4520-94f8-7b1dcce6166a	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho mì xào phiên bản 013, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	13	\N
20bcc840-50d8-4495-89f6-487bf69b66e4	2026-09-22 16:40:27.935108+00	\N	f	1	f1a8a3e3-9e06-4520-94f8-7b1dcce6166a	2	Sơ chế	Sơ chế cho mì xào phiên bản 013, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	11	\N
3f4140dd-2679-4b76-9d5f-4b414bd40c60	2026-09-22 16:40:27.935108+00	\N	f	1	f1a8a3e3-9e06-4520-94f8-7b1dcce6166a	3	Ướp gia vị	Ướp gia vị cho mì xào phiên bản 013, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	11	\N
a6ff0451-bcc6-4ae4-9976-dbe57de5da9f	2026-09-22 16:40:27.935108+00	\N	f	1	f1a8a3e3-9e06-4520-94f8-7b1dcce6166a	4	Làm nóng chảo	Làm nóng chảo cho mì xào phiên bản 013, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.	16	\N
13208439-d803-4405-aaa1-077730ac3d81	2026-09-22 16:40:27.935108+00	\N	f	1	f1a8a3e3-9e06-4520-94f8-7b1dcce6166a	5	Chế biến phần chính	Chế biến phần chính cho mì xào phiên bản 013, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	15	\N
7af18572-f9d9-4817-9f44-653f71d4710e	2026-09-22 16:40:27.935108+00	\N	f	1	f1a8a3e3-9e06-4520-94f8-7b1dcce6166a	6	Nêm nếm	Nêm nếm cho mì xào phiên bản 013, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	8	\N
bd5ca1ff-f234-4fc8-bb83-dc8f9ed11dff	2026-09-22 16:40:27.935108+00	\N	f	1	f1a8a3e3-9e06-4520-94f8-7b1dcce6166a	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho mì xào phiên bản 013, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	14	\N
7105112c-396a-43df-bd4d-e3da11105800	2026-09-22 16:40:27.935108+00	\N	f	1	a347dce3-40ce-4ffb-8e3d-f24d88d19404	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho bún thịt phiên bản 014, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	17	\N
859f01a8-6fbf-4074-a89a-e2b23f53690d	2026-09-22 16:40:27.935108+00	\N	f	1	a347dce3-40ce-4ffb-8e3d-f24d88d19404	2	Sơ chế	Sơ chế cho bún thịt phiên bản 014, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.	15	\N
3b5c6721-75ef-4723-9b52-cf86f0fb2539	2026-09-22 16:40:27.935108+00	\N	f	1	a347dce3-40ce-4ffb-8e3d-f24d88d19404	3	Ướp gia vị	Ướp gia vị cho bún thịt phiên bản 014, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	10	\N
b120f456-255b-434e-af63-f34b198b028c	2026-09-22 16:40:27.935108+00	\N	f	1	a347dce3-40ce-4ffb-8e3d-f24d88d19404	4	Làm nóng chảo	Làm nóng chảo cho bún thịt phiên bản 014, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	12	\N
e4d41c4a-7d7e-4ec7-9cef-dd306d5d6efb	2026-09-22 16:40:27.935108+00	\N	f	1	a347dce3-40ce-4ffb-8e3d-f24d88d19404	5	Chế biến phần chính	Chế biến phần chính cho bún thịt phiên bản 014, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.	19	\N
ef610b49-74af-40ff-9e22-f89258780940	2026-09-22 16:40:27.935108+00	\N	f	1	a347dce3-40ce-4ffb-8e3d-f24d88d19404	6	Nêm nếm	Nêm nếm cho bún thịt phiên bản 014, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	17	\N
9245a785-3e44-4511-8405-7c42136848fb	2026-09-22 16:40:27.935108+00	\N	f	1	018f344f-43b8-4593-bb41-5c94eb229f62	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho bánh khoai phiên bản 015, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	17	\N
e04c14a0-4b69-4b47-b07c-607c916c8b30	2026-09-22 16:40:27.935108+00	\N	f	1	018f344f-43b8-4593-bb41-5c94eb229f62	2	Sơ chế	Sơ chế cho bánh khoai phiên bản 015, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	6	\N
0a90e4c7-002f-4fde-b29c-92f77e4fed5e	2026-09-22 16:40:27.935108+00	\N	f	1	018f344f-43b8-4593-bb41-5c94eb229f62	3	Ướp gia vị	Ướp gia vị cho bánh khoai phiên bản 015, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	13	\N
4b5ad5a5-b1b2-4553-8f74-3f20d992700b	2026-09-22 16:40:27.935108+00	\N	f	1	018f344f-43b8-4593-bb41-5c94eb229f62	4	Làm nóng chảo	Làm nóng chảo cho bánh khoai phiên bản 015, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	19	\N
d7cdc4c3-e215-46a5-83fb-7227a7b96b81	2026-09-22 16:40:27.935108+00	\N	f	1	018f344f-43b8-4593-bb41-5c94eb229f62	5	Chế biến phần chính	Chế biến phần chính cho bánh khoai phiên bản 015, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	6	\N
e2955fd4-bf98-4264-bd11-b7ebd29cff36	2026-09-22 16:40:27.935108+00	\N	f	1	018f344f-43b8-4593-bb41-5c94eb229f62	6	Nêm nếm	Nêm nếm cho bánh khoai phiên bản 015, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.	11	\N
d46fc5bd-630f-4a9e-8896-979d18908aab	2026-09-22 16:40:27.935108+00	\N	f	1	018f344f-43b8-4593-bb41-5c94eb229f62	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho bánh khoai phiên bản 015, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	6	\N
549b1709-5225-48ba-8a79-431161efaa0a	2026-09-22 16:40:27.935108+00	\N	f	1	faf4d8d6-f61e-4245-ac7d-c2e75e566caa	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho chè đậu phiên bản 016, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	19	\N
b175e3fb-5e61-4057-be34-eadd8ca85113	2026-09-22 16:40:27.935108+00	\N	f	1	faf4d8d6-f61e-4245-ac7d-c2e75e566caa	2	Sơ chế	Sơ chế cho chè đậu phiên bản 016, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	13	\N
819f16d5-dae4-4494-8342-d51918115d84	2026-09-22 16:40:27.935108+00	\N	f	1	faf4d8d6-f61e-4245-ac7d-c2e75e566caa	3	Ướp gia vị	Ướp gia vị cho chè đậu phiên bản 016, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	18	\N
96bc29d1-24f0-4eec-b0e2-1f0e0824efdc	2026-09-22 16:40:27.935108+00	\N	f	1	faf4d8d6-f61e-4245-ac7d-c2e75e566caa	4	Làm nóng chảo	Làm nóng chảo cho chè đậu phiên bản 016, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	13	\N
d952bd39-f635-43f8-9142-50275e5d57be	2026-09-22 16:40:27.935108+00	\N	f	1	faf4d8d6-f61e-4245-ac7d-c2e75e566caa	5	Chế biến phần chính	Chế biến phần chính cho chè đậu phiên bản 016, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	6	\N
0245cf63-61d1-421a-ba4e-11dfa8759490	2026-09-22 16:40:27.935108+00	\N	f	1	faf4d8d6-f61e-4245-ac7d-c2e75e566caa	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho chè đậu phiên bản 016, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	13	\N
c8014ff7-c5cd-42ff-8b33-0674d14f8f77	2026-09-22 16:40:27.935108+00	\N	f	1	d158485e-362a-424a-97e5-09b0c64ef412	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho bánh mì trứng phiên bản 017, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	14	\N
bde390d4-6df3-4f3e-bbfc-ae306c938e4b	2026-09-22 16:40:27.935108+00	\N	f	1	d158485e-362a-424a-97e5-09b0c64ef412	2	Sơ chế	Sơ chế cho bánh mì trứng phiên bản 017, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	17	\N
62703fb6-7624-4f29-8896-8ac3136cad7a	2026-09-22 16:40:27.935108+00	\N	f	1	d158485e-362a-424a-97e5-09b0c64ef412	3	Ướp gia vị	Ướp gia vị cho bánh mì trứng phiên bản 017, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	13	\N
ed60cb06-c649-4d78-b8ef-f2362c8f4f77	2026-09-22 16:40:27.935108+00	\N	f	1	d158485e-362a-424a-97e5-09b0c64ef412	4	Làm nóng chảo	Làm nóng chảo cho bánh mì trứng phiên bản 017, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	9	\N
17957f4d-d64c-4b99-a8d6-342b49ec76e2	2026-09-22 16:40:27.935108+00	\N	f	1	d158485e-362a-424a-97e5-09b0c64ef412	5	Chế biến phần chính	Chế biến phần chính cho bánh mì trứng phiên bản 017, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	6	\N
4e2a16c5-81e4-4523-af61-78cc4cfc0eb3	2026-09-22 16:40:27.935108+00	\N	f	1	d158485e-362a-424a-97e5-09b0c64ef412	6	Nêm nếm	Nêm nếm cho bánh mì trứng phiên bản 017, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	7	\N
0370966f-5f3d-40ae-9229-1e9ff1e506da	2026-09-22 16:40:27.935108+00	\N	f	1	d158485e-362a-424a-97e5-09b0c64ef412	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho bánh mì trứng phiên bản 017, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	9	\N
273cb05c-6027-424b-a057-6beb85618e7e	2026-09-22 16:40:27.935108+00	\N	f	1	4282d768-5d60-4c3b-bb2a-022ef252b7fe	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho gỏi cuốn phiên bản 018, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	14	\N
fe00800a-907a-46de-8841-04824ed7c436	2026-09-22 16:40:27.935108+00	\N	f	1	4282d768-5d60-4c3b-bb2a-022ef252b7fe	2	Sơ chế	Sơ chế cho gỏi cuốn phiên bản 018, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	8	\N
d688b544-2d60-4728-9efe-a209d1c4aef3	2026-09-22 16:40:27.935108+00	\N	f	1	4282d768-5d60-4c3b-bb2a-022ef252b7fe	3	Ướp gia vị	Ướp gia vị cho gỏi cuốn phiên bản 018, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	14	\N
d1c29106-c2db-40a5-9075-9be8c9e5a139	2026-09-22 16:40:27.935108+00	\N	f	1	4282d768-5d60-4c3b-bb2a-022ef252b7fe	4	Làm nóng chảo	Làm nóng chảo cho gỏi cuốn phiên bản 018, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	18	\N
e00958e6-cfab-4d21-bb81-293093de72fc	2026-09-22 16:40:27.935108+00	\N	f	1	4282d768-5d60-4c3b-bb2a-022ef252b7fe	5	Chế biến phần chính	Chế biến phần chính cho gỏi cuốn phiên bản 018, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	8	\N
31303ad8-d7dc-458c-84c9-6ae32beb505f	2026-09-22 16:40:27.935108+00	\N	f	1	4282d768-5d60-4c3b-bb2a-022ef252b7fe	6	Nêm nếm	Nêm nếm cho gỏi cuốn phiên bản 018, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	12	\N
40a4ce13-35fb-4497-bcf7-f46f231226ea	2026-09-22 16:40:27.935108+00	\N	f	1	4282d768-5d60-4c3b-bb2a-022ef252b7fe	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho gỏi cuốn phiên bản 018, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	14	\N
f8196f49-89b2-4071-8b7a-0b910aea147e	2026-09-22 16:40:27.935108+00	\N	f	1	25dc4e45-c780-4f24-bf7f-30f10f1c8cfe	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho lẩu rau phiên bản 019, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	8	\N
51782aa8-14b0-43c6-8569-55564118ecd7	2026-09-22 16:40:27.935108+00	\N	f	1	25dc4e45-c780-4f24-bf7f-30f10f1c8cfe	2	Sơ chế	Sơ chế cho lẩu rau phiên bản 019, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	20	\N
56f38d71-6ddb-4e81-9167-21d78bfc35c8	2026-09-22 16:40:27.935108+00	\N	f	1	25dc4e45-c780-4f24-bf7f-30f10f1c8cfe	3	Ướp gia vị	Ướp gia vị cho lẩu rau phiên bản 019, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	12	\N
d2d964a0-4a41-4aad-8ef1-18ab93fa9b9f	2026-09-22 16:40:27.935108+00	\N	f	1	25dc4e45-c780-4f24-bf7f-30f10f1c8cfe	4	Làm nóng chảo	Làm nóng chảo cho lẩu rau phiên bản 019, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	9	\N
eed0b30d-36af-4d98-a8c4-59de682b897f	2026-09-22 16:40:27.935108+00	\N	f	1	25dc4e45-c780-4f24-bf7f-30f10f1c8cfe	5	Chế biến phần chính	Chế biến phần chính cho lẩu rau phiên bản 019, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	18	\N
4bee7dbb-0b91-4dee-a6bc-58ad0107b047	2026-09-22 16:40:27.935108+00	\N	f	1	65dde4a2-ae27-4dfe-ba8d-0d8acf6d615e	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho xôi gấc phiên bản 020, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	19	\N
7709a6d6-87a9-48ae-82cc-cc8ffc939cc8	2026-09-22 16:40:27.935108+00	\N	f	1	65dde4a2-ae27-4dfe-ba8d-0d8acf6d615e	2	Sơ chế	Sơ chế cho xôi gấc phiên bản 020, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	19	\N
76e12139-ede2-420a-bfad-1726d37226a9	2026-09-22 16:40:27.935108+00	\N	f	1	65dde4a2-ae27-4dfe-ba8d-0d8acf6d615e	3	Ướp gia vị	Ướp gia vị cho xôi gấc phiên bản 020, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	14	\N
b6567058-3288-4121-a96a-4eb273728cd0	2026-09-22 16:40:27.935108+00	\N	f	1	65dde4a2-ae27-4dfe-ba8d-0d8acf6d615e	4	Làm nóng chảo	Làm nóng chảo cho xôi gấc phiên bản 020, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	15	\N
15f6b51c-b039-48c6-b746-322cfa3a55b4	2026-09-22 16:40:27.935108+00	\N	f	1	65dde4a2-ae27-4dfe-ba8d-0d8acf6d615e	5	Chế biến phần chính	Chế biến phần chính cho xôi gấc phiên bản 020, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	8	\N
fea39cf5-8ea2-4818-86f7-1d90acaa245e	2026-09-22 16:40:27.935108+00	\N	f	1	65dde4a2-ae27-4dfe-ba8d-0d8acf6d615e	6	Nêm nếm	Nêm nếm cho xôi gấc phiên bản 020, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	19	\N
ab2548a2-53b3-473d-99fa-9f8b96a9d68b	2026-09-22 16:40:27.935108+00	\N	f	1	65dde4a2-ae27-4dfe-ba8d-0d8acf6d615e	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho xôi gấc phiên bản 020, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	12	\N
94a09be4-1ac9-4ce8-9c7c-4536c1f086f4	2026-09-22 16:40:27.935108+00	\N	f	1	bddd9f3d-8139-420a-aecc-70be4d87d38d	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho cơm gà phiên bản 021, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	20	\N
377d3271-aaee-46d0-aa59-f2bfe401dabd	2026-09-22 16:40:27.935108+00	\N	f	1	bddd9f3d-8139-420a-aecc-70be4d87d38d	2	Sơ chế	Sơ chế cho cơm gà phiên bản 021, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	20	\N
e4eef65d-3226-4e59-a0ca-8334163fe22d	2026-09-22 16:40:27.935108+00	\N	f	1	bddd9f3d-8139-420a-aecc-70be4d87d38d	3	Ướp gia vị	Ướp gia vị cho cơm gà phiên bản 021, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	19	\N
80701f0e-4993-4766-b217-40c779aae09e	2026-09-22 16:40:27.935108+00	\N	f	1	bddd9f3d-8139-420a-aecc-70be4d87d38d	4	Làm nóng chảo	Làm nóng chảo cho cơm gà phiên bản 021, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	20	\N
852e14c4-6734-4ced-87f9-f24a8a19b5e6	2026-09-22 16:40:27.935108+00	\N	f	1	bddd9f3d-8139-420a-aecc-70be4d87d38d	5	Chế biến phần chính	Chế biến phần chính cho cơm gà phiên bản 021, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.	18	\N
1c10e7a5-739b-471f-8394-d18166baf36f	2026-09-22 16:40:27.935108+00	\N	f	1	bddd9f3d-8139-420a-aecc-70be4d87d38d	6	Nêm nếm	Nêm nếm cho cơm gà phiên bản 021, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	8	\N
0954e8e6-4a7c-41a9-a0dc-27915765571c	2026-09-22 16:40:27.935108+00	\N	f	1	32b68618-1ac3-4b3c-95fb-6fb93ef0fa5b	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho bún bò phiên bản 022, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	14	\N
253275af-3914-4e8b-a3df-9d7fe497976d	2026-09-22 16:40:27.935108+00	\N	f	1	32b68618-1ac3-4b3c-95fb-6fb93ef0fa5b	2	Sơ chế	Sơ chế cho bún bò phiên bản 022, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	20	\N
0c53374d-2bbd-4dbd-bd81-9ea48e8f984c	2026-09-22 16:40:27.935108+00	\N	f	1	32b68618-1ac3-4b3c-95fb-6fb93ef0fa5b	3	Ướp gia vị	Ướp gia vị cho bún bò phiên bản 022, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	20	\N
ac66e95d-2467-4aa2-a9ae-2e7946f0a18b	2026-09-22 16:40:27.935108+00	\N	f	1	32b68618-1ac3-4b3c-95fb-6fb93ef0fa5b	4	Làm nóng chảo	Làm nóng chảo cho bún bò phiên bản 022, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	14	\N
93aabf9e-7e32-4d8b-875b-3662d99e84be	2026-09-22 16:40:27.935108+00	\N	f	1	32b68618-1ac3-4b3c-95fb-6fb93ef0fa5b	5	Chế biến phần chính	Chế biến phần chính cho bún bò phiên bản 022, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	19	\N
5e24a735-1c55-4abe-98db-0dce7764e19b	2026-09-22 16:40:27.935108+00	\N	f	1	32b68618-1ac3-4b3c-95fb-6fb93ef0fa5b	6	Nêm nếm	Nêm nếm cho bún bò phiên bản 022, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	20	\N
fd7fcd45-d4c3-4439-a7b7-14b04b33d1cc	2026-09-22 16:40:27.935108+00	\N	f	1	32b68618-1ac3-4b3c-95fb-6fb93ef0fa5b	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho bún bò phiên bản 022, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	16	\N
0d390d91-9f7b-4c8f-9963-cded728fb114	2026-09-22 16:40:27.935108+00	\N	f	1	420a4583-b573-4ae5-9323-c9e6d990fdcd	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho mì rau củ phiên bản 023, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	16	\N
d0ec7588-7c4e-450e-8833-e406969f0a8d	2026-09-22 16:40:27.935108+00	\N	f	1	420a4583-b573-4ae5-9323-c9e6d990fdcd	2	Sơ chế	Sơ chế cho mì rau củ phiên bản 023, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	15	\N
5021de88-ae03-4fa4-82d9-c0a0bbb76f8c	2026-09-22 16:40:27.935108+00	\N	f	1	420a4583-b573-4ae5-9323-c9e6d990fdcd	3	Ướp gia vị	Ướp gia vị cho mì rau củ phiên bản 023, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	6	\N
0a67e167-360c-474d-90c6-e8eda5f4d6ed	2026-09-22 16:40:27.935108+00	\N	f	1	420a4583-b573-4ae5-9323-c9e6d990fdcd	4	Làm nóng chảo	Làm nóng chảo cho mì rau củ phiên bản 023, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	10	\N
565bd990-975b-4efa-bb05-044a09f6be4f	2026-09-22 16:40:27.935108+00	\N	f	1	420a4583-b573-4ae5-9323-c9e6d990fdcd	5	Chế biến phần chính	Chế biến phần chính cho mì rau củ phiên bản 023, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	10	\N
7a33ec74-1c81-40d8-8f2f-25f392130851	2026-09-22 16:40:27.935108+00	\N	f	1	420a4583-b573-4ae5-9323-c9e6d990fdcd	6	Nêm nếm	Nêm nếm cho mì rau củ phiên bản 023, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	19	\N
396413f4-772d-45a5-9b83-0d76b41a497b	2026-09-22 16:40:27.935108+00	\N	f	1	420a4583-b573-4ae5-9323-c9e6d990fdcd	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho mì rau củ phiên bản 023, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	5	\N
32ee9683-054e-4c7b-8e5b-c5a7e8646e16	2026-09-22 16:40:27.935108+00	\N	f	1	38804e6d-578b-4e82-9cdb-94d6589cd8bc	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho đậu hũ sốt phiên bản 024, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	16	\N
6b6db919-6d80-438e-9014-59258953f57a	2026-09-22 16:40:27.935108+00	\N	f	1	38804e6d-578b-4e82-9cdb-94d6589cd8bc	2	Sơ chế	Sơ chế cho đậu hũ sốt phiên bản 024, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.	7	\N
32ebff6d-a33e-416c-85fc-5e4fc632be68	2026-09-22 16:40:27.935108+00	\N	f	1	38804e6d-578b-4e82-9cdb-94d6589cd8bc	3	Ướp gia vị	Ướp gia vị cho đậu hũ sốt phiên bản 024, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	19	\N
427c74ad-0dde-482f-bda8-1f7226969a67	2026-09-22 16:40:27.935108+00	\N	f	1	38804e6d-578b-4e82-9cdb-94d6589cd8bc	4	Làm nóng chảo	Làm nóng chảo cho đậu hũ sốt phiên bản 024, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	19	\N
7e5eebdc-4d8b-46c9-b7ca-b94cc21ab51b	2026-09-22 16:40:27.935108+00	\N	f	1	38804e6d-578b-4e82-9cdb-94d6589cd8bc	5	Chế biến phần chính	Chế biến phần chính cho đậu hũ sốt phiên bản 024, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	16	\N
2c7dca29-c225-411b-b942-167c67621729	2026-09-22 16:40:27.935108+00	\N	f	1	38804e6d-578b-4e82-9cdb-94d6589cd8bc	6	Nêm nếm	Nêm nếm cho đậu hũ sốt phiên bản 024, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	20	\N
7b1b5e15-4a6f-4c76-8632-6761f48c9778	2026-09-22 16:40:27.935108+00	\N	f	1	38804e6d-578b-4e82-9cdb-94d6589cd8bc	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho đậu hũ sốt phiên bản 024, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	10	\N
edbfca87-462e-4583-ba0b-64d1f771869b	2026-09-22 16:40:27.935108+00	\N	f	1	02c695ba-3c71-4ca4-bf1f-305be744eba2	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho cá nướng phiên bản 025, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.	15	\N
9bc1ea55-5001-441d-a769-77145d873a96	2026-09-22 16:40:27.935108+00	\N	f	1	02c695ba-3c71-4ca4-bf1f-305be744eba2	2	Sơ chế	Sơ chế cho cá nướng phiên bản 025, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	12	\N
869bbeac-3647-4461-8143-1378451bdfa7	2026-09-22 16:40:27.935108+00	\N	f	1	02c695ba-3c71-4ca4-bf1f-305be744eba2	3	Ướp gia vị	Ướp gia vị cho cá nướng phiên bản 025, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	17	\N
ab47dd35-fcb1-4b5a-967c-122515add629	2026-09-22 16:40:27.935108+00	\N	f	1	02c695ba-3c71-4ca4-bf1f-305be744eba2	4	Làm nóng chảo	Làm nóng chảo cho cá nướng phiên bản 025, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	18	\N
4d624c75-81b4-48f4-929a-3ac107bbca82	2026-09-22 16:40:27.935108+00	\N	f	1	02c695ba-3c71-4ca4-bf1f-305be744eba2	5	Chế biến phần chính	Chế biến phần chính cho cá nướng phiên bản 025, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	19	\N
23657f99-822b-4123-bc16-cd3749c2e166	2026-09-22 16:40:27.935108+00	\N	f	1	4311dbd4-6e85-453a-a8cf-3c412f8e3ce0	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho gà hấp phiên bản 026, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	7	\N
3d7086bf-d2d5-4e65-8b15-3b26e14c148e	2026-09-22 16:40:27.935108+00	\N	f	1	4311dbd4-6e85-453a-a8cf-3c412f8e3ce0	2	Sơ chế	Sơ chế cho gà hấp phiên bản 026, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	12	\N
15c1c536-95f6-4b01-93d8-a88426668b87	2026-09-22 16:40:27.935108+00	\N	f	1	4311dbd4-6e85-453a-a8cf-3c412f8e3ce0	3	Ướp gia vị	Ướp gia vị cho gà hấp phiên bản 026, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	20	\N
2abbe566-b339-4e54-80a4-94c8c269b299	2026-09-22 16:40:27.935108+00	\N	f	1	4311dbd4-6e85-453a-a8cf-3c412f8e3ce0	4	Làm nóng chảo	Làm nóng chảo cho gà hấp phiên bản 026, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	8	\N
ab28a903-fc1d-4eff-9785-14ab8ca0e72d	2026-09-22 16:40:27.935108+00	\N	f	1	4311dbd4-6e85-453a-a8cf-3c412f8e3ce0	5	Chế biến phần chính	Chế biến phần chính cho gà hấp phiên bản 026, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	17	\N
c50db2c0-9044-4dde-a721-5fa9947c2497	2026-09-22 16:40:27.935108+00	\N	f	1	4311dbd4-6e85-453a-a8cf-3c412f8e3ce0	6	Nêm nếm	Nêm nếm cho gà hấp phiên bản 026, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	6	\N
23821f63-dc7b-4195-8ab4-14180fc63518	2026-09-22 16:40:27.935108+00	\N	f	1	d242f842-9539-4034-8f4f-c021704e5abb	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho thịt xào phiên bản 027, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	9	\N
3cc375ef-6a89-4f55-8805-ea87fc4f3b09	2026-09-22 16:40:27.935108+00	\N	f	1	d242f842-9539-4034-8f4f-c021704e5abb	2	Sơ chế	Sơ chế cho thịt xào phiên bản 027, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	7	\N
9bf6fd8a-3e4b-4f2e-9aa3-9dbc653c0137	2026-09-22 16:40:27.935108+00	\N	f	1	d242f842-9539-4034-8f4f-c021704e5abb	3	Ướp gia vị	Ướp gia vị cho thịt xào phiên bản 027, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	16	\N
09a9cd3f-1d28-418e-8e88-32cbd4e14be8	2026-09-22 16:40:27.935108+00	\N	f	1	d242f842-9539-4034-8f4f-c021704e5abb	4	Làm nóng chảo	Làm nóng chảo cho thịt xào phiên bản 027, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	14	\N
caeb19a0-2dd6-4564-aa14-ae2c99e4d48b	2026-09-22 16:40:27.935108+00	\N	f	1	d242f842-9539-4034-8f4f-c021704e5abb	5	Chế biến phần chính	Chế biến phần chính cho thịt xào phiên bản 027, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	16	\N
35195670-f3e9-43ba-922b-c2b27a9e273e	2026-09-22 16:40:27.935108+00	\N	f	1	d242f842-9539-4034-8f4f-c021704e5abb	6	Nêm nếm	Nêm nếm cho thịt xào phiên bản 027, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	5	\N
7b68e51f-c8d6-4cc8-9800-f4cbfb6d401d	2026-09-22 16:40:27.935108+00	\N	f	1	bb91ff4a-ebdc-4aba-90f0-aa1f32b7bcde	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho tôm chiên phiên bản 028, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	12	\N
001adea9-2153-491b-823a-72b62e136582	2026-09-22 16:40:27.935108+00	\N	f	1	bb91ff4a-ebdc-4aba-90f0-aa1f32b7bcde	2	Sơ chế	Sơ chế cho tôm chiên phiên bản 028, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	14	\N
d81e4e49-8fa3-473a-9a37-98be6ec3c738	2026-09-22 16:40:27.935108+00	\N	f	1	bb91ff4a-ebdc-4aba-90f0-aa1f32b7bcde	3	Ướp gia vị	Ướp gia vị cho tôm chiên phiên bản 028, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	12	\N
d4869115-5d10-4871-806c-34f7a5aa147f	2026-09-22 16:40:27.935108+00	\N	f	1	bb91ff4a-ebdc-4aba-90f0-aa1f32b7bcde	4	Làm nóng chảo	Làm nóng chảo cho tôm chiên phiên bản 028, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	6	\N
a4a36ea1-d0cd-4e36-b186-87d1327c04d1	2026-09-22 16:40:27.935108+00	\N	f	1	bb91ff4a-ebdc-4aba-90f0-aa1f32b7bcde	5	Chế biến phần chính	Chế biến phần chính cho tôm chiên phiên bản 028, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	16	\N
d4d72cc2-d73c-45ea-a5a6-a034282232ea	2026-09-22 16:40:27.935108+00	\N	f	1	bb91ff4a-ebdc-4aba-90f0-aa1f32b7bcde	6	Nêm nếm	Nêm nếm cho tôm chiên phiên bản 028, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	9	\N
24ab6ed9-bc1f-45f3-8ed9-2d8786236d41	2026-09-22 16:40:27.935108+00	\N	f	1	88fa97ba-ecba-4c7e-8ea4-064022350579	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho cá kho phiên bản 029, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	10	\N
328ce11f-928b-4645-bbf2-45543f53d9b2	2026-09-22 16:40:27.935108+00	\N	f	1	88fa97ba-ecba-4c7e-8ea4-064022350579	2	Sơ chế	Sơ chế cho cá kho phiên bản 029, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	20	\N
601d4048-438f-4cf0-95a1-0e42b5f986db	2026-09-22 16:40:27.935108+00	\N	f	1	88fa97ba-ecba-4c7e-8ea4-064022350579	3	Ướp gia vị	Ướp gia vị cho cá kho phiên bản 029, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	5	\N
b5fab755-0f94-443d-a48d-ae4c7a50680c	2026-09-22 16:40:27.935108+00	\N	f	1	88fa97ba-ecba-4c7e-8ea4-064022350579	4	Làm nóng chảo	Làm nóng chảo cho cá kho phiên bản 029, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	6	\N
182ac5b1-3a0f-48f1-b590-c883dc3f47f7	2026-09-22 16:40:27.935108+00	\N	f	1	88fa97ba-ecba-4c7e-8ea4-064022350579	5	Chế biến phần chính	Chế biến phần chính cho cá kho phiên bản 029, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.	19	\N
78a4f0c2-2ed1-4ea4-8121-73808a24cc36	2026-09-22 16:40:27.935108+00	\N	f	1	6e5dc0c4-9ebd-4c6f-9b12-a6a866a6fd2d	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho canh bí phiên bản 030, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	9	\N
c7951c1c-739a-4017-8478-c086ebae75f5	2026-09-22 16:40:27.935108+00	\N	f	1	6e5dc0c4-9ebd-4c6f-9b12-a6a866a6fd2d	2	Sơ chế	Sơ chế cho canh bí phiên bản 030, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	14	\N
f25e6a9c-7607-4c69-8e47-f97189939724	2026-09-22 16:40:27.935108+00	\N	f	1	6e5dc0c4-9ebd-4c6f-9b12-a6a866a6fd2d	3	Ướp gia vị	Ướp gia vị cho canh bí phiên bản 030, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	8	\N
21217305-6266-4801-8904-db1c49a9fa79	2026-09-22 16:40:27.935108+00	\N	f	1	6e5dc0c4-9ebd-4c6f-9b12-a6a866a6fd2d	4	Làm nóng chảo	Làm nóng chảo cho canh bí phiên bản 030, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	20	\N
137292f5-653f-4601-a170-5c7f7e01388e	2026-09-22 16:40:27.935108+00	\N	f	1	6e5dc0c4-9ebd-4c6f-9b12-a6a866a6fd2d	5	Chế biến phần chính	Chế biến phần chính cho canh bí phiên bản 030, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	10	\N
519fb11b-a5ac-4658-86aa-4b5437952441	2026-09-22 16:40:27.935108+00	\N	f	1	6e5dc0c4-9ebd-4c6f-9b12-a6a866a6fd2d	6	Nêm nếm	Nêm nếm cho canh bí phiên bản 030, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	20	\N
a840b9c2-a742-45de-804e-74ff5026a679	2026-09-22 16:40:27.935108+00	\N	f	1	aa6fb2ef-abf8-403f-aa8e-426b37f45c7c	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho súp nấm phiên bản 031, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	14	\N
bae15a1a-4044-4718-9421-1d5063b66735	2026-09-22 16:40:27.935108+00	\N	f	1	aa6fb2ef-abf8-403f-aa8e-426b37f45c7c	2	Sơ chế	Sơ chế cho súp nấm phiên bản 031, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	16	\N
ce15327f-80c0-46fe-b723-e83f509fcb1b	2026-09-22 16:40:27.935108+00	\N	f	1	aa6fb2ef-abf8-403f-aa8e-426b37f45c7c	3	Ướp gia vị	Ướp gia vị cho súp nấm phiên bản 031, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	11	\N
2c574f43-31de-468f-8dc4-f2f4c6aff77a	2026-09-22 16:40:27.935108+00	\N	f	1	aa6fb2ef-abf8-403f-aa8e-426b37f45c7c	4	Làm nóng chảo	Làm nóng chảo cho súp nấm phiên bản 031, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	18	\N
6c87d7f8-ee4b-4aac-b8de-47205bee4340	2026-09-22 16:40:27.935108+00	\N	f	1	aa6fb2ef-abf8-403f-aa8e-426b37f45c7c	5	Chế biến phần chính	Chế biến phần chính cho súp nấm phiên bản 031, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	9	\N
bbfad586-25dc-4797-84ee-6fd7551d4328	2026-09-22 16:40:27.935108+00	\N	f	1	aa6fb2ef-abf8-403f-aa8e-426b37f45c7c	6	Nêm nếm	Nêm nếm cho súp nấm phiên bản 031, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	13	\N
47e231fa-4ffb-4d93-bd28-6710a35ad5b3	2026-09-22 16:40:27.935108+00	\N	f	1	40da8dea-a2d9-49d0-b54c-ed06024f7f9c	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho cơm rang phiên bản 032, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	14	\N
b11fa94e-d302-4a07-8101-7e69919c6266	2026-09-22 16:40:27.935108+00	\N	f	1	40da8dea-a2d9-49d0-b54c-ed06024f7f9c	2	Sơ chế	Sơ chế cho cơm rang phiên bản 032, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	10	\N
1e57b753-e3d9-4f7e-a690-acd3161ddd7d	2026-09-22 16:40:27.935108+00	\N	f	1	40da8dea-a2d9-49d0-b54c-ed06024f7f9c	3	Ướp gia vị	Ướp gia vị cho cơm rang phiên bản 032, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.	13	\N
83fd1d8f-fa30-4e9b-aa75-43a5ee2ba973	2026-09-22 16:40:27.935108+00	\N	f	1	40da8dea-a2d9-49d0-b54c-ed06024f7f9c	4	Làm nóng chảo	Làm nóng chảo cho cơm rang phiên bản 032, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	7	\N
778e00ee-4f18-4968-a843-702f591d012c	2026-09-22 16:40:27.935108+00	\N	f	1	40da8dea-a2d9-49d0-b54c-ed06024f7f9c	5	Chế biến phần chính	Chế biến phần chính cho cơm rang phiên bản 032, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	17	\N
56c7c3e3-d8d7-48cd-96f3-75101f09a68e	2026-09-22 16:40:27.935108+00	\N	f	1	40da8dea-a2d9-49d0-b54c-ed06024f7f9c	6	Nêm nếm	Nêm nếm cho cơm rang phiên bản 032, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	9	\N
355fc4b4-9c49-4833-99d0-9394423f2e19	2026-09-22 16:40:27.935108+00	\N	f	1	40da8dea-a2d9-49d0-b54c-ed06024f7f9c	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho cơm rang phiên bản 032, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	14	\N
d885b60b-7386-4bb5-81db-1bf56b334b69	2026-09-22 16:40:27.935108+00	\N	f	1	644080d9-bb15-4924-942f-11382b57b7d2	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho mì xào phiên bản 033, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	12	\N
b1c3dcc1-5912-4ec1-9fe5-033fbd92fb69	2026-09-22 16:40:27.935108+00	\N	f	1	644080d9-bb15-4924-942f-11382b57b7d2	2	Sơ chế	Sơ chế cho mì xào phiên bản 033, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	16	\N
844a9006-62ff-4b89-b33e-d31e1462b176	2026-09-22 16:40:27.935108+00	\N	f	1	644080d9-bb15-4924-942f-11382b57b7d2	3	Ướp gia vị	Ướp gia vị cho mì xào phiên bản 033, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	15	\N
e1bbdea5-d382-4b31-8b07-ec82699dbe12	2026-09-22 16:40:27.935108+00	\N	f	1	644080d9-bb15-4924-942f-11382b57b7d2	4	Làm nóng chảo	Làm nóng chảo cho mì xào phiên bản 033, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	16	\N
e2d6be9c-748c-4c79-8df8-5b1ff2f8d12c	2026-09-22 16:40:27.935108+00	\N	f	1	644080d9-bb15-4924-942f-11382b57b7d2	5	Chế biến phần chính	Chế biến phần chính cho mì xào phiên bản 033, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	17	\N
99dd7b73-ae1e-449d-8222-d14c214b463f	2026-09-22 16:40:27.935108+00	\N	f	1	644080d9-bb15-4924-942f-11382b57b7d2	6	Nêm nếm	Nêm nếm cho mì xào phiên bản 033, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	5	\N
19f9762e-6f19-46d9-9426-d0ab6f8daed7	2026-09-22 16:40:27.935108+00	\N	f	1	644080d9-bb15-4924-942f-11382b57b7d2	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho mì xào phiên bản 033, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	20	\N
afb7871e-759a-43a0-962f-36b6c2eb15d2	2026-09-22 16:40:27.935108+00	\N	f	1	b66fb87b-4e6b-43d2-ad8f-5dbc6cab2cef	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho bún thịt phiên bản 034, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	12	\N
0a8cc509-28ac-4a25-9ee6-91ee387fb5af	2026-09-22 16:40:27.935108+00	\N	f	1	b66fb87b-4e6b-43d2-ad8f-5dbc6cab2cef	2	Sơ chế	Sơ chế cho bún thịt phiên bản 034, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	6	\N
b525313d-db6d-4101-af3e-24edb4459e25	2026-09-22 16:40:27.935108+00	\N	f	1	b66fb87b-4e6b-43d2-ad8f-5dbc6cab2cef	3	Ướp gia vị	Ướp gia vị cho bún thịt phiên bản 034, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	13	\N
a8519c96-48db-4413-aee9-4a9edd267fbf	2026-09-22 16:40:27.935108+00	\N	f	1	b66fb87b-4e6b-43d2-ad8f-5dbc6cab2cef	4	Làm nóng chảo	Làm nóng chảo cho bún thịt phiên bản 034, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	6	\N
dbc2e9a3-077e-4610-a393-e38b7cf033c5	2026-09-22 16:40:27.935108+00	\N	f	1	b66fb87b-4e6b-43d2-ad8f-5dbc6cab2cef	5	Chế biến phần chính	Chế biến phần chính cho bún thịt phiên bản 034, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	8	\N
b90d4008-690a-458d-abdc-c00d0836a6c6	2026-09-22 16:40:27.935108+00	\N	f	1	664c65ce-22e6-4391-a9ba-61d862f98ff8	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho bánh khoai phiên bản 035, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	12	\N
f85487cc-9f22-49a4-b4be-bae991011075	2026-09-22 16:40:27.935108+00	\N	f	1	664c65ce-22e6-4391-a9ba-61d862f98ff8	2	Sơ chế	Sơ chế cho bánh khoai phiên bản 035, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	5	\N
87c21119-c52a-461e-91a4-443962ec64b8	2026-09-22 16:40:27.935108+00	\N	f	1	664c65ce-22e6-4391-a9ba-61d862f98ff8	3	Ướp gia vị	Ướp gia vị cho bánh khoai phiên bản 035, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	19	\N
cbf5b9a9-4084-4546-976e-397e319af449	2026-09-22 16:40:27.935108+00	\N	f	1	664c65ce-22e6-4391-a9ba-61d862f98ff8	4	Làm nóng chảo	Làm nóng chảo cho bánh khoai phiên bản 035, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	15	\N
c72a09e2-1853-49f4-abad-9e04520dd833	2026-09-22 16:40:27.935108+00	\N	f	1	664c65ce-22e6-4391-a9ba-61d862f98ff8	5	Chế biến phần chính	Chế biến phần chính cho bánh khoai phiên bản 035, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	20	\N
5ec4cf7d-5bb9-4af8-983a-886acaf95293	2026-09-22 16:40:27.935108+00	\N	f	1	664c65ce-22e6-4391-a9ba-61d862f98ff8	6	Nêm nếm	Nêm nếm cho bánh khoai phiên bản 035, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	8	\N
968fa767-f230-4d3b-83c0-85911514ad81	2026-09-22 16:40:27.935108+00	\N	f	1	664c65ce-22e6-4391-a9ba-61d862f98ff8	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho bánh khoai phiên bản 035, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	20	\N
b071fa06-7237-4480-b406-3d1bdc84df28	2026-09-22 16:40:27.935108+00	\N	f	1	3b0774bd-aa26-49e3-bff4-1ebaaca8f01c	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho chè đậu phiên bản 036, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	13	\N
ddba16f4-f5d3-47a8-85f0-c5e0a870e5ba	2026-09-22 16:40:27.935108+00	\N	f	1	3b0774bd-aa26-49e3-bff4-1ebaaca8f01c	2	Sơ chế	Sơ chế cho chè đậu phiên bản 036, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	15	\N
eca2b725-2fdd-4b1d-815a-fe7a506f27c1	2026-09-22 16:40:27.935108+00	\N	f	1	3b0774bd-aa26-49e3-bff4-1ebaaca8f01c	3	Ướp gia vị	Ướp gia vị cho chè đậu phiên bản 036, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	17	\N
57295c25-7a4b-43e1-8b13-2877b0f20b26	2026-09-22 16:40:27.935108+00	\N	f	1	3b0774bd-aa26-49e3-bff4-1ebaaca8f01c	4	Làm nóng chảo	Làm nóng chảo cho chè đậu phiên bản 036, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	18	\N
2a12afa1-1c05-49b5-9095-9047643aeb25	2026-09-22 16:40:27.935108+00	\N	f	1	3b0774bd-aa26-49e3-bff4-1ebaaca8f01c	5	Chế biến phần chính	Chế biến phần chính cho chè đậu phiên bản 036, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	19	\N
c822b543-45ca-4609-9339-648a578f67be	2026-09-22 16:40:27.935108+00	\N	f	1	3b0774bd-aa26-49e3-bff4-1ebaaca8f01c	6	Nêm nếm	Nêm nếm cho chè đậu phiên bản 036, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	17	\N
a2382659-5907-4f3d-b4bc-81d00772adb4	2026-09-22 16:40:27.935108+00	\N	f	1	f38b31dd-0ed1-405f-84fd-de5aafe547e7	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho bánh mì trứng phiên bản 037, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	14	\N
fd1e0cc8-c287-42a6-9ce7-d3c20af51b06	2026-09-22 16:40:27.935108+00	\N	f	1	f38b31dd-0ed1-405f-84fd-de5aafe547e7	2	Sơ chế	Sơ chế cho bánh mì trứng phiên bản 037, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	16	\N
6a259532-0484-4023-96b8-fdcc07aab233	2026-09-22 16:40:27.935108+00	\N	f	1	f38b31dd-0ed1-405f-84fd-de5aafe547e7	3	Ướp gia vị	Ướp gia vị cho bánh mì trứng phiên bản 037, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	19	\N
9ea65d3e-9374-451c-af3c-42d861451996	2026-09-22 16:40:27.935108+00	\N	f	1	f38b31dd-0ed1-405f-84fd-de5aafe547e7	4	Làm nóng chảo	Làm nóng chảo cho bánh mì trứng phiên bản 037, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	14	\N
5f3792ec-07ef-4ed5-8cf7-39b05d7b6057	2026-09-22 16:40:27.935108+00	\N	f	1	f38b31dd-0ed1-405f-84fd-de5aafe547e7	5	Chế biến phần chính	Chế biến phần chính cho bánh mì trứng phiên bản 037, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.	9	\N
f04037bc-6ed5-45d1-ac81-3d5cc7c2e151	2026-09-22 16:40:27.935108+00	\N	f	1	f38b31dd-0ed1-405f-84fd-de5aafe547e7	6	Nêm nếm	Nêm nếm cho bánh mì trứng phiên bản 037, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	13	\N
4bd38bbb-7396-4ebc-abfb-79fbfed72704	2026-09-22 16:40:27.935108+00	\N	f	1	f38b31dd-0ed1-405f-84fd-de5aafe547e7	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho bánh mì trứng phiên bản 037, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	10	\N
c7235c34-337f-4b8d-9b37-7d1a3536f8be	2026-09-22 16:40:27.935108+00	\N	f	1	ab32138f-bda8-4ae3-a101-c5e9ac792092	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho gỏi cuốn phiên bản 038, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	19	\N
91aee561-fa09-49f7-aa95-731f08cf50ba	2026-09-22 16:40:27.935108+00	\N	f	1	ab32138f-bda8-4ae3-a101-c5e9ac792092	2	Sơ chế	Sơ chế cho gỏi cuốn phiên bản 038, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.	14	\N
246efe44-fee1-4896-a755-5389eea1db1d	2026-09-22 16:40:27.935108+00	\N	f	1	ab32138f-bda8-4ae3-a101-c5e9ac792092	3	Ướp gia vị	Ướp gia vị cho gỏi cuốn phiên bản 038, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	19	\N
fa6575fe-a3d3-4a2a-b1cf-ffce3ed79bad	2026-09-22 16:40:27.935108+00	\N	f	1	ab32138f-bda8-4ae3-a101-c5e9ac792092	4	Làm nóng chảo	Làm nóng chảo cho gỏi cuốn phiên bản 038, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	10	\N
4522aa8a-cff7-43b0-8d36-2f9589c35608	2026-09-22 16:40:27.935108+00	\N	f	1	ab32138f-bda8-4ae3-a101-c5e9ac792092	5	Chế biến phần chính	Chế biến phần chính cho gỏi cuốn phiên bản 038, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.	12	\N
282286d3-7a7a-4848-923e-952206f7612d	2026-09-22 16:40:27.935108+00	\N	f	1	ab32138f-bda8-4ae3-a101-c5e9ac792092	6	Nêm nếm	Nêm nếm cho gỏi cuốn phiên bản 038, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	8	\N
607e864b-1ed3-45e1-afb4-51f2c1874f89	2026-09-22 16:40:27.935108+00	\N	f	1	ab32138f-bda8-4ae3-a101-c5e9ac792092	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho gỏi cuốn phiên bản 038, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	19	\N
5ab10ba9-2641-4ec9-b723-93e437ea8f14	2026-09-22 16:40:27.935108+00	\N	f	1	7ad9241a-0d83-4794-8307-e94ebf4194e9	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho lẩu rau phiên bản 039, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	11	\N
175feac4-d5f3-48c5-8711-1149c84f975b	2026-09-22 16:40:27.935108+00	\N	f	1	7ad9241a-0d83-4794-8307-e94ebf4194e9	2	Sơ chế	Sơ chế cho lẩu rau phiên bản 039, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	16	\N
aeaf32e7-b54e-4eab-acb4-099dd164a0cc	2026-09-22 16:40:27.935108+00	\N	f	1	7ad9241a-0d83-4794-8307-e94ebf4194e9	3	Ướp gia vị	Ướp gia vị cho lẩu rau phiên bản 039, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	11	\N
a49cf501-5a51-4b8d-af86-2cc4fa2a5741	2026-09-22 16:40:27.935108+00	\N	f	1	7ad9241a-0d83-4794-8307-e94ebf4194e9	4	Làm nóng chảo	Làm nóng chảo cho lẩu rau phiên bản 039, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	7	\N
5ab27396-8765-4da1-b39f-2e2eba644612	2026-09-22 16:40:27.935108+00	\N	f	1	7ad9241a-0d83-4794-8307-e94ebf4194e9	5	Chế biến phần chính	Chế biến phần chính cho lẩu rau phiên bản 039, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	12	\N
2cf73601-3456-4bbd-9b51-3ab78b839935	2026-09-22 16:40:27.935108+00	\N	f	1	7ad9241a-0d83-4794-8307-e94ebf4194e9	6	Nêm nếm	Nêm nếm cho lẩu rau phiên bản 039, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	5	\N
7eb479bd-87fd-491b-8920-416685802c66	2026-09-22 16:40:27.935108+00	\N	f	1	7ad9241a-0d83-4794-8307-e94ebf4194e9	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho lẩu rau phiên bản 039, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	8	\N
abb583f8-613f-4c86-ac41-1db862a39eed	2026-09-22 16:40:27.935108+00	\N	f	1	40548af9-3dd2-4ce5-810c-82997ed49b9f	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho xôi gấc phiên bản 040, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	6	\N
a3f99408-6b01-40b9-b334-f411c9a3b173	2026-09-22 16:40:27.935108+00	\N	f	1	40548af9-3dd2-4ce5-810c-82997ed49b9f	2	Sơ chế	Sơ chế cho xôi gấc phiên bản 040, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	15	\N
72c8cd86-df2a-431c-ba6b-7ba5c3ca7cb1	2026-09-22 16:40:27.935108+00	\N	f	1	40548af9-3dd2-4ce5-810c-82997ed49b9f	3	Ướp gia vị	Ướp gia vị cho xôi gấc phiên bản 040, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	13	\N
7c729d8e-0c37-46d4-aed0-987a3d36562d	2026-09-22 16:40:27.935108+00	\N	f	1	40548af9-3dd2-4ce5-810c-82997ed49b9f	4	Làm nóng chảo	Làm nóng chảo cho xôi gấc phiên bản 040, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	6	\N
a5a6e8dc-781e-42e1-b51b-511b6ee86fdf	2026-09-22 16:40:27.935108+00	\N	f	1	40548af9-3dd2-4ce5-810c-82997ed49b9f	5	Chế biến phần chính	Chế biến phần chính cho xôi gấc phiên bản 040, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	5	\N
c582afe7-64e1-460c-a303-7cf6e3befa47	2026-09-22 16:40:27.935108+00	\N	f	1	40548af9-3dd2-4ce5-810c-82997ed49b9f	6	Nêm nếm	Nêm nếm cho xôi gấc phiên bản 040, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	18	\N
99d0dad3-0816-422f-b779-9f56724e2ec0	2026-09-22 16:40:27.935108+00	\N	f	1	e386d488-0cc6-4148-a6f4-a0d843ef4ae1	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho cơm gà phiên bản 041, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	17	\N
458de020-ac85-44b5-8e51-5107b574e6d8	2026-09-22 16:40:27.935108+00	\N	f	1	e386d488-0cc6-4148-a6f4-a0d843ef4ae1	2	Sơ chế	Sơ chế cho cơm gà phiên bản 041, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	8	\N
cb22a9ed-68ba-4380-a8f2-98523cdc795b	2026-09-22 16:40:27.935108+00	\N	f	1	e386d488-0cc6-4148-a6f4-a0d843ef4ae1	3	Ướp gia vị	Ướp gia vị cho cơm gà phiên bản 041, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	6	\N
9248ce0d-ba9e-458d-a917-f4a66a55cf93	2026-09-22 16:40:27.935108+00	\N	f	1	e386d488-0cc6-4148-a6f4-a0d843ef4ae1	4	Làm nóng chảo	Làm nóng chảo cho cơm gà phiên bản 041, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	20	\N
43a9526c-358d-48bf-b68a-3b00828cf591	2026-09-22 16:40:27.935108+00	\N	f	1	e386d488-0cc6-4148-a6f4-a0d843ef4ae1	5	Chế biến phần chính	Chế biến phần chính cho cơm gà phiên bản 041, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	7	\N
efe64dfb-4525-4964-855a-58aa8c69d479	2026-09-22 16:40:27.935108+00	\N	f	1	bd5136c1-3f17-4512-868b-1f41b331b3e4	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho bún bò phiên bản 042, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	16	\N
8819d5b0-5b91-42d1-aedc-35880633427f	2026-09-22 16:40:27.935108+00	\N	f	1	bd5136c1-3f17-4512-868b-1f41b331b3e4	2	Sơ chế	Sơ chế cho bún bò phiên bản 042, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	11	\N
552a048b-7559-4ad7-9f47-0838a1cf58f0	2026-09-22 16:40:27.935108+00	\N	f	1	bd5136c1-3f17-4512-868b-1f41b331b3e4	3	Ướp gia vị	Ướp gia vị cho bún bò phiên bản 042, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	13	\N
0c254d40-f0f0-44a4-b5a8-7759af91e7db	2026-09-22 16:40:27.935108+00	\N	f	1	bd5136c1-3f17-4512-868b-1f41b331b3e4	4	Làm nóng chảo	Làm nóng chảo cho bún bò phiên bản 042, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	8	\N
56bdf7f6-8022-4001-a254-16c192e7ad42	2026-09-22 16:40:27.935108+00	\N	f	1	bd5136c1-3f17-4512-868b-1f41b331b3e4	5	Chế biến phần chính	Chế biến phần chính cho bún bò phiên bản 042, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.	11	\N
a2b3e900-c7ec-4d99-8b26-3ca3dbf35161	2026-09-22 16:40:27.935108+00	\N	f	1	bd5136c1-3f17-4512-868b-1f41b331b3e4	6	Nêm nếm	Nêm nếm cho bún bò phiên bản 042, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	7	\N
a23784d7-5548-40be-90d9-ca158852a212	2026-09-22 16:40:27.935108+00	\N	f	1	bd5136c1-3f17-4512-868b-1f41b331b3e4	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho bún bò phiên bản 042, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	6	\N
565a3184-8d1f-4ea7-816d-493597915fb9	2026-09-22 16:40:27.935108+00	\N	f	1	66a59220-a831-40de-9488-373cf8906b51	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho mì rau củ phiên bản 043, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	10	\N
3441074c-180f-4348-bcdb-4e392e8108e6	2026-09-22 16:40:27.935108+00	\N	f	1	66a59220-a831-40de-9488-373cf8906b51	2	Sơ chế	Sơ chế cho mì rau củ phiên bản 043, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	20	\N
e98d37f8-7c24-4b63-bb9f-a2ac9f830fd3	2026-09-22 16:40:27.935108+00	\N	f	1	66a59220-a831-40de-9488-373cf8906b51	3	Ướp gia vị	Ướp gia vị cho mì rau củ phiên bản 043, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	18	\N
9a7068cb-00ea-464e-9b0b-3f1f6594958b	2026-09-22 16:40:27.935108+00	\N	f	1	66a59220-a831-40de-9488-373cf8906b51	4	Làm nóng chảo	Làm nóng chảo cho mì rau củ phiên bản 043, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	10	\N
4e65088d-1e04-4e8c-8268-ffe1ec375021	2026-09-22 16:40:27.935108+00	\N	f	1	66a59220-a831-40de-9488-373cf8906b51	5	Chế biến phần chính	Chế biến phần chính cho mì rau củ phiên bản 043, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	17	\N
2b601840-df4d-4045-a15a-37da776f5419	2026-09-22 16:40:27.935108+00	\N	f	1	66a59220-a831-40de-9488-373cf8906b51	6	Nêm nếm	Nêm nếm cho mì rau củ phiên bản 043, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	9	\N
3636b32d-a221-40bf-86db-67dcb46deaae	2026-09-22 16:40:27.935108+00	\N	f	1	fbb77065-b828-4f55-b260-d0555e7f2e4c	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho đậu hũ sốt phiên bản 044, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	14	\N
973a2f9b-1d02-465a-8d58-dcc4a824aa30	2026-09-22 16:40:27.935108+00	\N	f	1	fbb77065-b828-4f55-b260-d0555e7f2e4c	2	Sơ chế	Sơ chế cho đậu hũ sốt phiên bản 044, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	7	\N
a4c328d9-7e30-4627-8519-7cc0bb5d3f28	2026-09-22 16:40:27.935108+00	\N	f	1	fbb77065-b828-4f55-b260-d0555e7f2e4c	3	Ướp gia vị	Ướp gia vị cho đậu hũ sốt phiên bản 044, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	14	\N
4f4252ae-ab72-4023-9466-0f7e89f779f1	2026-09-22 16:40:27.935108+00	\N	f	1	fbb77065-b828-4f55-b260-d0555e7f2e4c	4	Làm nóng chảo	Làm nóng chảo cho đậu hũ sốt phiên bản 044, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	20	\N
abc54a58-94c4-4d16-a571-15a02113bbda	2026-09-22 16:40:27.935108+00	\N	f	1	fbb77065-b828-4f55-b260-d0555e7f2e4c	5	Chế biến phần chính	Chế biến phần chính cho đậu hũ sốt phiên bản 044, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	5	\N
ec603db4-d06d-4e78-bd10-8057c387508c	2026-09-22 16:40:27.935108+00	\N	f	1	fbb77065-b828-4f55-b260-d0555e7f2e4c	6	Nêm nếm	Nêm nếm cho đậu hũ sốt phiên bản 044, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	6	\N
849c6918-444e-4226-aaed-f851ace1c6b9	2026-09-22 16:40:27.935108+00	\N	f	1	fbb77065-b828-4f55-b260-d0555e7f2e4c	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho đậu hũ sốt phiên bản 044, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	7	\N
86080f77-bb6c-4003-9363-bbc740d312c4	2026-09-22 16:40:27.935108+00	\N	f	1	ddf9a41b-987e-4232-9719-1dad2566daef	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho cá nướng phiên bản 045, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	5	\N
a2b1e638-89d5-479b-98d9-910d4ceb7caa	2026-09-22 16:40:27.935108+00	\N	f	1	ddf9a41b-987e-4232-9719-1dad2566daef	2	Sơ chế	Sơ chế cho cá nướng phiên bản 045, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	14	\N
7d4f5883-48a1-42ad-95b3-fe384fee1c05	2026-09-22 16:40:27.935108+00	\N	f	1	ddf9a41b-987e-4232-9719-1dad2566daef	3	Ướp gia vị	Ướp gia vị cho cá nướng phiên bản 045, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	15	\N
16b1ee62-9def-4624-b131-568c96aaf52d	2026-09-22 16:40:27.935108+00	\N	f	1	ddf9a41b-987e-4232-9719-1dad2566daef	4	Làm nóng chảo	Làm nóng chảo cho cá nướng phiên bản 045, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	10	\N
d71712ef-ffa4-4ef1-beaf-91cb7d85a643	2026-09-22 16:40:27.935108+00	\N	f	1	ddf9a41b-987e-4232-9719-1dad2566daef	5	Chế biến phần chính	Chế biến phần chính cho cá nướng phiên bản 045, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	9	\N
deca0a42-7c2f-48a0-90cd-9ea61db98ba3	2026-09-22 16:40:27.935108+00	\N	f	1	ddf9a41b-987e-4232-9719-1dad2566daef	6	Nêm nếm	Nêm nếm cho cá nướng phiên bản 045, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	17	\N
ad3a30a1-8e3c-41d6-b814-77465fc9d4d2	2026-09-22 16:40:27.935108+00	\N	f	1	ddf9a41b-987e-4232-9719-1dad2566daef	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho cá nướng phiên bản 045, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	13	\N
89b140d7-04fe-41b5-bf39-442fb4f0d088	2026-09-22 16:40:27.935108+00	\N	f	1	562c335a-10be-4338-b035-3c1e2cffd334	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho gà hấp phiên bản 046, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	17	\N
c95df299-52d5-417d-a97e-06f4850eeeae	2026-09-22 16:40:27.935108+00	\N	f	1	562c335a-10be-4338-b035-3c1e2cffd334	2	Sơ chế	Sơ chế cho gà hấp phiên bản 046, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	11	\N
a9502bdd-c648-424f-a690-8b8132818db1	2026-09-22 16:40:27.935108+00	\N	f	1	562c335a-10be-4338-b035-3c1e2cffd334	3	Ướp gia vị	Ướp gia vị cho gà hấp phiên bản 046, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	8	\N
606e422f-c6d2-47f8-a336-6cb3b5b8e9b7	2026-09-22 16:40:27.935108+00	\N	f	1	562c335a-10be-4338-b035-3c1e2cffd334	4	Làm nóng chảo	Làm nóng chảo cho gà hấp phiên bản 046, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	7	\N
fdda1393-3911-4a8c-ab69-09739d1cacae	2026-09-22 16:40:27.935108+00	\N	f	1	562c335a-10be-4338-b035-3c1e2cffd334	5	Chế biến phần chính	Chế biến phần chính cho gà hấp phiên bản 046, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	9	\N
17f04b31-2d1f-42e5-bfaf-f327b96ae7df	2026-09-22 16:40:27.935108+00	\N	f	1	8dccba9d-12b4-4d2d-9a1d-5fc14008d51c	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho thịt xào phiên bản 047, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	11	\N
ae3cd313-2343-4f71-8038-fcdcf1806511	2026-09-22 16:40:27.935108+00	\N	f	1	8dccba9d-12b4-4d2d-9a1d-5fc14008d51c	2	Sơ chế	Sơ chế cho thịt xào phiên bản 047, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	17	\N
163e088f-682b-4c18-b51b-72a9e3e35805	2026-09-22 16:40:27.935108+00	\N	f	1	8dccba9d-12b4-4d2d-9a1d-5fc14008d51c	3	Ướp gia vị	Ướp gia vị cho thịt xào phiên bản 047, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	14	\N
d761ff6a-bb38-4763-8c15-6a50fd9d6192	2026-09-22 16:40:27.935108+00	\N	f	1	8dccba9d-12b4-4d2d-9a1d-5fc14008d51c	4	Làm nóng chảo	Làm nóng chảo cho thịt xào phiên bản 047, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	14	\N
473da9bf-6ce6-49c8-88ff-7a32048b104d	2026-09-22 16:40:27.935108+00	\N	f	1	8dccba9d-12b4-4d2d-9a1d-5fc14008d51c	5	Chế biến phần chính	Chế biến phần chính cho thịt xào phiên bản 047, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	6	\N
5c91bc8f-13d6-4de4-a0c8-d7bf233e8e10	2026-09-22 16:40:27.935108+00	\N	f	1	24a10494-0371-4fb9-94cf-4758144aedd3	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho tôm chiên phiên bản 048, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	15	\N
8eb2d71a-17fa-416e-9551-3b8a344566e2	2026-09-22 16:40:27.935108+00	\N	f	1	24a10494-0371-4fb9-94cf-4758144aedd3	2	Sơ chế	Sơ chế cho tôm chiên phiên bản 048, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	18	\N
819ad535-43e7-4dd0-919f-c71ec0ad1514	2026-09-22 16:40:27.935108+00	\N	f	1	24a10494-0371-4fb9-94cf-4758144aedd3	3	Ướp gia vị	Ướp gia vị cho tôm chiên phiên bản 048, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	13	\N
3d2080fe-a165-4b65-bbb8-49837c643df8	2026-09-22 16:40:27.935108+00	\N	f	1	24a10494-0371-4fb9-94cf-4758144aedd3	4	Làm nóng chảo	Làm nóng chảo cho tôm chiên phiên bản 048, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	6	\N
f5a91215-eb0f-48eb-8002-3cf68b496e08	2026-09-22 16:40:27.935108+00	\N	f	1	24a10494-0371-4fb9-94cf-4758144aedd3	5	Chế biến phần chính	Chế biến phần chính cho tôm chiên phiên bản 048, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	15	\N
30e8db77-f355-4d16-b811-2c38ea1464e4	2026-09-22 16:40:27.935108+00	\N	f	1	24a10494-0371-4fb9-94cf-4758144aedd3	6	Nêm nếm	Nêm nếm cho tôm chiên phiên bản 048, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	19	\N
84fd7046-7d6b-4554-b283-12bd063d8c68	2026-09-22 16:40:27.935108+00	\N	f	1	002b91a9-5ca6-4239-b385-339e48d88bd6	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho cá kho phiên bản 049, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.	6	\N
4682d8d7-7a4f-4274-9596-7102092b2525	2026-09-22 16:40:27.935108+00	\N	f	1	002b91a9-5ca6-4239-b385-339e48d88bd6	2	Sơ chế	Sơ chế cho cá kho phiên bản 049, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	20	\N
5534ea79-6bcc-4bc7-ad23-e72152ba3871	2026-09-22 16:40:27.935108+00	\N	f	1	002b91a9-5ca6-4239-b385-339e48d88bd6	3	Ướp gia vị	Ướp gia vị cho cá kho phiên bản 049, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	13	\N
2f323744-bde6-4bde-aced-0f65414a050b	2026-09-22 16:40:27.935108+00	\N	f	1	002b91a9-5ca6-4239-b385-339e48d88bd6	4	Làm nóng chảo	Làm nóng chảo cho cá kho phiên bản 049, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	18	\N
edf3aae3-987c-4a4a-a5b6-9085951d5954	2026-09-22 16:40:27.935108+00	\N	f	1	002b91a9-5ca6-4239-b385-339e48d88bd6	5	Chế biến phần chính	Chế biến phần chính cho cá kho phiên bản 049, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	5	\N
f908480d-6501-488a-94e7-a1a594c36a26	2026-09-22 16:40:27.935108+00	\N	f	1	002b91a9-5ca6-4239-b385-339e48d88bd6	6	Nêm nếm	Nêm nếm cho cá kho phiên bản 049, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	16	\N
5d0faa46-34f6-4108-8800-47de1b2b3ef5	2026-09-22 16:40:27.935108+00	\N	f	1	002b91a9-5ca6-4239-b385-339e48d88bd6	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho cá kho phiên bản 049, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	7	\N
e3ed724e-5884-4c81-b184-945766d72cae	2026-09-22 16:40:27.935108+00	\N	f	1	4928facf-c82b-48f1-9886-2db427ee7301	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho canh bí phiên bản 050, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	20	\N
39e006bb-d565-489f-bf46-2b0e0490a3c5	2026-09-22 16:40:27.935108+00	\N	f	1	4928facf-c82b-48f1-9886-2db427ee7301	2	Sơ chế	Sơ chế cho canh bí phiên bản 050, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	14	\N
e7522cff-47e4-4c78-b25b-d093a19b3c95	2026-09-22 16:40:27.935108+00	\N	f	1	4928facf-c82b-48f1-9886-2db427ee7301	3	Ướp gia vị	Ướp gia vị cho canh bí phiên bản 050, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	15	\N
029e7f13-177a-4e87-b59b-05a3d1a5f42e	2026-09-22 16:40:27.935108+00	\N	f	1	4928facf-c82b-48f1-9886-2db427ee7301	4	Làm nóng chảo	Làm nóng chảo cho canh bí phiên bản 050, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	13	\N
d23e4e29-4148-40db-9830-5d432676424a	2026-09-22 16:40:27.935108+00	\N	f	1	4928facf-c82b-48f1-9886-2db427ee7301	5	Chế biến phần chính	Chế biến phần chính cho canh bí phiên bản 050, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	11	\N
511f5f16-669e-4826-b516-2d0a4e00474a	2026-09-22 16:40:27.935108+00	\N	f	1	f4a63e23-a5aa-4d23-8822-77aa3ee9ed24	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho súp nấm phiên bản 051, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	11	\N
bc5ccc85-e636-4e13-8080-2e7f2160d40f	2026-09-22 16:40:27.935108+00	\N	f	1	f4a63e23-a5aa-4d23-8822-77aa3ee9ed24	2	Sơ chế	Sơ chế cho súp nấm phiên bản 051, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	19	\N
99c449eb-e3de-4260-9c7d-4d2bf9445626	2026-09-22 16:40:27.935108+00	\N	f	1	f4a63e23-a5aa-4d23-8822-77aa3ee9ed24	3	Ướp gia vị	Ướp gia vị cho súp nấm phiên bản 051, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	13	\N
faef0de5-4cc0-475f-af01-7e2ac7d30878	2026-09-22 16:40:27.935108+00	\N	f	1	f4a63e23-a5aa-4d23-8822-77aa3ee9ed24	4	Làm nóng chảo	Làm nóng chảo cho súp nấm phiên bản 051, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	19	\N
67b21068-e71f-4b2d-a07c-5eb309c9ad7b	2026-09-22 16:40:27.935108+00	\N	f	1	f4a63e23-a5aa-4d23-8822-77aa3ee9ed24	5	Chế biến phần chính	Chế biến phần chính cho súp nấm phiên bản 051, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	17	\N
5de0f07f-5be2-4edb-b404-c2c9ad7812d2	2026-09-22 16:40:27.935108+00	\N	f	1	f4a63e23-a5aa-4d23-8822-77aa3ee9ed24	6	Nêm nếm	Nêm nếm cho súp nấm phiên bản 051, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	8	\N
c46e9a27-815e-40ce-b7b4-de01689ba7c6	2026-09-22 16:40:27.935108+00	\N	f	1	67b9aad3-b7ff-4922-b6ce-ba52462074ad	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho cơm rang phiên bản 052, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	13	\N
a33a6894-822a-4ac9-8d83-04d372b1ec8a	2026-09-22 16:40:27.935108+00	\N	f	1	67b9aad3-b7ff-4922-b6ce-ba52462074ad	2	Sơ chế	Sơ chế cho cơm rang phiên bản 052, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	8	\N
67e96447-74e6-4111-8093-0f981b24853c	2026-09-22 16:40:27.935108+00	\N	f	1	67b9aad3-b7ff-4922-b6ce-ba52462074ad	3	Ướp gia vị	Ướp gia vị cho cơm rang phiên bản 052, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	15	\N
61934dd1-8e6a-49e2-a4ba-88d4860521af	2026-09-22 16:40:27.935108+00	\N	f	1	67b9aad3-b7ff-4922-b6ce-ba52462074ad	4	Làm nóng chảo	Làm nóng chảo cho cơm rang phiên bản 052, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	5	\N
fe6dfbf1-22b7-4446-86f6-5f37cd171a86	2026-09-22 16:40:27.935108+00	\N	f	1	67b9aad3-b7ff-4922-b6ce-ba52462074ad	5	Chế biến phần chính	Chế biến phần chính cho cơm rang phiên bản 052, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	16	\N
08c1c9c1-4168-4447-8532-383293718da0	2026-09-22 16:40:27.935108+00	\N	f	1	f7735694-c470-473b-b4d3-8557fb5a642c	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho mì xào phiên bản 053, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.	5	\N
e7327a63-6b31-4bbb-9838-55bc521b3d77	2026-09-22 16:40:27.935108+00	\N	f	1	f7735694-c470-473b-b4d3-8557fb5a642c	2	Sơ chế	Sơ chế cho mì xào phiên bản 053, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	15	\N
7c6b7644-36cd-4512-9240-235071621739	2026-09-22 16:40:27.935108+00	\N	f	1	f7735694-c470-473b-b4d3-8557fb5a642c	3	Ướp gia vị	Ướp gia vị cho mì xào phiên bản 053, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.	19	\N
9550b686-e443-42d2-ad38-4e1356b8bdef	2026-09-22 16:40:27.935108+00	\N	f	1	f7735694-c470-473b-b4d3-8557fb5a642c	4	Làm nóng chảo	Làm nóng chảo cho mì xào phiên bản 053, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	12	\N
01bd90e4-8265-4b71-9404-4f7c09648bc1	2026-09-22 16:40:27.935108+00	\N	f	1	f7735694-c470-473b-b4d3-8557fb5a642c	5	Chế biến phần chính	Chế biến phần chính cho mì xào phiên bản 053, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	7	\N
dbd01ecf-f8f2-4b0c-83e9-bcb8dfcb99d3	2026-09-22 16:40:27.935108+00	\N	f	1	f7735694-c470-473b-b4d3-8557fb5a642c	6	Nêm nếm	Nêm nếm cho mì xào phiên bản 053, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	12	\N
dcb81fb0-c816-4021-b83b-4218c064c5ce	2026-09-22 16:40:27.935108+00	\N	f	1	4548ae76-9712-45e4-a504-aa9907e39f05	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho bún thịt phiên bản 054, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	12	\N
da419a70-327e-4709-b4ef-34c5a9e50f00	2026-09-22 16:40:27.935108+00	\N	f	1	4548ae76-9712-45e4-a504-aa9907e39f05	2	Sơ chế	Sơ chế cho bún thịt phiên bản 054, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.	17	\N
73d687b5-ef59-47e0-aa1d-8d087e5f17e9	2026-09-22 16:40:27.935108+00	\N	f	1	4548ae76-9712-45e4-a504-aa9907e39f05	3	Ướp gia vị	Ướp gia vị cho bún thịt phiên bản 054, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	8	\N
cd8e6736-dc44-4ae6-ac92-fecdf3dae562	2026-09-22 16:40:27.935108+00	\N	f	1	4548ae76-9712-45e4-a504-aa9907e39f05	4	Làm nóng chảo	Làm nóng chảo cho bún thịt phiên bản 054, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	19	\N
3994f8e0-acea-456b-8385-c480df4185be	2026-09-22 16:40:27.935108+00	\N	f	1	4548ae76-9712-45e4-a504-aa9907e39f05	5	Chế biến phần chính	Chế biến phần chính cho bún thịt phiên bản 054, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	7	\N
8a677c56-d7e7-4023-b718-a28ca412b7fe	2026-09-22 16:40:27.935108+00	\N	f	1	0b417a11-2833-4b53-9222-3a9856648872	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho bánh khoai phiên bản 055, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	12	\N
0190b565-86a0-4e90-b543-75a3002fd719	2026-09-22 16:40:27.935108+00	\N	f	1	0b417a11-2833-4b53-9222-3a9856648872	2	Sơ chế	Sơ chế cho bánh khoai phiên bản 055, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	16	\N
2f16321f-f018-4584-9805-fb7e5a386d1c	2026-09-22 16:40:27.935108+00	\N	f	1	0b417a11-2833-4b53-9222-3a9856648872	3	Ướp gia vị	Ướp gia vị cho bánh khoai phiên bản 055, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	9	\N
864c5a7e-296f-49fb-b4ca-3eaa2b0d079b	2026-09-22 16:40:27.935108+00	\N	f	1	0b417a11-2833-4b53-9222-3a9856648872	4	Làm nóng chảo	Làm nóng chảo cho bánh khoai phiên bản 055, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	7	\N
2da33cd2-7770-4ab7-ae1d-7b36ea0e1c3f	2026-09-22 16:40:27.935108+00	\N	f	1	0b417a11-2833-4b53-9222-3a9856648872	5	Chế biến phần chính	Chế biến phần chính cho bánh khoai phiên bản 055, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	7	\N
862f79b8-e142-4ce8-bbe1-89d5e1ac7d26	2026-09-22 16:40:27.935108+00	\N	f	1	4c69c3ad-4c91-4e42-9a0e-31bc940cdb3a	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho chè đậu phiên bản 056, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	16	\N
7530fa89-88b3-4de2-98a3-25f8228db4d6	2026-09-22 16:40:27.935108+00	\N	f	1	4c69c3ad-4c91-4e42-9a0e-31bc940cdb3a	2	Sơ chế	Sơ chế cho chè đậu phiên bản 056, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	5	\N
e17d8cef-d860-450f-beeb-6ce6aa3e59c2	2026-09-22 16:40:27.935108+00	\N	f	1	4c69c3ad-4c91-4e42-9a0e-31bc940cdb3a	3	Ướp gia vị	Ướp gia vị cho chè đậu phiên bản 056, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	20	\N
6a3f9642-b84c-43ce-8a85-5d8517d7f2bf	2026-09-22 16:40:27.935108+00	\N	f	1	4c69c3ad-4c91-4e42-9a0e-31bc940cdb3a	4	Làm nóng chảo	Làm nóng chảo cho chè đậu phiên bản 056, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	15	\N
291dac11-dd44-474f-b9d5-b98b9e59c574	2026-09-22 16:40:27.935108+00	\N	f	1	4c69c3ad-4c91-4e42-9a0e-31bc940cdb3a	5	Chế biến phần chính	Chế biến phần chính cho chè đậu phiên bản 056, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	10	\N
661b80c3-38e2-45ec-b596-4af941063f72	2026-09-22 16:40:27.935108+00	\N	f	1	254dc0a9-d270-47ab-ba08-d4cd5408a1b7	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho bánh mì trứng phiên bản 057, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	7	\N
8bc5a6b8-30aa-4274-bc99-da19c968ad3f	2026-09-22 16:40:27.935108+00	\N	f	1	254dc0a9-d270-47ab-ba08-d4cd5408a1b7	2	Sơ chế	Sơ chế cho bánh mì trứng phiên bản 057, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	6	\N
3ad9e824-d604-453e-a4ed-2cc8605eccc2	2026-09-22 16:40:27.935108+00	\N	f	1	254dc0a9-d270-47ab-ba08-d4cd5408a1b7	3	Ướp gia vị	Ướp gia vị cho bánh mì trứng phiên bản 057, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	9	\N
44392103-43cd-4e5c-ade4-455b2f851f6b	2026-09-22 16:40:27.935108+00	\N	f	1	254dc0a9-d270-47ab-ba08-d4cd5408a1b7	4	Làm nóng chảo	Làm nóng chảo cho bánh mì trứng phiên bản 057, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	8	\N
f37afd03-cde3-4cd5-9037-d770b469be62	2026-09-22 16:40:27.935108+00	\N	f	1	254dc0a9-d270-47ab-ba08-d4cd5408a1b7	5	Chế biến phần chính	Chế biến phần chính cho bánh mì trứng phiên bản 057, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	18	\N
8490fb24-26aa-45ec-9531-ec50a7ecf66f	2026-09-22 16:40:27.935108+00	\N	f	1	254dc0a9-d270-47ab-ba08-d4cd5408a1b7	6	Nêm nếm	Nêm nếm cho bánh mì trứng phiên bản 057, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	12	\N
cfab94f5-4a87-4354-aa82-63737b8a74f5	2026-09-22 16:40:27.935108+00	\N	f	1	254dc0a9-d270-47ab-ba08-d4cd5408a1b7	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho bánh mì trứng phiên bản 057, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	5	\N
ef01d6b6-b135-4edc-bfee-e5c1cfda88f4	2026-09-22 16:40:27.935108+00	\N	f	1	c1621222-23ce-4ea4-8779-9882684c6adf	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho gỏi cuốn phiên bản 058, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	12	\N
a3ad16d1-7d72-4560-92aa-e51f440336e6	2026-09-22 16:40:27.935108+00	\N	f	1	c1621222-23ce-4ea4-8779-9882684c6adf	2	Sơ chế	Sơ chế cho gỏi cuốn phiên bản 058, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	14	\N
a5d8efff-f54f-4e6e-a1dc-794b54411695	2026-09-22 16:40:27.935108+00	\N	f	1	c1621222-23ce-4ea4-8779-9882684c6adf	3	Ướp gia vị	Ướp gia vị cho gỏi cuốn phiên bản 058, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	17	\N
731fc3e0-e682-4d91-889a-eb0efa802347	2026-09-22 16:40:27.935108+00	\N	f	1	c1621222-23ce-4ea4-8779-9882684c6adf	4	Làm nóng chảo	Làm nóng chảo cho gỏi cuốn phiên bản 058, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	10	\N
a1fc60f5-0261-44d7-9648-0ff070e23359	2026-09-22 16:40:27.935108+00	\N	f	1	c1621222-23ce-4ea4-8779-9882684c6adf	5	Chế biến phần chính	Chế biến phần chính cho gỏi cuốn phiên bản 058, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	8	\N
2f087528-c8ef-40c7-b441-810945259d57	2026-09-22 16:40:27.935108+00	\N	f	1	c3668171-26a6-485b-b0bd-1beb69f63762	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho lẩu rau phiên bản 059, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	16	\N
0f0cd8dc-2b77-4968-889a-232d0c87c63b	2026-09-22 16:40:27.935108+00	\N	f	1	c3668171-26a6-485b-b0bd-1beb69f63762	2	Sơ chế	Sơ chế cho lẩu rau phiên bản 059, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	13	\N
50dc4984-2ff1-4c86-a732-6ef937307998	2026-09-22 16:40:27.935108+00	\N	f	1	c3668171-26a6-485b-b0bd-1beb69f63762	3	Ướp gia vị	Ướp gia vị cho lẩu rau phiên bản 059, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	15	\N
5dfbb723-e0da-4e9c-ab56-4f4b80b3bf09	2026-09-22 16:40:27.935108+00	\N	f	1	c3668171-26a6-485b-b0bd-1beb69f63762	4	Làm nóng chảo	Làm nóng chảo cho lẩu rau phiên bản 059, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	9	\N
7c8dd4a0-5e80-4514-9bb1-efdd46580c46	2026-09-22 16:40:27.935108+00	\N	f	1	c3668171-26a6-485b-b0bd-1beb69f63762	5	Chế biến phần chính	Chế biến phần chính cho lẩu rau phiên bản 059, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	18	\N
0bd971a2-2f5c-4d44-8300-6173940fc3f2	2026-09-22 16:40:27.935108+00	\N	f	1	55912428-102a-4a22-9469-dbd50bf77a30	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho xôi gấc phiên bản 060, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	9	\N
e760d9be-5820-4aae-b12f-e8aa0ba24638	2026-09-22 16:40:27.935108+00	\N	f	1	55912428-102a-4a22-9469-dbd50bf77a30	2	Sơ chế	Sơ chế cho xôi gấc phiên bản 060, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	18	\N
4648a5ff-e706-495c-b6f1-0c5403cd1bb3	2026-09-22 16:40:27.935108+00	\N	f	1	55912428-102a-4a22-9469-dbd50bf77a30	3	Ướp gia vị	Ướp gia vị cho xôi gấc phiên bản 060, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	18	\N
b0dc28c2-ecbe-4237-b084-ff69ab3ad3d0	2026-09-22 16:40:27.935108+00	\N	f	1	55912428-102a-4a22-9469-dbd50bf77a30	4	Làm nóng chảo	Làm nóng chảo cho xôi gấc phiên bản 060, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	14	\N
1e029373-5fc5-4875-b706-ab1c4dc70042	2026-09-22 16:40:27.935108+00	\N	f	1	55912428-102a-4a22-9469-dbd50bf77a30	5	Chế biến phần chính	Chế biến phần chính cho xôi gấc phiên bản 060, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	10	\N
a4165033-4432-42f9-b62b-9d2d14be68b8	2026-09-22 16:40:27.935108+00	\N	f	1	55912428-102a-4a22-9469-dbd50bf77a30	6	Nêm nếm	Nêm nếm cho xôi gấc phiên bản 060, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	6	\N
bdf341c9-1f43-4746-9874-4f4fdbd78eed	2026-09-22 16:40:27.935108+00	\N	f	1	07941b56-fc37-4e04-ba2b-0909d1c5eafa	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho cơm gà phiên bản 061, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	9	\N
1dc5261c-3598-4e56-8e4d-06d59e953d97	2026-09-22 16:40:27.935108+00	\N	f	1	07941b56-fc37-4e04-ba2b-0909d1c5eafa	2	Sơ chế	Sơ chế cho cơm gà phiên bản 061, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	20	\N
2501896e-b1c0-43ec-a151-de2174182eb4	2026-09-22 16:40:27.935108+00	\N	f	1	07941b56-fc37-4e04-ba2b-0909d1c5eafa	3	Ướp gia vị	Ướp gia vị cho cơm gà phiên bản 061, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	11	\N
78435501-715f-49ad-aa83-1a7f0167984c	2026-09-22 16:40:27.935108+00	\N	f	1	07941b56-fc37-4e04-ba2b-0909d1c5eafa	4	Làm nóng chảo	Làm nóng chảo cho cơm gà phiên bản 061, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	17	\N
6370d986-6d03-4c3c-9c8c-7b5253f489ef	2026-09-22 16:40:27.935108+00	\N	f	1	07941b56-fc37-4e04-ba2b-0909d1c5eafa	5	Chế biến phần chính	Chế biến phần chính cho cơm gà phiên bản 061, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	19	\N
df0da141-edeb-43ce-8cd5-d7bb15eab58b	2026-09-22 16:40:27.935108+00	\N	f	1	db57d063-8581-44b7-9ae7-4357288c86c6	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho bún bò phiên bản 062, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	18	\N
74efd2bb-22a6-4e14-a3ec-4e49f214c5fc	2026-09-22 16:40:27.935108+00	\N	f	1	db57d063-8581-44b7-9ae7-4357288c86c6	2	Sơ chế	Sơ chế cho bún bò phiên bản 062, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	7	\N
cfba3656-6b20-4e11-98c5-959f0fe6ecf7	2026-09-22 16:40:27.935108+00	\N	f	1	db57d063-8581-44b7-9ae7-4357288c86c6	3	Ướp gia vị	Ướp gia vị cho bún bò phiên bản 062, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	13	\N
6361679a-d9b0-4190-abc5-43e29650d4fb	2026-09-22 16:40:27.935108+00	\N	f	1	db57d063-8581-44b7-9ae7-4357288c86c6	4	Làm nóng chảo	Làm nóng chảo cho bún bò phiên bản 062, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	5	\N
6766d52f-b80b-4f71-8ddf-086e22b25ce6	2026-09-22 16:40:27.935108+00	\N	f	1	db57d063-8581-44b7-9ae7-4357288c86c6	5	Chế biến phần chính	Chế biến phần chính cho bún bò phiên bản 062, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	17	\N
30fbf6ef-bf77-4bb6-9450-888000103be6	2026-09-22 16:40:27.935108+00	\N	f	1	db57d063-8581-44b7-9ae7-4357288c86c6	6	Nêm nếm	Nêm nếm cho bún bò phiên bản 062, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	6	\N
e980e8c7-5e9c-4f3a-8891-110776ee3811	2026-09-22 16:40:27.935108+00	\N	f	1	db57d063-8581-44b7-9ae7-4357288c86c6	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho bún bò phiên bản 062, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	14	\N
54ecbaca-4891-44e1-833d-43d7ff4a6410	2026-09-22 16:40:27.935108+00	\N	f	1	d559b794-996c-4ca7-a987-6a17c5327fcd	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho mì rau củ phiên bản 063, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	7	\N
494b64dc-2da2-4279-a58c-f0ecae4b3360	2026-09-22 16:40:27.935108+00	\N	f	1	d559b794-996c-4ca7-a987-6a17c5327fcd	2	Sơ chế	Sơ chế cho mì rau củ phiên bản 063, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	14	\N
983eb817-701a-4636-af90-422967b2c278	2026-09-22 16:40:27.935108+00	\N	f	1	d559b794-996c-4ca7-a987-6a17c5327fcd	3	Ướp gia vị	Ướp gia vị cho mì rau củ phiên bản 063, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	13	\N
fe884f6d-6257-4c5a-a0f2-d7a104e45ad1	2026-09-22 16:40:27.935108+00	\N	f	1	d559b794-996c-4ca7-a987-6a17c5327fcd	4	Làm nóng chảo	Làm nóng chảo cho mì rau củ phiên bản 063, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	11	\N
be8bb65c-a526-4455-9d39-01738c560f50	2026-09-22 16:40:27.935108+00	\N	f	1	d559b794-996c-4ca7-a987-6a17c5327fcd	5	Chế biến phần chính	Chế biến phần chính cho mì rau củ phiên bản 063, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	10	\N
f9f7e58d-8b84-4628-9796-699f47d89dec	2026-09-22 16:40:27.935108+00	\N	f	1	d559b794-996c-4ca7-a987-6a17c5327fcd	6	Nêm nếm	Nêm nếm cho mì rau củ phiên bản 063, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	13	\N
d6d04180-51ff-4417-8cf1-bab60e7feb81	2026-09-22 16:40:27.935108+00	\N	f	1	348fddfe-7f64-4fb3-95b6-c14a3ad63c00	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho đậu hũ sốt phiên bản 064, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	17	\N
6088a767-ea3e-4d46-af6c-fbce8fa1bcc4	2026-09-22 16:40:27.935108+00	\N	f	1	348fddfe-7f64-4fb3-95b6-c14a3ad63c00	2	Sơ chế	Sơ chế cho đậu hũ sốt phiên bản 064, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.	16	\N
a6d7f200-27a3-429a-8a0d-3d7462ef33a3	2026-09-22 16:40:27.935108+00	\N	f	1	348fddfe-7f64-4fb3-95b6-c14a3ad63c00	3	Ướp gia vị	Ướp gia vị cho đậu hũ sốt phiên bản 064, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	15	\N
1caaead4-8d8b-4acd-a803-5d27754d0b88	2026-09-22 16:40:27.935108+00	\N	f	1	348fddfe-7f64-4fb3-95b6-c14a3ad63c00	4	Làm nóng chảo	Làm nóng chảo cho đậu hũ sốt phiên bản 064, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	19	\N
e9022208-ad2f-49bf-b00e-ea46e85aee2f	2026-09-22 16:40:27.935108+00	\N	f	1	348fddfe-7f64-4fb3-95b6-c14a3ad63c00	5	Chế biến phần chính	Chế biến phần chính cho đậu hũ sốt phiên bản 064, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	7	\N
9a070f6b-3afb-4e1d-a759-d92deb18766e	2026-09-22 16:40:27.935108+00	\N	f	1	348fddfe-7f64-4fb3-95b6-c14a3ad63c00	6	Nêm nếm	Nêm nếm cho đậu hũ sốt phiên bản 064, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.	16	\N
adbcbadf-fd3d-4c55-bbb5-8923d9c9547e	2026-09-22 16:40:27.935108+00	\N	f	1	e129e855-dd11-41d6-8189-fb3d3044f076	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho cá nướng phiên bản 065, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	12	\N
061e770b-2ccf-467a-a8e2-3b3ee79741d4	2026-09-22 16:40:27.935108+00	\N	f	1	e129e855-dd11-41d6-8189-fb3d3044f076	2	Sơ chế	Sơ chế cho cá nướng phiên bản 065, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	19	\N
5f67e511-173c-4ff8-96f3-7b3d72a9b0ea	2026-09-22 16:40:27.935108+00	\N	f	1	e129e855-dd11-41d6-8189-fb3d3044f076	3	Ướp gia vị	Ướp gia vị cho cá nướng phiên bản 065, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	20	\N
c01979ce-7663-475f-8460-a23895ab02fb	2026-09-22 16:40:27.935108+00	\N	f	1	e129e855-dd11-41d6-8189-fb3d3044f076	4	Làm nóng chảo	Làm nóng chảo cho cá nướng phiên bản 065, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	11	\N
7524de2c-2f97-4f6e-8d70-0850e596c786	2026-09-22 16:40:27.935108+00	\N	f	1	e129e855-dd11-41d6-8189-fb3d3044f076	5	Chế biến phần chính	Chế biến phần chính cho cá nướng phiên bản 065, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	9	\N
06d91e9f-e221-4a78-9040-3ddda1279784	2026-09-22 16:40:27.935108+00	\N	f	1	e129e855-dd11-41d6-8189-fb3d3044f076	6	Nêm nếm	Nêm nếm cho cá nướng phiên bản 065, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	9	\N
2dfd106d-6a12-41e8-bd62-5aa9d3b46e6a	2026-09-22 16:40:27.935108+00	\N	f	1	4037f256-e830-4bea-a6e2-1ca411095a6f	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho gà hấp phiên bản 066, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	10	\N
664e7508-b67c-4e76-9b9a-b9a2c3cd1290	2026-09-22 16:40:27.935108+00	\N	f	1	4037f256-e830-4bea-a6e2-1ca411095a6f	2	Sơ chế	Sơ chế cho gà hấp phiên bản 066, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	5	\N
41a43c8a-023a-4fe6-902e-9d8477076f26	2026-09-22 16:40:27.935108+00	\N	f	1	4037f256-e830-4bea-a6e2-1ca411095a6f	3	Ướp gia vị	Ướp gia vị cho gà hấp phiên bản 066, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	9	\N
ebd0c5a2-44e0-4d59-878b-4632f0f217dd	2026-09-22 16:40:27.935108+00	\N	f	1	4037f256-e830-4bea-a6e2-1ca411095a6f	4	Làm nóng chảo	Làm nóng chảo cho gà hấp phiên bản 066, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	5	\N
79b245ae-52ab-4c90-962c-29e4efb9ad0b	2026-09-22 16:40:27.935108+00	\N	f	1	4037f256-e830-4bea-a6e2-1ca411095a6f	5	Chế biến phần chính	Chế biến phần chính cho gà hấp phiên bản 066, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	7	\N
a0d97c9b-fbe6-44e7-a660-1b7bebb8e0e4	2026-09-22 16:40:27.935108+00	\N	f	1	2e96fe2e-5745-4849-b64b-9ed07902a179	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho thịt xào phiên bản 067, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	14	\N
b1933852-e704-4309-b90c-c7bf21727ee8	2026-09-22 16:40:27.935108+00	\N	f	1	2e96fe2e-5745-4849-b64b-9ed07902a179	2	Sơ chế	Sơ chế cho thịt xào phiên bản 067, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	19	\N
36e52d50-7075-49de-87cc-524a1c303e9b	2026-09-22 16:40:27.935108+00	\N	f	1	2e96fe2e-5745-4849-b64b-9ed07902a179	3	Ướp gia vị	Ướp gia vị cho thịt xào phiên bản 067, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.	16	\N
89080ef6-55f9-4eb1-aad1-97c6d09f12d5	2026-09-22 16:40:27.935108+00	\N	f	1	2e96fe2e-5745-4849-b64b-9ed07902a179	4	Làm nóng chảo	Làm nóng chảo cho thịt xào phiên bản 067, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	8	\N
b5a76fdd-fdc4-4f08-be0e-266a2c5222c7	2026-09-22 16:40:27.935108+00	\N	f	1	2e96fe2e-5745-4849-b64b-9ed07902a179	5	Chế biến phần chính	Chế biến phần chính cho thịt xào phiên bản 067, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	6	\N
33f6bf5a-0746-4d17-82f9-b439caa47334	2026-09-22 16:40:27.935108+00	\N	f	1	f1c3df32-5906-492a-beba-4197b0ca4f8b	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho tôm chiên phiên bản 068, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	19	\N
3be7d8c0-ab12-4903-81ad-bdb86270c763	2026-09-22 16:40:27.935108+00	\N	f	1	f1c3df32-5906-492a-beba-4197b0ca4f8b	2	Sơ chế	Sơ chế cho tôm chiên phiên bản 068, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	6	\N
357df5bd-7c94-4937-9a9f-77ba032889a8	2026-09-22 16:40:27.935108+00	\N	f	1	f1c3df32-5906-492a-beba-4197b0ca4f8b	3	Ướp gia vị	Ướp gia vị cho tôm chiên phiên bản 068, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	10	\N
38510ada-6f7a-4c19-ae8b-c9c39c3b64b9	2026-09-22 16:40:27.935108+00	\N	f	1	f1c3df32-5906-492a-beba-4197b0ca4f8b	4	Làm nóng chảo	Làm nóng chảo cho tôm chiên phiên bản 068, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	12	\N
800d2b7d-57a6-4f68-903d-08df456134a9	2026-09-22 16:40:27.935108+00	\N	f	1	f1c3df32-5906-492a-beba-4197b0ca4f8b	5	Chế biến phần chính	Chế biến phần chính cho tôm chiên phiên bản 068, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	19	\N
7d1f23e6-75f9-4095-a75c-8f5fa005511e	2026-09-22 16:40:27.935108+00	\N	f	1	a1957e38-5472-4dab-93db-31c54769f19c	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho cá kho phiên bản 069, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	16	\N
7b5c11f3-fb7b-41ce-9119-d0ab9d3c9fbe	2026-09-22 16:40:27.935108+00	\N	f	1	a1957e38-5472-4dab-93db-31c54769f19c	2	Sơ chế	Sơ chế cho cá kho phiên bản 069, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	14	\N
bcb45d0b-f8cc-4a09-bdd7-87b271eb8379	2026-09-22 16:40:27.935108+00	\N	f	1	a1957e38-5472-4dab-93db-31c54769f19c	3	Ướp gia vị	Ướp gia vị cho cá kho phiên bản 069, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.	16	\N
cef3879f-76ff-4040-9aaa-a2eeb426e4ae	2026-09-22 16:40:27.935108+00	\N	f	1	a1957e38-5472-4dab-93db-31c54769f19c	4	Làm nóng chảo	Làm nóng chảo cho cá kho phiên bản 069, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	12	\N
5919058c-be91-4a33-834d-b297c6643efe	2026-09-22 16:40:27.935108+00	\N	f	1	a1957e38-5472-4dab-93db-31c54769f19c	5	Chế biến phần chính	Chế biến phần chính cho cá kho phiên bản 069, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	14	\N
1a4396c8-488a-42e1-ad21-7f5b316d53d2	2026-09-22 16:40:27.935108+00	\N	f	1	a1957e38-5472-4dab-93db-31c54769f19c	6	Nêm nếm	Nêm nếm cho cá kho phiên bản 069, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	8	\N
8f20ddbe-3792-4788-b304-857e0f86dac0	2026-09-22 16:40:27.935108+00	\N	f	1	010d72a8-39ab-4e3f-8c70-0854712210f8	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho canh bí phiên bản 070, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	6	\N
b76316af-427a-4d38-9238-9b88efaf2514	2026-09-22 16:40:27.935108+00	\N	f	1	010d72a8-39ab-4e3f-8c70-0854712210f8	2	Sơ chế	Sơ chế cho canh bí phiên bản 070, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	20	\N
678deb3f-2615-438f-b825-1875dfcf8e02	2026-09-22 16:40:27.935108+00	\N	f	1	010d72a8-39ab-4e3f-8c70-0854712210f8	3	Ướp gia vị	Ướp gia vị cho canh bí phiên bản 070, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	13	\N
083023ff-c849-4adb-bdeb-cc9512a5e598	2026-09-22 16:40:27.935108+00	\N	f	1	010d72a8-39ab-4e3f-8c70-0854712210f8	4	Làm nóng chảo	Làm nóng chảo cho canh bí phiên bản 070, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	14	\N
dfec09b6-cd89-4401-9b45-8f8caf9249a7	2026-09-22 16:40:27.935108+00	\N	f	1	010d72a8-39ab-4e3f-8c70-0854712210f8	5	Chế biến phần chính	Chế biến phần chính cho canh bí phiên bản 070, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	16	\N
75aaa80a-1c55-437d-8f63-c029a91dd28e	2026-09-22 16:40:27.935108+00	\N	f	1	010d72a8-39ab-4e3f-8c70-0854712210f8	6	Nêm nếm	Nêm nếm cho canh bí phiên bản 070, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	8	\N
e61c2b27-a09b-48ff-bf68-94ab6d40da73	2026-09-22 16:40:27.935108+00	\N	f	1	010d72a8-39ab-4e3f-8c70-0854712210f8	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho canh bí phiên bản 070, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	12	\N
ec46c889-100a-451d-b252-3c4854e085ea	2026-09-22 16:40:27.935108+00	\N	f	1	9deb3613-087f-4e6a-af02-a6ac3785e666	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho súp nấm phiên bản 071, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	16	\N
cfd78345-a251-48f4-b70f-08d3f162fa8a	2026-09-22 16:40:27.935108+00	\N	f	1	9deb3613-087f-4e6a-af02-a6ac3785e666	2	Sơ chế	Sơ chế cho súp nấm phiên bản 071, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	11	\N
97466efb-9a48-4577-8e52-e359b938f802	2026-09-22 16:40:27.935108+00	\N	f	1	9deb3613-087f-4e6a-af02-a6ac3785e666	3	Ướp gia vị	Ướp gia vị cho súp nấm phiên bản 071, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.	7	\N
72f22994-7a0e-4bbf-b6d7-6a09bb8295c4	2026-09-22 16:40:27.935108+00	\N	f	1	9deb3613-087f-4e6a-af02-a6ac3785e666	4	Làm nóng chảo	Làm nóng chảo cho súp nấm phiên bản 071, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	9	\N
be4f768c-d44d-4a51-bebf-2aafbf8694bd	2026-09-22 16:40:27.935108+00	\N	f	1	9deb3613-087f-4e6a-af02-a6ac3785e666	5	Chế biến phần chính	Chế biến phần chính cho súp nấm phiên bản 071, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	11	\N
24c179dd-bfae-4cdf-88f8-55784157751d	2026-09-22 16:40:27.935108+00	\N	f	1	88d059e3-ed60-4381-8b70-b16b10d11154	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho cơm rang phiên bản 072, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	18	\N
e5276480-03c1-45ac-9c01-7fae6c8eef26	2026-09-22 16:40:27.935108+00	\N	f	1	88d059e3-ed60-4381-8b70-b16b10d11154	2	Sơ chế	Sơ chế cho cơm rang phiên bản 072, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	11	\N
b5836cb4-ec75-4567-8b1f-3341a01e47c4	2026-09-22 16:40:27.935108+00	\N	f	1	88d059e3-ed60-4381-8b70-b16b10d11154	3	Ướp gia vị	Ướp gia vị cho cơm rang phiên bản 072, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	20	\N
3eadba51-1750-406c-a643-3e2e10faff7d	2026-09-22 16:40:27.935108+00	\N	f	1	88d059e3-ed60-4381-8b70-b16b10d11154	4	Làm nóng chảo	Làm nóng chảo cho cơm rang phiên bản 072, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	17	\N
78420775-2b4f-45c5-8af3-bfc657a7681b	2026-09-22 16:40:27.935108+00	\N	f	1	88d059e3-ed60-4381-8b70-b16b10d11154	5	Chế biến phần chính	Chế biến phần chính cho cơm rang phiên bản 072, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	9	\N
de9a5414-8fe8-4ff4-b4fa-7956fff201d1	2026-09-22 16:40:27.935108+00	\N	f	1	d3564a99-ff0d-4f2e-b129-d214c229ca39	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho mì xào phiên bản 073, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	7	\N
96022ac3-c0cc-4248-9ab5-05db74299b8d	2026-09-22 16:40:27.935108+00	\N	f	1	d3564a99-ff0d-4f2e-b129-d214c229ca39	2	Sơ chế	Sơ chế cho mì xào phiên bản 073, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	19	\N
ec2757cb-b9e1-41e7-8062-50a65b0c3d07	2026-09-22 16:40:27.935108+00	\N	f	1	d3564a99-ff0d-4f2e-b129-d214c229ca39	3	Ướp gia vị	Ướp gia vị cho mì xào phiên bản 073, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	19	\N
6bcee0a7-e65b-4cb9-b894-a7571241da8f	2026-09-22 16:40:27.935108+00	\N	f	1	d3564a99-ff0d-4f2e-b129-d214c229ca39	4	Làm nóng chảo	Làm nóng chảo cho mì xào phiên bản 073, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	15	\N
7d92a1bb-3201-408d-a9ca-5f2ba5ba3517	2026-09-22 16:40:27.935108+00	\N	f	1	d3564a99-ff0d-4f2e-b129-d214c229ca39	5	Chế biến phần chính	Chế biến phần chính cho mì xào phiên bản 073, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	20	\N
33cebe8b-4710-411e-aa1c-4ed31b660873	2026-09-22 16:40:27.935108+00	\N	f	1	d3564a99-ff0d-4f2e-b129-d214c229ca39	6	Nêm nếm	Nêm nếm cho mì xào phiên bản 073, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	7	\N
07e2d448-bf6b-4690-8088-12df80a68cde	2026-09-22 16:40:27.935108+00	\N	f	1	f0e97260-a94a-4228-8b66-43092cc4d960	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho bún thịt phiên bản 074, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	15	\N
0421cfaf-c2aa-4b92-a7fb-472ac19bd72e	2026-09-22 16:40:27.935108+00	\N	f	1	f0e97260-a94a-4228-8b66-43092cc4d960	2	Sơ chế	Sơ chế cho bún thịt phiên bản 074, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	5	\N
fe8a1f37-0fda-4624-8741-84936e0ecbf6	2026-09-22 16:40:27.935108+00	\N	f	1	f0e97260-a94a-4228-8b66-43092cc4d960	3	Ướp gia vị	Ướp gia vị cho bún thịt phiên bản 074, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	19	\N
e155c960-86f6-4b56-a3b6-f5b56c836d58	2026-09-22 16:40:27.935108+00	\N	f	1	f0e97260-a94a-4228-8b66-43092cc4d960	4	Làm nóng chảo	Làm nóng chảo cho bún thịt phiên bản 074, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	18	\N
2972fdb8-f666-447d-be73-95d174f7bdb1	2026-09-22 16:40:27.935108+00	\N	f	1	f0e97260-a94a-4228-8b66-43092cc4d960	5	Chế biến phần chính	Chế biến phần chính cho bún thịt phiên bản 074, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	10	\N
3844691e-df3e-4033-80c4-5eac5a502646	2026-09-22 16:40:27.935108+00	\N	f	1	f0e97260-a94a-4228-8b66-43092cc4d960	6	Nêm nếm	Nêm nếm cho bún thịt phiên bản 074, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	7	\N
5c7b3d3b-1b6f-4f8b-bd1d-d8c80c192359	2026-09-22 16:40:27.935108+00	\N	f	1	f0e97260-a94a-4228-8b66-43092cc4d960	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho bún thịt phiên bản 074, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	20	\N
b49c77de-ae27-41c4-98c9-32715f754d8a	2026-09-22 16:40:27.935108+00	\N	f	1	efa700aa-6196-4fb7-a624-f1794047dc83	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho bánh khoai phiên bản 075, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	20	\N
dad41d1e-810f-4257-a6fe-de9af1683c5c	2026-09-22 16:40:27.935108+00	\N	f	1	efa700aa-6196-4fb7-a624-f1794047dc83	2	Sơ chế	Sơ chế cho bánh khoai phiên bản 075, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	8	\N
b4703d69-46f6-4bb5-9db2-c95093eb794f	2026-09-22 16:40:27.935108+00	\N	f	1	efa700aa-6196-4fb7-a624-f1794047dc83	3	Ướp gia vị	Ướp gia vị cho bánh khoai phiên bản 075, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	14	\N
d7ad6b7e-3b5b-4c44-8c8c-7edb77c36a86	2026-09-22 16:40:27.935108+00	\N	f	1	efa700aa-6196-4fb7-a624-f1794047dc83	4	Làm nóng chảo	Làm nóng chảo cho bánh khoai phiên bản 075, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	7	\N
82e4d49d-b0ec-46bc-a8e6-db44e958c7db	2026-09-22 16:40:27.935108+00	\N	f	1	efa700aa-6196-4fb7-a624-f1794047dc83	5	Chế biến phần chính	Chế biến phần chính cho bánh khoai phiên bản 075, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.	13	\N
45aa7b84-9356-4183-af59-0822fb4b5af7	2026-09-22 16:40:27.935108+00	\N	f	1	efa700aa-6196-4fb7-a624-f1794047dc83	6	Nêm nếm	Nêm nếm cho bánh khoai phiên bản 075, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	20	\N
dc3e85f6-081a-42c0-b13a-3fd4dd16e331	2026-09-22 16:40:27.935108+00	\N	f	1	efa700aa-6196-4fb7-a624-f1794047dc83	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho bánh khoai phiên bản 075, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	8	\N
d2cac8d4-5829-4352-8274-511537f99189	2026-09-22 16:40:27.935108+00	\N	f	1	c70f9112-e933-4cf3-bc7c-f3597318dc92	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho chè đậu phiên bản 076, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	9	\N
0d82f6d2-ae43-47e8-9475-10ab514ea7ee	2026-09-22 16:40:27.935108+00	\N	f	1	c70f9112-e933-4cf3-bc7c-f3597318dc92	2	Sơ chế	Sơ chế cho chè đậu phiên bản 076, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	5	\N
ea2acbda-317d-43f7-9943-55a28aa9cbd5	2026-09-22 16:40:27.935108+00	\N	f	1	c70f9112-e933-4cf3-bc7c-f3597318dc92	3	Ướp gia vị	Ướp gia vị cho chè đậu phiên bản 076, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	18	\N
3d4dee5c-ffa4-4771-95ac-8c106a9c08c2	2026-09-22 16:40:27.935108+00	\N	f	1	c70f9112-e933-4cf3-bc7c-f3597318dc92	4	Làm nóng chảo	Làm nóng chảo cho chè đậu phiên bản 076, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	15	\N
fe5d2d7f-fb29-4330-a7d2-5b1d46cc8660	2026-09-22 16:40:27.935108+00	\N	f	1	c70f9112-e933-4cf3-bc7c-f3597318dc92	5	Chế biến phần chính	Chế biến phần chính cho chè đậu phiên bản 076, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	10	\N
5694547d-8b9c-4091-a6ed-31da40f3ff21	2026-09-22 16:40:27.935108+00	\N	f	1	c70f9112-e933-4cf3-bc7c-f3597318dc92	6	Nêm nếm	Nêm nếm cho chè đậu phiên bản 076, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	15	\N
e61f773e-c55b-4c4c-858b-1e9b4afce10b	2026-09-22 16:40:27.935108+00	\N	f	1	c70f9112-e933-4cf3-bc7c-f3597318dc92	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho chè đậu phiên bản 076, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	6	\N
63189fbb-28b0-48d6-8ae5-f64b2f71b2d3	2026-09-22 16:40:27.935108+00	\N	f	1	b45deffb-8faf-489e-8b94-1b8db806314f	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho bánh mì trứng phiên bản 077, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	6	\N
1f313f4e-22a6-4484-9d95-c9dd37f04f9e	2026-09-22 16:40:27.935108+00	\N	f	1	b45deffb-8faf-489e-8b94-1b8db806314f	2	Sơ chế	Sơ chế cho bánh mì trứng phiên bản 077, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	13	\N
655cd911-d72d-4df5-b2cb-13727342b592	2026-09-22 16:40:27.935108+00	\N	f	1	b45deffb-8faf-489e-8b94-1b8db806314f	3	Ướp gia vị	Ướp gia vị cho bánh mì trứng phiên bản 077, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	16	\N
ba70d4ec-870a-4f59-a049-428e93a4c6d4	2026-09-22 16:40:27.935108+00	\N	f	1	b45deffb-8faf-489e-8b94-1b8db806314f	4	Làm nóng chảo	Làm nóng chảo cho bánh mì trứng phiên bản 077, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	7	\N
d60ebe9c-c0c4-4567-adf1-3762135b562f	2026-09-22 16:40:27.935108+00	\N	f	1	b45deffb-8faf-489e-8b94-1b8db806314f	5	Chế biến phần chính	Chế biến phần chính cho bánh mì trứng phiên bản 077, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	10	\N
a1418b6d-522a-481b-9f9d-498c575c70fe	2026-09-22 16:40:27.935108+00	\N	f	1	f852915b-e743-4648-bc53-354564274cbe	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho gỏi cuốn phiên bản 078, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	6	\N
d58e9bae-ba3a-4d00-8eb7-f82e9af11af9	2026-09-22 16:40:27.935108+00	\N	f	1	f852915b-e743-4648-bc53-354564274cbe	2	Sơ chế	Sơ chế cho gỏi cuốn phiên bản 078, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	18	\N
16b279f8-b4e4-4abc-bbfe-cf8e801dddd6	2026-09-22 16:40:27.935108+00	\N	f	1	f852915b-e743-4648-bc53-354564274cbe	3	Ướp gia vị	Ướp gia vị cho gỏi cuốn phiên bản 078, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	18	\N
318aeddd-e372-408d-b669-87721fb71624	2026-09-22 16:40:27.935108+00	\N	f	1	f852915b-e743-4648-bc53-354564274cbe	4	Làm nóng chảo	Làm nóng chảo cho gỏi cuốn phiên bản 078, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.	11	\N
4afbbac3-066e-42f0-8951-408c297a024c	2026-09-22 16:40:27.935108+00	\N	f	1	f852915b-e743-4648-bc53-354564274cbe	5	Chế biến phần chính	Chế biến phần chính cho gỏi cuốn phiên bản 078, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	14	\N
da9f0bba-ceea-4310-9ea9-3ed1caa05192	2026-09-22 16:40:27.935108+00	\N	f	1	8903560f-3e94-4465-a48f-e2add7ec29b9	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho lẩu rau phiên bản 079, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	5	\N
5d093f4f-ac3b-4575-b183-b24f273a169c	2026-09-22 16:40:27.935108+00	\N	f	1	8903560f-3e94-4465-a48f-e2add7ec29b9	2	Sơ chế	Sơ chế cho lẩu rau phiên bản 079, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	15	\N
e8f30dc8-1200-42ca-ab04-55af14ba827b	2026-09-22 16:40:27.935108+00	\N	f	1	8903560f-3e94-4465-a48f-e2add7ec29b9	3	Ướp gia vị	Ướp gia vị cho lẩu rau phiên bản 079, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	20	\N
aa52d043-1069-41b3-aed9-d16b5c6f21ef	2026-09-22 16:40:27.935108+00	\N	f	1	8903560f-3e94-4465-a48f-e2add7ec29b9	4	Làm nóng chảo	Làm nóng chảo cho lẩu rau phiên bản 079, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	5	\N
2e855edc-16f7-4909-8794-870c1f96c0a5	2026-09-22 16:40:27.935108+00	\N	f	1	8903560f-3e94-4465-a48f-e2add7ec29b9	5	Chế biến phần chính	Chế biến phần chính cho lẩu rau phiên bản 079, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	17	\N
babaeace-0f94-4f01-b874-ce8c21d64ddf	2026-09-22 16:40:27.935108+00	\N	f	1	d5fc07e8-c8ef-4829-b86d-7672a4f9430e	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho xôi gấc phiên bản 080, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	8	\N
5aed303a-3bf6-47ca-b6f3-b5a5de3356eb	2026-09-22 16:40:27.935108+00	\N	f	1	d5fc07e8-c8ef-4829-b86d-7672a4f9430e	2	Sơ chế	Sơ chế cho xôi gấc phiên bản 080, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.	14	\N
cb2af781-60d8-41d9-9a90-525724e61ff6	2026-09-22 16:40:27.935108+00	\N	f	1	d5fc07e8-c8ef-4829-b86d-7672a4f9430e	3	Ướp gia vị	Ướp gia vị cho xôi gấc phiên bản 080, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	11	\N
059f0c3f-7dea-4f92-b687-4c3a939a3130	2026-09-22 16:40:27.935108+00	\N	f	1	d5fc07e8-c8ef-4829-b86d-7672a4f9430e	4	Làm nóng chảo	Làm nóng chảo cho xôi gấc phiên bản 080, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	16	\N
3f9ec2fc-fcbe-419e-a9c0-28d9af3d7afd	2026-09-22 16:40:27.935108+00	\N	f	1	d5fc07e8-c8ef-4829-b86d-7672a4f9430e	5	Chế biến phần chính	Chế biến phần chính cho xôi gấc phiên bản 080, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	16	\N
4b9e4c0e-831f-4844-b028-d584ca22e056	2026-09-22 16:40:27.935108+00	\N	f	1	7124d61c-c57e-41db-8620-3280b7ee79f6	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho cơm gà phiên bản 081, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	13	\N
c1e1a609-8a08-45fd-b66a-cf708871e113	2026-09-22 16:40:27.935108+00	\N	f	1	7124d61c-c57e-41db-8620-3280b7ee79f6	2	Sơ chế	Sơ chế cho cơm gà phiên bản 081, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	11	\N
7c1a69f3-e8b7-42fd-ba92-dd6aad344561	2026-09-22 16:40:27.935108+00	\N	f	1	7124d61c-c57e-41db-8620-3280b7ee79f6	3	Ướp gia vị	Ướp gia vị cho cơm gà phiên bản 081, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	15	\N
57a09b24-12cd-459d-b8d0-e0dc45972b6c	2026-09-22 16:40:27.935108+00	\N	f	1	7124d61c-c57e-41db-8620-3280b7ee79f6	4	Làm nóng chảo	Làm nóng chảo cho cơm gà phiên bản 081, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	17	\N
634bc57a-a25e-43d1-9236-a8dccfafddd6	2026-09-22 16:40:27.935108+00	\N	f	1	7124d61c-c57e-41db-8620-3280b7ee79f6	5	Chế biến phần chính	Chế biến phần chính cho cơm gà phiên bản 081, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	12	\N
2eae7d82-bd1c-4ca8-ac1f-3be10c269460	2026-09-22 16:40:27.935108+00	\N	f	1	7124d61c-c57e-41db-8620-3280b7ee79f6	6	Nêm nếm	Nêm nếm cho cơm gà phiên bản 081, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	18	\N
4e09a5cb-6bf9-4d51-9da8-930b5cce74a5	2026-09-22 16:40:27.935108+00	\N	f	1	7124d61c-c57e-41db-8620-3280b7ee79f6	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho cơm gà phiên bản 081, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	16	\N
0d598ecf-db76-464d-b7de-81b345d06b86	2026-09-22 16:40:27.935108+00	\N	f	1	7e91259b-de31-4da3-8cb1-952047e7f1d8	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho bún bò phiên bản 082, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	15	\N
05a2cb16-e5a0-456f-b37b-18e00da78b28	2026-09-22 16:40:27.935108+00	\N	f	1	7e91259b-de31-4da3-8cb1-952047e7f1d8	2	Sơ chế	Sơ chế cho bún bò phiên bản 082, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	18	\N
32f73578-6499-4810-a0eb-3dbc90a3900a	2026-09-22 16:40:27.935108+00	\N	f	1	7e91259b-de31-4da3-8cb1-952047e7f1d8	3	Ướp gia vị	Ướp gia vị cho bún bò phiên bản 082, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	19	\N
a10f6261-4691-4bf2-8aab-8ce183b83c4d	2026-09-22 16:40:27.935108+00	\N	f	1	7e91259b-de31-4da3-8cb1-952047e7f1d8	4	Làm nóng chảo	Làm nóng chảo cho bún bò phiên bản 082, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	6	\N
158d970a-d182-460d-b509-f2a429ded435	2026-09-22 16:40:27.935108+00	\N	f	1	7e91259b-de31-4da3-8cb1-952047e7f1d8	5	Chế biến phần chính	Chế biến phần chính cho bún bò phiên bản 082, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	11	\N
578c844c-2ec8-48d8-bb24-6e9b17733800	2026-09-22 16:40:27.935108+00	\N	f	1	7e91259b-de31-4da3-8cb1-952047e7f1d8	6	Nêm nếm	Nêm nếm cho bún bò phiên bản 082, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	11	\N
907bd9f0-240f-459f-b66e-ebcfb5f6af85	2026-09-22 16:40:27.935108+00	\N	f	1	d633c604-10a2-4556-a684-c0ce020d58a3	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho mì rau củ phiên bản 083, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	17	\N
3af8c31e-9281-4e01-bfb7-d7eba4c98060	2026-09-22 16:40:27.935108+00	\N	f	1	d633c604-10a2-4556-a684-c0ce020d58a3	2	Sơ chế	Sơ chế cho mì rau củ phiên bản 083, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	9	\N
04c7213d-3294-4f45-8b69-e17267c23e20	2026-09-22 16:40:27.935108+00	\N	f	1	d633c604-10a2-4556-a684-c0ce020d58a3	3	Ướp gia vị	Ướp gia vị cho mì rau củ phiên bản 083, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	13	\N
604639be-de22-4353-a260-6de33081988e	2026-09-22 16:40:27.935108+00	\N	f	1	d633c604-10a2-4556-a684-c0ce020d58a3	4	Làm nóng chảo	Làm nóng chảo cho mì rau củ phiên bản 083, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	9	\N
fc349175-dcb0-4375-b224-a4ed86a95b1b	2026-09-22 16:40:27.935108+00	\N	f	1	d633c604-10a2-4556-a684-c0ce020d58a3	5	Chế biến phần chính	Chế biến phần chính cho mì rau củ phiên bản 083, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	11	\N
699e2338-eb1a-40db-b32a-21f335669966	2026-09-22 16:40:27.935108+00	\N	f	1	d5d9066a-2580-452a-b50a-01614390485e	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho đậu hũ sốt phiên bản 084, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	6	\N
162fd54c-f679-4676-81d1-91381582c201	2026-09-22 16:40:27.935108+00	\N	f	1	d5d9066a-2580-452a-b50a-01614390485e	2	Sơ chế	Sơ chế cho đậu hũ sốt phiên bản 084, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	11	\N
a3dfa8ef-0f10-4935-a37b-6ed29d3aee13	2026-09-22 16:40:27.935108+00	\N	f	1	d5d9066a-2580-452a-b50a-01614390485e	3	Ướp gia vị	Ướp gia vị cho đậu hũ sốt phiên bản 084, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	15	\N
86099d3e-39ca-4eda-9ded-62ae430ba7c1	2026-09-22 16:40:27.935108+00	\N	f	1	d5d9066a-2580-452a-b50a-01614390485e	4	Làm nóng chảo	Làm nóng chảo cho đậu hũ sốt phiên bản 084, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	5	\N
9a88f7c8-5f48-4172-a7d0-bb40cc9473df	2026-09-22 16:40:27.935108+00	\N	f	1	d5d9066a-2580-452a-b50a-01614390485e	5	Chế biến phần chính	Chế biến phần chính cho đậu hũ sốt phiên bản 084, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.	19	\N
92500b37-9c49-4b0b-b0bd-a03b1da64270	2026-09-22 16:40:27.935108+00	\N	f	1	d5d9066a-2580-452a-b50a-01614390485e	6	Nêm nếm	Nêm nếm cho đậu hũ sốt phiên bản 084, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	15	\N
7b53fd60-0148-4d1d-9302-c1d87b8160fa	2026-09-22 16:40:27.935108+00	\N	f	1	81d1e8e4-7cda-4041-b16e-e8deb0cff897	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho cá nướng phiên bản 085, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	5	\N
f6de4e68-84bc-4c45-adcf-962a02d727af	2026-09-22 16:40:27.935108+00	\N	f	1	81d1e8e4-7cda-4041-b16e-e8deb0cff897	2	Sơ chế	Sơ chế cho cá nướng phiên bản 085, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	16	\N
4355424f-b716-46c7-8768-27241dc8b9c8	2026-09-22 16:40:27.935108+00	\N	f	1	81d1e8e4-7cda-4041-b16e-e8deb0cff897	3	Ướp gia vị	Ướp gia vị cho cá nướng phiên bản 085, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	13	\N
1587776f-5200-4df9-bc7b-5ac13534b1b7	2026-09-22 16:40:27.935108+00	\N	f	1	81d1e8e4-7cda-4041-b16e-e8deb0cff897	4	Làm nóng chảo	Làm nóng chảo cho cá nướng phiên bản 085, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	6	\N
0f77b86a-c546-436d-abea-5f239bb0ef5a	2026-09-22 16:40:27.935108+00	\N	f	1	81d1e8e4-7cda-4041-b16e-e8deb0cff897	5	Chế biến phần chính	Chế biến phần chính cho cá nướng phiên bản 085, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	12	\N
67bb6637-986f-4cfd-bb59-ae7580e441f9	2026-09-22 16:40:27.935108+00	\N	f	1	81d1e8e4-7cda-4041-b16e-e8deb0cff897	6	Nêm nếm	Nêm nếm cho cá nướng phiên bản 085, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	18	\N
01c0f538-4122-4e6a-bb18-ea4072a14a39	2026-09-22 16:40:27.935108+00	\N	f	1	ce535140-4132-41cc-b688-4600cd898301	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho gà hấp phiên bản 086, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	18	\N
544eb9e3-9554-4342-b9e2-580d6aaed96e	2026-09-22 16:40:27.935108+00	\N	f	1	ce535140-4132-41cc-b688-4600cd898301	2	Sơ chế	Sơ chế cho gà hấp phiên bản 086, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	12	\N
58a21944-e0ed-46a6-8503-e67b2084914d	2026-09-22 16:40:27.935108+00	\N	f	1	ce535140-4132-41cc-b688-4600cd898301	3	Ướp gia vị	Ướp gia vị cho gà hấp phiên bản 086, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	14	\N
ea900a3f-7427-496d-a00c-66d9e87c78ea	2026-09-22 16:40:27.935108+00	\N	f	1	ce535140-4132-41cc-b688-4600cd898301	4	Làm nóng chảo	Làm nóng chảo cho gà hấp phiên bản 086, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	19	\N
06a760ae-bdad-470d-bfa7-a338dd6e46d8	2026-09-22 16:40:27.935108+00	\N	f	1	ce535140-4132-41cc-b688-4600cd898301	5	Chế biến phần chính	Chế biến phần chính cho gà hấp phiên bản 086, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	8	\N
f4b18d3d-959f-4919-a142-d127031d373c	2026-09-22 16:40:27.935108+00	\N	f	1	ce535140-4132-41cc-b688-4600cd898301	6	Nêm nếm	Nêm nếm cho gà hấp phiên bản 086, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	5	\N
aac9da6d-36fd-46a2-8e9c-d4fd5eb01b44	2026-09-22 16:40:27.935108+00	\N	f	1	051ff554-9d6d-430e-aa97-a33c5cfd02f3	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho thịt xào phiên bản 087, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	10	\N
dae1b5e4-c1ca-4791-9974-72af49e52862	2026-09-22 16:40:27.935108+00	\N	f	1	051ff554-9d6d-430e-aa97-a33c5cfd02f3	2	Sơ chế	Sơ chế cho thịt xào phiên bản 087, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	14	\N
91ed784a-027a-4a89-8b56-49d4610d035c	2026-09-22 16:40:27.935108+00	\N	f	1	051ff554-9d6d-430e-aa97-a33c5cfd02f3	3	Ướp gia vị	Ướp gia vị cho thịt xào phiên bản 087, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	10	\N
000cd995-8ced-468f-a28e-d6804d057975	2026-09-22 16:40:27.935108+00	\N	f	1	051ff554-9d6d-430e-aa97-a33c5cfd02f3	4	Làm nóng chảo	Làm nóng chảo cho thịt xào phiên bản 087, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	14	\N
2195df85-428d-445b-a304-906c0e8b46d1	2026-09-22 16:40:27.935108+00	\N	f	1	051ff554-9d6d-430e-aa97-a33c5cfd02f3	5	Chế biến phần chính	Chế biến phần chính cho thịt xào phiên bản 087, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	9	\N
7edb87e1-7de9-492b-b33a-ec30570ebec3	2026-09-22 16:40:27.935108+00	\N	f	1	051ff554-9d6d-430e-aa97-a33c5cfd02f3	6	Nêm nếm	Nêm nếm cho thịt xào phiên bản 087, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	19	\N
7f1d04bf-71b6-4909-9c73-0da54614be0a	2026-09-22 16:40:27.935108+00	\N	f	1	051ff554-9d6d-430e-aa97-a33c5cfd02f3	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho thịt xào phiên bản 087, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	19	\N
cefe42cd-72b7-4f16-9a92-296b65bc5f67	2026-09-22 16:40:27.935108+00	\N	f	1	fc4b83b7-4471-4d88-b9ff-7bf95c2bdec5	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho tôm chiên phiên bản 088, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	18	\N
226bf464-0766-4af0-b3d6-e892e5d2c554	2026-09-22 16:40:27.935108+00	\N	f	1	fc4b83b7-4471-4d88-b9ff-7bf95c2bdec5	2	Sơ chế	Sơ chế cho tôm chiên phiên bản 088, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	14	\N
8055a2fd-64e6-420b-80bd-9f66ceebdee9	2026-09-22 16:40:27.935108+00	\N	f	1	fc4b83b7-4471-4d88-b9ff-7bf95c2bdec5	3	Ướp gia vị	Ướp gia vị cho tôm chiên phiên bản 088, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	18	\N
c816fb81-edb1-4e70-9f1d-64555b766bec	2026-09-22 16:40:27.935108+00	\N	f	1	fc4b83b7-4471-4d88-b9ff-7bf95c2bdec5	4	Làm nóng chảo	Làm nóng chảo cho tôm chiên phiên bản 088, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	11	\N
53603c11-5f0f-40f2-b857-90dcd6a753bc	2026-09-22 16:40:27.935108+00	\N	f	1	fc4b83b7-4471-4d88-b9ff-7bf95c2bdec5	5	Chế biến phần chính	Chế biến phần chính cho tôm chiên phiên bản 088, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	7	\N
f2735fd6-d4a7-4796-9ac8-2bd899bb87cd	2026-09-22 16:40:27.935108+00	\N	f	1	fc4b83b7-4471-4d88-b9ff-7bf95c2bdec5	6	Nêm nếm	Nêm nếm cho tôm chiên phiên bản 088, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	20	\N
4fd64afb-e894-4990-b924-aafcef4c3918	2026-09-22 16:40:27.935108+00	\N	f	1	fc4b83b7-4471-4d88-b9ff-7bf95c2bdec5	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho tôm chiên phiên bản 088, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	16	\N
74c21ef6-c799-4b0b-95b6-17b12825fefd	2026-09-22 16:40:27.935108+00	\N	f	1	a6f16e93-82b8-4735-b8ae-cf751bcc2ba9	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho cá kho phiên bản 089, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	17	\N
b5f1c01a-a9fa-4215-810d-67dd290615a0	2026-09-22 16:40:27.935108+00	\N	f	1	a6f16e93-82b8-4735-b8ae-cf751bcc2ba9	2	Sơ chế	Sơ chế cho cá kho phiên bản 089, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	8	\N
5bd4a38a-af24-4056-aa80-5fe808643fa5	2026-09-22 16:40:27.935108+00	\N	f	1	a6f16e93-82b8-4735-b8ae-cf751bcc2ba9	3	Ướp gia vị	Ướp gia vị cho cá kho phiên bản 089, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	15	\N
07453968-31a4-4948-a6db-b3f85d64987d	2026-09-22 16:40:27.935108+00	\N	f	1	a6f16e93-82b8-4735-b8ae-cf751bcc2ba9	4	Làm nóng chảo	Làm nóng chảo cho cá kho phiên bản 089, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	20	\N
491dbe7e-6818-4e29-852d-a792f2b2f317	2026-09-22 16:40:27.935108+00	\N	f	1	a6f16e93-82b8-4735-b8ae-cf751bcc2ba9	5	Chế biến phần chính	Chế biến phần chính cho cá kho phiên bản 089, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	16	\N
406870d8-cd97-4864-aef4-a8aea5cfb491	2026-09-22 16:40:27.935108+00	\N	f	1	62eda459-2322-4352-ba9a-a9d14aba6b6e	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho canh bí phiên bản 090, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	10	\N
4248bf6d-1942-4899-bf27-8797f4095f96	2026-09-22 16:40:27.935108+00	\N	f	1	62eda459-2322-4352-ba9a-a9d14aba6b6e	2	Sơ chế	Sơ chế cho canh bí phiên bản 090, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	8	\N
549cbbe2-bdd1-43bb-95fc-72fbb76efb5d	2026-09-22 16:40:27.935108+00	\N	f	1	62eda459-2322-4352-ba9a-a9d14aba6b6e	3	Ướp gia vị	Ướp gia vị cho canh bí phiên bản 090, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	10	\N
4c59eeab-e74f-4cc4-a524-eab1ee4641d2	2026-09-22 16:40:27.935108+00	\N	f	1	62eda459-2322-4352-ba9a-a9d14aba6b6e	4	Làm nóng chảo	Làm nóng chảo cho canh bí phiên bản 090, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	14	\N
dbbf95fa-0efc-4dcf-ab8d-e3fbc86e9418	2026-09-22 16:40:27.935108+00	\N	f	1	62eda459-2322-4352-ba9a-a9d14aba6b6e	5	Chế biến phần chính	Chế biến phần chính cho canh bí phiên bản 090, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	12	\N
8f36aae6-898c-4d49-a0b0-ec81789c776e	2026-09-22 16:40:27.935108+00	\N	f	1	62eda459-2322-4352-ba9a-a9d14aba6b6e	6	Nêm nếm	Nêm nếm cho canh bí phiên bản 090, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	18	\N
e50e9b5c-e1c6-4232-9b7b-b01aa50a4fdd	2026-09-22 16:40:27.935108+00	\N	f	1	62eda459-2322-4352-ba9a-a9d14aba6b6e	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho canh bí phiên bản 090, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	11	\N
b62326ad-bdd7-412e-8c3b-c18ce94fde6a	2026-09-22 16:40:27.935108+00	\N	f	1	6265c5ea-183c-438d-b7c7-3930970b563f	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho súp nấm phiên bản 091, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	12	\N
abe59447-ca87-4658-a043-794e44879880	2026-09-22 16:40:27.935108+00	\N	f	1	6265c5ea-183c-438d-b7c7-3930970b563f	2	Sơ chế	Sơ chế cho súp nấm phiên bản 091, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	16	\N
7d598a76-b357-43d1-be1c-057beda38297	2026-09-22 16:40:27.935108+00	\N	f	1	6265c5ea-183c-438d-b7c7-3930970b563f	3	Ướp gia vị	Ướp gia vị cho súp nấm phiên bản 091, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	19	\N
3d80c791-e0a4-402c-a079-ce484631e4ec	2026-09-22 16:40:27.935108+00	\N	f	1	6265c5ea-183c-438d-b7c7-3930970b563f	4	Làm nóng chảo	Làm nóng chảo cho súp nấm phiên bản 091, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	18	\N
5027df7c-d32b-447c-990e-11eb2a3d14d5	2026-09-22 16:40:27.935108+00	\N	f	1	6265c5ea-183c-438d-b7c7-3930970b563f	5	Chế biến phần chính	Chế biến phần chính cho súp nấm phiên bản 091, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	10	\N
69c9d124-81de-446c-bc6c-01a12e3cc459	2026-09-22 16:40:27.935108+00	\N	f	1	25f17627-db23-487f-a6b2-aca2abb11e51	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho cơm rang phiên bản 092, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	19	\N
189bf215-6061-4a82-824d-1f87de1d53e4	2026-09-22 16:40:27.935108+00	\N	f	1	25f17627-db23-487f-a6b2-aca2abb11e51	2	Sơ chế	Sơ chế cho cơm rang phiên bản 092, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	13	\N
af4f1fdd-1abb-4d1e-be57-37b3efcc4dee	2026-09-22 16:40:27.935108+00	\N	f	1	25f17627-db23-487f-a6b2-aca2abb11e51	3	Ướp gia vị	Ướp gia vị cho cơm rang phiên bản 092, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	8	\N
80d022ea-5c6b-4235-8ad6-c93f561280b9	2026-09-22 16:40:27.935108+00	\N	f	1	25f17627-db23-487f-a6b2-aca2abb11e51	4	Làm nóng chảo	Làm nóng chảo cho cơm rang phiên bản 092, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	6	\N
db559192-0600-422c-8783-5a0e1fb198a6	2026-09-22 16:40:27.935108+00	\N	f	1	25f17627-db23-487f-a6b2-aca2abb11e51	5	Chế biến phần chính	Chế biến phần chính cho cơm rang phiên bản 092, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	9	\N
dba68f11-0a71-4c94-a287-25c6b20c2c42	2026-09-22 16:40:27.935108+00	\N	f	1	25f17627-db23-487f-a6b2-aca2abb11e51	6	Nêm nếm	Nêm nếm cho cơm rang phiên bản 092, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	18	\N
daef021b-75dc-4ff1-a24c-8f61e534aeb2	2026-09-22 16:40:27.935108+00	\N	f	1	1997d118-cbc5-4be5-a65d-093e23c14fce	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho mì xào phiên bản 093, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	11	\N
c764fcf4-6a54-4401-9184-3d171470c2b4	2026-09-22 16:40:27.935108+00	\N	f	1	1997d118-cbc5-4be5-a65d-093e23c14fce	2	Sơ chế	Sơ chế cho mì xào phiên bản 093, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	13	\N
31398737-e94b-4056-8cc6-89a0bfee342c	2026-09-22 16:40:27.935108+00	\N	f	1	1997d118-cbc5-4be5-a65d-093e23c14fce	3	Ướp gia vị	Ướp gia vị cho mì xào phiên bản 093, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	18	\N
0d126bb5-8210-452b-aef9-3851f959e5ee	2026-09-22 16:40:27.935108+00	\N	f	1	1997d118-cbc5-4be5-a65d-093e23c14fce	4	Làm nóng chảo	Làm nóng chảo cho mì xào phiên bản 093, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	14	\N
875f52fc-42b0-48d8-b04e-6a7e7aa649d8	2026-09-22 16:40:27.935108+00	\N	f	1	1997d118-cbc5-4be5-a65d-093e23c14fce	5	Chế biến phần chính	Chế biến phần chính cho mì xào phiên bản 093, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	5	\N
1be1bff8-5726-46ff-8134-623712bf62b4	2026-09-22 16:40:27.935108+00	\N	f	1	1997d118-cbc5-4be5-a65d-093e23c14fce	6	Nêm nếm	Nêm nếm cho mì xào phiên bản 093, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	19	\N
2eb5938b-37e0-4c4d-a3a8-c0c17576dabb	2026-09-22 16:40:27.935108+00	\N	f	1	9715c962-5702-4b62-9f10-6111b76cfef4	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho bún thịt phiên bản 094, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	11	\N
fe633071-7a37-4270-8b5a-8db2a271910d	2026-09-22 16:40:27.935108+00	\N	f	1	9715c962-5702-4b62-9f10-6111b76cfef4	2	Sơ chế	Sơ chế cho bún thịt phiên bản 094, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	16	\N
7c4f8e3a-7f70-4191-9f85-bdb74ea35576	2026-09-22 16:40:27.935108+00	\N	f	1	9715c962-5702-4b62-9f10-6111b76cfef4	3	Ướp gia vị	Ướp gia vị cho bún thịt phiên bản 094, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	16	\N
dc5fb546-24c3-48a4-a6c2-a6aeb3abdd9a	2026-09-22 16:40:27.935108+00	\N	f	1	9715c962-5702-4b62-9f10-6111b76cfef4	4	Làm nóng chảo	Làm nóng chảo cho bún thịt phiên bản 094, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.	9	\N
683380a6-0756-4060-89d9-b487dfed0b50	2026-09-22 16:40:27.935108+00	\N	f	1	9715c962-5702-4b62-9f10-6111b76cfef4	5	Chế biến phần chính	Chế biến phần chính cho bún thịt phiên bản 094, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	9	\N
73375b1c-6ed1-454d-b871-371d89c9e9d8	2026-09-22 16:40:27.935108+00	\N	f	1	9715c962-5702-4b62-9f10-6111b76cfef4	6	Nêm nếm	Nêm nếm cho bún thịt phiên bản 094, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	8	\N
19be4768-8294-49d9-becb-af88fa8962e8	2026-09-22 16:40:27.935108+00	\N	f	1	9715c962-5702-4b62-9f10-6111b76cfef4	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho bún thịt phiên bản 094, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	13	\N
a84ce60f-93bf-4af8-a2fc-ca4c66787e5e	2026-09-22 16:40:27.935108+00	\N	f	1	a0596eb3-1063-4178-b49c-8ea5186af4d4	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho bánh khoai phiên bản 095, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	18	\N
a33a57e9-0c00-4128-8f91-4ddcc348f768	2026-09-22 16:40:27.935108+00	\N	f	1	a0596eb3-1063-4178-b49c-8ea5186af4d4	2	Sơ chế	Sơ chế cho bánh khoai phiên bản 095, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	12	\N
8e7cb2a3-3716-4605-ab21-55157e6970c2	2026-09-22 16:40:27.935108+00	\N	f	1	a0596eb3-1063-4178-b49c-8ea5186af4d4	3	Ướp gia vị	Ướp gia vị cho bánh khoai phiên bản 095, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	16	\N
512fd49a-47ca-49fd-8d72-47a932cb2612	2026-09-22 16:40:27.935108+00	\N	f	1	a0596eb3-1063-4178-b49c-8ea5186af4d4	4	Làm nóng chảo	Làm nóng chảo cho bánh khoai phiên bản 095, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	11	\N
077c04ce-736c-439b-a564-e21b1eb2b889	2026-09-22 16:40:27.935108+00	\N	f	1	a0596eb3-1063-4178-b49c-8ea5186af4d4	5	Chế biến phần chính	Chế biến phần chính cho bánh khoai phiên bản 095, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	17	\N
ea1b5323-63ce-4e6b-8418-caf8713b15d1	2026-09-22 16:40:27.935108+00	\N	f	1	a0596eb3-1063-4178-b49c-8ea5186af4d4	6	Nêm nếm	Nêm nếm cho bánh khoai phiên bản 095, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	19	\N
fc2a8a09-8485-4323-b1e1-6e57574d4d26	2026-09-22 16:40:27.935108+00	\N	f	1	f9624aa7-7f5d-4a13-85eb-c10edb84d182	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho chè đậu phiên bản 096, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	14	\N
205aa9d8-0cd9-4881-8701-634013876c47	2026-09-22 16:40:27.935108+00	\N	f	1	f9624aa7-7f5d-4a13-85eb-c10edb84d182	2	Sơ chế	Sơ chế cho chè đậu phiên bản 096, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	7	\N
b2009354-af80-40c7-9771-fe53c0467d71	2026-09-22 16:40:27.935108+00	\N	f	1	f9624aa7-7f5d-4a13-85eb-c10edb84d182	3	Ướp gia vị	Ướp gia vị cho chè đậu phiên bản 096, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	5	\N
04c4ddf8-42cc-4166-a389-5de4cc2fd853	2026-09-22 16:40:27.935108+00	\N	f	1	f9624aa7-7f5d-4a13-85eb-c10edb84d182	4	Làm nóng chảo	Làm nóng chảo cho chè đậu phiên bản 096, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	7	\N
dd2ba31b-acc2-441d-acfc-5ac3f067a411	2026-09-22 16:40:27.935108+00	\N	f	1	f9624aa7-7f5d-4a13-85eb-c10edb84d182	5	Chế biến phần chính	Chế biến phần chính cho chè đậu phiên bản 096, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	17	\N
213678ff-a0df-4718-a7dc-2f95d07b548c	2026-09-22 16:40:27.935108+00	\N	f	1	94173c5c-f916-413b-9405-8f6f415899fb	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho bánh mì trứng phiên bản 097, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	7	\N
cbf6ff96-618a-408a-b900-6951a97a6b6c	2026-09-22 16:40:27.935108+00	\N	f	1	94173c5c-f916-413b-9405-8f6f415899fb	2	Sơ chế	Sơ chế cho bánh mì trứng phiên bản 097, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	5	\N
5a06e305-0ee5-43f6-b3eb-4cfd8b23e6d0	2026-09-22 16:40:27.935108+00	\N	f	1	94173c5c-f916-413b-9405-8f6f415899fb	3	Ướp gia vị	Ướp gia vị cho bánh mì trứng phiên bản 097, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	5	\N
ada553a7-71c3-4129-9386-97162406225c	2026-09-22 16:40:27.935108+00	\N	f	1	94173c5c-f916-413b-9405-8f6f415899fb	4	Làm nóng chảo	Làm nóng chảo cho bánh mì trứng phiên bản 097, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	11	\N
33220b6f-db4b-4478-bda8-4f57f3785574	2026-09-22 16:40:27.935108+00	\N	f	1	94173c5c-f916-413b-9405-8f6f415899fb	5	Chế biến phần chính	Chế biến phần chính cho bánh mì trứng phiên bản 097, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	7	\N
7ff39d81-0375-4777-87d9-b298d3fab4ba	2026-09-22 16:40:27.935108+00	\N	f	1	94173c5c-f916-413b-9405-8f6f415899fb	6	Nêm nếm	Nêm nếm cho bánh mì trứng phiên bản 097, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	13	\N
b2d10ff1-60e7-4d1d-85d8-004deb709ec7	2026-09-22 16:40:27.935108+00	\N	f	1	b87f3df8-f610-4fea-8971-f0239c09372a	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho gỏi cuốn phiên bản 098, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	8	\N
71d62672-966a-48a5-b585-042c7cfd04dd	2026-09-22 16:40:27.935108+00	\N	f	1	b87f3df8-f610-4fea-8971-f0239c09372a	2	Sơ chế	Sơ chế cho gỏi cuốn phiên bản 098, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	15	\N
0cbf8610-9565-4b15-9f4e-fd8431a4c0a4	2026-09-22 16:40:27.935108+00	\N	f	1	b87f3df8-f610-4fea-8971-f0239c09372a	3	Ướp gia vị	Ướp gia vị cho gỏi cuốn phiên bản 098, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	16	\N
ed421bf3-4153-484a-a53a-3ed8b2ee7dcc	2026-09-22 16:40:27.935108+00	\N	f	1	b87f3df8-f610-4fea-8971-f0239c09372a	4	Làm nóng chảo	Làm nóng chảo cho gỏi cuốn phiên bản 098, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	18	\N
4a01c8d8-1b58-43da-bc09-4f7b20e7e227	2026-09-22 16:40:27.935108+00	\N	f	1	b87f3df8-f610-4fea-8971-f0239c09372a	5	Chế biến phần chính	Chế biến phần chính cho gỏi cuốn phiên bản 098, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	12	\N
daceb554-17bf-48d7-a502-95be7ab7445d	2026-09-22 16:40:27.935108+00	\N	f	1	6e4ba959-1bfc-4f17-a5ea-cca315f28167	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho lẩu rau phiên bản 099, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	7	\N
adeb8337-1690-4bda-a152-5945605679ba	2026-09-22 16:40:27.935108+00	\N	f	1	6e4ba959-1bfc-4f17-a5ea-cca315f28167	2	Sơ chế	Sơ chế cho lẩu rau phiên bản 099, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	17	\N
3613e705-f997-4519-8e88-3efa06e7b060	2026-09-22 16:40:27.935108+00	\N	f	1	6e4ba959-1bfc-4f17-a5ea-cca315f28167	3	Ướp gia vị	Ướp gia vị cho lẩu rau phiên bản 099, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	14	\N
a6951e87-7372-4857-be0d-c5914025fbcd	2026-09-22 16:40:27.935108+00	\N	f	1	6e4ba959-1bfc-4f17-a5ea-cca315f28167	4	Làm nóng chảo	Làm nóng chảo cho lẩu rau phiên bản 099, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	18	\N
92ea4754-2c3d-4676-afd9-dafb2a89dc3b	2026-09-22 16:40:27.935108+00	\N	f	1	6e4ba959-1bfc-4f17-a5ea-cca315f28167	5	Chế biến phần chính	Chế biến phần chính cho lẩu rau phiên bản 099, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	13	\N
6a2039be-dc18-422b-913e-8a6484e0059d	2026-09-22 16:40:27.935108+00	\N	f	1	6e4ba959-1bfc-4f17-a5ea-cca315f28167	6	Nêm nếm	Nêm nếm cho lẩu rau phiên bản 099, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	5	\N
165e7f4d-5b50-4557-87b7-7b30aacf33b3	2026-09-22 16:40:27.935108+00	\N	f	1	a2252302-6dcd-4676-9894-6d61e5bdbc95	1	Chuẩn bị nguyên liệu	Chuẩn bị nguyên liệu cho xôi gấc phiên bản 100, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.	10	\N
25ab37c8-fb13-4690-b465-6398e55af7ad	2026-09-22 16:40:27.935108+00	\N	f	1	a2252302-6dcd-4676-9894-6d61e5bdbc95	2	Sơ chế	Sơ chế cho xôi gấc phiên bản 100, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	11	\N
94181f67-5d78-4b8d-aa4b-b4a6edb422d3	2026-09-22 16:40:27.935108+00	\N	f	1	a2252302-6dcd-4676-9894-6d61e5bdbc95	3	Ướp gia vị	Ướp gia vị cho xôi gấc phiên bản 100, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.	20	\N
5304c727-af88-437a-9a4f-2a4a0beebc5b	2026-09-22 16:40:27.935108+00	\N	f	1	a2252302-6dcd-4676-9894-6d61e5bdbc95	4	Làm nóng chảo	Làm nóng chảo cho xôi gấc phiên bản 100, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	10	\N
6221983e-6817-44de-af89-55e1d94be3ed	2026-09-22 16:40:27.935108+00	\N	f	1	a2252302-6dcd-4676-9894-6d61e5bdbc95	5	Chế biến phần chính	Chế biến phần chính cho xôi gấc phiên bản 100, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	11	\N
d9277f8e-9071-4158-a1c3-b0220db70a03	2026-09-22 16:40:27.935108+00	\N	f	1	a2252302-6dcd-4676-9894-6d61e5bdbc95	6	Nêm nếm	Nêm nếm cho xôi gấc phiên bản 100, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	16	\N
73240324-d868-4a13-bb3c-592878a058f3	2026-09-22 16:40:27.935108+00	\N	f	1	a2252302-6dcd-4676-9894-6d61e5bdbc95	7	Hoàn thiện và trình bày	Hoàn thiện và trình bày cho xôi gấc phiên bản 100, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	13	\N
\.


--
-- Data for Name: recipes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.recipes (id, created_at, updated_at, is_deleted, row_version, category_id, status, title, slug, description, instructions, prep_time, cook_time, servings, difficulty, author_id, published_at, nutrition_calories, nutrition_protein, nutrition_carbohydrates, nutrition_fat, nutrition_fiber, nutrition_sodium) FROM stdin;
3787d4e3-76f7-4e24-b1ec-02d9dc13d6e0	2026-09-22 16:40:27.935108+00	\N	f	1	84195f7c-4f8b-45a5-8bff-59d7520c4322	Published	Cơm gà phiên bản 001	lab2-recipe-001	Công thức mẫu cơm gà phiên bản 001 thuộc Món Việt.	1. Chuẩn bị nguyên liệu cho cơm gà phiên bản 001, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.\n2. Sơ chế cho cơm gà phiên bản 001, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.\n3. Ướp gia vị cho cơm gà phiên bản 001, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n4. Làm nóng chảo cho cơm gà phiên bản 001, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n5. Chế biến phần chính cho cơm gà phiên bản 001, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	10	32	6	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:27.949+00	\N	\N	\N	\N	\N	\N
1703c731-fb1d-4e84-ba8a-adbdeed3dad6	2026-09-22 16:40:27.935108+00	\N	f	1	82d6aa2c-4c63-4208-afcb-39a2b20e25fe	Published	Bún bò phiên bản 002	lab2-recipe-002	Công thức mẫu bún bò phiên bản 002 thuộc Món Á.	1. Chuẩn bị nguyên liệu cho bún bò phiên bản 002, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.\n2. Sơ chế cho bún bò phiên bản 002, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.\n3. Ướp gia vị cho bún bò phiên bản 002, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n4. Làm nóng chảo cho bún bò phiên bản 002, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n5. Chế biến phần chính cho bún bò phiên bản 002, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n6. Nêm nếm cho bún bò phiên bản 002, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n7. Hoàn thiện và trình bày cho bún bò phiên bản 002, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	30	26	2	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:27.956+00	\N	\N	\N	\N	\N	\N
b40ee684-3a0c-495f-b9a6-bfc26d73e009	2026-09-22 16:40:27.935108+00	\N	f	1	058020db-2ae1-444d-9dd8-36925696092d	Published	Mì rau củ phiên bản 003	lab2-recipe-003	Công thức mẫu mì rau củ phiên bản 003 thuộc Món Âu.	1. Chuẩn bị nguyên liệu cho mì rau củ phiên bản 003, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.\n2. Sơ chế cho mì rau củ phiên bản 003, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.\n3. Ướp gia vị cho mì rau củ phiên bản 003, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n4. Làm nóng chảo cho mì rau củ phiên bản 003, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n5. Chế biến phần chính cho mì rau củ phiên bản 003, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	13	58	2	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:27.96+00	\N	\N	\N	\N	\N	\N
050092b5-1c6f-4445-a54e-612ce26146a9	2026-09-22 16:40:27.935108+00	\N	f	1	af794161-e952-4746-9bfe-ae1023f82546	Published	Đậu hũ sốt phiên bản 004	lab2-recipe-004	Công thức mẫu đậu hũ sốt phiên bản 004 thuộc Món chay.	1. Chuẩn bị nguyên liệu cho đậu hũ sốt phiên bản 004, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n2. Sơ chế cho đậu hũ sốt phiên bản 004, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n3. Ướp gia vị cho đậu hũ sốt phiên bản 004, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.\n4. Làm nóng chảo cho đậu hũ sốt phiên bản 004, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.\n5. Chế biến phần chính cho đậu hũ sốt phiên bản 004, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.\n6. Nêm nếm cho đậu hũ sốt phiên bản 004, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n7. Hoàn thiện và trình bày cho đậu hũ sốt phiên bản 004, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	14	42	3	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:27.963+00	\N	\N	\N	\N	\N	\N
2394e84b-4eee-4ad5-9013-515f70a3ab4d	2026-09-22 16:40:27.935108+00	\N	f	1	19d6294c-4afb-4fac-901b-1f474784a6cd	Published	Cá nướng phiên bản 005	lab2-recipe-005	Công thức mẫu cá nướng phiên bản 005 thuộc Món nướng.	1. Chuẩn bị nguyên liệu cho cá nướng phiên bản 005, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.\n2. Sơ chế cho cá nướng phiên bản 005, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n3. Ướp gia vị cho cá nướng phiên bản 005, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n4. Làm nóng chảo cho cá nướng phiên bản 005, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.\n5. Chế biến phần chính cho cá nướng phiên bản 005, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.\n6. Nêm nếm cho cá nướng phiên bản 005, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.\n7. Hoàn thiện và trình bày cho cá nướng phiên bản 005, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	12	17	4	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:27.967+00	\N	\N	\N	\N	\N	\N
0c889484-df93-4a39-897a-e992dcf725e4	2026-09-22 16:40:27.935108+00	\N	f	1	0aef3997-c3e3-4a21-90c5-7a094bfd1846	Published	Gà hấp phiên bản 006	lab2-recipe-006	Công thức mẫu gà hấp phiên bản 006 thuộc Món hấp.	1. Chuẩn bị nguyên liệu cho gà hấp phiên bản 006, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.\n2. Sơ chế cho gà hấp phiên bản 006, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.\n3. Ướp gia vị cho gà hấp phiên bản 006, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n4. Làm nóng chảo cho gà hấp phiên bản 006, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n5. Chế biến phần chính cho gà hấp phiên bản 006, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n6. Nêm nếm cho gà hấp phiên bản 006, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	12	54	5	Easy	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:27.97+00	\N	\N	\N	\N	\N	\N
6510d19c-8538-43f3-8d99-6ec5f71ac9cf	2026-09-22 16:40:27.935108+00	\N	f	1	18f03254-878b-42c6-95bd-b19c6aa08642	Published	Thịt xào phiên bản 007	lab2-recipe-007	Công thức mẫu thịt xào phiên bản 007 thuộc Món xào.	1. Chuẩn bị nguyên liệu cho thịt xào phiên bản 007, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.\n2. Sơ chế cho thịt xào phiên bản 007, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n3. Ướp gia vị cho thịt xào phiên bản 007, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.\n4. Làm nóng chảo cho thịt xào phiên bản 007, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n5. Chế biến phần chính cho thịt xào phiên bản 007, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	27	34	5	Easy	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:27.973+00	\N	\N	\N	\N	\N	\N
88fa97ba-ecba-4c7e-8ea4-064022350579	2026-09-22 16:40:27.935108+00	\N	f	1	e66b86e1-4212-428a-a67d-c93d7b13491e	Published	Cá kho phiên bản 029	lab2-recipe-029	Công thức mẫu cá kho phiên bản 029 thuộc Món kho.	1. Chuẩn bị nguyên liệu cho cá kho phiên bản 029, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n2. Sơ chế cho cá kho phiên bản 029, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.\n3. Ướp gia vị cho cá kho phiên bản 029, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n4. Làm nóng chảo cho cá kho phiên bản 029, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n5. Chế biến phần chính cho cá kho phiên bản 029, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.	25	30	6	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.038+00	\N	\N	\N	\N	\N	\N
970ab102-0421-42a7-8494-6b67971d7ac3	2026-09-22 16:40:27.935108+00	\N	f	1	cc7b4987-5b04-4d3d-8dfb-bdb425310a43	Published	Tôm chiên phiên bản 008	lab2-recipe-008	Công thức mẫu tôm chiên phiên bản 008 thuộc Món chiên.	1. Chuẩn bị nguyên liệu cho tôm chiên phiên bản 008, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.\n2. Sơ chế cho tôm chiên phiên bản 008, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.\n3. Ướp gia vị cho tôm chiên phiên bản 008, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n4. Làm nóng chảo cho tôm chiên phiên bản 008, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.\n5. Chế biến phần chính cho tôm chiên phiên bản 008, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.\n6. Nêm nếm cho tôm chiên phiên bản 008, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.\n7. Hoàn thiện và trình bày cho tôm chiên phiên bản 008, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	13	19	4	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:27.976+00	\N	\N	\N	\N	\N	\N
75cfa00e-2706-4f44-bb2e-a391e66446d1	2026-09-22 16:40:27.935108+00	\N	f	1	e66b86e1-4212-428a-a67d-c93d7b13491e	Published	Cá kho phiên bản 009	lab2-recipe-009	Công thức mẫu cá kho phiên bản 009 thuộc Món kho.	1. Chuẩn bị nguyên liệu cho cá kho phiên bản 009, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.\n2. Sơ chế cho cá kho phiên bản 009, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.\n3. Ướp gia vị cho cá kho phiên bản 009, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n4. Làm nóng chảo cho cá kho phiên bản 009, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n5. Chế biến phần chính cho cá kho phiên bản 009, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.\n6. Nêm nếm cho cá kho phiên bản 009, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n7. Hoàn thiện và trình bày cho cá kho phiên bản 009, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	15	45	5	Easy	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:27.979+00	\N	\N	\N	\N	\N	\N
788bda25-29a3-4dc9-887a-229470df72b1	2026-09-22 16:40:27.935108+00	\N	f	1	bff0da8f-b4d4-4abf-9ee0-6745b206152e	Published	Canh bí phiên bản 010	lab2-recipe-010	Công thức mẫu canh bí phiên bản 010 thuộc Món canh.	1. Chuẩn bị nguyên liệu cho canh bí phiên bản 010, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.\n2. Sơ chế cho canh bí phiên bản 010, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.\n3. Ướp gia vị cho canh bí phiên bản 010, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.\n4. Làm nóng chảo cho canh bí phiên bản 010, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.\n5. Chế biến phần chính cho canh bí phiên bản 010, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n6. Nêm nếm cho canh bí phiên bản 010, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	18	37	5	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:27.982+00	\N	\N	\N	\N	\N	\N
6c5a11c1-fbae-44ca-92e5-e723cc2041e9	2026-09-22 16:40:27.935108+00	\N	f	1	db88f651-9af0-457c-8479-e358ae00119a	Published	Súp nấm phiên bản 011	lab2-recipe-011	Công thức mẫu súp nấm phiên bản 011 thuộc Món súp.	1. Chuẩn bị nguyên liệu cho súp nấm phiên bản 011, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.\n2. Sơ chế cho súp nấm phiên bản 011, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.\n3. Ướp gia vị cho súp nấm phiên bản 011, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.\n4. Làm nóng chảo cho súp nấm phiên bản 011, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.\n5. Chế biến phần chính cho súp nấm phiên bản 011, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n6. Nêm nếm cho súp nấm phiên bản 011, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	28	47	6	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:27.985+00	\N	\N	\N	\N	\N	\N
64ec096c-f2d9-410a-aa22-ee25b77345cb	2026-09-22 16:40:27.935108+00	\N	f	1	9e9a056b-76d8-4803-b59e-b28e2f0728c1	Published	Cơm rang phiên bản 012	lab2-recipe-012	Công thức mẫu cơm rang phiên bản 012 thuộc Món cơm.	1. Chuẩn bị nguyên liệu cho cơm rang phiên bản 012, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n2. Sơ chế cho cơm rang phiên bản 012, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n3. Ướp gia vị cho cơm rang phiên bản 012, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n4. Làm nóng chảo cho cơm rang phiên bản 012, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n5. Chế biến phần chính cho cơm rang phiên bản 012, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n6. Nêm nếm cho cơm rang phiên bản 012, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	10	26	6	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:27.988+00	\N	\N	\N	\N	\N	\N
f1a8a3e3-9e06-4520-94f8-7b1dcce6166a	2026-09-22 16:40:27.935108+00	\N	f	1	c8bad750-acdb-4077-a4e1-2ae6d13b63c2	Published	Mì xào phiên bản 013	lab2-recipe-013	Công thức mẫu mì xào phiên bản 013 thuộc Món mì.	1. Chuẩn bị nguyên liệu cho mì xào phiên bản 013, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.\n2. Sơ chế cho mì xào phiên bản 013, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.\n3. Ướp gia vị cho mì xào phiên bản 013, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.\n4. Làm nóng chảo cho mì xào phiên bản 013, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.\n5. Chế biến phần chính cho mì xào phiên bản 013, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n6. Nêm nếm cho mì xào phiên bản 013, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.\n7. Hoàn thiện và trình bày cho mì xào phiên bản 013, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	15	34	6	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:27.991+00	\N	\N	\N	\N	\N	\N
a347dce3-40ce-4ffb-8e3d-f24d88d19404	2026-09-22 16:40:27.935108+00	\N	f	1	b6763cb8-2c61-423c-9c26-f0ddd11eaa51	Published	Bún thịt phiên bản 014	lab2-recipe-014	Công thức mẫu bún thịt phiên bản 014 thuộc Món bún.	1. Chuẩn bị nguyên liệu cho bún thịt phiên bản 014, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.\n2. Sơ chế cho bún thịt phiên bản 014, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.\n3. Ướp gia vị cho bún thịt phiên bản 014, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.\n4. Làm nóng chảo cho bún thịt phiên bản 014, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n5. Chế biến phần chính cho bún thịt phiên bản 014, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.\n6. Nêm nếm cho bún thịt phiên bản 014, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	12	32	4	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:27.994+00	\N	\N	\N	\N	\N	\N
018f344f-43b8-4593-bb41-5c94eb229f62	2026-09-22 16:40:27.935108+00	\N	f	1	87366ac5-9a02-419a-af8c-7dc296ded1dc	Published	Bánh khoai phiên bản 015	lab2-recipe-015	Công thức mẫu bánh khoai phiên bản 015 thuộc Món bánh.	1. Chuẩn bị nguyên liệu cho bánh khoai phiên bản 015, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.\n2. Sơ chế cho bánh khoai phiên bản 015, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.\n3. Ướp gia vị cho bánh khoai phiên bản 015, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.\n4. Làm nóng chảo cho bánh khoai phiên bản 015, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n5. Chế biến phần chính cho bánh khoai phiên bản 015, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n6. Nêm nếm cho bánh khoai phiên bản 015, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.\n7. Hoàn thiện và trình bày cho bánh khoai phiên bản 015, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	26	50	5	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:27.997+00	\N	\N	\N	\N	\N	\N
faf4d8d6-f61e-4245-ac7d-c2e75e566caa	2026-09-22 16:40:27.935108+00	\N	f	1	a9a5cf88-5f7a-420a-9c33-d3ccc7e83405	Published	Chè đậu phiên bản 016	lab2-recipe-016	Công thức mẫu chè đậu phiên bản 016 thuộc Món tráng miệng.	1. Chuẩn bị nguyên liệu cho chè đậu phiên bản 016, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.\n2. Sơ chế cho chè đậu phiên bản 016, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.\n3. Ướp gia vị cho chè đậu phiên bản 016, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n4. Làm nóng chảo cho chè đậu phiên bản 016, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.\n5. Chế biến phần chính cho chè đậu phiên bản 016, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n6. Nêm nếm cho chè đậu phiên bản 016, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.\n7. Hoàn thiện và trình bày cho chè đậu phiên bản 016, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	18	58	5	Easy	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28+00	\N	\N	\N	\N	\N	\N
d158485e-362a-424a-97e5-09b0c64ef412	2026-09-22 16:40:27.935108+00	\N	f	1	96cfe3d7-3e7b-4863-ac69-3223877f6fda	Published	Bánh mì trứng phiên bản 017	lab2-recipe-017	Công thức mẫu bánh mì trứng phiên bản 017 thuộc Món ăn sáng.	1. Chuẩn bị nguyên liệu cho bánh mì trứng phiên bản 017, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n2. Sơ chế cho bánh mì trứng phiên bản 017, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.\n3. Ướp gia vị cho bánh mì trứng phiên bản 017, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.\n4. Làm nóng chảo cho bánh mì trứng phiên bản 017, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n5. Chế biến phần chính cho bánh mì trứng phiên bản 017, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n6. Nêm nếm cho bánh mì trứng phiên bản 017, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.\n7. Hoàn thiện và trình bày cho bánh mì trứng phiên bản 017, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	28	30	4	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.002+00	\N	\N	\N	\N	\N	\N
4282d768-5d60-4c3b-bb2a-022ef252b7fe	2026-09-22 16:40:27.935108+00	\N	f	1	2c0638cb-2557-4242-b543-1f520de0ed53	Published	Gỏi cuốn phiên bản 018	lab2-recipe-018	Công thức mẫu gỏi cuốn phiên bản 018 thuộc Món ăn nhẹ.	1. Chuẩn bị nguyên liệu cho gỏi cuốn phiên bản 018, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n2. Sơ chế cho gỏi cuốn phiên bản 018, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.\n3. Ướp gia vị cho gỏi cuốn phiên bản 018, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n4. Làm nóng chảo cho gỏi cuốn phiên bản 018, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n5. Chế biến phần chính cho gỏi cuốn phiên bản 018, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.\n6. Nêm nếm cho gỏi cuốn phiên bản 018, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.\n7. Hoàn thiện và trình bày cho gỏi cuốn phiên bản 018, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	23	33	4	Easy	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.006+00	\N	\N	\N	\N	\N	\N
25dc4e45-c780-4f24-bf7f-30f10f1c8cfe	2026-09-22 16:40:27.935108+00	\N	f	1	c0fe3e7d-920b-43bd-97fd-90eab8b8eb3a	Published	Lẩu rau phiên bản 019	lab2-recipe-019	Công thức mẫu lẩu rau phiên bản 019 thuộc Món gia đình.	1. Chuẩn bị nguyên liệu cho lẩu rau phiên bản 019, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.\n2. Sơ chế cho lẩu rau phiên bản 019, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.\n3. Ướp gia vị cho lẩu rau phiên bản 019, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.\n4. Làm nóng chảo cho lẩu rau phiên bản 019, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n5. Chế biến phần chính cho lẩu rau phiên bản 019, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	26	50	5	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.009+00	\N	\N	\N	\N	\N	\N
65dde4a2-ae27-4dfe-ba8d-0d8acf6d615e	2026-09-22 16:40:27.935108+00	\N	f	1	5b8d9b6c-4ebc-4012-bd51-6b12ab970582	Published	Xôi gấc phiên bản 020	lab2-recipe-020	Công thức mẫu xôi gấc phiên bản 020 thuộc Món ngày lễ.	1. Chuẩn bị nguyên liệu cho xôi gấc phiên bản 020, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.\n2. Sơ chế cho xôi gấc phiên bản 020, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n3. Ướp gia vị cho xôi gấc phiên bản 020, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.\n4. Làm nóng chảo cho xôi gấc phiên bản 020, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.\n5. Chế biến phần chính cho xôi gấc phiên bản 020, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.\n6. Nêm nếm cho xôi gấc phiên bản 020, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n7. Hoàn thiện và trình bày cho xôi gấc phiên bản 020, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	29	46	6	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.013+00	\N	\N	\N	\N	\N	\N
bddd9f3d-8139-420a-aecc-70be4d87d38d	2026-09-22 16:40:27.935108+00	\N	f	1	84195f7c-4f8b-45a5-8bff-59d7520c4322	Published	Cơm gà phiên bản 021	lab2-recipe-021	Công thức mẫu cơm gà phiên bản 021 thuộc Món Việt.	1. Chuẩn bị nguyên liệu cho cơm gà phiên bản 021, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n2. Sơ chế cho cơm gà phiên bản 021, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.\n3. Ướp gia vị cho cơm gà phiên bản 021, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.\n4. Làm nóng chảo cho cơm gà phiên bản 021, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n5. Chế biến phần chính cho cơm gà phiên bản 021, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.\n6. Nêm nếm cho cơm gà phiên bản 021, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	14	50	6	Easy	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.016+00	\N	\N	\N	\N	\N	\N
32b68618-1ac3-4b3c-95fb-6fb93ef0fa5b	2026-09-22 16:40:27.935108+00	\N	f	1	82d6aa2c-4c63-4208-afcb-39a2b20e25fe	Published	Bún bò phiên bản 022	lab2-recipe-022	Công thức mẫu bún bò phiên bản 022 thuộc Món Á.	1. Chuẩn bị nguyên liệu cho bún bò phiên bản 022, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.\n2. Sơ chế cho bún bò phiên bản 022, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.\n3. Ướp gia vị cho bún bò phiên bản 022, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n4. Làm nóng chảo cho bún bò phiên bản 022, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n5. Chế biến phần chính cho bún bò phiên bản 022, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n6. Nêm nếm cho bún bò phiên bản 022, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.\n7. Hoàn thiện và trình bày cho bún bò phiên bản 022, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	21	49	2	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.018+00	\N	\N	\N	\N	\N	\N
420a4583-b573-4ae5-9323-c9e6d990fdcd	2026-09-22 16:40:27.935108+00	\N	f	1	058020db-2ae1-444d-9dd8-36925696092d	Published	Mì rau củ phiên bản 023	lab2-recipe-023	Công thức mẫu mì rau củ phiên bản 023 thuộc Món Âu.	1. Chuẩn bị nguyên liệu cho mì rau củ phiên bản 023, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.\n2. Sơ chế cho mì rau củ phiên bản 023, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n3. Ướp gia vị cho mì rau củ phiên bản 023, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n4. Làm nóng chảo cho mì rau củ phiên bản 023, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n5. Chế biến phần chính cho mì rau củ phiên bản 023, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.\n6. Nêm nếm cho mì rau củ phiên bản 023, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.\n7. Hoàn thiện và trình bày cho mì rau củ phiên bản 023, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	28	21	6	Easy	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.021+00	\N	\N	\N	\N	\N	\N
38804e6d-578b-4e82-9cdb-94d6589cd8bc	2026-09-22 16:40:27.935108+00	\N	f	1	af794161-e952-4746-9bfe-ae1023f82546	Published	Đậu hũ sốt phiên bản 024	lab2-recipe-024	Công thức mẫu đậu hũ sốt phiên bản 024 thuộc Món chay.	1. Chuẩn bị nguyên liệu cho đậu hũ sốt phiên bản 024, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n2. Sơ chế cho đậu hũ sốt phiên bản 024, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.\n3. Ướp gia vị cho đậu hũ sốt phiên bản 024, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.\n4. Làm nóng chảo cho đậu hũ sốt phiên bản 024, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n5. Chế biến phần chính cho đậu hũ sốt phiên bản 024, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n6. Nêm nếm cho đậu hũ sốt phiên bản 024, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n7. Hoàn thiện và trình bày cho đậu hũ sốt phiên bản 024, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	18	43	3	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.024+00	\N	\N	\N	\N	\N	\N
02c695ba-3c71-4ca4-bf1f-305be744eba2	2026-09-22 16:40:27.935108+00	\N	f	1	19d6294c-4afb-4fac-901b-1f474784a6cd	Published	Cá nướng phiên bản 025	lab2-recipe-025	Công thức mẫu cá nướng phiên bản 025 thuộc Món nướng.	1. Chuẩn bị nguyên liệu cho cá nướng phiên bản 025, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.\n2. Sơ chế cho cá nướng phiên bản 025, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n3. Ướp gia vị cho cá nướng phiên bản 025, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.\n4. Làm nóng chảo cho cá nướng phiên bản 025, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.\n5. Chế biến phần chính cho cá nướng phiên bản 025, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	25	23	3	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.027+00	\N	\N	\N	\N	\N	\N
4311dbd4-6e85-453a-a8cf-3c412f8e3ce0	2026-09-22 16:40:27.935108+00	\N	f	1	0aef3997-c3e3-4a21-90c5-7a094bfd1846	Published	Gà hấp phiên bản 026	lab2-recipe-026	Công thức mẫu gà hấp phiên bản 026 thuộc Món hấp.	1. Chuẩn bị nguyên liệu cho gà hấp phiên bản 026, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.\n2. Sơ chế cho gà hấp phiên bản 026, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n3. Ướp gia vị cho gà hấp phiên bản 026, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.\n4. Làm nóng chảo cho gà hấp phiên bản 026, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.\n5. Chế biến phần chính cho gà hấp phiên bản 026, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.\n6. Nêm nếm cho gà hấp phiên bản 026, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	16	18	3	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.029+00	\N	\N	\N	\N	\N	\N
d242f842-9539-4034-8f4f-c021704e5abb	2026-09-22 16:40:27.935108+00	\N	f	1	18f03254-878b-42c6-95bd-b19c6aa08642	Published	Thịt xào phiên bản 027	lab2-recipe-027	Công thức mẫu thịt xào phiên bản 027 thuộc Món xào.	1. Chuẩn bị nguyên liệu cho thịt xào phiên bản 027, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n2. Sơ chế cho thịt xào phiên bản 027, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.\n3. Ướp gia vị cho thịt xào phiên bản 027, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.\n4. Làm nóng chảo cho thịt xào phiên bản 027, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.\n5. Chế biến phần chính cho thịt xào phiên bản 027, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n6. Nêm nếm cho thịt xào phiên bản 027, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	26	29	4	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.032+00	\N	\N	\N	\N	\N	\N
bb91ff4a-ebdc-4aba-90f0-aa1f32b7bcde	2026-09-22 16:40:27.935108+00	\N	f	1	cc7b4987-5b04-4d3d-8dfb-bdb425310a43	Published	Tôm chiên phiên bản 028	lab2-recipe-028	Công thức mẫu tôm chiên phiên bản 028 thuộc Món chiên.	1. Chuẩn bị nguyên liệu cho tôm chiên phiên bản 028, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.\n2. Sơ chế cho tôm chiên phiên bản 028, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.\n3. Ướp gia vị cho tôm chiên phiên bản 028, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.\n4. Làm nóng chảo cho tôm chiên phiên bản 028, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.\n5. Chế biến phần chính cho tôm chiên phiên bản 028, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.\n6. Nêm nếm cho tôm chiên phiên bản 028, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	18	16	5	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.035+00	\N	\N	\N	\N	\N	\N
6e5dc0c4-9ebd-4c6f-9b12-a6a866a6fd2d	2026-09-22 16:40:27.935108+00	\N	f	1	bff0da8f-b4d4-4abf-9ee0-6745b206152e	Published	Canh bí phiên bản 030	lab2-recipe-030	Công thức mẫu canh bí phiên bản 030 thuộc Món canh.	1. Chuẩn bị nguyên liệu cho canh bí phiên bản 030, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n2. Sơ chế cho canh bí phiên bản 030, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.\n3. Ướp gia vị cho canh bí phiên bản 030, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n4. Làm nóng chảo cho canh bí phiên bản 030, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.\n5. Chế biến phần chính cho canh bí phiên bản 030, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n6. Nêm nếm cho canh bí phiên bản 030, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	10	39	6	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.041+00	\N	\N	\N	\N	\N	\N
aa6fb2ef-abf8-403f-aa8e-426b37f45c7c	2026-09-22 16:40:27.935108+00	\N	f	1	db88f651-9af0-457c-8479-e358ae00119a	Published	Súp nấm phiên bản 031	lab2-recipe-031	Công thức mẫu súp nấm phiên bản 031 thuộc Món súp.	1. Chuẩn bị nguyên liệu cho súp nấm phiên bản 031, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.\n2. Sơ chế cho súp nấm phiên bản 031, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.\n3. Ướp gia vị cho súp nấm phiên bản 031, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n4. Làm nóng chảo cho súp nấm phiên bản 031, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.\n5. Chế biến phần chính cho súp nấm phiên bản 031, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n6. Nêm nếm cho súp nấm phiên bản 031, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	15	56	5	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.053+00	\N	\N	\N	\N	\N	\N
40da8dea-a2d9-49d0-b54c-ed06024f7f9c	2026-09-22 16:40:27.935108+00	\N	f	1	9e9a056b-76d8-4803-b59e-b28e2f0728c1	Published	Cơm rang phiên bản 032	lab2-recipe-032	Công thức mẫu cơm rang phiên bản 032 thuộc Món cơm.	1. Chuẩn bị nguyên liệu cho cơm rang phiên bản 032, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.\n2. Sơ chế cho cơm rang phiên bản 032, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n3. Ướp gia vị cho cơm rang phiên bản 032, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.\n4. Làm nóng chảo cho cơm rang phiên bản 032, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n5. Chế biến phần chính cho cơm rang phiên bản 032, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n6. Nêm nếm cho cơm rang phiên bản 032, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.\n7. Hoàn thiện và trình bày cho cơm rang phiên bản 032, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	15	27	4	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.056+00	\N	\N	\N	\N	\N	\N
644080d9-bb15-4924-942f-11382b57b7d2	2026-09-22 16:40:27.935108+00	\N	f	1	c8bad750-acdb-4077-a4e1-2ae6d13b63c2	Published	Mì xào phiên bản 033	lab2-recipe-033	Công thức mẫu mì xào phiên bản 033 thuộc Món mì.	1. Chuẩn bị nguyên liệu cho mì xào phiên bản 033, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n2. Sơ chế cho mì xào phiên bản 033, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n3. Ướp gia vị cho mì xào phiên bản 033, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n4. Làm nóng chảo cho mì xào phiên bản 033, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n5. Chế biến phần chính cho mì xào phiên bản 033, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.\n6. Nêm nếm cho mì xào phiên bản 033, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.\n7. Hoàn thiện và trình bày cho mì xào phiên bản 033, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	27	43	2	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.059+00	\N	\N	\N	\N	\N	\N
b66fb87b-4e6b-43d2-ad8f-5dbc6cab2cef	2026-09-22 16:40:27.935108+00	\N	f	1	b6763cb8-2c61-423c-9c26-f0ddd11eaa51	Published	Bún thịt phiên bản 034	lab2-recipe-034	Công thức mẫu bún thịt phiên bản 034 thuộc Món bún.	1. Chuẩn bị nguyên liệu cho bún thịt phiên bản 034, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n2. Sơ chế cho bún thịt phiên bản 034, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n3. Ướp gia vị cho bún thịt phiên bản 034, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n4. Làm nóng chảo cho bún thịt phiên bản 034, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.\n5. Chế biến phần chính cho bún thịt phiên bản 034, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	29	54	3	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.063+00	\N	\N	\N	\N	\N	\N
664c65ce-22e6-4391-a9ba-61d862f98ff8	2026-09-22 16:40:27.935108+00	\N	f	1	87366ac5-9a02-419a-af8c-7dc296ded1dc	Published	Bánh khoai phiên bản 035	lab2-recipe-035	Công thức mẫu bánh khoai phiên bản 035 thuộc Món bánh.	1. Chuẩn bị nguyên liệu cho bánh khoai phiên bản 035, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.\n2. Sơ chế cho bánh khoai phiên bản 035, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n3. Ướp gia vị cho bánh khoai phiên bản 035, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.\n4. Làm nóng chảo cho bánh khoai phiên bản 035, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n5. Chế biến phần chính cho bánh khoai phiên bản 035, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.\n6. Nêm nếm cho bánh khoai phiên bản 035, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n7. Hoàn thiện và trình bày cho bánh khoai phiên bản 035, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	19	34	2	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.066+00	\N	\N	\N	\N	\N	\N
3b0774bd-aa26-49e3-bff4-1ebaaca8f01c	2026-09-22 16:40:27.935108+00	\N	f	1	a9a5cf88-5f7a-420a-9c33-d3ccc7e83405	Published	Chè đậu phiên bản 036	lab2-recipe-036	Công thức mẫu chè đậu phiên bản 036 thuộc Món tráng miệng.	1. Chuẩn bị nguyên liệu cho chè đậu phiên bản 036, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n2. Sơ chế cho chè đậu phiên bản 036, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.\n3. Ướp gia vị cho chè đậu phiên bản 036, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.\n4. Làm nóng chảo cho chè đậu phiên bản 036, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.\n5. Chế biến phần chính cho chè đậu phiên bản 036, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.\n6. Nêm nếm cho chè đậu phiên bản 036, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	22	28	6	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.068+00	\N	\N	\N	\N	\N	\N
f38b31dd-0ed1-405f-84fd-de5aafe547e7	2026-09-22 16:40:27.935108+00	\N	f	1	96cfe3d7-3e7b-4863-ac69-3223877f6fda	Published	Bánh mì trứng phiên bản 037	lab2-recipe-037	Công thức mẫu bánh mì trứng phiên bản 037 thuộc Món ăn sáng.	1. Chuẩn bị nguyên liệu cho bánh mì trứng phiên bản 037, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.\n2. Sơ chế cho bánh mì trứng phiên bản 037, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n3. Ướp gia vị cho bánh mì trứng phiên bản 037, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n4. Làm nóng chảo cho bánh mì trứng phiên bản 037, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.\n5. Chế biến phần chính cho bánh mì trứng phiên bản 037, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.\n6. Nêm nếm cho bánh mì trứng phiên bản 037, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n7. Hoàn thiện và trình bày cho bánh mì trứng phiên bản 037, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	28	54	3	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.071+00	\N	\N	\N	\N	\N	\N
ab32138f-bda8-4ae3-a101-c5e9ac792092	2026-09-22 16:40:27.935108+00	\N	f	1	2c0638cb-2557-4242-b543-1f520de0ed53	Published	Gỏi cuốn phiên bản 038	lab2-recipe-038	Công thức mẫu gỏi cuốn phiên bản 038 thuộc Món ăn nhẹ.	1. Chuẩn bị nguyên liệu cho gỏi cuốn phiên bản 038, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.\n2. Sơ chế cho gỏi cuốn phiên bản 038, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.\n3. Ướp gia vị cho gỏi cuốn phiên bản 038, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.\n4. Làm nóng chảo cho gỏi cuốn phiên bản 038, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.\n5. Chế biến phần chính cho gỏi cuốn phiên bản 038, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.\n6. Nêm nếm cho gỏi cuốn phiên bản 038, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.\n7. Hoàn thiện và trình bày cho gỏi cuốn phiên bản 038, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	11	49	4	Easy	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.076+00	\N	\N	\N	\N	\N	\N
7ad9241a-0d83-4794-8307-e94ebf4194e9	2026-09-22 16:40:27.935108+00	\N	f	1	c0fe3e7d-920b-43bd-97fd-90eab8b8eb3a	Published	Lẩu rau phiên bản 039	lab2-recipe-039	Công thức mẫu lẩu rau phiên bản 039 thuộc Món gia đình.	1. Chuẩn bị nguyên liệu cho lẩu rau phiên bản 039, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.\n2. Sơ chế cho lẩu rau phiên bản 039, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.\n3. Ướp gia vị cho lẩu rau phiên bản 039, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.\n4. Làm nóng chảo cho lẩu rau phiên bản 039, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.\n5. Chế biến phần chính cho lẩu rau phiên bản 039, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.\n6. Nêm nếm cho lẩu rau phiên bản 039, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n7. Hoàn thiện và trình bày cho lẩu rau phiên bản 039, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	23	32	3	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.08+00	\N	\N	\N	\N	\N	\N
40548af9-3dd2-4ce5-810c-82997ed49b9f	2026-09-22 16:40:27.935108+00	\N	f	1	5b8d9b6c-4ebc-4012-bd51-6b12ab970582	Published	Xôi gấc phiên bản 040	lab2-recipe-040	Công thức mẫu xôi gấc phiên bản 040 thuộc Món ngày lễ.	1. Chuẩn bị nguyên liệu cho xôi gấc phiên bản 040, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n2. Sơ chế cho xôi gấc phiên bản 040, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n3. Ướp gia vị cho xôi gấc phiên bản 040, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n4. Làm nóng chảo cho xôi gấc phiên bản 040, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n5. Chế biến phần chính cho xôi gấc phiên bản 040, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.\n6. Nêm nếm cho xôi gấc phiên bản 040, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	26	50	2	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.083+00	\N	\N	\N	\N	\N	\N
e386d488-0cc6-4148-a6f4-a0d843ef4ae1	2026-09-22 16:40:27.935108+00	\N	f	1	84195f7c-4f8b-45a5-8bff-59d7520c4322	Published	Cơm gà phiên bản 041	lab2-recipe-041	Công thức mẫu cơm gà phiên bản 041 thuộc Món Việt.	1. Chuẩn bị nguyên liệu cho cơm gà phiên bản 041, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n2. Sơ chế cho cơm gà phiên bản 041, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.\n3. Ướp gia vị cho cơm gà phiên bản 041, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n4. Làm nóng chảo cho cơm gà phiên bản 041, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.\n5. Chế biến phần chính cho cơm gà phiên bản 041, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	21	49	2	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.085+00	\N	\N	\N	\N	\N	\N
bd5136c1-3f17-4512-868b-1f41b331b3e4	2026-09-22 16:40:27.935108+00	\N	f	1	82d6aa2c-4c63-4208-afcb-39a2b20e25fe	Published	Bún bò phiên bản 042	lab2-recipe-042	Công thức mẫu bún bò phiên bản 042 thuộc Món Á.	1. Chuẩn bị nguyên liệu cho bún bò phiên bản 042, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n2. Sơ chế cho bún bò phiên bản 042, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.\n3. Ướp gia vị cho bún bò phiên bản 042, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n4. Làm nóng chảo cho bún bò phiên bản 042, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.\n5. Chế biến phần chính cho bún bò phiên bản 042, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.\n6. Nêm nếm cho bún bò phiên bản 042, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.\n7. Hoàn thiện và trình bày cho bún bò phiên bản 042, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	11	18	5	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.088+00	\N	\N	\N	\N	\N	\N
66a59220-a831-40de-9488-373cf8906b51	2026-09-22 16:40:27.935108+00	\N	f	1	058020db-2ae1-444d-9dd8-36925696092d	Published	Mì rau củ phiên bản 043	lab2-recipe-043	Công thức mẫu mì rau củ phiên bản 043 thuộc Món Âu.	1. Chuẩn bị nguyên liệu cho mì rau củ phiên bản 043, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.\n2. Sơ chế cho mì rau củ phiên bản 043, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n3. Ướp gia vị cho mì rau củ phiên bản 043, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n4. Làm nóng chảo cho mì rau củ phiên bản 043, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n5. Chế biến phần chính cho mì rau củ phiên bản 043, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n6. Nêm nếm cho mì rau củ phiên bản 043, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	26	56	3	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.091+00	\N	\N	\N	\N	\N	\N
fbb77065-b828-4f55-b260-d0555e7f2e4c	2026-09-22 16:40:27.935108+00	\N	f	1	af794161-e952-4746-9bfe-ae1023f82546	Published	Đậu hũ sốt phiên bản 044	lab2-recipe-044	Công thức mẫu đậu hũ sốt phiên bản 044 thuộc Món chay.	1. Chuẩn bị nguyên liệu cho đậu hũ sốt phiên bản 044, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.\n2. Sơ chế cho đậu hũ sốt phiên bản 044, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n3. Ướp gia vị cho đậu hũ sốt phiên bản 044, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.\n4. Làm nóng chảo cho đậu hũ sốt phiên bản 044, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n5. Chế biến phần chính cho đậu hũ sốt phiên bản 044, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.\n6. Nêm nếm cho đậu hũ sốt phiên bản 044, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.\n7. Hoàn thiện và trình bày cho đậu hũ sốt phiên bản 044, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	11	58	5	Easy	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.093+00	\N	\N	\N	\N	\N	\N
ddf9a41b-987e-4232-9719-1dad2566daef	2026-09-22 16:40:27.935108+00	\N	f	1	19d6294c-4afb-4fac-901b-1f474784a6cd	Published	Cá nướng phiên bản 045	lab2-recipe-045	Công thức mẫu cá nướng phiên bản 045 thuộc Món nướng.	1. Chuẩn bị nguyên liệu cho cá nướng phiên bản 045, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n2. Sơ chế cho cá nướng phiên bản 045, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.\n3. Ướp gia vị cho cá nướng phiên bản 045, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.\n4. Làm nóng chảo cho cá nướng phiên bản 045, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.\n5. Chế biến phần chính cho cá nướng phiên bản 045, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n6. Nêm nếm cho cá nướng phiên bản 045, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n7. Hoàn thiện và trình bày cho cá nướng phiên bản 045, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	28	21	5	Easy	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.096+00	\N	\N	\N	\N	\N	\N
562c335a-10be-4338-b035-3c1e2cffd334	2026-09-22 16:40:27.935108+00	\N	f	1	0aef3997-c3e3-4a21-90c5-7a094bfd1846	Published	Gà hấp phiên bản 046	lab2-recipe-046	Công thức mẫu gà hấp phiên bản 046 thuộc Món hấp.	1. Chuẩn bị nguyên liệu cho gà hấp phiên bản 046, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n2. Sơ chế cho gà hấp phiên bản 046, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.\n3. Ướp gia vị cho gà hấp phiên bản 046, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.\n4. Làm nóng chảo cho gà hấp phiên bản 046, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.\n5. Chế biến phần chính cho gà hấp phiên bản 046, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	25	52	2	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.098+00	\N	\N	\N	\N	\N	\N
8dccba9d-12b4-4d2d-9a1d-5fc14008d51c	2026-09-22 16:40:27.935108+00	\N	f	1	18f03254-878b-42c6-95bd-b19c6aa08642	Published	Thịt xào phiên bản 047	lab2-recipe-047	Công thức mẫu thịt xào phiên bản 047 thuộc Món xào.	1. Chuẩn bị nguyên liệu cho thịt xào phiên bản 047, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.\n2. Sơ chế cho thịt xào phiên bản 047, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.\n3. Ướp gia vị cho thịt xào phiên bản 047, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n4. Làm nóng chảo cho thịt xào phiên bản 047, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n5. Chế biến phần chính cho thịt xào phiên bản 047, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	29	45	2	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.101+00	\N	\N	\N	\N	\N	\N
24a10494-0371-4fb9-94cf-4758144aedd3	2026-09-22 16:40:27.935108+00	\N	f	1	cc7b4987-5b04-4d3d-8dfb-bdb425310a43	Published	Tôm chiên phiên bản 048	lab2-recipe-048	Công thức mẫu tôm chiên phiên bản 048 thuộc Món chiên.	1. Chuẩn bị nguyên liệu cho tôm chiên phiên bản 048, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n2. Sơ chế cho tôm chiên phiên bản 048, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.\n3. Ướp gia vị cho tôm chiên phiên bản 048, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n4. Làm nóng chảo cho tôm chiên phiên bản 048, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.\n5. Chế biến phần chính cho tôm chiên phiên bản 048, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.\n6. Nêm nếm cho tôm chiên phiên bản 048, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	28	56	3	Easy	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.104+00	\N	\N	\N	\N	\N	\N
002b91a9-5ca6-4239-b385-339e48d88bd6	2026-09-22 16:40:27.935108+00	\N	f	1	e66b86e1-4212-428a-a67d-c93d7b13491e	Published	Cá kho phiên bản 049	lab2-recipe-049	Công thức mẫu cá kho phiên bản 049 thuộc Món kho.	1. Chuẩn bị nguyên liệu cho cá kho phiên bản 049, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.\n2. Sơ chế cho cá kho phiên bản 049, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n3. Ướp gia vị cho cá kho phiên bản 049, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.\n4. Làm nóng chảo cho cá kho phiên bản 049, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n5. Chế biến phần chính cho cá kho phiên bản 049, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.\n6. Nêm nếm cho cá kho phiên bản 049, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n7. Hoàn thiện và trình bày cho cá kho phiên bản 049, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	18	16	2	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.106+00	\N	\N	\N	\N	\N	\N
4928facf-c82b-48f1-9886-2db427ee7301	2026-09-22 16:40:27.935108+00	\N	f	1	bff0da8f-b4d4-4abf-9ee0-6745b206152e	Published	Canh bí phiên bản 050	lab2-recipe-050	Công thức mẫu canh bí phiên bản 050 thuộc Món canh.	1. Chuẩn bị nguyên liệu cho canh bí phiên bản 050, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n2. Sơ chế cho canh bí phiên bản 050, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.\n3. Ướp gia vị cho canh bí phiên bản 050, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n4. Làm nóng chảo cho canh bí phiên bản 050, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n5. Chế biến phần chính cho canh bí phiên bản 050, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	17	44	6	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.109+00	\N	\N	\N	\N	\N	\N
c3668171-26a6-485b-b0bd-1beb69f63762	2026-09-22 16:40:27.935108+00	\N	f	1	c0fe3e7d-920b-43bd-97fd-90eab8b8eb3a	Published	Lẩu rau phiên bản 059	lab2-recipe-059	Công thức mẫu lẩu rau phiên bản 059 thuộc Món gia đình.	1. Chuẩn bị nguyên liệu cho lẩu rau phiên bản 059, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.\n2. Sơ chế cho lẩu rau phiên bản 059, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n3. Ướp gia vị cho lẩu rau phiên bản 059, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.\n4. Làm nóng chảo cho lẩu rau phiên bản 059, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n5. Chế biến phần chính cho lẩu rau phiên bản 059, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	14	18	6	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.131+00	\N	\N	\N	\N	\N	\N
f4a63e23-a5aa-4d23-8822-77aa3ee9ed24	2026-09-22 16:40:27.935108+00	\N	f	1	db88f651-9af0-457c-8479-e358ae00119a	Published	Súp nấm phiên bản 051	lab2-recipe-051	Công thức mẫu súp nấm phiên bản 051 thuộc Món súp.	1. Chuẩn bị nguyên liệu cho súp nấm phiên bản 051, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.\n2. Sơ chế cho súp nấm phiên bản 051, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.\n3. Ướp gia vị cho súp nấm phiên bản 051, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.\n4. Làm nóng chảo cho súp nấm phiên bản 051, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n5. Chế biến phần chính cho súp nấm phiên bản 051, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n6. Nêm nếm cho súp nấm phiên bản 051, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	13	45	2	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.111+00	\N	\N	\N	\N	\N	\N
67b9aad3-b7ff-4922-b6ce-ba52462074ad	2026-09-22 16:40:27.935108+00	\N	f	1	9e9a056b-76d8-4803-b59e-b28e2f0728c1	Published	Cơm rang phiên bản 052	lab2-recipe-052	Công thức mẫu cơm rang phiên bản 052 thuộc Món cơm.	1. Chuẩn bị nguyên liệu cho cơm rang phiên bản 052, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n2. Sơ chế cho cơm rang phiên bản 052, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n3. Ướp gia vị cho cơm rang phiên bản 052, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.\n4. Làm nóng chảo cho cơm rang phiên bản 052, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n5. Chế biến phần chính cho cơm rang phiên bản 052, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	23	50	3	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.114+00	\N	\N	\N	\N	\N	\N
f7735694-c470-473b-b4d3-8557fb5a642c	2026-09-22 16:40:27.935108+00	\N	f	1	c8bad750-acdb-4077-a4e1-2ae6d13b63c2	Published	Mì xào phiên bản 053	lab2-recipe-053	Công thức mẫu mì xào phiên bản 053 thuộc Món mì.	1. Chuẩn bị nguyên liệu cho mì xào phiên bản 053, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.\n2. Sơ chế cho mì xào phiên bản 053, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n3. Ướp gia vị cho mì xào phiên bản 053, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.\n4. Làm nóng chảo cho mì xào phiên bản 053, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n5. Chế biến phần chính cho mì xào phiên bản 053, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n6. Nêm nếm cho mì xào phiên bản 053, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	15	41	3	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.116+00	\N	\N	\N	\N	\N	\N
4548ae76-9712-45e4-a504-aa9907e39f05	2026-09-22 16:40:27.935108+00	\N	f	1	b6763cb8-2c61-423c-9c26-f0ddd11eaa51	Published	Bún thịt phiên bản 054	lab2-recipe-054	Công thức mẫu bún thịt phiên bản 054 thuộc Món bún.	1. Chuẩn bị nguyên liệu cho bún thịt phiên bản 054, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.\n2. Sơ chế cho bún thịt phiên bản 054, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.\n3. Ướp gia vị cho bún thịt phiên bản 054, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.\n4. Làm nóng chảo cho bún thịt phiên bản 054, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.\n5. Chế biến phần chính cho bún thịt phiên bản 054, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	19	39	4	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.118+00	\N	\N	\N	\N	\N	\N
0b417a11-2833-4b53-9222-3a9856648872	2026-09-22 16:40:27.935108+00	\N	f	1	87366ac5-9a02-419a-af8c-7dc296ded1dc	Published	Bánh khoai phiên bản 055	lab2-recipe-055	Công thức mẫu bánh khoai phiên bản 055 thuộc Món bánh.	1. Chuẩn bị nguyên liệu cho bánh khoai phiên bản 055, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.\n2. Sơ chế cho bánh khoai phiên bản 055, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n3. Ướp gia vị cho bánh khoai phiên bản 055, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.\n4. Làm nóng chảo cho bánh khoai phiên bản 055, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n5. Chế biến phần chính cho bánh khoai phiên bản 055, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	10	33	6	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.121+00	\N	\N	\N	\N	\N	\N
4c69c3ad-4c91-4e42-9a0e-31bc940cdb3a	2026-09-22 16:40:27.935108+00	\N	f	1	a9a5cf88-5f7a-420a-9c33-d3ccc7e83405	Published	Chè đậu phiên bản 056	lab2-recipe-056	Công thức mẫu chè đậu phiên bản 056 thuộc Món tráng miệng.	1. Chuẩn bị nguyên liệu cho chè đậu phiên bản 056, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n2. Sơ chế cho chè đậu phiên bản 056, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n3. Ướp gia vị cho chè đậu phiên bản 056, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n4. Làm nóng chảo cho chè đậu phiên bản 056, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.\n5. Chế biến phần chính cho chè đậu phiên bản 056, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	25	60	4	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.123+00	\N	\N	\N	\N	\N	\N
254dc0a9-d270-47ab-ba08-d4cd5408a1b7	2026-09-22 16:40:27.935108+00	\N	f	1	96cfe3d7-3e7b-4863-ac69-3223877f6fda	Published	Bánh mì trứng phiên bản 057	lab2-recipe-057	Công thức mẫu bánh mì trứng phiên bản 057 thuộc Món ăn sáng.	1. Chuẩn bị nguyên liệu cho bánh mì trứng phiên bản 057, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n2. Sơ chế cho bánh mì trứng phiên bản 057, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.\n3. Ướp gia vị cho bánh mì trứng phiên bản 057, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n4. Làm nóng chảo cho bánh mì trứng phiên bản 057, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.\n5. Chế biến phần chính cho bánh mì trứng phiên bản 057, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n6. Nêm nếm cho bánh mì trứng phiên bản 057, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n7. Hoàn thiện và trình bày cho bánh mì trứng phiên bản 057, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	19	24	3	Easy	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.126+00	\N	\N	\N	\N	\N	\N
c1621222-23ce-4ea4-8779-9882684c6adf	2026-09-22 16:40:27.935108+00	\N	f	1	2c0638cb-2557-4242-b543-1f520de0ed53	Published	Gỏi cuốn phiên bản 058	lab2-recipe-058	Công thức mẫu gỏi cuốn phiên bản 058 thuộc Món ăn nhẹ.	1. Chuẩn bị nguyên liệu cho gỏi cuốn phiên bản 058, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.\n2. Sơ chế cho gỏi cuốn phiên bản 058, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.\n3. Ướp gia vị cho gỏi cuốn phiên bản 058, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n4. Làm nóng chảo cho gỏi cuốn phiên bản 058, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.\n5. Chế biến phần chính cho gỏi cuốn phiên bản 058, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	15	39	4	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.129+00	\N	\N	\N	\N	\N	\N
55912428-102a-4a22-9469-dbd50bf77a30	2026-09-22 16:40:27.935108+00	\N	f	1	5b8d9b6c-4ebc-4012-bd51-6b12ab970582	Published	Xôi gấc phiên bản 060	lab2-recipe-060	Công thức mẫu xôi gấc phiên bản 060 thuộc Món ngày lễ.	1. Chuẩn bị nguyên liệu cho xôi gấc phiên bản 060, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.\n2. Sơ chế cho xôi gấc phiên bản 060, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n3. Ướp gia vị cho xôi gấc phiên bản 060, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n4. Làm nóng chảo cho xôi gấc phiên bản 060, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n5. Chế biến phần chính cho xôi gấc phiên bản 060, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.\n6. Nêm nếm cho xôi gấc phiên bản 060, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	27	16	6	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.134+00	\N	\N	\N	\N	\N	\N
07941b56-fc37-4e04-ba2b-0909d1c5eafa	2026-09-22 16:40:27.935108+00	\N	f	1	84195f7c-4f8b-45a5-8bff-59d7520c4322	Published	Cơm gà phiên bản 061	lab2-recipe-061	Công thức mẫu cơm gà phiên bản 061 thuộc Món Việt.	1. Chuẩn bị nguyên liệu cho cơm gà phiên bản 061, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n2. Sơ chế cho cơm gà phiên bản 061, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.\n3. Ướp gia vị cho cơm gà phiên bản 061, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n4. Làm nóng chảo cho cơm gà phiên bản 061, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n5. Chế biến phần chính cho cơm gà phiên bản 061, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	13	18	2	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.136+00	\N	\N	\N	\N	\N	\N
db57d063-8581-44b7-9ae7-4357288c86c6	2026-09-22 16:40:27.935108+00	\N	f	1	82d6aa2c-4c63-4208-afcb-39a2b20e25fe	Published	Bún bò phiên bản 062	lab2-recipe-062	Công thức mẫu bún bò phiên bản 062 thuộc Món Á.	1. Chuẩn bị nguyên liệu cho bún bò phiên bản 062, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n2. Sơ chế cho bún bò phiên bản 062, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.\n3. Ướp gia vị cho bún bò phiên bản 062, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.\n4. Làm nóng chảo cho bún bò phiên bản 062, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.\n5. Chế biến phần chính cho bún bò phiên bản 062, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.\n6. Nêm nếm cho bún bò phiên bản 062, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.\n7. Hoàn thiện và trình bày cho bún bò phiên bản 062, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	24	48	5	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.138+00	\N	\N	\N	\N	\N	\N
d559b794-996c-4ca7-a987-6a17c5327fcd	2026-09-22 16:40:27.935108+00	\N	f	1	058020db-2ae1-444d-9dd8-36925696092d	Published	Mì rau củ phiên bản 063	lab2-recipe-063	Công thức mẫu mì rau củ phiên bản 063 thuộc Món Âu.	1. Chuẩn bị nguyên liệu cho mì rau củ phiên bản 063, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.\n2. Sơ chế cho mì rau củ phiên bản 063, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.\n3. Ướp gia vị cho mì rau củ phiên bản 063, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.\n4. Làm nóng chảo cho mì rau củ phiên bản 063, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n5. Chế biến phần chính cho mì rau củ phiên bản 063, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.\n6. Nêm nếm cho mì rau củ phiên bản 063, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	15	43	5	Easy	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.142+00	\N	\N	\N	\N	\N	\N
348fddfe-7f64-4fb3-95b6-c14a3ad63c00	2026-09-22 16:40:27.935108+00	\N	f	1	af794161-e952-4746-9bfe-ae1023f82546	Published	Đậu hũ sốt phiên bản 064	lab2-recipe-064	Công thức mẫu đậu hũ sốt phiên bản 064 thuộc Món chay.	1. Chuẩn bị nguyên liệu cho đậu hũ sốt phiên bản 064, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.\n2. Sơ chế cho đậu hũ sốt phiên bản 064, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.\n3. Ướp gia vị cho đậu hũ sốt phiên bản 064, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.\n4. Làm nóng chảo cho đậu hũ sốt phiên bản 064, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n5. Chế biến phần chính cho đậu hũ sốt phiên bản 064, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n6. Nêm nếm cho đậu hũ sốt phiên bản 064, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.	30	46	4	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.145+00	\N	\N	\N	\N	\N	\N
e129e855-dd11-41d6-8189-fb3d3044f076	2026-09-22 16:40:27.935108+00	\N	f	1	19d6294c-4afb-4fac-901b-1f474784a6cd	Published	Cá nướng phiên bản 065	lab2-recipe-065	Công thức mẫu cá nướng phiên bản 065 thuộc Món nướng.	1. Chuẩn bị nguyên liệu cho cá nướng phiên bản 065, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.\n2. Sơ chế cho cá nướng phiên bản 065, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.\n3. Ướp gia vị cho cá nướng phiên bản 065, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.\n4. Làm nóng chảo cho cá nướng phiên bản 065, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.\n5. Chế biến phần chính cho cá nướng phiên bản 065, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.\n6. Nêm nếm cho cá nướng phiên bản 065, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	18	52	3	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.148+00	\N	\N	\N	\N	\N	\N
4037f256-e830-4bea-a6e2-1ca411095a6f	2026-09-22 16:40:27.935108+00	\N	f	1	0aef3997-c3e3-4a21-90c5-7a094bfd1846	Published	Gà hấp phiên bản 066	lab2-recipe-066	Công thức mẫu gà hấp phiên bản 066 thuộc Món hấp.	1. Chuẩn bị nguyên liệu cho gà hấp phiên bản 066, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.\n2. Sơ chế cho gà hấp phiên bản 066, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n3. Ướp gia vị cho gà hấp phiên bản 066, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n4. Làm nóng chảo cho gà hấp phiên bản 066, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.\n5. Chế biến phần chính cho gà hấp phiên bản 066, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	26	51	5	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.15+00	\N	\N	\N	\N	\N	\N
2e96fe2e-5745-4849-b64b-9ed07902a179	2026-09-22 16:40:27.935108+00	\N	f	1	18f03254-878b-42c6-95bd-b19c6aa08642	Published	Thịt xào phiên bản 067	lab2-recipe-067	Công thức mẫu thịt xào phiên bản 067 thuộc Món xào.	1. Chuẩn bị nguyên liệu cho thịt xào phiên bản 067, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.\n2. Sơ chế cho thịt xào phiên bản 067, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.\n3. Ướp gia vị cho thịt xào phiên bản 067, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.\n4. Làm nóng chảo cho thịt xào phiên bản 067, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.\n5. Chế biến phần chính cho thịt xào phiên bản 067, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	23	15	3	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.153+00	\N	\N	\N	\N	\N	\N
f1c3df32-5906-492a-beba-4197b0ca4f8b	2026-09-22 16:40:27.935108+00	\N	f	1	cc7b4987-5b04-4d3d-8dfb-bdb425310a43	Published	Tôm chiên phiên bản 068	lab2-recipe-068	Công thức mẫu tôm chiên phiên bản 068 thuộc Món chiên.	1. Chuẩn bị nguyên liệu cho tôm chiên phiên bản 068, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.\n2. Sơ chế cho tôm chiên phiên bản 068, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.\n3. Ướp gia vị cho tôm chiên phiên bản 068, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.\n4. Làm nóng chảo cho tôm chiên phiên bản 068, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.\n5. Chế biến phần chính cho tôm chiên phiên bản 068, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	16	23	3	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.155+00	\N	\N	\N	\N	\N	\N
a1957e38-5472-4dab-93db-31c54769f19c	2026-09-22 16:40:27.935108+00	\N	f	1	e66b86e1-4212-428a-a67d-c93d7b13491e	Published	Cá kho phiên bản 069	lab2-recipe-069	Công thức mẫu cá kho phiên bản 069 thuộc Món kho.	1. Chuẩn bị nguyên liệu cho cá kho phiên bản 069, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.\n2. Sơ chế cho cá kho phiên bản 069, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n3. Ướp gia vị cho cá kho phiên bản 069, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.\n4. Làm nóng chảo cho cá kho phiên bản 069, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.\n5. Chế biến phần chính cho cá kho phiên bản 069, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n6. Nêm nếm cho cá kho phiên bản 069, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	23	50	3	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.158+00	\N	\N	\N	\N	\N	\N
010d72a8-39ab-4e3f-8c70-0854712210f8	2026-09-22 16:40:27.935108+00	\N	f	1	bff0da8f-b4d4-4abf-9ee0-6745b206152e	Published	Canh bí phiên bản 070	lab2-recipe-070	Công thức mẫu canh bí phiên bản 070 thuộc Món canh.	1. Chuẩn bị nguyên liệu cho canh bí phiên bản 070, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n2. Sơ chế cho canh bí phiên bản 070, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n3. Ướp gia vị cho canh bí phiên bản 070, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.\n4. Làm nóng chảo cho canh bí phiên bản 070, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n5. Chế biến phần chính cho canh bí phiên bản 070, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.\n6. Nêm nếm cho canh bí phiên bản 070, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n7. Hoàn thiện và trình bày cho canh bí phiên bản 070, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	14	22	6	Easy	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.161+00	\N	\N	\N	\N	\N	\N
9deb3613-087f-4e6a-af02-a6ac3785e666	2026-09-22 16:40:27.935108+00	\N	f	1	db88f651-9af0-457c-8479-e358ae00119a	Published	Súp nấm phiên bản 071	lab2-recipe-071	Công thức mẫu súp nấm phiên bản 071 thuộc Món súp.	1. Chuẩn bị nguyên liệu cho súp nấm phiên bản 071, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n2. Sơ chế cho súp nấm phiên bản 071, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.\n3. Ướp gia vị cho súp nấm phiên bản 071, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.\n4. Làm nóng chảo cho súp nấm phiên bản 071, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.\n5. Chế biến phần chính cho súp nấm phiên bản 071, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	17	25	2	Easy	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.164+00	\N	\N	\N	\N	\N	\N
88d059e3-ed60-4381-8b70-b16b10d11154	2026-09-22 16:40:27.935108+00	\N	f	1	9e9a056b-76d8-4803-b59e-b28e2f0728c1	Published	Cơm rang phiên bản 072	lab2-recipe-072	Công thức mẫu cơm rang phiên bản 072 thuộc Món cơm.	1. Chuẩn bị nguyên liệu cho cơm rang phiên bản 072, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n2. Sơ chế cho cơm rang phiên bản 072, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n3. Ướp gia vị cho cơm rang phiên bản 072, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.\n4. Làm nóng chảo cho cơm rang phiên bản 072, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.\n5. Chế biến phần chính cho cơm rang phiên bản 072, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	14	23	4	Easy	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.166+00	\N	\N	\N	\N	\N	\N
d3564a99-ff0d-4f2e-b129-d214c229ca39	2026-09-22 16:40:27.935108+00	\N	f	1	c8bad750-acdb-4077-a4e1-2ae6d13b63c2	Published	Mì xào phiên bản 073	lab2-recipe-073	Công thức mẫu mì xào phiên bản 073 thuộc Món mì.	1. Chuẩn bị nguyên liệu cho mì xào phiên bản 073, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.\n2. Sơ chế cho mì xào phiên bản 073, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.\n3. Ướp gia vị cho mì xào phiên bản 073, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n4. Làm nóng chảo cho mì xào phiên bản 073, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.\n5. Chế biến phần chính cho mì xào phiên bản 073, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n6. Nêm nếm cho mì xào phiên bản 073, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	27	46	4	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.169+00	\N	\N	\N	\N	\N	\N
f0e97260-a94a-4228-8b66-43092cc4d960	2026-09-22 16:40:27.935108+00	\N	f	1	b6763cb8-2c61-423c-9c26-f0ddd11eaa51	Published	Bún thịt phiên bản 074	lab2-recipe-074	Công thức mẫu bún thịt phiên bản 074 thuộc Món bún.	1. Chuẩn bị nguyên liệu cho bún thịt phiên bản 074, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.\n2. Sơ chế cho bún thịt phiên bản 074, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.\n3. Ướp gia vị cho bún thịt phiên bản 074, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n4. Làm nóng chảo cho bún thịt phiên bản 074, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n5. Chế biến phần chính cho bún thịt phiên bản 074, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n6. Nêm nếm cho bún thịt phiên bản 074, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n7. Hoàn thiện và trình bày cho bún thịt phiên bản 074, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	18	44	4	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.172+00	\N	\N	\N	\N	\N	\N
efa700aa-6196-4fb7-a624-f1794047dc83	2026-09-22 16:40:27.935108+00	\N	f	1	87366ac5-9a02-419a-af8c-7dc296ded1dc	Published	Bánh khoai phiên bản 075	lab2-recipe-075	Công thức mẫu bánh khoai phiên bản 075 thuộc Món bánh.	1. Chuẩn bị nguyên liệu cho bánh khoai phiên bản 075, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n2. Sơ chế cho bánh khoai phiên bản 075, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.\n3. Ướp gia vị cho bánh khoai phiên bản 075, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.\n4. Làm nóng chảo cho bánh khoai phiên bản 075, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n5. Chế biến phần chính cho bánh khoai phiên bản 075, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.\n6. Nêm nếm cho bánh khoai phiên bản 075, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.\n7. Hoàn thiện và trình bày cho bánh khoai phiên bản 075, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	15	29	2	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.175+00	\N	\N	\N	\N	\N	\N
c70f9112-e933-4cf3-bc7c-f3597318dc92	2026-09-22 16:40:27.935108+00	\N	f	1	a9a5cf88-5f7a-420a-9c33-d3ccc7e83405	Published	Chè đậu phiên bản 076	lab2-recipe-076	Công thức mẫu chè đậu phiên bản 076 thuộc Món tráng miệng.	1. Chuẩn bị nguyên liệu cho chè đậu phiên bản 076, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.\n2. Sơ chế cho chè đậu phiên bản 076, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n3. Ướp gia vị cho chè đậu phiên bản 076, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.\n4. Làm nóng chảo cho chè đậu phiên bản 076, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n5. Chế biến phần chính cho chè đậu phiên bản 076, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n6. Nêm nếm cho chè đậu phiên bản 076, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n7. Hoàn thiện và trình bày cho chè đậu phiên bản 076, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.	27	22	6	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.178+00	\N	\N	\N	\N	\N	\N
b45deffb-8faf-489e-8b94-1b8db806314f	2026-09-22 16:40:27.935108+00	\N	f	1	96cfe3d7-3e7b-4863-ac69-3223877f6fda	Published	Bánh mì trứng phiên bản 077	lab2-recipe-077	Công thức mẫu bánh mì trứng phiên bản 077 thuộc Món ăn sáng.	1. Chuẩn bị nguyên liệu cho bánh mì trứng phiên bản 077, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n2. Sơ chế cho bánh mì trứng phiên bản 077, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.\n3. Ướp gia vị cho bánh mì trứng phiên bản 077, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n4. Làm nóng chảo cho bánh mì trứng phiên bản 077, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.\n5. Chế biến phần chính cho bánh mì trứng phiên bản 077, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	28	58	6	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.18+00	\N	\N	\N	\N	\N	\N
f852915b-e743-4648-bc53-354564274cbe	2026-09-22 16:40:27.935108+00	\N	f	1	2c0638cb-2557-4242-b543-1f520de0ed53	Published	Gỏi cuốn phiên bản 078	lab2-recipe-078	Công thức mẫu gỏi cuốn phiên bản 078 thuộc Món ăn nhẹ.	1. Chuẩn bị nguyên liệu cho gỏi cuốn phiên bản 078, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n2. Sơ chế cho gỏi cuốn phiên bản 078, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.\n3. Ướp gia vị cho gỏi cuốn phiên bản 078, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.\n4. Làm nóng chảo cho gỏi cuốn phiên bản 078, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.\n5. Chế biến phần chính cho gỏi cuốn phiên bản 078, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	20	57	5	Easy	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.183+00	\N	\N	\N	\N	\N	\N
8903560f-3e94-4465-a48f-e2add7ec29b9	2026-09-22 16:40:27.935108+00	\N	f	1	c0fe3e7d-920b-43bd-97fd-90eab8b8eb3a	Published	Lẩu rau phiên bản 079	lab2-recipe-079	Công thức mẫu lẩu rau phiên bản 079 thuộc Món gia đình.	1. Chuẩn bị nguyên liệu cho lẩu rau phiên bản 079, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n2. Sơ chế cho lẩu rau phiên bản 079, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n3. Ướp gia vị cho lẩu rau phiên bản 079, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n4. Làm nóng chảo cho lẩu rau phiên bản 079, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n5. Chế biến phần chính cho lẩu rau phiên bản 079, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.	16	30	2	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.185+00	\N	\N	\N	\N	\N	\N
d5fc07e8-c8ef-4829-b86d-7672a4f9430e	2026-09-22 16:40:27.935108+00	\N	f	1	5b8d9b6c-4ebc-4012-bd51-6b12ab970582	Published	Xôi gấc phiên bản 080	lab2-recipe-080	Công thức mẫu xôi gấc phiên bản 080 thuộc Món ngày lễ.	1. Chuẩn bị nguyên liệu cho xôi gấc phiên bản 080, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.\n2. Sơ chế cho xôi gấc phiên bản 080, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.\n3. Ướp gia vị cho xôi gấc phiên bản 080, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.\n4. Làm nóng chảo cho xôi gấc phiên bản 080, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n5. Chế biến phần chính cho xôi gấc phiên bản 080, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	22	38	5	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.187+00	\N	\N	\N	\N	\N	\N
7124d61c-c57e-41db-8620-3280b7ee79f6	2026-09-22 16:40:27.935108+00	\N	f	1	84195f7c-4f8b-45a5-8bff-59d7520c4322	Published	Cơm gà phiên bản 081	lab2-recipe-081	Công thức mẫu cơm gà phiên bản 081 thuộc Món Việt.	1. Chuẩn bị nguyên liệu cho cơm gà phiên bản 081, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n2. Sơ chế cho cơm gà phiên bản 081, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.\n3. Ướp gia vị cho cơm gà phiên bản 081, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.\n4. Làm nóng chảo cho cơm gà phiên bản 081, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.\n5. Chế biến phần chính cho cơm gà phiên bản 081, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n6. Nêm nếm cho cơm gà phiên bản 081, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n7. Hoàn thiện và trình bày cho cơm gà phiên bản 081, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	17	30	5	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.19+00	\N	\N	\N	\N	\N	\N
7e91259b-de31-4da3-8cb1-952047e7f1d8	2026-09-22 16:40:27.935108+00	\N	f	1	82d6aa2c-4c63-4208-afcb-39a2b20e25fe	Published	Bún bò phiên bản 082	lab2-recipe-082	Công thức mẫu bún bò phiên bản 082 thuộc Món Á.	1. Chuẩn bị nguyên liệu cho bún bò phiên bản 082, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n2. Sơ chế cho bún bò phiên bản 082, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.\n3. Ướp gia vị cho bún bò phiên bản 082, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.\n4. Làm nóng chảo cho bún bò phiên bản 082, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n5. Chế biến phần chính cho bún bò phiên bản 082, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.\n6. Nêm nếm cho bún bò phiên bản 082, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	28	52	6	Easy	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.192+00	\N	\N	\N	\N	\N	\N
d633c604-10a2-4556-a684-c0ce020d58a3	2026-09-22 16:40:27.935108+00	\N	f	1	058020db-2ae1-444d-9dd8-36925696092d	Published	Mì rau củ phiên bản 083	lab2-recipe-083	Công thức mẫu mì rau củ phiên bản 083 thuộc Món Âu.	1. Chuẩn bị nguyên liệu cho mì rau củ phiên bản 083, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.\n2. Sơ chế cho mì rau củ phiên bản 083, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.\n3. Ướp gia vị cho mì rau củ phiên bản 083, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n4. Làm nóng chảo cho mì rau củ phiên bản 083, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.\n5. Chế biến phần chính cho mì rau củ phiên bản 083, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.	21	39	3	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.195+00	\N	\N	\N	\N	\N	\N
d5d9066a-2580-452a-b50a-01614390485e	2026-09-22 16:40:27.935108+00	\N	f	1	af794161-e952-4746-9bfe-ae1023f82546	Published	Đậu hũ sốt phiên bản 084	lab2-recipe-084	Công thức mẫu đậu hũ sốt phiên bản 084 thuộc Món chay.	1. Chuẩn bị nguyên liệu cho đậu hũ sốt phiên bản 084, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.\n2. Sơ chế cho đậu hũ sốt phiên bản 084, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n3. Ướp gia vị cho đậu hũ sốt phiên bản 084, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.\n4. Làm nóng chảo cho đậu hũ sốt phiên bản 084, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.\n5. Chế biến phần chính cho đậu hũ sốt phiên bản 084, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.\n6. Nêm nếm cho đậu hũ sốt phiên bản 084, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	16	59	5	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.197+00	\N	\N	\N	\N	\N	\N
81d1e8e4-7cda-4041-b16e-e8deb0cff897	2026-09-22 16:40:27.935108+00	\N	f	1	19d6294c-4afb-4fac-901b-1f474784a6cd	Published	Cá nướng phiên bản 085	lab2-recipe-085	Công thức mẫu cá nướng phiên bản 085 thuộc Món nướng.	1. Chuẩn bị nguyên liệu cho cá nướng phiên bản 085, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.\n2. Sơ chế cho cá nướng phiên bản 085, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.\n3. Ướp gia vị cho cá nướng phiên bản 085, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n4. Làm nóng chảo cho cá nướng phiên bản 085, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.\n5. Chế biến phần chính cho cá nướng phiên bản 085, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n6. Nêm nếm cho cá nướng phiên bản 085, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	28	50	4	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.2+00	\N	\N	\N	\N	\N	\N
ce535140-4132-41cc-b688-4600cd898301	2026-09-22 16:40:27.935108+00	\N	f	1	0aef3997-c3e3-4a21-90c5-7a094bfd1846	Published	Gà hấp phiên bản 086	lab2-recipe-086	Công thức mẫu gà hấp phiên bản 086 thuộc Món hấp.	1. Chuẩn bị nguyên liệu cho gà hấp phiên bản 086, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.\n2. Sơ chế cho gà hấp phiên bản 086, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.\n3. Ướp gia vị cho gà hấp phiên bản 086, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.\n4. Làm nóng chảo cho gà hấp phiên bản 086, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.\n5. Chế biến phần chính cho gà hấp phiên bản 086, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.\n6. Nêm nếm cho gà hấp phiên bản 086, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.	27	21	3	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.202+00	\N	\N	\N	\N	\N	\N
051ff554-9d6d-430e-aa97-a33c5cfd02f3	2026-09-22 16:40:27.935108+00	\N	f	1	18f03254-878b-42c6-95bd-b19c6aa08642	Published	Thịt xào phiên bản 087	lab2-recipe-087	Công thức mẫu thịt xào phiên bản 087 thuộc Món xào.	1. Chuẩn bị nguyên liệu cho thịt xào phiên bản 087, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.\n2. Sơ chế cho thịt xào phiên bản 087, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n3. Ướp gia vị cho thịt xào phiên bản 087, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n4. Làm nóng chảo cho thịt xào phiên bản 087, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n5. Chế biến phần chính cho thịt xào phiên bản 087, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n6. Nêm nếm cho thịt xào phiên bản 087, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n7. Hoàn thiện và trình bày cho thịt xào phiên bản 087, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	28	29	6	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.205+00	\N	\N	\N	\N	\N	\N
fc4b83b7-4471-4d88-b9ff-7bf95c2bdec5	2026-09-22 16:40:27.935108+00	\N	f	1	cc7b4987-5b04-4d3d-8dfb-bdb425310a43	Published	Tôm chiên phiên bản 088	lab2-recipe-088	Công thức mẫu tôm chiên phiên bản 088 thuộc Món chiên.	1. Chuẩn bị nguyên liệu cho tôm chiên phiên bản 088, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.\n2. Sơ chế cho tôm chiên phiên bản 088, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n3. Ướp gia vị cho tôm chiên phiên bản 088, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n4. Làm nóng chảo cho tôm chiên phiên bản 088, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.\n5. Chế biến phần chính cho tôm chiên phiên bản 088, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n6. Nêm nếm cho tôm chiên phiên bản 088, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.\n7. Hoàn thiện và trình bày cho tôm chiên phiên bản 088, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.	26	46	5	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.208+00	\N	\N	\N	\N	\N	\N
a6f16e93-82b8-4735-b8ae-cf751bcc2ba9	2026-09-22 16:40:27.935108+00	\N	f	1	e66b86e1-4212-428a-a67d-c93d7b13491e	Published	Cá kho phiên bản 089	lab2-recipe-089	Công thức mẫu cá kho phiên bản 089 thuộc Món kho.	1. Chuẩn bị nguyên liệu cho cá kho phiên bản 089, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n2. Sơ chế cho cá kho phiên bản 089, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.\n3. Ướp gia vị cho cá kho phiên bản 089, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n4. Làm nóng chảo cho cá kho phiên bản 089, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.\n5. Chế biến phần chính cho cá kho phiên bản 089, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	14	34	2	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.211+00	\N	\N	\N	\N	\N	\N
62eda459-2322-4352-ba9a-a9d14aba6b6e	2026-09-22 16:40:27.935108+00	\N	f	1	bff0da8f-b4d4-4abf-9ee0-6745b206152e	Published	Canh bí phiên bản 090	lab2-recipe-090	Công thức mẫu canh bí phiên bản 090 thuộc Món canh.	1. Chuẩn bị nguyên liệu cho canh bí phiên bản 090, dùng nguyên liệu đã chuẩn bị và thực hiện trong 17 phút.\n2. Sơ chế cho canh bí phiên bản 090, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n3. Ướp gia vị cho canh bí phiên bản 090, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n4. Làm nóng chảo cho canh bí phiên bản 090, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.\n5. Chế biến phần chính cho canh bí phiên bản 090, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.\n6. Nêm nếm cho canh bí phiên bản 090, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.\n7. Hoàn thiện và trình bày cho canh bí phiên bản 090, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	27	59	3	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.213+00	\N	\N	\N	\N	\N	\N
6265c5ea-183c-438d-b7c7-3930970b563f	2026-09-22 16:40:27.935108+00	\N	f	1	db88f651-9af0-457c-8479-e358ae00119a	Published	Súp nấm phiên bản 091	lab2-recipe-091	Công thức mẫu súp nấm phiên bản 091 thuộc Món súp.	1. Chuẩn bị nguyên liệu cho súp nấm phiên bản 091, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.\n2. Sơ chế cho súp nấm phiên bản 091, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n3. Ướp gia vị cho súp nấm phiên bản 091, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.\n4. Làm nóng chảo cho súp nấm phiên bản 091, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.\n5. Chế biến phần chính cho súp nấm phiên bản 091, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.	14	30	5	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.216+00	\N	\N	\N	\N	\N	\N
25f17627-db23-487f-a6b2-aca2abb11e51	2026-09-22 16:40:27.935108+00	\N	f	1	9e9a056b-76d8-4803-b59e-b28e2f0728c1	Published	Cơm rang phiên bản 092	lab2-recipe-092	Công thức mẫu cơm rang phiên bản 092 thuộc Món cơm.	1. Chuẩn bị nguyên liệu cho cơm rang phiên bản 092, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.\n2. Sơ chế cho cơm rang phiên bản 092, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n3. Ướp gia vị cho cơm rang phiên bản 092, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n4. Làm nóng chảo cho cơm rang phiên bản 092, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n5. Chế biến phần chính cho cơm rang phiên bản 092, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.\n6. Nêm nếm cho cơm rang phiên bản 092, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.	22	36	2	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.218+00	\N	\N	\N	\N	\N	\N
1997d118-cbc5-4be5-a65d-093e23c14fce	2026-09-22 16:40:27.935108+00	\N	f	1	c8bad750-acdb-4077-a4e1-2ae6d13b63c2	Published	Mì xào phiên bản 093	lab2-recipe-093	Công thức mẫu mì xào phiên bản 093 thuộc Món mì.	1. Chuẩn bị nguyên liệu cho mì xào phiên bản 093, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n2. Sơ chế cho mì xào phiên bản 093, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.\n3. Ướp gia vị cho mì xào phiên bản 093, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.\n4. Làm nóng chảo cho mì xào phiên bản 093, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.\n5. Chế biến phần chính cho mì xào phiên bản 093, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n6. Nêm nếm cho mì xào phiên bản 093, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.	13	44	2	Easy	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.221+00	\N	\N	\N	\N	\N	\N
9715c962-5702-4b62-9f10-6111b76cfef4	2026-09-22 16:40:27.935108+00	\N	f	1	b6763cb8-2c61-423c-9c26-f0ddd11eaa51	Published	Bún thịt phiên bản 094	lab2-recipe-094	Công thức mẫu bún thịt phiên bản 094 thuộc Món bún.	1. Chuẩn bị nguyên liệu cho bún thịt phiên bản 094, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n2. Sơ chế cho bún thịt phiên bản 094, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.\n3. Ướp gia vị cho bún thịt phiên bản 094, dùng nguyên liệu đã chuẩn bị và thực hiện trong 5 phút.\n4. Làm nóng chảo cho bún thịt phiên bản 094, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.\n5. Chế biến phần chính cho bún thịt phiên bản 094, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.\n6. Nêm nếm cho bún thịt phiên bản 094, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.\n7. Hoàn thiện và trình bày cho bún thịt phiên bản 094, dùng nguyên liệu đã chuẩn bị và thực hiện trong 16 phút.	12	46	2	Easy	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.223+00	\N	\N	\N	\N	\N	\N
a0596eb3-1063-4178-b49c-8ea5186af4d4	2026-09-22 16:40:27.935108+00	\N	f	1	87366ac5-9a02-419a-af8c-7dc296ded1dc	Published	Bánh khoai phiên bản 095	lab2-recipe-095	Công thức mẫu bánh khoai phiên bản 095 thuộc Món bánh.	1. Chuẩn bị nguyên liệu cho bánh khoai phiên bản 095, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n2. Sơ chế cho bánh khoai phiên bản 095, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.\n3. Ướp gia vị cho bánh khoai phiên bản 095, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n4. Làm nóng chảo cho bánh khoai phiên bản 095, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n5. Chế biến phần chính cho bánh khoai phiên bản 095, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n6. Nêm nếm cho bánh khoai phiên bản 095, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.	12	36	4	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.226+00	\N	\N	\N	\N	\N	\N
f9624aa7-7f5d-4a13-85eb-c10edb84d182	2026-09-22 16:40:27.935108+00	\N	f	1	a9a5cf88-5f7a-420a-9c33-d3ccc7e83405	Published	Chè đậu phiên bản 096	lab2-recipe-096	Công thức mẫu chè đậu phiên bản 096 thuộc Món tráng miệng.	1. Chuẩn bị nguyên liệu cho chè đậu phiên bản 096, dùng nguyên liệu đã chuẩn bị và thực hiện trong 9 phút.\n2. Sơ chế cho chè đậu phiên bản 096, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.\n3. Ướp gia vị cho chè đậu phiên bản 096, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n4. Làm nóng chảo cho chè đậu phiên bản 096, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.\n5. Chế biến phần chính cho chè đậu phiên bản 096, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.	11	21	3	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.228+00	\N	\N	\N	\N	\N	\N
94173c5c-f916-413b-9405-8f6f415899fb	2026-09-22 16:40:27.935108+00	\N	f	1	96cfe3d7-3e7b-4863-ac69-3223877f6fda	Published	Bánh mì trứng phiên bản 097	lab2-recipe-097	Công thức mẫu bánh mì trứng phiên bản 097 thuộc Món ăn sáng.	1. Chuẩn bị nguyên liệu cho bánh mì trứng phiên bản 097, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n2. Sơ chế cho bánh mì trứng phiên bản 097, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n3. Ướp gia vị cho bánh mì trứng phiên bản 097, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.\n4. Làm nóng chảo cho bánh mì trứng phiên bản 097, dùng nguyên liệu đã chuẩn bị và thực hiện trong 14 phút.\n5. Chế biến phần chính cho bánh mì trứng phiên bản 097, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n6. Nêm nếm cho bánh mì trứng phiên bản 097, dùng nguyên liệu đã chuẩn bị và thực hiện trong 6 phút.	10	57	6	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.231+00	\N	\N	\N	\N	\N	\N
b87f3df8-f610-4fea-8971-f0239c09372a	2026-09-22 16:40:27.935108+00	\N	f	1	2c0638cb-2557-4242-b543-1f520de0ed53	Published	Gỏi cuốn phiên bản 098	lab2-recipe-098	Công thức mẫu gỏi cuốn phiên bản 098 thuộc Món ăn nhẹ.	1. Chuẩn bị nguyên liệu cho gỏi cuốn phiên bản 098, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.\n2. Sơ chế cho gỏi cuốn phiên bản 098, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n3. Ướp gia vị cho gỏi cuốn phiên bản 098, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n4. Làm nóng chảo cho gỏi cuốn phiên bản 098, dùng nguyên liệu đã chuẩn bị và thực hiện trong 11 phút.\n5. Chế biến phần chính cho gỏi cuốn phiên bản 098, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.	30	26	4	Easy	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.235+00	\N	\N	\N	\N	\N	\N
6e4ba959-1bfc-4f17-a5ea-cca315f28167	2026-09-22 16:40:27.935108+00	\N	f	1	c0fe3e7d-920b-43bd-97fd-90eab8b8eb3a	Published	Lẩu rau phiên bản 099	lab2-recipe-099	Công thức mẫu lẩu rau phiên bản 099 thuộc Món gia đình.	1. Chuẩn bị nguyên liệu cho lẩu rau phiên bản 099, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.\n2. Sơ chế cho lẩu rau phiên bản 099, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.\n3. Ướp gia vị cho lẩu rau phiên bản 099, dùng nguyên liệu đã chuẩn bị và thực hiện trong 7 phút.\n4. Làm nóng chảo cho lẩu rau phiên bản 099, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n5. Chế biến phần chính cho lẩu rau phiên bản 099, dùng nguyên liệu đã chuẩn bị và thực hiện trong 8 phút.\n6. Nêm nếm cho lẩu rau phiên bản 099, dùng nguyên liệu đã chuẩn bị và thực hiện trong 10 phút.	17	24	5	Hard	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.237+00	\N	\N	\N	\N	\N	\N
a2252302-6dcd-4676-9894-6d61e5bdbc95	2026-09-22 16:40:27.935108+00	\N	f	1	5b8d9b6c-4ebc-4012-bd51-6b12ab970582	Published	Xôi gấc phiên bản 100	lab2-recipe-100	Công thức mẫu xôi gấc phiên bản 100 thuộc Món ngày lễ.	1. Chuẩn bị nguyên liệu cho xôi gấc phiên bản 100, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.\n2. Sơ chế cho xôi gấc phiên bản 100, dùng nguyên liệu đã chuẩn bị và thực hiện trong 13 phút.\n3. Ướp gia vị cho xôi gấc phiên bản 100, dùng nguyên liệu đã chuẩn bị và thực hiện trong 12 phút.\n4. Làm nóng chảo cho xôi gấc phiên bản 100, dùng nguyên liệu đã chuẩn bị và thực hiện trong 15 phút.\n5. Chế biến phần chính cho xôi gấc phiên bản 100, dùng nguyên liệu đã chuẩn bị và thực hiện trong 19 phút.\n6. Nêm nếm cho xôi gấc phiên bản 100, dùng nguyên liệu đã chuẩn bị và thực hiện trong 18 phút.\n7. Hoàn thiện và trình bày cho xôi gấc phiên bản 100, dùng nguyên liệu đã chuẩn bị và thực hiện trong 20 phút.	18	37	3	Medium	924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:28.24+00	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, created_at, updated_at, is_deleted, row_version, email, password_hash, display_name, avatar_url, bio, role, is_active, failed_login_attempts, locked_until) FROM stdin;
924736bd-d3f1-4ca8-bda3-741859705d65	2026-09-22 16:40:27.935108+00	\N	f	1	lab2.seed.author@example.invalid	\N	Lab 2 Sample Author	\N	\N	Author	t	0	\N
b661cd1d-0fd9-4979-a078-a5cbf2889d3b	2026-09-22 18:43:00.947733+00	\N	f	1	smoketest1@example.com	$argon2id$v=19$m=65536,p=4,t=3$WXXbE2jgO+z0P6cRm4tNDw$KJ8ddmTlgEyxMqQjxp4jTnc60UcRKksv2grb/Ly0vWU	Smoke Test	\N	\N	Author	t	0	\N
a3de2610-b4f8-435f-af11-d08420416221	2026-09-22 18:54:46.5253+00	2026-09-22 18:54:46.5253+00	f	1	admin@admin.com	$argon2id$v=19$m=65536,p=4,t=3$Ra59asbpk6SQPH4bHeOIYQ$d2F3xZNs7LEgRx1ESMJaWeyVPMZEb+mMk3ihxggugc4	Admin	\N	\N	Admin	t	0	\N
5aa37cee-5fdb-49c0-9861-44d0bc8427f1	2026-09-22 19:05:05.680808+00	\N	f	1	locktest@example.com	$argon2id$v=19$m=65536,p=4,t=3$ig4DH/GngFpRbDcFFbz8Ng$L0LH2wZy3DLQ40WJMchFcJXHkh/wF8RD11QkrrElIJc	Lock Test	\N	\N	Author	t	0	2026-09-22 19:20:05.975+00
\.


--
-- Name: __drizzle_migrations_id_seq; Type: SEQUENCE SET; Schema: drizzle; Owner: -
--

SELECT pg_catalog.setval('drizzle.__drizzle_migrations_id_seq', 2, true);


--
-- Name: __drizzle_migrations __drizzle_migrations_pkey; Type: CONSTRAINT; Schema: drizzle; Owner: -
--

ALTER TABLE ONLY drizzle.__drizzle_migrations
    ADD CONSTRAINT __drizzle_migrations_pkey PRIMARY KEY (id);


--
-- Name: categories categories_name_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_name_unique UNIQUE (name);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: categories categories_slug_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_slug_unique UNIQUE (slug);


--
-- Name: recipe_ingredients recipe_ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recipe_ingredients
    ADD CONSTRAINT recipe_ingredients_pkey PRIMARY KEY (id);


--
-- Name: recipe_steps recipe_steps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recipe_steps
    ADD CONSTRAINT recipe_steps_pkey PRIMARY KEY (id);


--
-- Name: recipe_steps recipe_steps_recipe_id_step_number_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recipe_steps
    ADD CONSTRAINT recipe_steps_recipe_id_step_number_unique UNIQUE (recipe_id, step_number);


--
-- Name: recipes recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_pkey PRIMARY KEY (id);


--
-- Name: recipes recipes_slug_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_slug_unique UNIQUE (slug);


--
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: recipe_ingredients recipe_ingredients_recipe_id_recipes_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recipe_ingredients
    ADD CONSTRAINT recipe_ingredients_recipe_id_recipes_id_fk FOREIGN KEY (recipe_id) REFERENCES public.recipes(id) ON DELETE CASCADE;


--
-- Name: recipe_steps recipe_steps_recipe_id_recipes_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recipe_steps
    ADD CONSTRAINT recipe_steps_recipe_id_recipes_id_fk FOREIGN KEY (recipe_id) REFERENCES public.recipes(id) ON DELETE CASCADE;


--
-- Name: recipes recipes_author_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_author_id_users_id_fk FOREIGN KEY (author_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: recipes recipes_category_id_categories_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_category_id_categories_id_fk FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

\unrestrict 6RCdUclvRdcDeIKeuZuBvhWmbrE4XdVo17aI89Z6ht49Yx0bJhKGqgewxlZbIPP

