-- Note: Name of table in plural
--       because https://github.com/currencybot/open-exchange-rates is, too.

create table open_exchange_rates (
  date_           date            not null check (date_ = trunc(date_)),
  currency_id                     not null references currency,
  rate            number(14,8)    not null,
  --------------  
  primary key (date_, currency_id, rate)
)
organization index;
