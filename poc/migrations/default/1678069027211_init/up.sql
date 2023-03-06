-- hasura migrate create "init" --from-server

SET check_function_bodies = false;
CREATE TABLE public.blog_post (
    id integer NOT NULL,
    title text NOT NULL,
    content text NOT NULL,
    date timestamp with time zone DEFAULT now() NOT NULL,
    is_published boolean DEFAULT false NOT NULL,
    user_id text
);
CREATE TABLE public.blog_post_activity (
    id integer NOT NULL,
    blog_post_id integer NOT NULL,
    type text NOT NULL,
    date timestamp with time zone DEFAULT now() NOT NULL
);
CREATE SEQUENCE public.blog_post_activity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.blog_post_activity_id_seq OWNED BY public.blog_post_activity.id;
CREATE TABLE public.blog_post_activity_type (
    name text NOT NULL
);
CREATE SEQUENCE public.blog_post_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.blog_post_id_seq OWNED BY public.blog_post.id;
ALTER TABLE ONLY public.blog_post ALTER COLUMN id SET DEFAULT nextval('public.blog_post_id_seq'::regclass);
ALTER TABLE ONLY public.blog_post_activity ALTER COLUMN id SET DEFAULT nextval('public.blog_post_activity_id_seq'::regclass);
ALTER TABLE ONLY public.blog_post_activity
    ADD CONSTRAINT blog_post_activity_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.blog_post_activity_type
    ADD CONSTRAINT blog_post_activity_type_pkey PRIMARY KEY (name);
ALTER TABLE ONLY public.blog_post
    ADD CONSTRAINT blog_post_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.blog_post_activity
    ADD CONSTRAINT blog_post_activity_blog_post_id_fkey FOREIGN KEY (blog_post_id) REFERENCES public.blog_post(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.blog_post_activity
    ADD CONSTRAINT blog_post_activity_type_fkey FOREIGN KEY (type) REFERENCES public.blog_post_activity_type(name) ON UPDATE RESTRICT ON DELETE RESTRICT;
