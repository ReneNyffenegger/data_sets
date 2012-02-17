alter session set nls_numeric_characters='.,';
declare

   start_date date := to_date('&start_date_yyyymmdd', 'yyyymmdd');
   end_date   date := to_date('&end_date_yyyymmdd'  , 'yyyymmdd');

   procedure fill_rates_for_date(dt in date) is/*{*/

       req          utl_http.req;
       resp         utl_http.resp;
       line         varchar2(4000);

       matched_line varchar2(4000);

       url          varchar2(4000) := 'https://raw.github.com/currencybot/open-exchange-rates/master/historical/';

       rate_        number;
       currency_    varchar2(3);

   begin

       url := url || to_char(dt, 'yyyy-mm-dd') || '.json';

       req  := utl_http.begin_request(url, 'GET', 'HTTP/1.1');
       utl_http.set_header(req, 'User-Agent', 'open-exchange-rates-bot');
       resp := utl_http.get_response (req);


       loop/*{*/
         utl_http.read_line(resp, line, true);

         exit when regexp_like(line, '^ *' || chr(125) || ' *$');

         matched_line := regexp_substr(line, '"\w\w\w": \d+\.?\d*');

         if matched_line is not null then/*{*/

            currency_ :=           substr(matched_line, 2,3);
            rate_     := to_number(substr(matched_line, 8  ));

            begin
              insert into open_exchange_rates (date_, currency_id, rate) values (dt, currency_, rate_ );
            exception when others then
               if sqlcode = -2291 then
                  dbms_output.put_line('Unknown currency ' || currency_ || ' (date: ' || to_char(dt, 'dd.mm.yyyy'));
               end if;
            end;

         end if;/*}*/

       end loop;/*}*/

       utl_http.end_response(resp);

   exception when others then
       
       dbms_output.put_line(url);
       dbms_output.put_line(to_char(dt, 'dd.mm.yyyy'));
       dbms_output.put_line(sqlerrm);

   end fill_rates_for_date;/*}*/

begin


--
-- Wallet: needed for https connections.
--
--
-- Prevent ORA-29024
-- 
-- See http://eternal-donut.blogspot.com/2008/07/tip-5-using-utlhttp-and-ssl.html  
-- or  http://blog.whitehorses.nl/2010/05/27/access-to-https-via-utl_http-using-the-orapki-wallet-command/
--
-- In Windows Vista or Windows 7 you must run Internet Explorer as Administrator before the [Copy to File...] button is enabled
--
-------------------------------------------------------------------------------------------------------------------------------

   utl_http.set_wallet('file:&wallet_file', '&wallet_password');
-- utl_http.set_proxy('proxy.my-company.com', 'corp.my-company.com');

   for i in 0 .. end_date - start_date loop/*{*/

       fill_rates_for_date(start_date + i);
       commit;

   end loop;/*}*/

end;
/
