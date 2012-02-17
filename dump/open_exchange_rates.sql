-- See https://raw.github.com/ReneNyffenegger/oracle_scriptlets/master/sqlpath/spool.sql
@spool ../dumped/open_exchange_rates.sql

select '-- Data as found on https://github.com/currencybot/open-exchange-rates' from dual;
select '-- Dumped from TODO' from dual;
select null from dual;

select 'insert into open_exchange_rates values ('
   || 'date ''' || to_char(date_, 'yyyy-mm-dd') || ''', '
   || '''' || currency_id || ''', '
   || to_char(rate, '999990.99999999') 
   || ');' 
from 
  open_exchange_rates 
;

spool off
