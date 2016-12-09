create table bfs_gemeinde (
  nr     number  ( 4) primary key,
  name   varchar2(30) not null,
  kanton varchar2( 2) not null
)
organization index
pctfree 0;
