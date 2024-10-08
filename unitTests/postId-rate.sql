PGDMP      "                |         	   STUDPOSTS    16.3    16.3     �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    25372 	   STUDPOSTS    DATABASE        CREATE DATABASE "STUDPOSTS" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE "STUDPOSTS";
                postgres    false            �            1255    25451    changedislikescount()    FUNCTION     Z  CREATE FUNCTION public.changedislikescount() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
            IF (TG_OP = 'DELETE') THEN
                UPDATE posts
                SET dislikesCount = (SELECT COUNT(*) FROM dislikes WHERE post_id = OLD.post_id)
                WHERE unique_id = OLD.post_id;
            ELSIF (TG_OP = 'INSERT') THEN
                UPDATE posts
                SET dislikesCount = (SELECT COUNT(*) FROM dislikes WHERE post_id = NEW.post_id)
                WHERE unique_id = NEW.post_id; 
            END IF;
            RETURN NULL;
        END;
        $$;
 ,   DROP FUNCTION public.changedislikescount();
       public          postgres    false            �            1255    25444    changelikescount()    FUNCTION     K  CREATE FUNCTION public.changelikescount() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
            IF (TG_OP = 'DELETE') THEN
                UPDATE posts
                SET likesCount = (SELECT COUNT(*) FROM likes WHERE post_id = OLD.post_id)
                WHERE unique_id = OLD.post_id;
            ELSIF (TG_OP = 'INSERT') THEN
                UPDATE posts
                SET likesCount = (SELECT COUNT(*) FROM likes WHERE post_id = NEW.post_id)
                WHERE unique_id = NEW.post_id; 
            END IF;
            RETURN NULL;
        END;
        $$;
 )   DROP FUNCTION public.changelikescount();
       public          postgres    false            �            1259    25400    comments    TABLE       CREATE TABLE public.comments (
    unique_id character varying(50) NOT NULL,
    owner_login character varying(255) NOT NULL,
    post_id character varying(50) NOT NULL,
    content character varying(5000) NOT NULL,
    createdat timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.comments;
       public         heap    postgres    false            �            1259    25431    dislikes    TABLE     ~   CREATE TABLE public.dislikes (
    owner_login character varying(255) NOT NULL,
    post_id character varying(50) NOT NULL
);
    DROP TABLE public.dislikes;
       public         heap    postgres    false            �            1259    25418    likes    TABLE     {   CREATE TABLE public.likes (
    owner_login character varying(255) NOT NULL,
    post_id character varying(50) NOT NULL
);
    DROP TABLE public.likes;
       public         heap    postgres    false            �            1259    25384    posts    TABLE     �  CREATE TABLE public.posts (
    unique_id character varying(50) NOT NULL,
    owner_login character varying(255) NOT NULL,
    title character varying(200) NOT NULL,
    content character varying(5000) NOT NULL,
    tags character varying(200),
    createdat timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    imagedata character varying(255),
    viewcount integer DEFAULT 0,
    likescount integer DEFAULT 0,
    dislikescount integer DEFAULT 0
);
    DROP TABLE public.posts;
       public         heap    postgres    false            �            1259    25376    users    TABLE     �  CREATE TABLE public.users (
    login character varying(255) NOT NULL,
    password character varying(128) NOT NULL,
    firstname character varying(50) NOT NULL,
    surname character varying(50) NOT NULL,
    middlename character varying(50),
    privileged boolean DEFAULT false,
    email character varying(36),
    phonenumber character varying(20),
    persphotodata character varying(255)
);
    DROP TABLE public.users;
       public         heap    postgres    false            �          0    25400    comments 
   TABLE DATA           W   COPY public.comments (unique_id, owner_login, post_id, content, createdat) FROM stdin;
    public          postgres    false    217   �'       �          0    25431    dislikes 
   TABLE DATA           8   COPY public.dislikes (owner_login, post_id) FROM stdin;
    public          postgres    false    219   �'       �          0    25418    likes 
   TABLE DATA           5   COPY public.likes (owner_login, post_id) FROM stdin;
    public          postgres    false    218   �'       �          0    25384    posts 
   TABLE DATA           �   COPY public.posts (unique_id, owner_login, title, content, tags, createdat, imagedata, viewcount, likescount, dislikescount) FROM stdin;
    public          postgres    false    216   (       �          0    25376    users 
   TABLE DATA              COPY public.users (login, password, firstname, surname, middlename, privileged, email, phonenumber, persphotodata) FROM stdin;
    public          postgres    false    215   v(       6           2606    25407    comments comments_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (unique_id);
 @   ALTER TABLE ONLY public.comments DROP CONSTRAINT comments_pkey;
       public            postgres    false    217            4           2606    25394    posts posts_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (unique_id);
 :   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_pkey;
       public            postgres    false    216            2           2606    25383    users users_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (login);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    215            ?           2620    25452    dislikes tgrchangedislikescount    TRIGGER     �   CREATE TRIGGER tgrchangedislikescount AFTER INSERT OR DELETE ON public.dislikes FOR EACH ROW EXECUTE FUNCTION public.changedislikescount();
 8   DROP TRIGGER tgrchangedislikescount ON public.dislikes;
       public          postgres    false    219    221            >           2620    25450    likes tgrchangelikescount    TRIGGER     �   CREATE TRIGGER tgrchangelikescount AFTER INSERT OR DELETE ON public.likes FOR EACH ROW EXECUTE FUNCTION public.changelikescount();
 2   DROP TRIGGER tgrchangelikescount ON public.likes;
       public          postgres    false    218    220            8           2606    25408 "   comments comments_owner_login_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_owner_login_fkey FOREIGN KEY (owner_login) REFERENCES public.users(login) ON UPDATE CASCADE;
 L   ALTER TABLE ONLY public.comments DROP CONSTRAINT comments_owner_login_fkey;
       public          postgres    false    215    217    4658            9           2606    25413    comments comments_post_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(unique_id);
 H   ALTER TABLE ONLY public.comments DROP CONSTRAINT comments_post_id_fkey;
       public          postgres    false    216    217    4660            <           2606    25434 "   dislikes dislikes_owner_login_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.dislikes
    ADD CONSTRAINT dislikes_owner_login_fkey FOREIGN KEY (owner_login) REFERENCES public.users(login) ON UPDATE CASCADE;
 L   ALTER TABLE ONLY public.dislikes DROP CONSTRAINT dislikes_owner_login_fkey;
       public          postgres    false    215    4658    219            =           2606    25439    dislikes dislikes_post_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.dislikes
    ADD CONSTRAINT dislikes_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(unique_id);
 H   ALTER TABLE ONLY public.dislikes DROP CONSTRAINT dislikes_post_id_fkey;
       public          postgres    false    4660    219    216            :           2606    25421    likes likes_owner_login_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.likes
    ADD CONSTRAINT likes_owner_login_fkey FOREIGN KEY (owner_login) REFERENCES public.users(login) ON UPDATE CASCADE;
 F   ALTER TABLE ONLY public.likes DROP CONSTRAINT likes_owner_login_fkey;
       public          postgres    false    4658    215    218            ;           2606    25426    likes likes_post_id_fkey    FK CONSTRAINT     ~   ALTER TABLE ONLY public.likes
    ADD CONSTRAINT likes_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(unique_id);
 B   ALTER TABLE ONLY public.likes DROP CONSTRAINT likes_post_id_fkey;
       public          postgres    false    4660    218    216            7           2606    25395    posts posts_owner_login_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_owner_login_fkey FOREIGN KEY (owner_login) REFERENCES public.users(login) ON UPDATE CASCADE;
 F   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_owner_login_fkey;
       public          postgres    false    216    215    4658            �      x������ � �      �   "   x�K.��KO�M��,��,,M��LI����� ���      �      x������ � �      �   e   x�+��,,M��LI�L.��KO�M�㼰�b+*��xaυ�;.�
�+\��|���.�L���������������������������H� �b���� ��.      �   B   x�K.��KO�ؓ���ihd�ya��6]�za7'����> ���Ǚ"��+��tD+����� �E[     