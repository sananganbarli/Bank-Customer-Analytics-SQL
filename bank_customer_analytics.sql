-- 1. Write a query to determine the total transaction amount for customer_id = 1001 in the last 6 months.
select 
      c.customer_id,
      c.first_name,
      c.last_name,
      sum(t.amount) as total_transaction_amount
from transactions t
     join accounts a on t.account_id = a.account_id
     join customers c on a.customer_id = c.customer_id
where c.customer_id = 1001
      and t.transaction_date >= add_months(sysdate, -6)
group by c.customer_id, c.first_name, c.last_name;




-- 2. Show the total balance across all accounts and active loan amount for each customer.
select 
    c.customer_id,
    c.first_name,
    c.last_name as full_name,
    coalesce(sum(a.balance), 0) as total_balance,
    coalesce(sum(l.loan_amount), 0) as total_active_loans
from customers c
left join accounts a on c.customer_id = a.customer_id
left join loans l on c.customer_id = l.customer_id and l.end_date >= sysdate
group by c.customer_id, c.first_name, c.last_name;




-- 3. Retrieve a list of active deposit details and loan information for customers with an active deposit.
select 
    c.customer_id,
    c.first_name,
    c.last_name as full_name,
    d.deposit_id,
    d.deposit_type,
    d.deposit_amount,
    d.interest_rate,
    d.start_date,
    d.end_date,
    l.loan_id,
    l.loan_type,
    l.loan_amount,
    l.interest_rate,
    l.start_date,
    l.end_date
from customers c
join deposits d on c.customer_id = d.customer_id
left join loans l on c.customer_id = l.customer_id and l.end_date >= sysdate
where d.end_date >= sysdate;




-- 4. Display all accounts opened by each customer in the last 1 year and the total transaction amount for these accounts.
select 
    c.customer_id,
    c.first_name,
    c.last_name,
    a.account_id,
    a.account_type,
    a.date_opened,
    coalesce(sum(t.amount), 0) as total_transaction_amount
from customers c
join accounts a on c.customer_id = a.customer_id
left join transactions t on a.account_id = t.account_id
where a.date_opened >= add_months(sysdate, -12)
group by c.customer_id, c.first_name, c.last_name, a.account_id, a.account_type, a.date_opened;




-- 5. Show the total transaction amount grouped by transaction type for each customer over the last 1 year.
select 
    c.customer_id,
    c.first_name,
    c.last_name as full_name,
    t.transaction_type,
    sum(t.amount) as total_amount
from transactions t
join accounts a on t.account_id = a.account_id
join customers c on a.customer_id = c.customer_id
where t.transaction_date >= add_months(sysdate, -12)
group by c.customer_id, c.first_name, c.last_name, t.transaction_type;




-- 6. Write a query to find the highest single transaction amount for each customer in the last 6 months.
select 
    c.customer_id,
    c.first_name,
    c.last_name as full_name,
    max(t.amount) as max_transaction_amount
from transactions t
join accounts a on t.account_id = a.account_id
join customers c on a.customer_id = c.customer_id
where t.transaction_date >= add_months(sysdate, -6)
group by c.customer_id, c.first_name, c.last_name;




-- 7. Display the total balance and deposit amount per month for each customer over the last 1 year.
select 
    c.customer_id,
    c.first_name,
    c.last_name as full_name,
    to_char(t.transaction_date, 'yyyy-mm') as month,
    sum(a.balance) as total_balance,
    sum(d.deposit_amount) as total_deposit_amount
from customers c
join accounts a on c.customer_id = a.customer_id
left join transactions t on a.account_id = t.account_id
left join deposits d on c.customer_id = d.customer_id
where t.transaction_date >= add_months(sysdate, -12)
group by c.customer_id, c.first_name, c.last_name, to_char(t.transaction_date, 'yyyy-mm');




-- 8. Show the account with the highest transaction amount for each customer for each month over the last 3 months.
with transactionsummary as (
    select 
        c.customer_id,
        a.account_id,
        to_char(t.transaction_date, 'yyyy-mm') as month,
        sum(t.amount) as total_transaction_amount
    from transactions t
    join accounts a on t.account_id = a.account_id
    join customers c on a.customer_id = c.customer_id
    where t.transaction_date >= add_months(sysdate, -3)
    group by c.customer_id, a.account_id, to_char(t.transaction_date, 'yyyy-mm')
)
select 
    ts.customer_id,
    ts.month,
    ts.account_id,
    ts.total_transaction_amount
from transactionsummary ts
join (select 
              customer_id,
              month,
              max(total_transaction_amount) as max_amount
      from transactionsummary
      group by customer_id, month)
 max_ts on ts.customer_id = max_ts.customer_id 
         and ts.month = max_ts.month 
         and ts.total_transaction_amount = max_ts.max_amount;




-- 9. Display total monthly balance and address type categorized by customer addresses over the last 3 months.
select 
    c.customer_id,
    c.first_name,
    c.last_name as full_name,
    to_char(t.transaction_date, 'yyyy-mm') as month,
    a.address_name,
    at.type_name as address_type,
    sum(a.balance) as total_balance
from customers c
join address a on c.customer_id = a.customer_id
join address_type at on a.type_id = at.type_id
join accounts ac on c.customer_id = ac.customer_id
left join transactions t on ac.account_id = t.account_id
where t.transaction_date >= add_months(sysdate, -3)
group by c.customer_id, c.first_name, c.last_name, to_char(t.transaction_date, 'yyyy-mm'), a.address_name, at.type_name;




-- 11. Find the day with the highest number of transactions for each customer over the last 1 year.
with transactiondays as (
  select 
        c.customer_id,
        t.transaction_date,
        count(*) as transaction_count
  from transactions t
  join accounts a on t.account_id = a.account_id
  join customers c on a.customer_id = c.customer_id
  where t.transaction_date >= add_months(sysdate, -12)
  group by c.customer_id, t.transaction_date
)
select 
    td.customer_id,
    max(td.transaction_date) as most_active_day,
    max(td.transaction_count) as max_transaction_count
from transactiondays td
group by td.customer_id;




-- 12. Display details and loan amount for the customer with the highest loan amount in the last 6 months.
select 
    c.customer_id,
    c.first_name,
    c.last_name as full_name,
    max(l.loan_amount) as max_loan_amount
from loans l
join customers c on l.customer_id = c.customer_id
where l.start_date >= add_months(sysdate, -6)
group by c.customer_id, c.first_name, c.last_name;




-- 13. Identify the month with the highest balance increase for each customer over the last 1 year.
with balancechanges as (
    select 
        c.customer_id,
        to_char(t.transaction_date, 'yyyy-mm') as month,
        sum(t.amount) as balance_change
    from transactions t
    join accounts a on t.account_id = a.account_id
    join customers c on a.customer_id = c.customer_id
    where t.transaction_date >= add_months(sysdate, -12)
    group by c.customer_id, to_char(t.transaction_date, 'yyyy-mm')
)
select 
    bc.customer_id,
    bc.month,
    bc.balance_change
from balancechanges bc
join (
    select 
        customer_id,
        max(balance_change) as max_change
    from balancechanges
    group by customer_id
) max_bc on bc.customer_id = max_bc.customer_id 
         and bc.balance_change = max_bc.max_change;




-- 14. Display the most frequently used transaction types and transaction count per type for each customer over the last 1 year.
with transactiontypes as (
    select 
        c.customer_id,
        t.transaction_type,
        count(*) as transaction_count
    from transactions t
    join accounts a on t.account_id = a.account_id
    join customers c on a.customer_id = c.customer_id
    where t.transaction_date >= add_months(sysdate, -12)
    group by c.customer_id, t.transaction_type)
select 
    tt.customer_id,
    tt.transaction_type,
    tt.transaction_count
from transactiontypes tt
join (
    select 
        customer_id,
        max(transaction_count) as max_count
    from transactiontypes
    group by customer_id) 
max_tt on tt.customer_id = max_tt.customer_id 
         and tt.transaction_count = max_tt.max_count;




-- 15. Find the longest active loan duration for each customer in the last 6 months.
select 
    c.customer_id,
    c.first_name,
    c.last_name as full_name,
    max(l.end_date - l.start_date) as longest_loan_duration
from loans l
join customers c on l.customer_id = c.customer_id
where l.start_date >= add_months(sysdate, -6)
group by c.customer_id, c.first_name, c.last_name;