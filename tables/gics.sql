-- The GICS structure consists of 
--    10 sectors, 
--    24 industry groups, 
--    68 industries and 
--   154 sub-industries.
--

create table gics_sector (
  id                char(2) primary key,
  text              varchar2(100) not null
);

create table gics_industry_group(
  id                char(4) primary key, 
  id_sector         not null references gics_sector,
  text              varchar2(100) not null
);

create table gics_industry (
  id                char(6) primary key,
  id_industry_group not null references gics_industry_group,
  text              varchar2(100) not null
);


create table gics_subindustry (
  id                char(8) primary key,
  id_industry       not null references gics_industry,
  text              varchar2(100) not null
);
