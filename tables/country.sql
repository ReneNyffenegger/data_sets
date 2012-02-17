create table country ( 
-- ISO 3166
   id               char    ( 2) not null primary key, 
   name             varchar2(80) not null, 
   iso3             char    ( 3)     null unique,
   numcode          number  ( 3)     null unique
)
organization index;
